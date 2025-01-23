import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../models/capitolo.dart';
import '../models/volume.dart';
import '../services/download_manager.dart';
import '../services/gestione_file.dart';

class ExpansionVolume extends StatefulWidget {
  const ExpansionVolume({super.key, required this.volume});
  final Volume volume;
  @override
  State<ExpansionVolume> createState() => _ExpansionVolumeState();
}

class _ExpansionVolumeState extends State<ExpansionVolume> {
  bool expanded = false;
  bool loadingDownloadVolume = false;
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final downloadManager =
          Provider.of<DownloadManager>(context, listen: false);
      downloadManager.checkFileStatus(widget.volume.capitoli!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadManager = Provider.of<DownloadManager>(context);
    bool allDownloaded = widget.volume.capitoli!
        .every((capitolo) => downloadManager.getStatus(capitolo.fileName));

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        shape: ContinuousRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(80)),
        ),
      ),
      child: ExpansionPanelList(
        expansionCallback: (int i, bool isExpanded) {
          setState(() {
            expanded = !expanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                minTileHeight: 50,
                title: Text(widget.volume.title),
              );
            },
            body: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isDownloading
                            ? null // Disabilita il pulsante se tutti i capitoli sono scaricati o se è in corso un download
                            : () async {
                                setState(() {
                                  isDownloading = true; // Inizia il caricamento
                                });

                                bool deleteAll = allDownloaded;
                                for (var capitolo in widget.volume.capitoli!) {
                                  if (deleteAll ||
                                      !downloadManager
                                          .getStatus(capitolo.fileName)) {
                                    GestioneFileService gestioneFileService =
                                        GestioneFileService(
                                            filename: capitolo.fileName);
                                    if (deleteAll) {
                                      await gestioneFileService.deleteFile();
                                    } else if (!downloadManager
                                        .getStatus(capitolo.fileName)) {
                                      downloadManager.setDownloading(
                                          capitolo.fileName, true);
                                      await gestioneFileService.downloadFile(
                                        url: capitolo.url,
                                        password: capitolo.passwordZip,
                                      );
                                    }

                                    bool exist =
                                        await gestioneFileService.checkFile();
                                    downloadManager.updateStatus(
                                        capitolo.fileName, exist);
                                    downloadManager.setDownloading(
                                        capitolo.fileName, false);
                                  }
                                }

                                allDownloaded = widget.volume.capitoli!.every(
                                    (capitolo) => downloadManager
                                        .getStatus(capitolo.fileName));

                                setState(() {
                                  isDownloading =
                                      false; // Termina il caricamento
                                });
                              },
                        icon: isDownloading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(allDownloaded
                                ? Icons.delete_outline
                                : Icons.download,
                        color: Colors.white,),
                        label: Text(
                          isDownloading
                              ? (allDownloaded
                                  ? "Cancellazione in corso..."
                                  : "Scaricamento in corso...")
                              : (allDownloaded
                                  ? "Elimina tutto"
                                  : "Scarica tutto"),
                          selectionColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                              return Theme.of(context).colorScheme.secondary.withOpacity(0.8);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...widget.volume.capitoli!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final capitolo = entry.value;
                    final status = downloadManager.getStatus(capitolo.fileName);

                    return Column(
                      children: [
                        TileCapitolo(capitolo: capitolo),
                        if (index < widget.volume.capitoli!.length - 1)
                          Divider(
                            color: Theme.of(context).colorScheme.surface,
                            endIndent: 10,
                            indent: 10,
                            thickness: 1.5,
                          ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            isExpanded: expanded,
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }
}

class TileCapitolo extends StatefulWidget {
  const TileCapitolo({super.key, required this.capitolo});
  final Capitolo capitolo;

  @override
  State<TileCapitolo> createState() => _TileCapitoloState();
}

class _TileCapitoloState extends State<TileCapitolo> {
  late GestioneFileService gestioneFileService;

  @override
  void initState() {
    super.initState();
    gestioneFileService =
        GestioneFileService(filename: widget.capitolo.fileName);
  }

  void _updateStatus(bool status, DownloadManager downloadManager) {
    downloadManager.updateStatus(widget.capitolo.fileName, status);
  }

  @override
  Widget build(BuildContext context) {
    final downloadManager = Provider.of<DownloadManager>(context);
    final status = downloadManager.getStatus(widget.capitolo.fileName);
    final loading = downloadManager.isDownloading(widget.capitolo.fileName);
    return InkWell(
      hoverDuration: const Duration(milliseconds: 200),
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        await Navigator.pushNamed(
          context,
          '/capitolo',
          arguments: widget.capitolo,
        ).then((result) async {
          // Aggiorna lo stato dopo il ritorno dalla schermata Capitolo
          if (status) {
            await gestioneFileService.deleteFile();
            _updateStatus(false, downloadManager);
          }
        });
      },
      child: ListTile(
        minLeadingWidth: 10,
        leading: Text(
          widget.capitolo.numberCap.toString(),
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        title: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: Text(
            widget.capitolo.title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    onTap: () async {
                      downloadManager.setDownloading(
                          widget.capitolo.fileName, true);

                      if (status) {
                        // Elimina il file
                        await gestioneFileService.deleteFile();
                        _updateStatus(false, downloadManager);
                      } else {
                        // Scarica il file
                        await gestioneFileService.downloadFile(
                          url: widget.capitolo.url,
                          password: widget.capitolo.passwordZip,
                        );
                        _updateStatus(true, downloadManager);
                      }

                      downloadManager.setDownloading(
                          widget.capitolo.fileName, false);
                    },
                    child: Icon(
                      status
                          ? Icons.delete_outline
                          : Icons.download_for_offline_outlined,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

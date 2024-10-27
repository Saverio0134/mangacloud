import 'package:flutter/material.dart';
import '../models/capitolo.dart';
import '../models/volume.dart';
import '../services/gestione_file.dart';

class ExpansionVolume extends StatefulWidget {
  const ExpansionVolume({super.key, required this.volume});
  final Volume volume;
  @override
  State<ExpansionVolume> createState() => _ExpansionVolumeState();
}

class _ExpansionVolumeState extends State<ExpansionVolume> {
  bool expanded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        shape: ContinuousRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(80))),
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
                    minTileHeight: 50, title: Text(widget.volume.title));
              },
              body: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    for (int index = 0;
                        index < widget.volume.capitoli!.length;
                        index++)
                      Column(
                        children: [
                          TileCapitolo(
                              capitolo: widget.volume.capitoli![index]),
                          if (index < widget.volume.capitoli!.length - 1)
                            Divider(
                              color: Theme.of(context).colorScheme.surface,
                              endIndent: 10,
                              indent: 10,
                              thickness: 1.5,
                            )
                        ],
                      ),
                  ],
                ),
              ),
              isExpanded: expanded,
              canTapOnHeader: true),
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
  bool _isLoading = false;
  late Future<bool> _exist;
  late GestioneFileService gestioneFileService;
  @override
  void initState() {
    super.initState();
    gestioneFileService =
        GestioneFileService(filename: widget.capitolo.fileName);
    checkFileExists();
  }

  void checkFileExists() {
    setState(() {
      _exist = gestioneFileService.checkFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverDuration: const Duration(milliseconds: 200),
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        await Navigator.pushNamed(context, '/capitolo',
                arguments: widget.capitolo)
            .then((result) async {
          if (!await _exist) {
            await gestioneFileService.deleteFile();
            checkFileExists();
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
            _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : FutureBuilder<bool>(
                    future: _exist,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data!) {
                        return InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await gestioneFileService.deleteFile();
                            checkFileExists();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: const Icon(Icons.delete_outline),
                        );
                      } else {
                        return InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await gestioneFileService.downloadFile(
                                url: widget.capitolo.url,
                                password: widget.capitolo.passwordZip);
                            checkFileExists();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child:
                              const Icon(Icons.download_for_offline_outlined),
                        );
                      }
                    }),
          ],
        ),
      ),
    );
  }
}

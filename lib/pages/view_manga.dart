import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mangacloud/widgets/dialog_all.dart';
import 'package:mangacloud/widgets/spinner.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/capitolo.dart';
import '../services/gestione_file.dart';
import 'package:flutter/material.dart';

class ViewManga extends StatefulWidget {
  ViewManga({super.key, required this.capitolo});
  final Capitolo capitolo;
  int initialIndex = 0;
  @override
  State<StatefulWidget> createState() => _ViewMangaState();
}

class _ViewMangaState extends State<ViewManga>
    with SingleTickerProviderStateMixin {
  Future<List<String>> _percorsi = Future.value([]);
  bool _endLoad = false;
  late PageController _pageController; // Aggiungi un ScrollController
  late int _lastPageRead = 0;
  bool _backActive = true;
  final DialogAll _dialogAll = DialogAll();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController = PageController(initialPage: widget.initialIndex);
    checkFileExists();
    // _scrollController.addListener(_printScrollPosition);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> checkFileExists() async {
    _percorsi = GestioneFileService(filename: widget.capitolo.fileName)
        .downloadFile(
            url: widget.capitolo.url, password: widget.capitolo.passwordZip);
    _endLoad = true;
    setState(() {}); // Aggiorna l'interfaccia utente
  }

  void _rotateScreen(){
    if(MediaQuery.of(context).orientation == Orientation.portrait)
    {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _back(){
    if (_backActive) {
      Navigator.pop(context); // Torna alla pagina precedente
    } else {
      _showBackDialog();
    }
  }

  void _showBackDialog() {
    TextStyle txtStyleBody = Theme.of(context).textTheme.labelLarge!;
    _dialogAll.showAlertDialogCustom(
        context: context,
        title: Text('Hai quasi finito...', style: Theme.of(context).textTheme.titleSmall!),
        body: [
          Text('Hai quasi letto tutte le pagine,', style: txtStyleBody,),
          Text('vuoi segnare questo capitolo come letto?', style: txtStyleBody),
        ],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _backActive = true;
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.pop(context);
              });

              // Chiu
            },
            child: Text('SI'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _backActive = true;
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.pop(context);
              });

              // Chiu
            },
            child: Text('NO'),
          ),
        ]);
  }

  void _showErrorDialog() {
    TextStyle txtStyleBody = Theme.of(context).textTheme.labelLarge!;
    _dialogAll.showAlertDialogCustom(
        context: context,
        title: Text('Errore', style: Theme.of(context).textTheme.titleSmall!,),
        body: [
          Text(
            'C\'è stato un problema con il download del manga,',
            style: txtStyleBody,
          ),
          Text(
            'controlla la tua connessione e riprova.',
            style: txtStyleBody,
          ),
          Text(
            'In caso il problema persista contatta l\'assistenza.',
            style: txtStyleBody,
          ),
        ],
        actions: [
          TextButton(
            child: const Text('Chiudi'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return;
        }
        _showBackDialog();
      },
      canPop: _backActive,
      child: Scaffold(
        appBar: isPortrait
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => _back(),
                ),
                title: Text(widget.capitolo.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(letterSpacing: 0)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(onPressed: () => _rotateScreen(), icon: Icon(Icons.screen_rotation)),
                  )
                ],
              )
            : null,
        body: Padding(
          padding: EdgeInsets.only(top: isPortrait ? 0 : statusBarHeight),
          child: Stack(
            children: [
              FutureBuilder(
                future: _percorsi,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !_endLoad) {
                    return Spinner(); // Loading indicator
                  } else if (snapshot.hasData && _endLoad) {
                    return PhotoViewGallery.builder(
                      loadingBuilder: (context, event) => Spinner(),
                      pageController: _pageController,
                      scrollPhysics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      onPageChanged: (index) {
                        if (index > _lastPageRead) _lastPageRead = index;
                        _backActive =
                        !(_lastPageRead + 2 >= snapshot.data!.length - 1 &&
                            _lastPageRead != snapshot.data!.length - 1);
                        setState(() {});
                      },
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          minScale: PhotoViewComputedScale.contained *
                              0.5, // Imposta la scala minima
                          maxScale: PhotoViewComputedScale.contained * 3,
                          imageProvider: FileImage(File(snapshot.data![index])),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showErrorDialog(); // Chiama il tuo metodo qui
                    });
                    return Container();
                  }
                  return const Text('');
                },
              ),
              if(!isPortrait)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: ()=> _back(), icon: Icon(Icons.arrow_back_outlined),
                      style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary.withOpacity(0.7)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Imposta il raggio desiderato
                        )),
                    ),),
                    IconButton(onPressed: () => _rotateScreen(), icon: Icon(Icons.screen_rotation),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary.withOpacity(0.7)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Imposta il raggio desiderato
                        )),
                      ),)
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

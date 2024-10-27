import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/manga.dart';
import '../load_image.dart';

class CardManga extends StatefulWidget {
  const CardManga({super.key, required this.manga});
  final Manga manga;

  @override
  State<CardManga> createState() => _CardMangaState();
}

class _CardMangaState extends State<CardManga> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(right: 25),
        clipBehavior: Clip.antiAlias,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(80))
        ),
        child: Stack(
          children: [
            Container(
                width:
                    156, // Assicurati che l'immagine abbia le stesse dimensioni del Container
                height: 240,
                child:
                CachedNetworkImage(
                  imageUrl: widget.manga.imageCard,
                  placeholder: (context, url) => LoadImageWidget(), // Widget mostrato durante il caricamento
                  errorWidget: (context, url, error) => LoadImageWidget(), // Widget mostrato in caso di errore
                  fit: BoxFit.cover,
                ),),
            Material(
              color: Colors.transparent,
              child: InkWell(
                hoverDuration: const Duration(milliseconds: 200),
                onTap: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  Navigator.pushNamed(context, '/volumi',
                      arguments: widget.manga);
                },
                child: Container(
                  width: 156,
                  height: 240,
                  alignment: AlignmentDirectional.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(
                          0, 200), // Regola l'offset per posizionare l'ombra
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  ]),
                  child: Text(widget.manga.title,
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
            ),
          ],
        ));
  }
}


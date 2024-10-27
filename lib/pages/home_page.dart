import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangacloud/services/authentication.dart';
import '../models/manga.dart';
import '../services/manga.dart';
import '../widgets/home/appbar/background_appbar.dart';
import '../widgets/home/appbar/button_account.dart';
import '../widgets/home/appbar/title.dart';
import '../widgets/home/card_manga.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Manga>> mangas = Future.value([]);
  final _mangaService = MangaService();
  bool _showTitle = false;
  final expandedHeight = 140.00;
  final toolbarHeight = 75.00;
  @override
  void initState() {
    super.initState();
    mangas = _mangaService.getAllManga();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= (expandedHeight - toolbarHeight)) {
          _showTitle = true; // Mostra il titolo
        } else {
          _showTitle = false; // Nascondi il titolo
        }
        setState(() {});
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<List<Manga>>(
            future: mangas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )); // Mostra un indicatore di caricamento
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: expandedHeight,
                      toolbarHeight: toolbarHeight,
                      floating: false,
                      pinned: true,
                      surfaceTintColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.3),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        centerTitle: true,
                        expandedTitleScale: 1,
                        title: TitleHomeAppBar(showTitle: _showTitle,),
                        background: BackgroundHomeAppbar(),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      childCount: 1,
                      (context, index) {
                        return SezionePopolari(mangas: snapshot.data!);
                      },
                    ))
                  ],
                );
              }
            },
          ),
        ),
        // bottomSheet: Padding(
        //   padding: const EdgeInsets.all(20),
        //   child: Container(
        //       height: 40,
        //       clipBehavior: Clip.antiAlias,
        //       decoration: ShapeDecoration(
        //         color: Theme.of(context).colorScheme.tertiary,
        //         shape: ContinuousRectangleBorder(
        //             side: BorderSide(color: Colors.transparent),
        //             borderRadius: BorderRadius.all(Radius.circular(80))),
        //       ),
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             TextButton(onPressed: (){}, child: Text("Home")),
        //             TextButton(onPressed: (){}, child: Text("Download"))
        //           ],
        //         ),
        //       )
        //   ),
        // ),
      ),
    );
  }
}

class SezionePopolari extends StatelessWidget {
  SezionePopolari({super.key, required this.mangas});
  List mangas;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 15, top: 20),
            alignment: AlignmentDirectional.bottomStart,
            child: Text('Popolari',
                style: Theme.of(context).textTheme.titleSmall)),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 20),
            child: Row(
              children: [for (var manga in mangas) CardManga(manga: manga)],
            ),
          ),
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangacloud/services/manga.dart';
import 'package:mangacloud/widgets/expansion_volume.dart';
import 'package:mangacloud/widgets/spinner.dart';
import '../models/manga.dart';
import '../models/volume.dart';
import '../widgets/load_image.dart';

class MangaDetails extends StatefulWidget {
  MangaDetails({super.key, required this.manga});
  Manga manga;

  @override
  State<StatefulWidget> createState() => _MangaDetails();
}

class _MangaDetails extends State<MangaDetails> {
  Future<List<Volume>> _volumi = Future.value([]);
  final _serviceManga = MangaService();
  bool _ordineCrescente = true;
  @override
  void initState() {
    super.initState();
    urlSpinner = widget.manga.spinner;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    caricaVolumi();
  }

  caricaVolumi() async{
    await Future.delayed(const Duration(milliseconds: 100));
    _volumi = _serviceManga.getVolumiByManga(widget.manga.id);
    setState(() {
    });
  }


  Future<void> changeOrderVolumi() async {
    _ordineCrescente = !_ordineCrescente;
    if(_ordineCrescente) {
      (await _volumi).sort((a, b) => a.number.compareTo(b.number));
    }
    else{
      (await _volumi).sort((a, b) => b.number.compareTo(a.number));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _volumi,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 230,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        centerTitle: true,
                        expandedTitleScale: 1,
                        title: Text(
                          widget.manga.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        background: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: const ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80))),
                                child:CachedNetworkImage(
                                  imageUrl: widget.manga.imageDetails,
                                  placeholder: (context, url) => LoadImageWidget(),
                                  errorWidget: (context, url, error) => LoadImageWidget(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]),
                        ),

                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary),

                        ),
                        onPressed: () async => await changeOrderVolumi(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_ordineCrescente ? Icons.arrow_downward_outlined : Icons.arrow_upward_outlined, color: Colors.white, size: 16,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("ORDINE", style: Theme.of(context).textTheme.labelMedium,),
                            ),
                          ],
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ListView.builder(
                        cacheExtent: 80 * double.parse(snapshot.data!.length.toString()),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ExpansionVolume(volume: snapshot.data![index]);
                        },
                      ),
                    ),)
                  ],
                )


              );
            }
          },
        ),
      ),
    );
  }
}

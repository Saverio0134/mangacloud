import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangacloud/models/volume.dart';

class Manga{
  String id;
  String title;
  String imageDetails;
  String imageCard;
  String spinner;
  List<Volume>? volumi;
  Manga({required this.id, required this.title,required this.imageDetails,required this.imageCard, required this.spinner, this.volumi});

  factory Manga.fromMap(Map<String, dynamic> data, String idManga, List<Volume>? volumi) {

    return Manga(
      id: idManga,
      title: data['title'],
      imageCard: data['image_card'],
      imageDetails: data['image_details'],
      spinner: data['spinner_loading'],
      volumi: volumi
    );
  }
}
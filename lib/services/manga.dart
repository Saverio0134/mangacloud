
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mangacloud/models/capitolo.dart';
import 'package:mangacloud/models/manga.dart';

import '../models/volume.dart';

class MangaService {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<List<Manga>> getAllManga() async {
        final collection = _db.collection("manga");
        final querySnapshot = await collection.get();
        final mangas = querySnapshot.docs.map((doc) async { // async nella map
            // final volumi = await getVolumiByManga(doc.id, collection); // await per ottenere i volumi
            return Manga.fromMap(doc.data(), doc.id, null);
        }).toList();

        return Future.wait(mangas); // Attendi il completamento di tutti i Future<Manga>
    }

    Future<List<Volume>> getVolumiByManga(String idManga) async {
        final collection = _db.collection("manga").doc(idManga).collection("volumi");
        final querySnapshot = await collection.orderBy("number").get();
        final volumi = querySnapshot.docs.map((doc) async {
            final capitoli = await getCapitoliByVolume(doc.id, collection);
            return Volume.fromMap(doc.data(), doc.id, capitoli);}).toList();
        return Future.wait(volumi);
    }

    Future<List<Capitolo>> getCapitoliByVolume(String idVolume, CollectionReference collectionVolume) async {
        final collection = collectionVolume.doc(idVolume).collection("capitoli");
        final querySnapshot = await collection.orderBy("number_cap").get();
        return querySnapshot.docs.map((doc) => Capitolo.fromMap(doc.data(), doc.id)).toList();
    }


    Future<Capitolo> getSingleCapitolo({required String idManga, required String idVolume, required String idCapitolo}) async {
        final querySnapshot = await _db.collection("manga").doc(idManga).collection("volumi").doc(idVolume).collection("capitoli").doc(idCapitolo).get();
        final capitolo = Capitolo.fromMap(querySnapshot.data()!, idCapitolo);
        return capitolo; // Attendi il completamento di tutti i Future<Manga>
    }

    Future<Manga> getSingleManga({required String idManga}) async {
        final querySnapshot = await _db.collection("manga").doc(idManga).get();
        final volumi = await getVolumiByManga(idManga);
        final manga = Manga.fromMap(querySnapshot.data()!, idManga, volumi);
        return manga; // Attendi il completamento di tutti i Future<Manga>
    }
}

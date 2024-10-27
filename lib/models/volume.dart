import 'capitolo.dart';

class Volume{
  String title;
  String id;
  int number;
  List<Capitolo>? capitoli;
  Volume({required this.title, required this.id, required this.number, this.capitoli});

  factory Volume.fromMap(Map<String, dynamic> data, String idVolume, List<Capitolo> capitoli) {
    return Volume(
        id: idVolume,
        title: data['title'],
        number: data['number'],
        capitoli: capitoli
    );
  }
}
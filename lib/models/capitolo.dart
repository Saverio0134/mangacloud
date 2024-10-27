class Capitolo{
  String id;
  String title;
  int numberCap;
  String? passwordZip;
  String fileName;
  String url;

  Capitolo({required this.title, required this.id, required this.numberCap, this.passwordZip, required this.fileName, required this.url});

  factory Capitolo.fromMap(Map<String, dynamic> data, String idCapitolo) {
    return Capitolo(
        id: idCapitolo,
        title: data['title'],
        numberCap: data['number_cap'],
        passwordZip: data['password_zip'],
        url: data['url'],
        fileName: data['filename']
    );
  }
}
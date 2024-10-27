import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class GestioneFileService{
  GestioneFileService({required this.filename});
  Directory? _appDocDir;
  final String filename;
  // Getter per accedere a appDocDir
  Future<Directory> get appDocDir async {
    _appDocDir ??= await getApplicationDocumentsDirectory();
    return _appDocDir!;
  }



  Future<List<String>> downloadFile(
      {required String url, String? password}) async {
    final docDir = await appDocDir;

    // Crea il percorso completo del file ZIP
    final zipFilePath = '${docDir.path}/zip$filename';
    final extractDir = Directory('${docDir.path}/extracted/$filename');

    // Controlla se la cartella di estrazione esiste già e non è vuota
    if (await extractDir.exists() && !(await extractDir.list().isEmpty)) {
      // Ottieni i percorsi delle immagini estratte
      final imagePaths = extractDir
          .listSync()
          .whereType<File>()
          .where((file) =>
      file.path.endsWith('.jpg') ||
          file.path.endsWith('.png') ||
          file.path.endsWith('.webp'))
          .map((file) => file.path)
          .toList();
      return imagePaths;
    } else {
      // Scarica e decomprimi il file ZIP
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Scrivi i dati nel file ZIP
        final file = File(zipFilePath);
        await file.writeAsBytes(response.bodyBytes);

        // Decomprimi il file ZIP
        final bytes = file.readAsBytesSync();
        final archive = ZipDecoder().decodeBytes(bytes, password: password);

        // Crea la directory di estrazione (se non esiste già)
        await extractDir.create(recursive: true);

        // Estrai i file direttamente nella cartella "extracted"
        List<String> percorsi = [];
        for (final file in archive) {
          final pagename = file.name
              .split('/')
              .last; // Prendi solo il nome del file, non il percorso completo all'interno del ZIP
          if (file.isFile) {
            final data = file.content as List<int>;
            final outFile = File('${extractDir.path}/$pagename');
            await outFile.create(recursive: true);
            percorsi.add(outFile.path);
            await outFile.writeAsBytes(data);
          }
        }

        // Cancella il file ZIP dopo l'estrazione
        await file.delete();

        return percorsi;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    }
  }

  Future<bool> checkFile() async {
    final docDir = await appDocDir;
    final dir = Directory('${docDir.path}/extracted/$filename');

    // Controlla se la cartella di estrazione esiste già e non è vuota
    if (await dir.exists() && !(await dir.list().isEmpty)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteFile() async {
    final docDir = await appDocDir;
    final dir = Directory('${docDir.path}/extracted/$filename');
    await dir.delete(recursive: true);
  }
}
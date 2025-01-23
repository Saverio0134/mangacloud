import 'package:flutter/foundation.dart';
import '../models/capitolo.dart';
import 'gestione_file.dart';

class DownloadManager extends ChangeNotifier {
  final Map<String, bool> _fileStatuses = {};
  final Map<String, bool> _fileDownloading = {}; // Traccia lo stato di download attivo

  void updateStatus(String fileName, bool status) {
    _fileStatuses[fileName] = status;
    notifyListeners();
  }

  bool getStatus(String fileName) {
    return _fileStatuses[fileName] ?? false;
  }

  Future<void> checkFileStatus(List<Capitolo> capitoli) async {
    for (var capitolo in capitoli) {
      // Esegui il controllo per ogni file e aggiorna lo stato
      final exists = await _checkFileExists(capitolo.fileName);
      _fileStatuses[capitolo.fileName] = exists;
    }
    notifyListeners();
  }

  void setDownloading(String fileName, bool downloading) {
    _fileDownloading[fileName] = downloading;
    notifyListeners();
  }

  bool isDownloading(String fileName) {
    return _fileDownloading[fileName] ?? false;
  }

  Future<bool> _checkFileExists(String fileName) async {
    GestioneFileService gestioneFileService =
        GestioneFileService(filename: fileName);
    final exists = gestioneFileService.checkFile();
    return exists;
  }
}

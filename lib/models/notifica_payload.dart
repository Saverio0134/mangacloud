class NotificaPayload {
  String idManga;
  String? idVolume;
  String? idCapitolo;

  NotificaPayload({required this.idManga, this.idVolume, this.idCapitolo});

  // Aggiungi un costruttore fromMap
  factory NotificaPayload.fromMap(Map<String, dynamic> data) {
    return NotificaPayload(
      idManga: data['idManga'],
      idVolume: data['idVolume'],
      idCapitolo: data['idCapitolo'],
    );
  }
  Map<String, dynamic> toJson() => {
    'idManga': idManga,
    'idVolume': idVolume,
    'idCapitolo': idCapitolo,
  };

}
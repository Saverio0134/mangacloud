class Utente{
  String uid;
  String nickname;
  String email;

  Utente({required this.uid, required this.nickname, required this.email});

  factory Utente.fromMap(Map<String, dynamic> data) {

    return Utente(
        uid: data['uid'],
        nickname: data['nickname'],
        email: data['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nickname': nickname,
    'email': email,
  };
}
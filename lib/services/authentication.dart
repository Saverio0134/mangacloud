import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/main.dart';
import 'package:mangacloud/models/utente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authChange => _firebaseAuth.authStateChanges();
  // Import per ScaffoldMessenger

  Future<User?> createAccount(
      {required String emailAddress,
      required String password,
      required nickname}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      final user = Utente(
          uid: credential.user!.uid, nickname: nickname, email: emailAddress);
      _db.collection("utente").doc(user.uid).set(user.toJson());
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'Errore sconosciuto'; // Messaggio di errore di default
      if (e.code == 'weak-password') {
        errorMessage = 'La password fornita è troppo debole.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Esiste già un account con questa email.';
      }

      // Mostra la Snackbar
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: Theme.of(navigatorKey.currentContext!).textTheme.labelLarge,
          ), // Messaggio di errore specifico
          backgroundColor: Colors.red, // Colore di sfondo rosso per l'errore
        ),
      );
    } catch (e) {
      // Mostra una Snackbar generica per errori non di FirebaseAuth
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Si è verificato un errore.',
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelLarge),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  Future<User?> loginAccount(
      {required String emailAddress, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      recuperaUtente();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'Errore sconosciuto'; // Messaggio di errore di default
      if (e.code == 'user-not-found') {
        errorMessage = 'Account non trovato!';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password errata!';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Credenziali errate!';
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: Theme.of(navigatorKey.currentContext!).textTheme.labelLarge,
          ), // Messaggio di errore specifico
          backgroundColor: Colors.red, // Colore di sfondo rosso per l'errore
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Si è verificato un errore.',
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelLarge),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // L'utente ha annullato

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Gestisci errori specifici di Firebase (account disabilitato, ecc.)
      print(e.message);
    } catch (e) {
      // Gestisci altri errori generici
      print(e.toString());
    }
    return null;
  }

  Future<Utente?> recuperaUtente() async {
    if (currentUser != null) {
      final querySnapshot =
          await _db.collection("utente").doc(currentUser!.uid).get();
      final utente = Utente.fromMap(querySnapshot.data()!);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("nickname", utente.nickname);
      return utente;
    } else {
      return null;
    }
  }

  Future<void> logoutAccount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nickname");
    await _firebaseAuth.signOut();
  }

  Future<User?> sendEmailRestPassword({required String emailAddress}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailAddress);

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Email di recupero password inviata!',
            style: Theme.of(navigatorKey.currentContext!).textTheme.labelLarge,
          ),
          backgroundColor:
              Theme.of(navigatorKey.currentContext!).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Si è verificato un errore.',
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelLarge),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  Future<User?> confirmResetPassword(
      {required String newPassword, required String code}) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Password resettata con successo',
            style: Theme.of(navigatorKey.currentContext!).textTheme.labelLarge,
          ),
          backgroundColor:
              Theme.of(navigatorKey.currentContext!).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Si è verificato un errore.',
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelLarge),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }
}

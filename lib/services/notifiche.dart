import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mangacloud/models/notifica_payload.dart';
import 'package:mangacloud/services/manga.dart';
import 'package:http/http.dart' as http;
import 'package:mangacloud/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../pages/home_page.dart';

int idNotifica = 0;
AndroidInitializationSettings androidInit = const AndroidInitializationSettings('my_icon');
DarwinInitializationSettings iOSInit = const DarwinInitializationSettings();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
MangaService mangaService = MangaService();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifiche importanti',
    description: 'Questo canale viene utilizzato per notifiche importanti.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  String? url = message.data['imageUrl'];
  late AndroidBitmap<Object> androidBitmap;
  if(url != null) {
    var res = await http.get(Uri.parse(url));
    androidBitmap =
        ByteArrayAndroidBitmap.fromBase64String(base64Encode(res.bodyBytes));
  }
  var androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: url != null ? androidBitmap : null,
      styleInformation: url != null ? BigPictureStyleInformation(
        androidBitmap, // Passa il nome del file dell'asset
        hideExpandedLargeIcon: true,
      ) : null
  );

  // Impostazioni iOS (aggiunte)
  var iOSDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        url ?? '', // URL dell'immagine (per iOS)
      ),
    ],
  );

  var notificationDetails =
  NotificationDetails(android: androidDetails, iOS: iOSDetails); // Combina le impostazioni
  final payload = jsonEncode(NotificaPayload.fromMap(message.data).toJson());
  flutterLocalNotificationsPlugin.show(
    idNotifica++,
    message.data['title'],
    message.data['body'],
    notificationDetails,
    payload: payload, // Modifica qui
  );
}

class NotificheService {

  final notificationSettings = FirebaseMessaging.instance;

  void onDidReceiveNotificationResponse(NotificationResponse? notificationResponse) async {
    if(notificationResponse != null && notificationResponse.payload != null) {
      final payload = NotificaPayload.fromMap(jsonDecode(notificationResponse.payload!));
      if(payload.idVolume != null && payload.idCapitolo != null) {
        final args = await mangaService.getSingleCapitolo(
            idManga: payload.idManga, idVolume: payload.idVolume!,
            idCapitolo: payload.idCapitolo!);
        await navigatorKey.currentState?.pushNamed(
            '/capitolo', arguments: args);
      }
      else{
        final args = await mangaService.getSingleManga(
            idManga: payload.idManga);
        await navigatorKey.currentState?.pushNamed(
            '/volumi', arguments: args);
      }
    }
  }

  Future initPushNotifications() async {
    await notificationSettings.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // Iscrizione al topic
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('manga') == null) {
      notificationSettings.subscribeToTopic('manga');
      prefs.setBool('manga', true);
    }
    if(prefs.getBool('capitolo') == null) {
      notificationSettings.subscribeToTopic('capitolo');
      prefs.setBool('capitolo', true);
    }


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // **Listener per le notifiche in primo piano**
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Messaggio ricevuto in primo piano: ${message.notification?.title}');

      // Mostra la notifica utilizzando flutterLocalNotificationsPlugin
      _showLocalNotification(message);
    });
  }

  Future<void> initiNotifications() async {
    NotificationSettings settings =
        await notificationSettings.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      String? token;

      try {
        token = Platform.isIOS || Platform.isMacOS
            ? await notificationSettings.getAPNSToken()
            : await FirebaseMessaging.instance.getToken();
        print('token: $token');
      } catch (e) {
        print("Errore nel recupero del token: $e");
        token = null; // Imposta token a null in caso di errore
      }
      initLocalNotifications();
      initPushNotifications();
    } else {
      // openAppSettings(); // Apri le impostazioni dell'app (opzionale)
      print('Permessi di notifica non concessi');
    }
  }

  void _showLocalNotification(RemoteMessage message) async {
    late AndroidBitmap<Object> androidBitmap;
    String? url = message.data['imageUrl'];
    if(url != null) {
      var res = await http.get(Uri.parse(url));
      androidBitmap =
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(res.bodyBytes));
    }
    var androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // ID del canale
      'Notifiche importanti', // Nome del canale
      channelDescription:
          'Questo canale viene utilizzato per notifiche importanti.',
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: url != null ? androidBitmap : null,
      styleInformation: url != null ? BigPictureStyleInformation(
        androidBitmap, // Passa il nome del file dell'asset
        hideExpandedLargeIcon: true,
      ) : null
    );

    var iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: <DarwinNotificationAttachment>[
        DarwinNotificationAttachment(
          url ?? '', // URL dell'immagine (per iOS)
        ),
      ],
    );

    var notificationDetails = NotificationDetails(
        android: androidDetails, iOS: iOSDetails);

    final payload = jsonEncode(NotificaPayload.fromMap(message.data).toJson());
    flutterLocalNotificationsPlugin.show(
      idNotifica++,
      message.data['title'],
      message.data['body'],
      notificationDetails,
      payload: payload, // Modifica qui
    );
  }

  Future<void> initLocalNotifications() async {
    // Inizializza flutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidInit,
        iOS: iOSInit,
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Configura il canale di notifica
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notifiche importanti',
      description: 'Questo canale viene utilizzato per notifiche importanti.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  Future<bool> isSubscribedToTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(topic) ?? false; // Valore di default false se non trovato
  }

  Future<bool> unSubscribeFromTopic(String topic) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(topic, false);
      notificationSettings.unsubscribeFromTopic(topic);
      return true;
    }
    catch(e){
      print('errore durante la disiscrizione dal topic');
      return false;
    }
  }

  Future<bool> subscribeToTopic(String topic) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      notificationSettings.subscribeToTopic(topic);
      prefs.setBool(topic, true);
      return true;
    }
    catch(e){
      print('errore durante l\'iscrizione al topic');
      return false;
    }
  }

}

import 'package:firebase_core/firebase_core.dart';
import 'package:mangacloud/pages/auth.dart';
import 'package:mangacloud/routes.dart';
import 'package:mangacloud/services/authentication.dart';
import 'package:mangacloud/services/notifiche.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/pages/home_page.dart';
import 'style.dart' as style;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificheService().initiNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationService().authChange,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'MangaCloud',
          theme: ThemeData(
            colorScheme: style.appColorScheme,
            textTheme: style.appTextScheme,
          ),
          home: !snapshot.hasData ? AuthPage() : const HomePage(),
          onGenerateRoute: Routes.route,
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}

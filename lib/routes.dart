import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/models/capitolo.dart';
import 'package:mangacloud/pages/home_page.dart';
import 'package:mangacloud/pages/manga_details.dart';
import 'package:mangacloud/pages/search.dart';
import 'package:mangacloud/pages/view_manga.dart';

import 'models/manga.dart';

class Routes{

  static Route<dynamic> route(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/volumi':
        if(args is Manga) {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MangaDetails(manga: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => pushTransition(animation, child),
            transitionDuration: const Duration(milliseconds: 300), // Durata della transizione
          );
        } else {
          return MaterialPageRoute(builder: (context) => const HomePage());
        }
      case '/capitolo':
        if(args is Capitolo){
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ViewManga(capitolo: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => pushTransition(animation, child),
            transitionDuration: const Duration(milliseconds: 300), // Durata della transizione
          );
        }
        else{
          return MaterialPageRoute(builder: (context) => const HomePage());
        }
      case '/search':
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => pushTransition(animation, child),
            transitionDuration: const Duration(milliseconds: 300), // Durata della transizione
          );
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }

  static SlideTransition pushTransition(Animation<double> animation, Widget child) {
    const begin = Offset(1.0, 0.0); // Inizia fuori dallo schermo a destra
    const end = Offset.zero; // Fine dell'animazione (posizione finale)
    const curve = Curves.easeInOut; // Curva di animazione

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
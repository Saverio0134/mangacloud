import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/main.dart';

class Utils{
  Utils();
  double statusBarHeight = MediaQuery.of(navigatorKey.currentContext!).padding.top;
  double width = MediaQuery.sizeOf(navigatorKey.currentContext!).width;

}
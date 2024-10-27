import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/widgets/home/appbar/search_bar_fake.dart';

import '../../../utils.dart';
import 'button_account.dart';

class TitleHomeAppBar extends StatefulWidget{

  TitleHomeAppBar({super.key, required this.showTitle});

  bool showTitle;

  @override
  State<StatefulWidget> createState() => _TitleHomeAppBarState();
}

class _TitleHomeAppBarState extends State<TitleHomeAppBar>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 15, end: 15),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.showTitle
              ? BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 20, sigmaY: 5),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                SearchBarFake(
                  width: Utils().width - 80,
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withOpacity(0.7),
                ),
                const ButtonAccount(),
              ],
            ),
          )
              : SearchBarFake(
            width: double.infinity,
            color: Theme.of(context)
                .colorScheme
                .tertiary
                .withOpacity(0.8),
          )),
    );
  }

}
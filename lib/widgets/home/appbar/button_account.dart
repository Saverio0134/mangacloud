import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/pages/profile.dart';

class ButtonAccount extends StatelessWidget{
  const ButtonAccount({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: const Icon(Icons.account_circle_outlined, size: 30,),
      onTap: (){
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: const ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                ),
                height: 360,
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10, sigmaY: 10),child: ProfilePage())),
          );

      },
    );
  }
}
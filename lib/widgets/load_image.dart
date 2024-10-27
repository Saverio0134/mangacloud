import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadImageWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Shimmer.fromColors(
     baseColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
     highlightColor: Theme.of(context).colorScheme.tertiary,
     child: Container(
       color: Theme.of(context).colorScheme.surface,
     ),
   );
  }

}
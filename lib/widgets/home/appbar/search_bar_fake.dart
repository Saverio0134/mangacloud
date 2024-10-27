import 'package:flutter/material.dart';

class SearchBarFake extends StatelessWidget{
  const SearchBarFake({super.key, required this.width, required this.color});

  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.pushNamed(context, '/search');
      },
      borderRadius: BorderRadius.all(Radius.circular(25)),
      child: Container(
        padding: const EdgeInsetsDirectional.all(10),
        width: width,
        height: 45,
        decoration: ShapeDecoration(
          shape: const ContinuousRectangleBorder(
              side: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(80))
          ),
          color: color,
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.white.withOpacity(0.8),),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Cerca tra i manga...', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white.withOpacity(0.5)),),
            )
          ],
        ),
      ),
    );
  }
}
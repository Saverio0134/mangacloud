import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

String urlSpinner = '';

class Spinner extends StatefulWidget {
  const Spinner({super.key});

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner>  with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durata di una rotazione completa
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition( // Usa AnimatedRotation per ruotare l'immagine
        turns: _animationController,
        child: CachedNetworkImage(imageUrl: urlSpinner, width: 40, height: 40), // Sostituisci con il percorso della tua immagine
      ),
    );
  }
}
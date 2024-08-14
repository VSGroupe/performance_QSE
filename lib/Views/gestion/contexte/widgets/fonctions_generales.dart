import 'package:flutter/material.dart';

class FonctionsGenerales extends StatefulWidget {
  const FonctionsGenerales({Key? key}) : super(key: key);

  @override
  State<FonctionsGenerales> createState() => _FonctionsGeneralesState();
}

class _FonctionsGeneralesState extends State<FonctionsGenerales> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Pages relatives aux fonctions générales",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

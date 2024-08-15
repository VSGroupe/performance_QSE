import 'package:flutter/material.dart';

class Ajouter extends StatefulWidget {
  const Ajouter({Key? key}) : super(key: key);

  @override
  State<Ajouter> createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Ajouter",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

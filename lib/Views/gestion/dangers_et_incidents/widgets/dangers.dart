import 'package:flutter/material.dart';

class Dangers extends StatefulWidget {
  const Dangers({Key? key}) : super(key: key);

  @override
  State<Dangers> createState() => _DangersState();
}

class _DangersState extends State<Dangers> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Affichage d'une liste de dangers",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

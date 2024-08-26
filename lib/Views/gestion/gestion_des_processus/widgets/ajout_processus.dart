import 'package:flutter/material.dart';

class AjoutProcessus extends StatefulWidget {
  const AjoutProcessus({Key? key}) : super(key: key);

  @override
  State<AjoutProcessus> createState() => _AjoutProcessusState();
}

class _AjoutProcessusState extends State<AjoutProcessus> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Ajouter un processus",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

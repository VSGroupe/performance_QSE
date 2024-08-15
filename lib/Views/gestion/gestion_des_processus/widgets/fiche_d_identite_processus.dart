import 'package:flutter/material.dart';

class FicheDIdentiteProcessus extends StatefulWidget {
  const FicheDIdentiteProcessus({Key? key}) : super(key: key);

  @override
  State<FicheDIdentiteProcessus> createState() => _FicheDIdentiteProcessusState();
}

class _FicheDIdentiteProcessusState extends State<FicheDIdentiteProcessus> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Fiche d'identité des processus",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

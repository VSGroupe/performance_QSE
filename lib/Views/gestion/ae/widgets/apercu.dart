import 'package:flutter/material.dart';

class Apercu extends StatefulWidget {
  const Apercu({Key? key}) : super(key: key);

  @override
  State<Apercu> createState() => _ApercuState();
}

class _ApercuState extends State<Apercu> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Aperçu des aspects environnementaux",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

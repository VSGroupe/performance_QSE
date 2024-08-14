import 'package:flutter/material.dart';

class Incidents extends StatefulWidget {
  const Incidents({Key? key}) : super(key: key);

  @override
  State<Incidents> createState() => _IncidentsState();
}

class _IncidentsState extends State<Incidents> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Pages d'affichage de la liste des incidents",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

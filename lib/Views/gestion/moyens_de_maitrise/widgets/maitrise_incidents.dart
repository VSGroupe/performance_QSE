import 'package:flutter/material.dart';

class MaitriseIncidents extends StatefulWidget {
  const MaitriseIncidents({Key? key}) : super(key: key);

  @override
  State<MaitriseIncidents> createState() => _MaitriseIncidentsState();
}

class _MaitriseIncidentsState extends State<MaitriseIncidents> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Maîtrise incidents",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

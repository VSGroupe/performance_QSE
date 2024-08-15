import 'package:flutter/material.dart';

class MaitriseRisques extends StatefulWidget {
  const MaitriseRisques({Key? key}) : super(key: key);

  @override
  State<MaitriseRisques> createState() => _MaitriseRisquesState();
}

class _MaitriseRisquesState extends State<MaitriseRisques> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Maîtrise des Risques",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MaitriseUrgences extends StatefulWidget {
  const MaitriseUrgences({Key? key}) : super(key: key);

  @override
  State<MaitriseUrgences> createState() => _MaitriseUrgencesState();
}

class _MaitriseUrgencesState extends State<MaitriseUrgences> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Maîtrise Urgences",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

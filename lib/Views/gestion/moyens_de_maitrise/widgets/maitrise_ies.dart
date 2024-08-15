import 'package:flutter/material.dart';

class MaitriseIes extends StatefulWidget {
  const MaitriseIes({Key? key}) : super(key: key);

  @override
  State<MaitriseIes> createState() => _MaitriseIesState();
}

class _MaitriseIesState extends State<MaitriseIes> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Maîtrise IES",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

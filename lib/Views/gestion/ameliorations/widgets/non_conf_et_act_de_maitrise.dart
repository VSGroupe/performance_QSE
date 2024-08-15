import 'package:flutter/material.dart';

class NonConfEtActDeMaitrise extends StatefulWidget {
  const NonConfEtActDeMaitrise({Key? key}) : super(key: key);

  @override
  State<NonConfEtActDeMaitrise> createState() => _NonConfEtActDeMaitriseState();
}

class _NonConfEtActDeMaitriseState extends State<NonConfEtActDeMaitrise> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Non conformités et actions de maîtrise",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RapportDuRisque extends StatefulWidget {
  const RapportDuRisque({Key? key}) : super(key: key);

  @override
  State<RapportDuRisque> createState() => _RapportDuRisqueState();
}

class _RapportDuRisqueState extends State<RapportDuRisque> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Plan d'action",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

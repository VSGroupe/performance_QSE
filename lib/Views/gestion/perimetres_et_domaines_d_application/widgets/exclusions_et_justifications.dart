import 'package:flutter/material.dart';

class ExclusionsEtJustifications extends StatefulWidget {
  const ExclusionsEtJustifications({Key? key}) : super(key: key);

  @override
  State<ExclusionsEtJustifications> createState() => _ExclusionsEtJustificationsState();
}

class _ExclusionsEtJustificationsState extends State<ExclusionsEtJustifications> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Exclusions et justifications",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

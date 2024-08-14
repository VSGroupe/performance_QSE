import 'package:flutter/material.dart';

class ModifierDangerOuIncident extends StatefulWidget {
  const ModifierDangerOuIncident({Key? key}) : super(key: key);

  @override
  State<ModifierDangerOuIncident> createState() => _ModifierDangerOuIncidentState();
}

class _ModifierDangerOuIncidentState extends State<ModifierDangerOuIncident> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Modifier, ajouter ou supprimer un danger ou un incident",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

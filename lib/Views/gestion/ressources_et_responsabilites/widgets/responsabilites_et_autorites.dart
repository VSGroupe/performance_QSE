import 'package:flutter/material.dart';

class ResponsabilitesEtAutorites extends StatefulWidget {
  const ResponsabilitesEtAutorites({Key? key}) : super(key: key);

  @override
  State<ResponsabilitesEtAutorites> createState() => _ResponsabilitesEtAutoritesState();
}

class _ResponsabilitesEtAutoritesState extends State<ResponsabilitesEtAutorites> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Page d'affichage des ressources et responsabilités",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

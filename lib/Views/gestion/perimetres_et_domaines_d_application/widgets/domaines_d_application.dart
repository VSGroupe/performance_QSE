import 'package:flutter/material.dart';

class DomainesDApplication extends StatefulWidget {
  const DomainesDApplication({Key? key}) : super(key: key);

  @override
  State<DomainesDApplication> createState() => _DomainesDApplicationState();
}

class _DomainesDApplicationState extends State<DomainesDApplication> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Informations Informations relatives aux périmètres et domaines d'application",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

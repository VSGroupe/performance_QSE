import 'package:flutter/material.dart';

class ImpactsEnvironnementaux extends StatefulWidget {
  const ImpactsEnvironnementaux({Key? key}) : super(key: key);

  @override
  State<ImpactsEnvironnementaux> createState() => _ImpactsEnvironnementauxState();
}

class _ImpactsEnvironnementauxState extends State<ImpactsEnvironnementaux> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Impacts environnementaux",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

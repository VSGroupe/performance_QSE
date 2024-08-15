import 'package:flutter/material.dart';

class Modifier extends StatefulWidget {
  const Modifier({Key? key}) : super(key: key);

  @override
  State<Modifier> createState() => _ModifierState();
}

class _ModifierState extends State<Modifier> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Modifier un aspect envrironnemental",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

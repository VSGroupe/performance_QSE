import 'package:flutter/material.dart';

class ModifierInfosPartiesInteressees extends StatefulWidget {
  const ModifierInfosPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ModifierInfosPartiesInteressees> createState() => _ModifierInfosPartiesInteresseesState();
}

class _ModifierInfosPartiesInteresseesState extends State<ModifierInfosPartiesInteressees> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Faire une modification des infos sur les parties intéressées",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ApercuPartiesInteressees extends StatefulWidget {
  const ApercuPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ApercuPartiesInteressees> createState() => _ApercuPartiesInteresseesState();
}

class _ApercuPartiesInteresseesState extends State<ApercuPartiesInteressees> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Tableau relatif aux informations sur les parties intétessées",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

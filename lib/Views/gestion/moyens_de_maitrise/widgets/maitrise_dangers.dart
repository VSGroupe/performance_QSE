import 'package:flutter/material.dart';

class MaitriseDangers extends StatefulWidget {
  const MaitriseDangers({Key? key}) : super(key: key);

  @override
  State<MaitriseDangers> createState() => _MaitriseDangersState();
}

class _MaitriseDangersState extends State<MaitriseDangers> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Maîtrise des dangers",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

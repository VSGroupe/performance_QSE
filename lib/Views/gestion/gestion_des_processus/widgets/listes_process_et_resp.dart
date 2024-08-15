import 'package:flutter/material.dart';

class ListesProcessEtResp extends StatefulWidget {
  const ListesProcessEtResp({Key? key}) : super(key: key);

  @override
  State<ListesProcessEtResp> createState() => _ListesProcessEtRespState();
}

class _ListesProcessEtRespState extends State<ListesProcessEtResp> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Liste des processus et responsabilités",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

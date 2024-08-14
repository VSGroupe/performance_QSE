import 'package:flutter/material.dart';

class ImpactsSocietaux extends StatefulWidget {
  const ImpactsSocietaux({Key? key}) : super(key: key);

  @override
  State<ImpactsSocietaux> createState() => _ImpactsSocietauxState();
}

class _ImpactsSocietauxState extends State<ImpactsSocietaux> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Les impacts sociétaux",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

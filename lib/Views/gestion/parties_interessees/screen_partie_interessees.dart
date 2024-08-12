import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'parties_interessees.dart';

class ScreenPartieInteressees extends StatefulWidget {
  /// Constructs a [ScreenContexte] widget.
  const ScreenPartieInteressees({Key? key}) : super(key: key);

  @override
  State<ScreenPartieInteressees> createState() => _ScreenPartieInteresseesState();
}

class _ScreenPartieInteresseesState extends State<ScreenPartieInteressees> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: const Text(
                "MANAGEMENT DES PARTIES INTERESSEES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3C3D3F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(
            //   child: Obx(() {
            //     return Contexte();
            //   }),
            // ),
            Expanded(
              child: PartiesInteressees(),
            ),
          ],
        ),
      ),
    );
  }
}

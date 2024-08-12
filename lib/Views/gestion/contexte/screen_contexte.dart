import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'contexte.dart';

class ScreenContexte extends StatefulWidget {
  /// Constructs a [ScreenContexte] widget.
  const ScreenContexte({Key? key}) : super(key: key);

  @override
  State<ScreenContexte> createState() => _ScreenContexteState();
}

class _ScreenContexteState extends State<ScreenContexte> {
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
            const Text(
              "Contexte",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3C3D3F),
                fontWeight: FontWeight.bold,
              ),
            ),
            // Expanded(
            //   child: Obx(() {
            //     return Contexte();
            //   }),
            // ),
            Expanded(
              child: Contexte(),
            ),
          ],
        ),
      ),
    );
  }
}

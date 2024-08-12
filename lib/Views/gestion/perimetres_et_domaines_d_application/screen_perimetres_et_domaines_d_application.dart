import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'perimetres_et_domaines_d_application.dart';

class ScreenPerimetresEtDomainesDApplication extends StatefulWidget {
  /// Constructs a [ScreenContexte] widget.
  const ScreenPerimetresEtDomainesDApplication({Key? key}) : super(key: key);

  @override
  State<ScreenPerimetresEtDomainesDApplication> createState() => _ScreenPerimetresEtDomainesDApplicationState();
}

class _ScreenPerimetresEtDomainesDApplicationState extends State<ScreenPerimetresEtDomainesDApplication> {
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
                "Périmètres et Domaines d'application",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
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
              child: PerimetresEtDomainesDApplication(),
            ),
          ],
        ),
      ),
    );
  }
}

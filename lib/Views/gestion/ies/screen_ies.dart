import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/routes/routes.dart';
import 'ies.dart';

class ScreenIes extends StatefulWidget {
  /// Constructs a [ScreenIes] widget.
  const ScreenIes({Key? key}) : super(key: key);

  @override
  State<ScreenIes> createState() => _ScreenIesState();
}

class _ScreenIesState extends State<ScreenIes> {
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
            const SizedBox(height: 15),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.go("/gestion/accueil"); // Action de retour
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF3C3D3F), // Couleur de l'icône
                  ),
                  label: const Text(
                    "Retour",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3C3D3F), // Couleur du texte
                    ),
                  ),
                ),
                // const SizedBox(width: 8), // Espacement entre le bouton et l'image
                // Image.asset(
                //   'assets/icons/environnement.png', // Remplacez par le chemin de votre image
                //   width: 30, // Ajustez la taille de l'image si nécessaire
                //   height: 40,
                // ),
                const SizedBox(width: 330), // Espacement entre l'image et le texte
                const Text(
                  "Impacts environnementaux et sociétaux",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF3C3D3F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Ies(),
            ),
          ],
        ),
      ),
    );
  }
}

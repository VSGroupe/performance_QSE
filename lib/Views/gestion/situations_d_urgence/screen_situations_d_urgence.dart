import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'suituations_d_urgence.dart';

class ScreenSituationsDUrgence extends StatefulWidget {
  /// Constructs a [ScreenSituationsDUrgence] widget.
  const ScreenSituationsDUrgence({Key? key}) : super(key: key);

  @override
  State<ScreenSituationsDUrgence> createState() => _ScreenSituationsDUrgenceState();
}

class _ScreenSituationsDUrgenceState extends State<ScreenSituationsDUrgence> {
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
                const SizedBox(width: 395), // Espacement entre l'image et le texte
                const Text(
                  "Situations d'urgence",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF3C3D3F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SuituationsDUrgence(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApercuPartiesInteressees extends StatefulWidget {
  const ApercuPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ApercuPartiesInteressees> createState() => _ApercuPartiesInteresseesState();
}

class _ApercuPartiesInteresseesState extends State<ApercuPartiesInteressees> {
  final SupabaseClient supabase = Supabase.instance.client;

  // Listes pour stocker les parties intéressées en fonction du type
  List<String> internes = [];
  List<String> partenairesEco = [];
  List<String> regulateurs = [];
  List<String> influenceurs = [];

  @override
  void initState() {
    super.initState();
    fetchPartiesInteressees();
  }

  // Fonction pour récupérer les parties intéressées de la base de données
  Future<void> fetchPartiesInteressees() async {
    try {
      final response = await supabase.from('PartiesInteressees').select().execute();

      if (response.data != null) {
        print("\nDonnées récupérées avec succès:\nLes Données:\n");
        final data = response.data as List<dynamic>;
        print("\n");
        print(data);
        print("\n");

        setState(() {
          // Filtrer les données en fonction du type_pi
          internes = data.where((pi) => pi['type_pi'] == 'interne').map<String>((pi) => pi['libelle']).toList();
          print("Les parties intéressées internes:\n");
          print(internes);
          print("\n");
          partenairesEco = data.where((pi) => pi['type_pi'] == 'partenaire eco').map<String>((pi) => pi['libelle']).toList();
          regulateurs = data.where((pi) => pi['type_pi'] == 'regulateur').map<String>((pi) => pi['libelle']).toList();
          influenceurs = data.where((pi) => pi['type_pi'] == 'influenceur').map<String>((pi) => pi['libelle']).toList();
        });
      } else {
        // Gérer l'erreur
        print('Erreur lors de la récupération des données : ${response.status}');
      }
    } catch (e) {
      // Gérer l'exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties Intéressées'),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(485, 485),
          painter: QuadrantPainter(),
          child: SizedBox(
            width: 485,
            height: 485,
            child: Stack(
              children: [
                // Quadrant 1 - Parties prenantes internes
                Positioned(
                  top: 100,
                  left: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.red.withOpacity(0.0),
                    child: buildPartiesList(internes, "Parties prenantes internes"),
                  ),
                ),
                // Quadrant 2 - Partenaires économiques
                Positioned(
                  top: 100,
                  right: 31,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.green.withOpacity(0.0),
                    child: buildPartiesList(partenairesEco, "Partenaires économiques"),
                  ),
                ),
                // Quadrant 3 - Régulateurs
                Positioned(
                  bottom: 124,
                  left: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.blue.withOpacity(0.0),
                    child: buildPartiesList(regulateurs, "Régulateurs"),
                  ),
                ),
                // Quadrant 4 - Influenceurs sociétaux
                Positioned(
                  bottom: 125,
                  right: 31,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.yellow.withOpacity(0.0),//Colors.yellow.withOpacity(0.0),
                    child: buildPartiesList(influenceurs, "Influenceurs sociétaux"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget pour afficher la liste des parties intéressées sous forme de boutons
  Widget buildPartiesList(List<String> parties, String title) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 10,
          width: 210,
          height: 116,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centre le titre horizontalement
              children: [
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center, // Centre le texte dans le widget
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8), // Espacement entre le titre et les boutons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var partie in parties) ...[
                          SizedBox(
                            width: 200, // Largeur définie pour les boutons
                            child: ElevatedButton(
                              onPressed: () {
                                // Action sur le bouton
                                print('Sélectionné: $partie');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white, // Couleur du texte et du fond
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10), // Ajuste la hauteur du bouton
                                alignment: Alignment.centerLeft, // Aligne le texte à gauche
                              ),
                              child: Text(
                                partie,
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4), // Espacement de 4 pixels entre les boutons
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuadrantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);

    // Quadrant 1 - Haut Gauche (Influenceurs sociétaux)
    paint.color = Colors.red;
    canvas.drawArc(rect, pi, pi / 2, true, paint);

    // Quadrant 2 - Haut Droit (Partenaires économiques)
    paint.color = Colors.green;
    canvas.drawArc(rect, 3 * pi / 2, pi / 2, true, paint);

    // Quadrant 3 - Bas Gauche (Régulateurs)
    paint.color = Colors.blue;
    canvas.drawArc(rect, pi / 2, pi / 2, true, paint);

    // Quadrant 4 - Bas Droit (Parties prenantes internes)
    paint.color = Colors.yellow;
    canvas.drawArc(rect, 0, pi / 2, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

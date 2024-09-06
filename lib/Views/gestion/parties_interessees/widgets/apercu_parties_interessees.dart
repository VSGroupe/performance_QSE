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
        final data = response.data as List<dynamic>;

        setState(() {
          // Filtrer les données en fonction du type_pi
          internes = data.where((pi) => pi['type_pi'] == 'interne').map<String>((pi) => pi['libelle']).toList();
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
                  right: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.green.withOpacity(0.0),
                    child: buildPartiesList(partenairesEco, "Partenaires économiques"),
                  ),
                ),
                // Quadrant 3 - Régulateurs
                Positioned(
                  bottom: 100,
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
                  bottom: 100,
                  right: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.yellow.withOpacity(0.0),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  for (var partie in parties)
                    ElevatedButton(
                      onPressed: () {
                        // Action sur le bouton
                        print('Sélectionné: $partie');
                      },
                      child: Text(partie),
                    ),
                ],
              ),
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

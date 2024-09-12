import 'dart:math';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApercuPartiesInteressees extends StatefulWidget {
  const ApercuPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ApercuPartiesInteressees> createState() => _ApercuPartiesInteresseesState();
}

class _ApercuPartiesInteresseesState extends State<ApercuPartiesInteressees> {

  final String baseUrl = "http://localhost:5000";

  // Listes pour stocker les parties intéressées en fonction du type
  List<Map<String, dynamic>> internes = [];
  List<Map<String, dynamic>> partenairesEco = [];
  List<Map<String, dynamic>> regulateurs = [];
  List<Map<String, dynamic>> influenceurs = [];

  @override
  void initState() {
    super.initState();
    fetchPartiesInteressees();
  }

  // Fonction pour récupérer les parties intéressées de la base de données
  Future<void> fetchPartiesInteressees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parties_interessees'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          // Caster les données en List<Map<String, dynamic>>
          List<Map<String, dynamic>> partiesList = data.cast<Map<String, dynamic>>();

          internes = partiesList.where((pi) => pi['type_pi'] == 'interne').toList();
          partenairesEco = partiesList.where((pi) => pi['type_pi'] == 'partenaire eco').toList();
          regulateurs = partiesList.where((pi) => pi['type_pi'] == 'regulateur').toList();
          influenceurs = partiesList.where((pi) => pi['type_pi'] == 'influenceur').toList();
        });
      } else {
        print('Erreur lors de la récupération des données : ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  // Fonction pour afficher la boîte de dialogue avec les détails d'une partie intéressée
  void showPartieDetailsDialog(BuildContext context, Map<String, dynamic> partie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 350.0,
              minWidth: 350.0,
              minHeight: 250.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      partie['libelle'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Catégorie : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                TextSpan(
                                  text: '${partie['categorie']}',
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Poids : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                TextSpan(
                                  text: '${partie['poids_pi']}',
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ButtonBar(
                    alignment: MainAxisAlignment.end, // Aligne les boutons à droite
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                          foregroundColor: Colors.white, backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties Intéressées'),
      ),
      body: Center(
        child: Row(
          children: [
            // Légende à gauche du cercle
            buildLegend(),
            const SizedBox(width: 250),
            CustomPaint(
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
                      left: 30,
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
                      right: 21,
                      width: 220,
                      height: 140,
                      child: Container(
                        color: Colors.green.withOpacity(0.0),
                        child: buildPartiesList(partenairesEco, "Partenaires économiques"),
                      ),
                    ),
                    // Quadrant 3 - Régulateurs
                    Positioned(
                      bottom: 101,
                      left: 30,
                      width: 220,
                      height: 140,
                      child: Container(
                        color: Colors.blue.withOpacity(0.0),
                        child: buildPartiesList(regulateurs, "Régulateurs"),
                      ),
                    ),
                    // Quadrant 4 - Influenceurs sociétaux
                    Positioned(
                      bottom: 101,
                      right: 21,
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
          ],
        ),
      ),
    );
  }

  // Widget pour afficher la liste des parties intéressées sous forme de boutons
  Widget buildPartiesList(List<Map<String, dynamic>> parties, String title) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: 210,
          height: 150,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centre le titre horizontalement
              children: [
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center, // Centre le texte dans le widget
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 7), // Espacement entre le titre et les boutons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var partie in parties) ...[
                          SizedBox(
                            width: 188, // Largeur définie pour les boutons
                            child: ElevatedButton(
                              onPressed: () {
                                showPartieDetailsDialog(context, partie);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                alignment: Alignment.centerLeft, // Aligne le texte à gauche
                              ),
                              child: Text(
                                partie['libelle'],
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
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


  // Widget pour afficher la légende
  Widget buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLegendItem('Parties prenantes internes', Colors.red),
        buildLegendItem('Partenaires économiques', Colors.green),
        buildLegendItem('Régulateurs', Colors.blue),
        buildLegendItem('Influenceurs sociétaux', Colors.blueGrey),
      ],
    );
  }

  // Widget pour chaque élément de la légende
  Widget buildLegendItem(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
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
    paint.color = Colors.blueGrey;
    canvas.drawArc(rect, 0, pi / 2, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

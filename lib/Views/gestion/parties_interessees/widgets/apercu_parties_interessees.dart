import 'package:flutter/material.dart';
import 'dart:math';

class ApercuPartiesInteressees extends StatefulWidget {
  const ApercuPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ApercuPartiesInteressees> createState() => _ApercuPartiesInteresseesState();
}

class _ApercuPartiesInteresseesState extends State<ApercuPartiesInteressees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties Intéressées'),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(485, 485), // Taille du cercle
          painter: QuadrantPainter(),
          child: SizedBox(
            width: 485,
            height: 485,
            child: Stack(
              children: [
                // Quadrant 1 - Influenceurs sociétaux
                Positioned(
                  top: 100,
                  left: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.red.withOpacity(0.0), // Légère couleur pour visualiser le quadrant
                    child: Stack(
                      children: [
                        Positioned(
                          top: 24, // Ajustez la position en fonction des besoins
                          left: 10, // Ajustez la position en fonction des besoins
                          width: 210, // Ajustez la largeur en fonction des besoins
                          height: 116, // Ajustez la hauteur en fonction des besoins
                          child: Container(
                            color: Colors.white, // Couleur de fond du container
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Influenceurs sociétaux", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ElevatedButton(onPressed: () {}, child: Text("Médias")),
                                  ElevatedButton(onPressed: () {}, child: Text("Communautés locales")),
                                  ElevatedButton(onPressed: () {}, child: Text("Associations et ONG")),
                                  ElevatedButton(onPressed: () {}, child: Text("Secteur académique")),
                                  ElevatedButton(onPressed: () {}, child: Text("Société civile")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Quadrant 2 - Partenaires économiques
                Positioned(
                  top: 100,
                  right: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.green.withOpacity(0.0), // Légère couleur pour visualiser le quadrant
                    child: Stack(
                      children: [
                        Positioned(
                          top: 24, // Ajustez la position en fonction des besoins
                          left: 0, // Ajustez la position en fonction des besoins
                          width: 210, // Ajustez la largeur en fonction des besoins
                          height: 116, // Ajustez la hauteur en fonction des besoins
                          child: Container(
                            color: Colors.white, // Couleur de fond du container
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Partenaires économiques", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ElevatedButton(onPressed: () {}, child: Text("Actionnaires")),
                                  ElevatedButton(onPressed: () {}, child: Text("Investisseurs")),
                                  ElevatedButton(onPressed: () {}, child: Text("Clients")),
                                  ElevatedButton(onPressed: () {}, child: Text("Fournisseurs")),
                                  ElevatedButton(onPressed: () {}, child: Text("Sous-traitants")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Quadrant 3 - Régulateurs
                Positioned(
                  bottom: 100,
                  left: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.blue.withOpacity(0.0), // Légère couleur pour visualiser le quadrant
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 24, // Ajustez la position en fonction des besoins
                          left: 10, // Ajustez la position en fonction des besoins
                          width: 210, // Ajustez la largeur en fonction des besoins
                          height: 116, // Ajustez la hauteur en fonction des besoins
                          child: Container(
                            color: Colors.white, // Couleur de fond du container
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Régulateurs", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ElevatedButton(onPressed: () {}, child: Text("Pouvoirs publics")),
                                  ElevatedButton(onPressed: () {}, child: Text("Autorités de régulation")),
                                  ElevatedButton(onPressed: () {}, child: Text("Associations professionnelles")),
                                  ElevatedButton(onPressed: () {}, child: Text("Réseaux sectoriels")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Quadrant 4 - Parties prenantes internes
                Positioned(
                  bottom: 100,
                  right: 20,
                  width: 220,
                  height: 140,
                  child: Container(
                    color: Colors.yellow.withOpacity(0.0), // Légère couleur pour visualiser le quadrant
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          bottom: 24, // Ajustez la position en fonction des besoins
                           // Ajustez la position en fonction des besoins
                          width: 210, // Ajustez la largeur en fonction des besoins
                          height: 116, // Ajustez la hauteur en fonction des besoins
                          child: Container(
                            color: Colors.white, // Couleur de fond du container
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Parties prenantes internes", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ElevatedButton(onPressed: () {}, child: Text("Comité de direction")),
                                  ElevatedButton(onPressed: () {}, child: Text("Administrateurs")),
                                  ElevatedButton(onPressed: () {}, child: Text("Salariés")),
                                  ElevatedButton(onPressed: () {}, child: Text("Syndicats")),
                                  ElevatedButton(onPressed: () {}, child: Text("Comités divers")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuadrantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

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

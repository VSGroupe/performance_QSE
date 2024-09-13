import 'package:flutter/material.dart';

class FicheDIdentiteProcessus extends StatefulWidget {
  const FicheDIdentiteProcessus({Key? key}) : super(key: key);

  @override
  State<FicheDIdentiteProcessus> createState() => _FicheDIdentiteProcessusState();
}

class _FicheDIdentiteProcessusState extends State<FicheDIdentiteProcessus> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Color(0xFF7FC01E),
            child: const SizedBox(
              width: 50,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("F", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("O", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("U", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("R", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("I", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("E", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("U", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("R", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10,),

          Container(
            // color: Colors.blueGrey,
            child: SizedBox(
              width: 700,
              height: 470,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    // color: Colors.orange,
                    height: 150,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD67B84), // La couleur de fond du conteneur
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(60),
                              bottomLeft: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(60),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Container(
                              color: Color(0xFFD67B84),
                              width: 300,
                              height: double.maxFinite,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text(
                                      "Moyens, Outils",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 50,
                                    child: Image.asset(
                                      "assets/images/home1.png",
                                      width: 100.0,
                                      height: 80.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(60),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(60)
                          ),
                          child: Container(
                            color:Color(0xFFD67B84),
                            width: 300,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text("Acteurs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                    top: 40,
                                    left: 50,
                                    child: Image.asset(
                                      "assets/images/home1.png",
                                      width: 100.0,
                                      height: 80.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 20,
                    ),
                    // color: Colors.purple,
                    height: 120,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipPath(
                          clipper: TriangleClipper(), // Utilisation d'un clipper personnalisé
                          child: Container(
                            color: Color(0xFF7FC01E),
                            width: 240,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text("Données\nd'entrée", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                  top: 40,
                                  left: 50,
                                  child: Image.asset(
                                    "assets/images/home1.png",
                                    width: 60.0,
                                    height: 40.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          child: Container(
                            color: Color(0xFF7FC01E),
                            width: 200,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 120,
                                    child: Text("Processus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                    top: 40,
                                    left: 50,
                                    child: Image.asset(
                                      "assets/images/home1.png",
                                      width: 60.0,
                                      height: 40.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: TriangleClipper(), // Utilisation d'un clipper personnalisé
                          child: Container(
                            color: Color(0xFF7FC01E),
                            width: 240,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text("Données\nde sortie", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                  top: 40,
                                  left: 50,
                                  child: Image.asset(
                                    "assets/images/home1.png",
                                    width: 60.0,
                                    height: 40.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    // color: Colors.green,
                    height: 150,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(60),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(60)
                          ),
                          child: Container(
                            color:Color(0xFFD67B84),
                            width: 300,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text("Méthodes/Instructions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                    top: 40,
                                    left: 50,
                                    child: Image.asset(
                                      "assets/images/home1.png",
                                      width: 100.0,
                                      height: 80.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(60),
                            bottomLeft: Radius.circular(10)
                          ),
                          child: Container(
                            color:Color(0xFFD67B84),
                            width: 300,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 50,
                                    left: 140,
                                    child: Text("Indicateurs & Objectifs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                Positioned(
                                    top: 40,
                                    left: 50,
                                    child: Image.asset(
                                      "assets/images/home1.png",
                                      width: 100.0,
                                      height: 80.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10,),

          Container(
            color: Color(0xFF7FC01E),
            child: const SizedBox(
              width: 50,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("C", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("L", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("I", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("E", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("T", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Début en haut à gauche
    path.moveTo(0, 0);

    // Côté gauche
    path.lineTo(0, size.height);

    // Côté bas
    path.lineTo(size.width - 60, size.height);  // Ajuste cette valeur pour la pointe
    path.lineTo(size.width, size.height / 2);   // Crée la pointe du triangle

    // Côté haut
    path.lineTo(size.width - 60, 0);  // Ajuste cette valeur pour la pointe

    // Ferme le chemin
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}


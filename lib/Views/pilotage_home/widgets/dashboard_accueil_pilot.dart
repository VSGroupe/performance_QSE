import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:perfqse/Views/gestion/ae/controller/ae_controller.dart';

import '../controller/accueil_pilot_controller.dart';

class DashboardAccueilPilot extends StatefulWidget {
  const DashboardAccueilPilot({super.key});

  @override
  State<DashboardAccueilPilot> createState() => _DashboardAccueilPilotState();
}

class _DashboardAccueilPilotState extends State<DashboardAccueilPilot> {

  final ControllerAudit controllerAudit = Get.put(ControllerAudit());
  final AccueilPilotController accueilPilotController = Get.put(AccueilPilotController());

  final storage = FlutterSecureStorage();
  final String location = "/accueil_piotage";

  bool _isHoveringBox2 = false;
  bool _isHoveringBox3 = false;
  bool _isHoveringBox5 = false;
  bool _isHoveringBox9 = false;
  bool _isHoveringBox10 = false;
  bool _isHoveringBox11 = false;

  @override
  void initState() {
    super.initState();
    accueilPilotController.aAfficher.value=0;
  }

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas la référence d'accès à cet espace."),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getAccess(String centerTitle) async {
    String? reference = await storage.read(key: "ref");
    List<String> ref = ["QX", "SX"]; // ["Q", "S", "E", "QSE"]
    if (reference != null) {
      ref = reference.split("\n");
    }
    if (ref.contains(centerTitle)) {
      controllerAudit.reference.value = centerTitle;
      context.go(location);
    } else {
      _showDialogNoAcces();
    }
  }

  void _hideInformation() {
    setState(() {
    });
  }

  // le corps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _hideInformation,
        child: Stack(
          children: [
            // Full-screen GestureDetector to hide information when clicking outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideInformation,
                child: Container(color: Colors.transparent),
              ),
            ),



            // Le text "SYSTEME DE MANAGEMENT INTEGRE"

            Positioned(
              top: 10,
              right: 195,
              child: InkWell(
                child: SizedBox(
                  height: 50,
                  width: 900,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(0),
                          child: RichText(text:TextSpan(
                              text:"SYSTEME DE PILOTAGE ",style: TextStyle(fontSize: 40,color:Colors.grey.shade700,fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text:" PERFORMANCE ",style: TextStyle(fontSize: 40,color:Color.fromRGBO(42,77,4,1),fontWeight: FontWeight.bold),),
                                TextSpan(text:" Q",style: TextStyle(fontSize: 40,color:Color.fromRGBO(172,28,12,1),fontWeight: FontWeight.bold),),
                                TextSpan(text:"S",style: TextStyle(fontSize: 40,color:Color.fromRGBO(206,131,0,1),fontWeight: FontWeight.bold),),
                                TextSpan(text:"E",style: TextStyle(fontSize: 40,color:Color.fromRGBO(42,77,4,1),fontWeight: FontWeight.bold),)
                              ]
                          ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // La barre d'image

            Positioned(
              top: 80,
              right: 220,
              child: InkWell(
                child: SizedBox(
                  height: 130,
                  width: 850,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/Banière_Performance_QSE.png"),
                          fit: BoxFit.fitWidth),
                      color: Colors.grey, // Changez la couleur de fond selon vos besoins
                      border: Border.all(color: Colors.white, width: 2), // Bordure grise
                      borderRadius: BorderRadius.circular(20), // Bordure circulaire
                    ),
                    // child: Stack(
                    //   children: [
                    //     Positioned(
                    //       top: 15, // Positionner l'image en haut
                    //       left: 0,
                    //       right: 0, // Centrer horizontalement
                    //       child: SizedBox(
                    //         height: 50,
                    //         width: 80,
                    //         child: Image.asset("assets/images/barre_qse.jpg", fit: BoxFit.contain),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       top: 10, // Positionner le texte en bas avec un padding de 10
                    //       left: 500,
                    //       right: 0,
                    //       child: Text(
                    //         'Q',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       bottom: 10, // Positionner le texte en bas avec un padding de 10
                    //       left: 0,
                    //       right: 0,
                    //       child: Text(
                    //         'S',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       top: 10, // Positionner le texte en bas avec un padding de 10
                    //       left: 0,
                    //       right: 500,
                    //       child: Text(
                    //         'E',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            ),


            // Les annotations qui suivront sont à lire du haut vers le bas et de la gauche vers la droite

            // 1

            Positioned(
              top: 230,
              right: 827,//,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox3 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox3 = false;
                }),
                child: InkWell(
                  onTap: () {
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox3 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 7,
                            left: 0,
                            right: 152, // Centrer horizontalement
                            child: SizedBox(
                              height: 35,
                              width: 55,
                              child: Image.asset("assets/icons/consolide_general.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 50,
                            right: 0,
                            child: Text(
                              'CONSOLIDE GENERAL',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2
            Positioned(
              top: 230,
              right: 546,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox11 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox11 = false;
                }),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      accueilPilotController.aAfficher.value=2;
                    });
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox11 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2, // Étendue de l'ombre
                            blurRadius: 5, // Flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 7, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 40,
                              width: 50,
                              child: Image.asset("assets/icons/usine1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              "Usine Yopougon 1",
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            //3
            Positioned(
              top: 230,
              right: 265,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox10 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox10 = false;
                }),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      accueilPilotController.aAfficher.value=2;
                    });
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox10 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2, // Étendue de l'ombre
                            blurRadius: 5, // Flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 3, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 42,
                              width: 52,
                              child: Image.asset("assets/icons/usine4.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 55,
                            right: 0,
                            child: Text(
                              'Usine Treichville',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),



            //4
            Positioned(
              top: 295,
              right: 827,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox5 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox5 = false;
                }),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      accueilPilotController.aAfficher.value=1;
                    });
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox5 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2, // Étendue de l'ombre
                            blurRadius: 5, // Flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 9, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 35,
                              width: 45,
                              child: Image.asset("assets/icons/siege1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 11, // Positionner le texte en bas avec un padding de 10
                            left: 52,
                            right: 0,
                            child: Text(
                              "SIEGE",
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            //5
            Positioned(
              top: 295,
              right: 546,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox2 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox2 = false;
                }),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      accueilPilotController.aAfficher.value=2;
                    });
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox2 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2, // Étendue de l'ombre
                            blurRadius: 5, // Flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 7, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 40,
                              width: 50,
                              child: Image.asset("assets/icons/usine3.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              "Usine Yopougon 2",
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),



            // 6
            Positioned(
              top: 295,
              right: 265,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox9 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox9 = false;
                }),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      accueilPilotController.aAfficher.value=2;
                    });
                    context.go("/pilotage");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox9 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(20), // Bordure circulaire
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 2, // Étendue de l'ombre
                            blurRadius: 5, // Flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 40,
                              width: 50,
                              child: Image.asset("assets/icons/usine5.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 55,
                            right: 0,
                            child: Text(
                              'Usine Bouaflé',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            // Gestion de l'entreprise Dropdown

            // Positioned(
            //   top: 30,
            //   right: 50,//480
            //   child: MouseRegion(
            //     onEnter: (_) {
            //       setState(() {
            //         isHoveredQSE = true;
            //       });
            //     },
            //     onExit: (_) {
            //       setState(() {
            //         isHoveredQSE = false;
            //       });
            //     },
            //     child: AnimatedContainer(
            //       duration: Duration(milliseconds: 300),
            //       height: isHoveredQSE ? 390 : 45,
            //       width: 275,
            //       decoration: BoxDecoration(
            //         color: Color(0xFF468FBC),//Color(0xFFB0C0CF),
            //         borderRadius: BorderRadius.circular(8),
            //         border: Border.all(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //       ),
            //       child: SingleChildScrollView(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(8),
            //                   topRight: Radius.circular(8),
            //                 ),
            //                 border: Border.all(
            //                   color: Colors.grey,
            //                   width: 1,
            //                 ),
            //               ),
            //               padding: EdgeInsets.symmetric(vertical: 8),
            //               child: Text(
            //                 "Gestion de l'entreprise",
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             if (isHoveredQSE)
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 10),
            //                 child: Column(
            //                   children: [
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("QSE");
            //                         },
            //                         child: Text("Fonctionnement de l'entreprise"),
            //                       ),
            //                     ),
            //                     SizedBox(height: 10),
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("QSE");
            //                         },
            //                         child: Text("Responsabilités et autorités"),
            //                       ),
            //                     ),
            //                     SizedBox(height: 10),
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("QSE");
            //                         },
            //                         child: Text("Gestion du personnel"),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Gestion SM-QSE Dropdown

            // Positioned(
            //   top: 30,
            //   left: 60,
            //   child: MouseRegion(
            //     onEnter: (_) {
            //       setState(() {
            //         isHoveredQ = true;
            //       });
            //     },
            //     onExit: (_) {
            //       setState(() {
            //         isHoveredQ = false;
            //       });
            //     },
            //     child: AnimatedContainer(
            //       duration: Duration(milliseconds: 300),
            //       height: isHoveredQ ? 390 : 45,
            //       width: 275,
            //       decoration: BoxDecoration(
            //         color: Color(0xFFD1DBE4),
            //         borderRadius: BorderRadius.circular(8),
            //         border: Border.all(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //       ),
            //       child: SingleChildScrollView(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(8),
            //                   topRight: Radius.circular(8),
            //                 ),
            //                 border: Border.all(
            //                   color: Colors.grey,
            //                   width: 1,
            //                 ),
            //               ),
            //               padding: EdgeInsets.symmetric(vertical: 8),
            //               child: Text(
            //                 "Gestion SM-QSE",
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             if (isHoveredQ)
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 10),
            //                 child: Column(
            //                   children: [
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("Q");
            //                         },
            //                         child: Text("Politique QSE"),
            //                       ),
            //                     ),
            //                     SizedBox(height: 10),
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("Q");
            //                         },
            //                         child: Text("Non conformités &\nactions correctives"),
            //                       ),
            //                     ),
            //                     SizedBox(height: 10),
            //                   ],
            //                 ),
            //               ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Systeme SM-QSE Dropdown

            // Positioned(
            //   top: 30,
            //   right: 480,//50
            //   child: MouseRegion(
            //     onEnter: (_) {
            //       setState(() {
            //         isHoveredS = true;
            //       });
            //     },
            //     onExit: (_) {
            //       setState(() {
            //         isHoveredS = false;
            //       });
            //     },
            //     child: AnimatedContainer(
            //       duration: Duration(milliseconds: 300),
            //       height: isHoveredS ? 390 : 45,
            //       width: 275,
            //       decoration: BoxDecoration(
            //         color: Color(0xFFB0C0CF),//Color(0xFF468FBC),
            //         borderRadius: BorderRadius.circular(8),
            //         border: Border.all(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //       ),
            //       child: SingleChildScrollView(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(8),
            //                   topRight: Radius.circular(8),
            //                 ),
            //                 border: Border.all(
            //                   color: Colors.grey,
            //                   width: 1,
            //                 ),
            //               ),
            //               padding: EdgeInsets.symmetric(vertical: 8),
            //               child: Text(
            //                 "Gestion SM-QSE",
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             if (isHoveredS)
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 10),
            //                 child: Column(
            //                   children: [
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("S");
            //                         },
            //                         child: Text("Parties intéressées"),
            //                       ),
            //                     ),
            //                     SizedBox(height: 10),
            //                     SizedBox(
            //                       width: 245, // Fixed width for buttons
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           getAccess("S");
            //                         },
            //                         child: Text("Gestion des processus"),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),


            // Information widget
            // if (_showInfo)
            //   Positioned(
            //     top: _infoPosition.dy,
            //     left: _infoPosition.dx,
            //     child: Material(
            //       color: Colors.transparent,
            //       child: Container(
            //         padding: EdgeInsets.all(8),
            //         decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.7),
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: Text(
            //           _infoText,
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

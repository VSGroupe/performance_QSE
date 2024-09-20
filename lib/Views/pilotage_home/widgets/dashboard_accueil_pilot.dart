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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:perfqse/Views/gestion/ae/controller/ae_controller.dart';

import '../../../utils/utils.dart';
import '../controller/accueil_pilot_controller.dart';

class DashboardAccueilPilot extends StatefulWidget {
  const DashboardAccueilPilot({super.key});

  @override
  State<DashboardAccueilPilot> createState() => _DashboardAccueilPilotState();
}

class _DashboardAccueilPilotState extends State<DashboardAccueilPilot> {

  final AccueilPilotController accueilPilotController = Get.put(AccueilPilotController());

  late String _userEmail = 'No email available';
  String _espaces_d_acces = "";

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
  }

  Future<void> _showNoAccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas accès à cet espace."),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _getAccessEspace(String espace) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      _userEmail = user.email ?? 'No email available';

      try {
        print('Début de la requête pour l\'utilisateur $_userEmail');
        final response = await Supabase.instance.client
            .from('Users')
            .select('a_acces_a')
            .eq('email', _userEmail)
            .single()
            .execute();

        print('Réponse obtenue: ${response.data}');
        final data = response.data;

        if (data == null) {
          print('Votre espace d\'accès n\'est pas spécifié dans la base de données');
          return false;
        }

        String espacesDacces = data['a_acces_a'] ?? '';

        setState(() {
          _espaces_d_acces = espacesDacces;
        });

        print('Espaces d\'accès: $_espaces_d_acces');

        if (_espaces_d_acces == espace) {
          print('Accès à l\'espace $espace autorisé.');
          return true;
        } else {
          print("Vous n'avez pas accès à: $espace");
          return false;
        }

      } catch (e) {
        print('Exception lors de la requête: $e');
        return false;
      }

    } else {
      print('Utilisateur non authentifié.');
      setState(() {
        _userEmail = 'No email available';
      });
      context.go("/");
      return false;
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
                  onTap: () async {
                    if (await _getAccessEspace("Consolide")) {
                      context.go("/pilotage");
                      setState(() {
                        accueilPilotController.aAfficher.value=0;
                      });
                    } else {
                      _showNoAccess();
                    }
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
              top: 295,
              right: 827,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox11 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox11 = false;
                }),
                child: InkWell(
                  onTap: () async {
                    if (await _getAccessEspace("Usine")){
                      setState(() {
                        accueilPilotController.aAfficher.value=2;
                      });
                      context.go("/pilotage");
                    } else{
                    _showNoAccess();
                    }
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
                            top: 2, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 43,
                              width: 53,
                              child: Image.asset("assets/icons/consolidation_inter.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              "Consolidé Processus",
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
                  onTap: () async {
                    if (await _getAccessEspace("Usine")){
                      setState(() {
                      accueilPilotController.aAfficher.value=2;
                      });
                      context.go("/pilotage");
                    } else{
                      _showNoAccess();
                    }
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
                            top: 11, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/site1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 55,
                            right: 0,
                            child: Text(
                              'Site 1',
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
              top: 230,
              right: 546,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox5 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox5 = false;
                }),
                child: InkWell(
                  onTap: () async {
                    if (await _getAccessEspace("Siege")){
                    setState(() {
                      accueilPilotController.aAfficher.value=1;
                      });
                      context.go("/pilotage");
                    } else{
                      _showNoAccess();
                    }
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
                  onTap: () async {
                    if (await _getAccessEspace("Usine")){
                      setState(() {
                        accueilPilotController.aAfficher.value=2;
                      });
                      context.go("/pilotage");
                    } else{
                      _showNoAccess();
                    }
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
                              child: Image.asset("assets/icons/usine1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              "Site 2",
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
                  onTap: () async {
                    if (await _getAccessEspace("Usine")){
                      setState(() {
                        accueilPilotController.aAfficher.value=2;
                      });
                      context.go("/pilotage");
                    } else{
                      _showNoAccess();
                    }
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
                            top: 11,
                            left: 0,
                            right: 150,
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/site2.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 55,
                            right: 0,
                            child: Text(
                              'Site 3',
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
          ],
        ),
      ),
    );
  }
}

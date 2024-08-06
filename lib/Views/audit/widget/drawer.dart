import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';

import '../../../utils/utils.dart';

class DrawerEvaluation extends StatefulWidget {
  const DrawerEvaluation({Key? key}) : super(key: key);

  @override
  State<DrawerEvaluation> createState() => _DrawerEvaluationState();
}

class _DrawerEvaluationState extends State<DrawerEvaluation> {
  final ControllerAudit controllerAudit =Get.put(ControllerAudit());
  final storage = FlutterSecureStorage();
  final Location="/audit/accueil";
  late String chemin = "";
  late String pagecourante = "";

  @override
  void initState() {
    controllerAudit.reference.value="";
    pagecourante = controllerAudit.currentPage.value;
    super.initState();
  }

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            "Aucune performance\nsélectionnée",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Veuillez sélectionner la performance à auditer\ndans l'espace à droite."),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas la référence d'accès à cet espace."),
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


  void getAccess(String centerTitle)async{
    String? reference = await storage.read(key:"ref");
    List<String> ref= ["Q", "S", "E", "QS", "QE", "SE", "QSE"];//["Q", "S", "QS", "E"];
    if (reference!=null){
      ref =reference.split("\n");
    }
    if(ref.contains(centerTitle)) {
      controllerAudit.reference.value=centerTitle;
      context.go(chemin);
    }else{
      showDialogNoAcces();
    }
  }


  // Menu de sélection des types d'audits

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Supprime l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Ferme le dialogue lorsqu'on clique en dehors
                },
                child: Container(
                  color: Colors.transparent, // Transparence pour capturer les clics
                  child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                ),
              ),
              Positioned(
                left: 0.0,
                top: 100.0,
                right: 1180.0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD1DBE4), // Couleur de fond bleue
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey, width: 2.0), // Bordure blanche
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sélectionnez le type d'audit",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Couleur du texte blanche
                            ),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey),
                        ListBody(
                          children: <Widget>[
                            ListTile(
                              title: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsQ";
                                });
                                getAccess("Q");
                              },
                            ),
                            ListTile(
                              title: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsS";
                                });
                                getAccess("S");
                              },
                            ),
                            ListTile(
                              title: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsE";
                                });
                                getAccess("E");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QSE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-audits";
                                });
                                getAccess("QSE");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QS', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsQS";
                                });
                                getAccess("QS");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsQE";
                                });
                                getAccess("QE");
                              },
                            ),
                            ListTile(
                              title: Text('Audit SE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/gestion-auditsSE";
                                });
                                getAccess("SE");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // Menu de sélection des aperçus par types d'audits.

  void _showCustomDialogApercu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Supprime l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Ferme le dialogue lorsqu'on clique en dehors
                },
                child: Container(
                  color: Colors.transparent, // Transparence pour capturer les clics
                  child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                ),
              ),
              Positioned(
                left: 0.0,
                top: 100.0,
                right: 1180.0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD1DBE4), // Couleur de fond bleue
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey, width: 2.0), // Bordure blanche
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sélectionnez le type d'audit",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Couleur du texte blanche
                            ),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey),
                        ListBody(
                          children: <Widget>[
                            ListTile(
                              title: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsQ";
                                });
                                getAccess("Q");
                              },
                            ),
                            ListTile(
                              title: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsS";
                                });
                                getAccess("S");
                              },
                            ),
                            ListTile(
                              title: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsE";
                                });
                                getAccess("E");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QSE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/audit/accueil";
                                });
                                getAccess("QSE");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QS', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsQS";
                                });
                                getAccess("QS");
                              },
                            ),
                            ListTile(
                              title: Text('Audit QE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsQE";
                                });
                                getAccess("QE");
                              },
                            ),
                            ListTile(
                              title: Text('Audit SE', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  chemin = "/apercu/auditsSE";
                                });
                                getAccess("SE");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 0, bottom: 20),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
                border: Border.fromBorderSide(
                  BorderSide(width: 2, color: Colors.grey),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      const Text(
                        "Menu Principal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                Obx(() => CustomMenuButton(
                  pathMenu: controllerAudit.reference.value == "" ? "" : "/audit/transite",
                  image: "assets/images/home1.png",
                  isFullPath: false,
                  label: "Accueil",
                  onTap: () {
                    // Set the reference value to an empty string
                    setState(() {
                      controllerAudit.reference.value = "";
                      controllerAudit.currentPage.value="/audit/transite";
                    });
                  },
                )),
                const SizedBox(height: 3),
                Obx(()
                =>  CustomMenuButton(
                  pathMenu: controllerAudit.reference.value==""? "":pagecourante,
                  image: "assets/images/audit.jpg",
                  isFullPath: false,
                  // icon: Icons.home,
                  label: "Aperçu des audits",
                  onTap: () {
                    _showCustomDialogApercu(context);
                  },
                ),
                ),
                const SizedBox(height: 3),
                Obx(() => CustomMenuButton(
                  pathMenu: controllerAudit.reference.value == "" ? "" : pagecourante,
                  image: "assets/images/audit.png",
                  isFullPath: false,
                  label: "Démarrer un audit",
                  onTap: () {
                    _showCustomDialog(context);
                  },
                )),
                const SizedBox(height: 3),
                Obx(()
                => CustomMenuButton(
                  pathMenu: controllerAudit.reference.value==""?"":'/audit/admin',
                  image: "assets/images/homme-daffaire.png",
                  // icon: Icons.table_chart_rounded,
                  isFullPath: false,
                  label: "Admin audits",
                  onTap: () {
                    setState(() {
                      controllerAudit.currentPage.value="/audit/admin";
                    });
                    // Action to execute
                    if(controllerAudit.reference.value == ""){
                      _showDialogNoAcces();
                    }
                  },
                ),
                ),

                const SizedBox(height: 3),
                Obx(() => CustomMenuButton(
                  pathMenu: controllerAudit.reference.value == "" ? "" : "",
                  image: "assets/images/res.png",
                  isFullPath: false,
                  label: "Programme des\naudits internes",
                  onTap: () {
                    _showDialogNoAcces();
                  },
                )),

                // const SizedBox(height: 3),
                // const CustomMenuButton(
                //   pathMenu: '',
                //   image: "assets/images/res.png",
                //   // icon: Icons.admin_panel_settings_outlined,
                //   isFullPath: false,
                //   label: "Programme des\naudits internes",
                // ),
                const SizedBox(height: 3),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                const CustomMenuButton(
                  pathMenu: '/pilotage',
                  image: "assets/images/retour_pilotage.jpg",
                  isFullPath: true,
                  // icon: Icons.arrow_circle_left_sharp,
                  label: "Pilotage",
                ),
                const SizedBox(height: 3),
                const CustomMenuButton(
                  pathMenu: '/gestion/accueil',
                  image: "assets/images/retour.jpg",
                  isFullPath: true,
                  // icon: Icons.arrow_circle_left_sharp,
                  label: "Gestion",
                ),
                const SizedBox(height: 3),
                const CustomMenuButton(
                  pathMenu: '',
                  image: "assets/images/retour_rapport.jpg",
                  isFullPath: true,
                  // icon: Icons.arrow_circle_left_sharp,
                  label: "Rapport",
                ),
                const SizedBox(height: 3),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                const CustomMenuButton(
                  pathMenu: '/',
                  image: "assets/images/return.png",
                  isFullPath: true,
                  // icon: Icons.arrow_circle_left_sharp,
                  label: "Accueil Général",
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  final String image;
  final bool isFullPath;
  final String label;
  final VoidCallback? onTap; // Pour pouvoir effectuer une action lorqu'on clique sur le bouton

  const CustomMenuButton({
    Key? key,
    required this.label,
    required this.pathMenu,
    required this.isFullPath,
    required this.image,
    this.onTap, // On pourra ainsi définir une action à exécuter lorsqu'on clique sur le bouton
  }) : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}


class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(); // Call the onTap callback
        }
        context.go(widget.pathMenu);
      },
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      child: Container(
        width: 248,
        height: 45,
        decoration: BoxDecoration(
            color: isSelected
                ? _isHovering
                ? const Color(0xFFEEEEEE)
                : const Color(0xFFE8F0FE)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: OutlinedButton(
          onPressed: () {
            if (widget.onTap != null) {
              widget.onTap!(); // Call the onTap callback
            }
            context.go(widget.pathMenu);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            side: const BorderSide(
              color: Colors.transparent,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          child: Row(
            children: [
              Image.asset(
                widget.image,
                width: 30,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    color: isSelected ? const Color(0xFF114693) : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}


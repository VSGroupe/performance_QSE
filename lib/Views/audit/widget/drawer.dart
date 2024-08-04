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
    List<String> ref= ["Q", "S", "QS"];//["Q", "S", "E", "QS", "QE", "SE", "QSE"];
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


  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                top: 100.0,
                right: 50.0,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Sélectionnez un élément',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(height: 1),
                      ListBody(
                        children: <Widget>[
                          ListTile(
                            title: Text('Item 1'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("QSE");
                            },
                          ),
                          ListTile(
                            title: Text('Item 2'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("QS");
                            },
                          ),
                          ListTile(
                            title: Text('Item 3'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("SE");
                            },
                          ),
                          ListTile(
                            title: Text('Item 4'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("Q");
                            },
                          ),
                          ListTile(
                            title: Text('Item 5'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("QE");
                            },
                          ),
                          ListTile(
                            title: Text('Item 6'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("S");
                            },
                          ),
                          ListTile(
                            title: Text('Item 7'),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                chemin = "/audit/accueil";
                              });
                              getAccess("E");
                            },
                          ),
                        ],
                      ),
                    ],
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
                      Padding(
                        padding: const EdgeInsets.only(left: 11.3),
                        child: Container(
                          width: 200,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if (controllerAudit.reference.value == "") {
                                    _showDialogNoAcces();
                                  } else {
                                    context.go("/audit/gestion-audits");
                                  }
                                });
                              },
                              child: const Text(
                                "Démarer un audit",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                  pathMenu: controllerAudit.reference.value==""? "":"/audit/accueil",
                  image: "assets/images/audit.jpg",
                  isFullPath: false,
                  // icon: Icons.home,
                  label: "Aperçu des audits",
                  onTap: () {
                    setState(() {
                      controllerAudit.currentPage.value="/audit/accueil";
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


// // Action to execute
// final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
// final RenderBox box = context.findRenderObject() as RenderBox;
// final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);
//
// showGeneralDialog(
// context: context,
// barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
// barrierColor: Colors.transparent, // Pas d'effet sombre
// pageBuilder: (context, _, __) {
// return Stack(
// children: [
// GestureDetector(
// onTap: () {
// Navigator.of(context).pop(); // Ferme le dialogue lorsqu'on clique en dehors
// },
// child: Container(
// color: Colors.transparent, // Transparence pour capturer les clics
// child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
// ),
// ),
// Positioned(
// left: 80,
// top: 244,
// child: Material(
// color: Colors.transparent, // Rendre le fond transparent
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white, // Couleur de fond personnalisée
// borderRadius: BorderRadius.circular(10),
// border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
// ),
// padding: EdgeInsets.all(6),
// constraints: BoxConstraints(
// maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
// ),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Text(
// "Sélectionner le type\nd'audit",
// style: TextStyle(
// fontSize: 14,
// color: Colors.black,
// fontWeight: FontWeight.bold,
// ),
// ),
// SizedBox(height: 20),
// ElevatedButton(
// onPressed: () {
// Navigator.pop(context);
// getAccess("QSE");
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.blue, // Couleur de fond du bouton
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
// side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
// ),
// padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
// ),
// child: Text("Button"),
// ),
// ],
// ),
// ),
// ),
// ),
// ],
// );
// },
// );



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


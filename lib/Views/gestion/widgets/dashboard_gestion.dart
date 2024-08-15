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

import '../gestion_des_processus/controller/gestion_processus_controller.dart';

class DashboardGestion extends StatefulWidget {
  const DashboardGestion({super.key});

  @override
  State<DashboardGestion> createState() => _DashboardGestionState();
}

class _DashboardGestionState extends State<DashboardGestion> {

  final GestionProcessusController gestionProcessusController = Get.put(GestionProcessusController());
  final ControllerAudit controllerAudit = Get.put(ControllerAudit());
  final AeController aeController = Get.put(AeController());

  final storage = FlutterSecureStorage();

  final String location = "/gestion/accueil";

  double scaleValue = 1.0; // Valeur initiale d'échelle pour l'agrandissement

  bool _isHoveringBox1 = false;
  bool _isHoveringBox2 = false;
  bool _isHoveringBox3 = false;
  bool _isHoveringBox4 = false;
  bool _isHoveringBox5 = false;
  bool _isHoveringBox6 = false;
  bool _isHoveringBox7 = false;
  bool _isHoveringBox8 = false;
  bool _isHoveringBox9 = false;
  bool _isHoveringBox10 = false;
  bool _isHoveringBox11 = false;
  bool _isHoveringBox12 = false;

  @override
  void initState() {
    super.initState();
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

  // Affichage de la politique QSE au format PDF


  void _openPDFInBrowser(BuildContext context) async {
    try {
      // Charger le PDF depuis les assets
      final pdfData = await rootBundle.load('assets/pdf_Politique_QSE/planning_de_travail.pdf');

      if (kIsWeb) {
        // Pour le Web : ouvrir le PDF en utilisant un Blob
        _openPDFInWeb(pdfData);
      } else {
        // Pour Windows : enregistrer le PDF temporairement et l'ouvrir
        final pdfPath = await _storePdfTemporarily(pdfData);
        await _openPDF(pdfPath);
      }
    } catch (e) {
      // Afficher le message d'erreur dans la console
      print('Erreur: $e');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Impossible d\'ouvrir le PDF.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  //Ouvrir le fichier pdf pour le modifier directement via un outil en ligne

  void _openPDFforModification(BuildContext context) {
    final pdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'; // URL publique du fichier PDF
    final acrobatUrl = 'https://acrobat.adobe.com/link/acrobat/pdf-viewer?url=$pdfUrl';

    launch(acrobatUrl);
  }



  Future<String> _storePdfTemporarily(ByteData pdfData) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/planning_de_travail.pdf');
    await file.writeAsBytes(pdfData.buffer.asUint8List());
    return file.path;
  }

  Future<void> _openPDF(String path) async {
    final Uri uri = Uri.file(path);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not open $path';
    }
  }

  void _openPDFInWeb(ByteData pdfData) {
    // Convertir le ByteData en Uint8List
    final pdfBytes = pdfData.buffer.asUint8List();

    // Créer un blob à partir des données PDF
    final blob = html.Blob([pdfBytes], 'application/pdf');

    // Créer une URL à partir du blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Ouvrir l'URL dans un nouvel onglet ou une nouvelle fenêtre
    html.window.open(url, '_blank');

    // Libérer l'URL après usage
    html.Url.revokeObjectUrl(url);
  }

  //box 1

  void _showCustomDialog1(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 490.0,
                    top: 280.0,
                    right: 750.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,//Color(0xFFD1DBE4), // Couleur de fond
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/analyse-exploratoire.png', // Remplacez par le chemin de votre image
                                      width: 30.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 40.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Contexte",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      context.go("");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Analyse du contexte',
                                        style: TextStyle(color: Colors.black, fontSize: 16.0,),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // _openPDFforModifiation(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Poids des risques\net opportunités',
                                        style: TextStyle(color: Colors.black, fontSize: 16.0,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }


  // box 2
  void _showCustomDialog2(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Supprime l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 720.0,
                    top: 280.0,
                    right: 520.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                                spreadRadius: 4, // Étendue de l'ombre
                                blurRadius: 5, // Flou de l'ombre
                                offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Box 3
  void _showCustomDialog3(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 960.0,
                    top: 280.0,
                    right: 280.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,//Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.white, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Box 4
  void _showCustomDialog4(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 1180.0,
                    top: 280.0,
                    right: 30.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/gestion_QSE.png', // Remplacez par le chemin de votre image
                                      width: 50.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 30.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Politique QSE",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.go("/gestion/politiqueQSE");
                                      // setState(() {
                                      //   //chemin = "/audit/gestion-auditsS";
                                      // });
                                      // getAccess("S");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Consulter',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _openPDFInBrowser(context);
                                      // setState(() {
                                      //   //chemin = "/audit/gestion-auditsQ";
                                      // });
                                      // getAccess("Q");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Format PDF',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _openPDFforModification(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Modifier la politique',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  //box 5

  void _showCustomDialog5(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 490.0,
                    top: 347.0,
                    right: 750.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // box 6
  void _showCustomDialog6(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 720.0,
                    top: 347.0,
                    right: 460.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 300,
                          height: 230,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 30.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 40.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Gestion des processus",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        gestionProcessusController.aAfficher.value = 1;
                                      });
                                      context.go("/gestion/processus");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Cartographie Générale des processus',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        gestionProcessusController.aAfficher.value = 2;
                                      });
                                      context.go("/gestion/processus");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Liste des processus et\nleurs responsabilités',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        gestionProcessusController.aAfficher.value = 3;
                                      });
                                      context.go("/gestion/processus");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Fiche d\'identité des processus',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }



  // Box 7
  void _showCustomDialog7(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 960.0,
                    top: 347.0,
                    right: 200.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/environnement.png', // Remplacez par le chemin de votre image
                                      width: 30.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 40.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Aspects environnementaux",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        aeController.aAfficher.value=1;
                                      });
                                      context.go("/gestion/aspects/environnementaux");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Consulter',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        aeController.aAfficher.value=2;
                                      });
                                      context.go("/gestion/aspects/environnementaux");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Modifier un aspect environnemental',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        aeController.aAfficher.value=3;
                                      });
                                      context.go("/gestion/aspects/environnementaux");
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Ajouter un aspect environnemental',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }


  // Box 8
  void _showCustomDialog8(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 1180.0,
                    top: 347.0,
                    right: 60.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  //box 9

  void _showCustomDialog9(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 490.0,
                    top: 410.0,
                    right: 750.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // box 10
  void _showCustomDialog10(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 720.0,
                    top: 410.0,
                    right: 520.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Box 11
  void _showCustomDialog11(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 960.0,
                    top: 410.0,
                    right: 280.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Box 12
  void _showCustomDialog12(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Rétablit l'effet sombre
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Inverse l'animation avant de fermer
                        scaleValue = 0.0;
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                        scaleValue = 1.0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // Transparence pour capturer les clics
                      child: SizedBox.expand(), // Remplit l'écran pour capturer tous les clics
                    ),
                  ),
                  Positioned(
                    left: 1180.0,
                    top: 410.0,
                    right: 60.0,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: scaleValue),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, double scale, child) {
                        return Align(
                          alignment: Alignment.topLeft, // Définir le point d'origine
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topLeft, // Définir le point d'origine pour l'agrandissement
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xFFD1DBE4), // Couleur de fond bleue
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(color: Colors.grey, width: 1.0), // Bordure blanche
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
                            //     spreadRadius: 4, // Étendue de l'ombre
                            //     blurRadius: 5, // Flou de l'ombre
                            //     offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
                            //   ),
                            // ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gestion_processus1.png', // Remplacez par le chemin de votre image
                                      width: 24.0, // Ajustez la taille de l'image selon vos besoins
                                      height: 24.0,
                                    ),
                                    SizedBox(width: 8.0), // Espace entre l'image et le texte
                                    Text(
                                      "Sélection 6",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              ListBody(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsQ";
                                      });
                                      getAccess("Q");
                                    },
                                    child: Text('Audit Qualité [ Q ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsS";
                                      });
                                      getAccess("S");
                                    },
                                    child: Text('Audit Sécurité [ S ]', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //chemin = "/audit/gestion-auditsE";
                                      });
                                      getAccess("E");
                                    },
                                    child: Text('Audit Environnement [ E ]', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
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
              right: 200,
              child: InkWell(
                child: SizedBox(
                  height: 50,
                  width: 900,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   // image: DecorationImage(
                    //   //   image: AssetImage("assets/images/barre_qse.jpg"),
                    //   //   fit: BoxFit.fitWidth,
                    //   // ),
                    //   color: Colors.grey, // Changez la couleur de fond selon vos besoins
                    //   border: Border.all(color: Colors.white, width: 2), // Bordure grise
                    //   borderRadius: BorderRadius.circular(20), // Bordure circulaire
                    // ),
                    child: Center(
                      child: Text(
                        'SYSTEME DE MANAGEMENT INTEGRE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF468FBC),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // La barre d'image

            Positioned(
              top: 80,
              right: 201,
              child: InkWell(
                child: SizedBox(
                  height: 130,
                  width: 900,
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
              right: 898,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox7 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox7 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog1(context);
                    context.go("/gestion/contexte");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox7 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/images/analyse-exploratoire.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 52,
                            right: 0,
                            child: Text(
                              'Contexte',
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
              right: 667,//50,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox3 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox3 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog2(context);
                    context.go("/gestion/partiesInteressees");
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
                            right: 152, // Centrer horizontalement
                            child: SizedBox(
                              height: 35,
                              width: 55,
                              child: Image.asset("assets/icons/parties_prenantes1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 11, // Positionner le texte en bas avec un padding de 10
                            left: 45,
                            right: 0,
                            child: Text(
                              'Parties intéressées',
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

            // 3
            Positioned(
              top: 230,
              right: 436,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox5 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox5 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog3(context);
                    context.go("/gestion/perimetresEt/domaines/Dapplication");
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
                              child: Image.asset("assets/icons/perimetres_d_d_app.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 5, // Positionner le texte en bas avec un padding de 10
                            left: 48,
                            right: 0,
                            child: Text(
                              "Périmètres et domaines d'application",
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
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


            // 4

            Positioned(
              top: 230,
              right: 205,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox1 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox1 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    _showCustomDialog4(context);
                    //context.go("/gestion/profil");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox1 ? Colors.white38 : Colors.white, // Couleur de fond
                        border: Border.all(color: Colors.grey, width: 0), // Bordure grise
                        borderRadius: BorderRadius.circular(18), // Bordure circulaire
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
                            right: 140, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 50,
                              child: Image.asset("assets/images/gestion_QSE.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 10, // Positionner le texte en bas avec un padding de 10
                            left: 60,
                            right: 0,
                            child: Text(
                              'Politique QSE',
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
              right: 898,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox2 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox2 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog5(context);
                    context.go("/gestion/ressources/et/responsabiltes");
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
                            top: 9, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 35,
                              width: 45,
                              child: Image.asset("assets/icons/responsabilites_et_ressources.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 2, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              "Ressources et responsabilités",
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

            // 6

            Positioned(
              top: 295,
              right: 667,//50,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox6 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox6 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    _showCustomDialog6(context);
                    //context.go("/gestion/profil");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox6 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/gestion_processus1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              'Gestion des processus',
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

            // 7
            Positioned(
              top: 295,
              right: 436,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox8 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox8 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    _showCustomDialog7(context);
                    //context.go("/gestion/profil");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox8 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/environnement.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 3, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              'Aspets environnementaux',
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



            // 8
            Positioned(
              top: 295,
              right: 205,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox9 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox9 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog8(context);
                    context.go("/gestion/ies");
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
                            top: 08, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/impact-environnemental.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 3, // Positionner le texte en bas avec un padding de 10
                            left: 45,
                            right: 0,
                            child: Text(
                              'Impact environnemental et social',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
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


            // 9
            Positioned(
              top: 360,
              right: 898,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox10 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox10 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog9(context);
                    context.go("/gestion/dangers/et/incidents");
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/danger_et_incident.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Positionner le texte en bas avec un padding de 10
                            left: 50,
                            right: 0,
                            child: Text(
                              'Dangers et incidents',
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


            // 10
            Positioned(
              top: 360,
              right: 667,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox11 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox11 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog10(context);
                    context.go("/gestion/situations/d/urgence");
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/icons/urgences1.png", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Positionner le texte en bas avec un padding de 10
                            left: 52,
                            right: 0,
                            child: Text(
                              "Situations d'urgence",
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


            // 11
            Positioned(
              top: 360,
              right: 436,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox12 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox12 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog11(context);
                    context.go("/gestion/moyens/de/maitrise");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox12 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
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
                            top: 10, // Positionner l'image en haut
                            left: 0,
                            right: 145, // Centrer horizontalement
                            child: SizedBox(
                              height: 30,
                              width: 40,
                              child: Image.asset("assets/images/images.jpg", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 13, // Positionner le texte en bas avec un padding de 10
                            left: 48,
                            right: 0,
                            child: Text(
                              'Moyens de maîtrise',
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


            // 12
            Positioned(
              top: 360,
              right: 205,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHoveringBox4 = true;
                }),
                onExit: (_) => setState(() {
                  _isHoveringBox4 = false;
                }),
                child: InkWell(
                  onTap: () {
                    // action à effectuer
                    //_showCustomDialog12(context);
                    context.go("/gestion/ameliorations");
                  },
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHoveringBox4 ? Colors.white38 : Colors.white, // Change la couleur de fond lorsqu'on survole
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
                            top: 08, // Positionner l'image en haut
                            left: 0,
                            right: 150, // Centrer horizontalement
                            child: SizedBox(
                              height: 35,
                              width: 45,
                              child: Image.asset("assets/icons/gif_amelioratioins.gif", fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 11, // Positionner le texte en bas avec un padding de 10
                            left: 0,
                            right: 0,
                            child: Text(
                              'Améliorations',
                              textAlign: TextAlign.center,
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

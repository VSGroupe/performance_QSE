import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class TransiteAudit extends StatefulWidget {
  const TransiteAudit({super.key});

  @override
  State<TransiteAudit> createState() => _TransiteAuditState();
}

class _TransiteAuditState extends State<TransiteAudit> {
  final ControllerAudit controllerAudit =Get.put(ControllerAudit());
  final storage =FlutterSecureStorage();
  String Location="";

  Future<void> _showDialogNoAcces() async {
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
    List<String> ref= ["Q", "S", "E", "QS", "QE", "SE", "QSE"]; //["Q", "S", "QS"];//
    if (reference!=null){
      ref =reference.split("\n");
    }
    if(ref.contains(centerTitle)) {
      controllerAudit.reference.value=centerTitle;
      context.go(Location);
    }else{
      _showDialogNoAcces();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 630,
        width: 1000,
        child: Center(
          child: Stack(children: [

            // QSE

            Positioned(
              top: 160,
              right: 385,
              child: SizedBox(
                height: 250,
                width: 250,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              left: 675,
                              top: 262,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit QSE",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(fontSize: 14,
                                            color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-audits";
                                          });
                                          getAccess("QSE");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/qse.png", fit: BoxFit.contain),
                ),
              ),
            ),

            // QS

            Positioned(
              top: 0,
              right: 350,
              child: SizedBox(
                height: 160,
                width: 300,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              left: 665,
                              top: 70,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit QS",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsQS";
                                          });
                                          getAccess("QS");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/qs.png", fit: BoxFit.contain),
                ),
              ),
            ),


            // E


            Positioned(
              bottom: 0,
              right: 350,
              child: SizedBox(
                height: 200,
                width: 300,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              left: 665,
                              top: 500,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit\nEnvironnement [ E ]",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsE";
                                          });
                                          getAccess("E");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/e.png", fit: BoxFit.contain),
                ),
              ),
            ),


            // Q


            Positioned(
              top: 140,
              left: 50,
              child: SizedBox(
                height: 160,
                width: 300,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              left: 333,
                              top: 188,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit\nQualité [ Q ]",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsQ";
                                          });
                                          getAccess("Q");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/q.png", fit: BoxFit.contain),
                ),
              ),
            ),

            // Positioned(
            //     top: 140,
            //     left: 60,
            //     child: SizedBox(
            //       height: 160,
            //       width: 300,
            //       child: InkWell(
            //           onTap: (){
            //             setState(() {
            //               getAccess("Q");
            //             });
            //           },
            //           mouseCursor: SystemMouseCursors.click,
            //           child: Image.asset("assets/images/q.png", fit: BoxFit.contain)
            //       ),
            //     )
            // ),

            // S

            Positioned(
              top: 140,
              right: 60,
              child: SizedBox(
                height: 160,
                width: 300,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              right: 333,
                              top: 188,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit\nSécurité [ S ]",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsS";
                                          });
                                          getAccess("S");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/s.png", fit: BoxFit.contain),
                ),
              ),
            ),


            // Positioned(
            //     top: 140,
            //     right: 60,
            //     child: SizedBox(
            //       height: 160,
            //       width: 300,
            //       child: InkWell(
            //           onTap: (){
            //             setState(() {
            //               getAccess("S");
            //             });
            //           },
            //           mouseCursor: SystemMouseCursors.click,
            //           child: Image.asset("assets/images/s.png", fit: BoxFit.contain)
            //       ),
            //     )
            // ),


            // SE


            Positioned(
              top: 340,
              right: 100,
              child: SizedBox(
                height: 200,
                width: 250,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              right: 338,
                              top: 450,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit SE",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsSE";
                                          });
                                          getAccess("SE");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/se.png", fit: BoxFit.contain),
                ),
              ),
            ),


            // Positioned(
            //     top: 340,
            //     right: 100,
            //     child: SizedBox(
            //       height: 200,
            //       width: 250,
            //       child: InkWell(
            //           onTap: (){
            //             setState(() {
            //               getAccess("SE");
            //             });
            //           },
            //           mouseCursor: SystemMouseCursors.click,
            //           child: Image.asset("assets/images/se.png", fit: BoxFit.contain)
            //       ),
            //     )
            // ),

            // QE


            Positioned(
              top: 340,
              left: 100,
              child: SizedBox(
                height: 200,
                width: 250,
                child: InkWell(
                  onTap: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false, // Ne ferme pas la boîte de dialogue en cliquant en dehors
                      barrierColor: Colors.transparent, // Pas d'effet sombre
                      pageBuilder: (context, _, __) {
                        return Stack(
                          children: [
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
                              left: 350,
                              top: 450,
                              child: Material(
                                color: Colors.transparent, // Rendre le fond transparent
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Couleur de fond personnalisée
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 2), // Bordure personnalisée
                                  ),
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Limiter la hauteur à 50% de la hauteur de l'écran
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Démarrer un audit QE",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cliquez sur le bouton pour\ncontinuer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            Location="/audit/gestion-auditsQE";
                                          });
                                          getAccess("QE");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Couleur de fond du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rayon des coins du bouton
                                            side: BorderSide(color: Colors.blue, width: 2), // Couleur et largeur de la bordure du bouton
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding du bouton
                                        ),
                                        child: Text(
                                          "Continuer",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/qe.png", fit: BoxFit.contain),
                ),
              ),
            ),


            // Positioned(
            //     top: 340,
            //     left: 100,
            //     child: SizedBox(
            //       height: 200,
            //       width: 250,
            //       child: InkWell(
            //           onTap: (){
            //             setState(() {
            //               getAccess("QE");
            //             });
            //           },
            //           mouseCursor: SystemMouseCursors.click,
            //           child: Image.asset("assets/images/qe.png", fit: BoxFit.contain)),
            //     )
            // ),

          ]),
        ),
      ),
    );
  }
}

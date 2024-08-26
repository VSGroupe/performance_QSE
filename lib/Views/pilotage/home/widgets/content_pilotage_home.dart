import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../widgets/customtext.dart';
import '../../entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'contentbox.dart';
import 'listeProcessus.dart';

class ContentPilotageHome extends StatefulWidget {
  const ContentPilotageHome({Key? key}) : super(key: key);

  @override
  State<ContentPilotageHome> createState() => _ContentPilotageHomeState();
}

class _ContentPilotageHomeState extends State<ContentPilotageHome> {
  ScrollController scrollController = ScrollController();
  List<Map<String, dynamic>> _filliale = [];
  List<Map<String, dynamic>> _management = [];
  List<Map<String, dynamic>> _operationnels = [];

  @override
  void initState() {
    super.initState();
    _loadSupportProcessus();
    _loadManagementProcessus();
    _loadOperationnelsProcessus();
  }

  // Récupération des processus Support
  Future<void> _loadSupportProcessus() async {
    try {
      final fillialeData = await getSupportProcessus();
      setState(() {
        _filliale = fillialeData;
      });
    } catch (e) {
      print('Erreur lors du chargement des processus: $e');
    }
  }

  // Récupération des processus Management
  Future<void> _loadManagementProcessus() async {
    try {
      final managementProcess = await getManagementProcessus();
      setState(() {
        _management = managementProcess;
      });
    } catch (e) {
      print('Erreur lors du chargement des processus: $e');
    }
  }


  // Récupération des processus Operationnels
  Future<void> _loadOperationnelsProcessus() async {
    try {
      final operationnelsProcess = await getOperationnelsProcessus();
      setState(() {
        _operationnels = operationnelsProcess;
      });
    } catch (e) {
      print('Erreur lors du chargement des processus: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 370, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 775,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: const Border.fromBorderSide(
                    BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                    child: Text(
                      "Processus et Indicateurs",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 3),
                  ContentBox(
                    title: Text(
                      "PROCESSUS MANAGEMENT",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    width: 250,
                    height: 211,
                    children: _management.map((item) {
                      return TextButton(
                        onPressed: () {},
                        child: Align(
                          alignment: Alignment.centerLeft, // Alignement du texte à gauche
                          child: Text(
                            item['management']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10),
                  ContentBox(
                    title: Text(
                      "PROCESSUS OPÉRATIONNELS",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    width: 280,
                    height: 210,
                    children: _operationnels.map((item) {
                      return TextButton(
                        onPressed: () {},
                        child: Align(
                          alignment: Alignment.centerLeft, // Alignement du texte à gauche
                          child: Text(
                            item['operationnels']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10),
                  ContentBox(
                    width: 220,
                    height: 211,
                    title: Text(
                      "PROCESSUS SUPPORT",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    children: _filliale.map((item) {
                      return EspaceTextButton(
                        title: item["support"]!,
                        espaceID: item["support"]!,
                        color: Colors.black,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class EspaceTextButton extends StatefulWidget {
  final String title;
  final String espaceID;
  final Color color;
  final Function()? onTap;

  const EspaceTextButton({
    super.key,
    required this.title,
    required this.espaceID,
    this.onTap,
    required this.color,
  });

  @override
  State<EspaceTextButton> createState() => _EspaceTextButtonState();
}

class _EspaceTextButtonState extends State<EspaceTextButton> {
  final ControllerTableauBord controllerTableauBord = Get.find();
  final supabase = Supabase.instance.client;
  final storage = FlutterSecureStorage();
  final int annee = DateTime.now().year;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas accès à cet espace."),
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

  Future<bool> goToEspaceEntitePilotage(String idEntite) async {
    EasyLoading.show(status: 'Chargement...');
    await Future.delayed(Duration(seconds: 2));
    String? email = await storage.read(key: 'email');
    if (email == null) {
      EasyLoading.dismiss();
      await Future.delayed(Duration(milliseconds: 30));
      _showMyDialog();
      return false;
    }
    final result = await supabase
        .from("AccesPilotage")
        .select()
        .eq("email", email);
    final acces = result[0];
    if (acces["est_bloque"]) {
      EasyLoading.dismiss();
      await Future.delayed(Duration(milliseconds: 30));
      _showMyDialog();
      return false;
    }
    final bool verfication = (acces["est_spectateur"] ||
        acces["est_collecteur"] ||
        acces["est_validateur"] ||
        acces["est_admin"]);
    final bool checkEspace = (acces["espace"].contains(widget.espaceID));
    if (verfication && checkEspace) {
      EasyLoading.dismiss();
      await storage.write(key: 'espace', value: widget.espaceID);

      controllerTableauBord.getAllViewTableauBord(
        annee: annee,
        espace: widget.espaceID,
      );

      String espaceWithoutSpecialCaratere = widget.espaceID
          .replaceAll("é", "e")
          .replaceAll("è", "e");
      final path = "/pilotage/espace/${espaceWithoutSpecialCaratere}/accueil";
      await Future.delayed(Duration(milliseconds: 100));
      context.go(path);
      return true;
    }
    EasyLoading.dismiss();
    await Future.delayed(Duration(milliseconds: 30));
    _showMyDialog();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onTap ?? () async {
        goToEspaceEntitePilotage(widget.espaceID);
      },
      child: Align(
        alignment: Alignment.centerLeft, // Alignement du texte à gauche
        child: CustomText(
          text: widget.title,
          color: widget.color,
          weight: FontWeight.bold,
          size: 16,
        ),
      ),
    );
  }
}

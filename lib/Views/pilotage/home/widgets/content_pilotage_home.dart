import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/customtext.dart';
import '../../../pilotage_home/controller/accueil_pilot_controller.dart';
import '../../entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'contentbox.dart';
import 'listeProcessus.dart';

class ContentPilotageHome extends StatefulWidget {
  const ContentPilotageHome({Key? key}) : super(key: key);

  @override
  State<ContentPilotageHome> createState() => _ContentPilotageHomeState();
}

class _ContentPilotageHomeState extends State<ContentPilotageHome> {
  final AccueilPilotController accueilPilotController = Get.put(AccueilPilotController());
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _filliale = [];
  List<Map<String, dynamic>> _management = [];
  List<Map<String, dynamic>> _operationnels = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fillialeData = await getSupportProcessus();
      final managementProcess = await getManagementProcessus();
      final operationnelsProcess = await getOperationnelsProcessus();

      setState(() {
        _filliale = fillialeData;
        _management = managementProcess;
        _operationnels = operationnelsProcess;
      });
    } catch (e) {
      print('Erreur lors du chargement des processus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTitle("Processus et Indicateurs"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContentBoxes(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContentBoxes() {
    final List<Widget> children = [];

    // Construire le contenu en fonction de la valeur de 'aAfficher'
    if (accueilPilotController.aAfficher.value == 0) {
      children.addAll([
        _buildContentBox("PROCESSUS MANAGEMENT", _management, "management"),
        const SizedBox(width: 10),
        _buildContentBox("PROCESSUS OPÉRATIONNELS", _operationnels, "operationnels"),
        const SizedBox(width: 10),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    } else if (accueilPilotController.aAfficher.value == 1) {
      children.addAll([
        _buildContentBox("PROCESSUS MANAGEMENT", _management, "management"),
        const SizedBox(width: 120),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    } else {
      children.addAll([
        _buildContentBox("PROCESSUS OPÉRATIONNELS", _operationnels, "operationnels"),
        const SizedBox(width: 120),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    }

    return children;
  }


  Widget _buildTitle(String title) {
    return Container(
      width: 775,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBox(String title, List<Map<String, dynamic>> items, String key) {
    return ContentBox(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      width: 250,
      height: 211,
      children: items.map((item) {
        return TextButton(
          onPressed: () {
            context.go("/accueil_pilotage");
            print("\nitems:\n");
            print(items);
            print("\nitem:\n");
            print(item[key]);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item[key]!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class EspaceTextButton extends StatelessWidget {
  final String title;
  final String espaceID;
  final Color color;
  final Function()? onTap;

  const EspaceTextButton({
    Key? key,
    required this.title,
    required this.espaceID,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: title,
          color: color,
          weight: FontWeight.bold,
          size: 16,
        ),
      ),
    );
  }
}

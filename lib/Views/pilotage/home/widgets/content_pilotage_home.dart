import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../pilotage_home/controller/accueil_pilot_controller.dart';
import 'contentbox.dart';
import 'listeProcessus.dart';

class ContentPilotageHome extends StatefulWidget {
  const ContentPilotageHome({Key? key}) : super(key: key);

  @override
  State<ContentPilotageHome> createState() => _ContentPilotageHomeState();
}

class _ContentPilotageHomeState extends State<ContentPilotageHome> {
  final AccueilPilotController accueilPilotController = Get.put(AccueilPilotController());
  List<Map<String, dynamic>> _filliale = [];
  List<Map<String, dynamic>> _management = [];
  List<Map<String, dynamic>> _operationnels = [];

  late String _userEmail = 'No email available';
  String _espaces_d_acces = "";

  final Map<String, bool> _accessCache = {};
  late Future<void> _loadDataFuture;
  late Future<void> _accessFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
    _accessFuture = _checkAccess(); // Assurez-vous que cette fonction est appelée une seule fois
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

  Future<void> _checkAccess() async {
    await Future.wait([
      _getAccessEspace("Consolide"),
      _getAccessEspace("Siege"),
      _getAccessEspace("Usine"),
    ]);
  }

  Future<bool> _getAccessEspace(String espace) async {
    if (_accessCache.containsKey(espace)) {
      return _accessCache[espace]!;
    }

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
          _accessCache[espace] = false;
          return false;
        }

        String espacesDacces = data['a_acces_a'] ?? '';

        setState(() {
          _espaces_d_acces = espacesDacces;
        });

        print('Espaces d\'accès: $_espaces_d_acces');

        if (_espaces_d_acces == espace) {
          print('Accès à l\'espace $espace autorisé.');
          _accessCache[espace] = true;
          return true;
        } else {
          print("Vous n'avez pas accès à: $espace");
          _accessCache[espace] = false;
          return false;
        }

      } catch (e) {
        print('Exception lors de la requête: $e');
        _accessCache[espace] = false;
        return false;
      }

    } else {
      print('Utilisateur non authentifié.');
      setState(() {
        _userEmail = 'No email available';
      });
      context.go("/");
      _accessCache[espace] = false;
      return false;
    }
  }

  Future<List<Widget>> _buildContentBoxes() async {
    final List<Widget> children = [];

    if (await _getAccessEspace("Consolide")) {
      children.addAll([
        _buildContentBox("PROCESSUS MANAGEMENT", _management, "management"),
        const SizedBox(width: 10),
        _buildContentBox("PROCESSUS OPÉRATIONNELS", _operationnels, "operationnels"),
        const SizedBox(width: 10),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    } else if (await _getAccessEspace("Siege")) {
      children.addAll([
        _buildContentBox("PROCESSUS MANAGEMENT", _management, "management"),
        const SizedBox(width: 120),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    } else if (await _getAccessEspace("Usine")) {
      children.addAll([
        _buildContentBox("PROCESSUS OPÉRATIONNELS", _operationnels, "operationnels"),
        const SizedBox(width: 120),
        _buildContentBox("PROCESSUS SUPPORT", _filliale, "support"),
      ]);
    } else {
      context.go("/accueil_pilotage");
    }

    return children;
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
          FutureBuilder<void>(
            future: Future.wait([_loadDataFuture, _accessFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else {
                return FutureBuilder<List<Widget>>(
                  future: _buildContentBoxes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucun contenu disponible.'));
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data!,
                      );
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
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

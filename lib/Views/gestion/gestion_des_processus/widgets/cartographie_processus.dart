import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartographieProcessus extends StatefulWidget {
  const CartographieProcessus({Key? key}) : super(key: key);

  @override
  State<CartographieProcessus> createState() => _CartographieProcessusState();
}

class _CartographieProcessusState extends State<CartographieProcessus> {

  final String baseUrl = "http://127.0.0.1:5000";

  List<dynamic> processusManagement = [];
  List<dynamic> processusOperationnels = [];
  List<dynamic> processusSupports = [];

  @override
  void initState() {
    super.initState();
    _fetchProcessus();
  }

  Future<void> _fetchProcessus() async {
    final response = await http.get(Uri.parse('$baseUrl/processus')); // URL de l'API Flask

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['processus'] as List<dynamic>;
      setState(() {
        processusManagement = data
            .where((processus) => processus['type_processus'] == 'Management')
            .toList()
          ..sort((a, b) => a['libelle_processus'].compareTo(b['libelle_processus']));

        processusOperationnels = data
            .where((processus) => processus['type_processus'] == 'Operationnels')
            .toList()
          ..sort((a, b) => a['libelle_processus'].compareTo(b['libelle_processus']));

        processusSupports = data
            .where((processus) => processus['type_processus'] == 'Support')
            .toList()
          ..sort((a, b) => a['libelle_processus'].compareTo(b['libelle_processus']));
      });
    } else {
      print("Erreur lors de la récupération des processus: ${response.statusCode}");
    }

  }

  void showProcessusDialog(BuildContext context, String libelleProcessus, String pilote) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(libelleProcessus, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400.0,
            height: 100.0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Responsabilité : ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: pilote,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }



  Widget _buildProcessusButtons(List<dynamic> processusList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: processusList.map((processus) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Tooltip(
              message: "Afficher la responsabilité",
              child: ElevatedButton(
                onPressed: () {
                  showProcessusDialog(
                      context,
                      processus['libelle_processus'],
                      processus['pilote']
                  );
                  print('Bouton pour ${processus['libelle_processus']} pressé');
                },
                child: Text(
                  processus['libelle_processus'],
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(205, 45)),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Ajuste la largeur
          height: MediaQuery.of(context).size.height * 0.7, // Ajuste la hauteur
          decoration: BoxDecoration(
            color: Colors.white, // Couleur de fond du grand bloc
            borderRadius: BorderRadius.circular(20), // Arrondi des bords
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // décalage de l'ombre
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Processus Management",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Bloc 1 - Processus Management
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 100,
                    width: 1200,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20), // Arrondi des bords
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // décalage de l'ombre
                        ),
                      ],
                    ),
                    child: _buildProcessusButtons(processusManagement),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Processus Opérationnels",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Bloc 2 - Processus Opérationnels
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 100,
                    width: 1200,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20), // Arrondi des bords
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // décalage de l'ombre
                        ),
                      ],
                    ),
                    child: _buildProcessusButtons(processusOperationnels),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Processus Supports",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Bloc 3 - Processus Supports
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 100,
                    width: 1200,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20), // Arrondi des bords
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // décalage de l'ombre
                        ),
                      ],
                    ),
                    child: _buildProcessusButtons(processusSupports),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

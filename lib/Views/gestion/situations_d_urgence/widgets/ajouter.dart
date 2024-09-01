import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';

class Ajouter extends StatefulWidget {
  const Ajouter({Key? key}) : super(key: key);

  @override
  State<Ajouter> createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController poidsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showSuccessAnimation = false;

  Future<void> ajouterUrgence() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('http://127.0.0.1:5000/ajouter_urgence'); // URL de votre serveur Flask local
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom_urgence': nomController.text,
          'poids_urgence': double.parse(poidsController.text),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _showSuccessAnimation = true;

          // Vidage des champs de texte
          nomController.clear();
          poidsController.clear();
        });

        // Afficher l'animation pendant 2 secondes
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _showSuccessAnimation = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${responseData['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Renseignez les informations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de l\'urgence',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom d\'urgence';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: poidsController,
                        decoration: const InputDecoration(
                          labelText: 'Poids de l\'urgence',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final poids = double.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un poids';
                          } else if (poids == null || !(poids == 0.25 || poids == 0.5 || poids == 0.75 || poids == 1.0)) {
                            return 'Veuillez entrer un poids valide (0.25, 0.5, 0.75, 1.0)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: ajouterUrgence,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        ),
                        child: const Text('Ajouter'),
                      ),
                      if (_showSuccessAnimation)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Lottie.asset(
                            'assets/animations/success.json', // Assurez-vous d'avoir ce fichier d'animation
                            width: 200,
                            height: 150,
                            repeat: false,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    poidsController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder/décoder les données JSON
import 'package:lottie/lottie.dart';

import '../../../../common.dart'; // Assurez-vous d'ajouter lottie dans vos dépendances pubspec.yaml

class AjoutProcessus extends StatefulWidget {
  const AjoutProcessus({Key? key}) : super(key: key);

  @override
  State<AjoutProcessus> createState() => _AjoutProcessusState();
}

class _AjoutProcessusState extends State<AjoutProcessus> {

  final _formKey = GlobalKey<FormState>();

  String _typeProcessus = 'Management';
  String _libelleProcessus = '';
  String _pilote = '';
  bool _showSuccessAnimation = false;

  Future<void> _ajouterProcessus() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('$baseUrl/ajouter_processus');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type_processus': _typeProcessus,
          'libelle_processus': _libelleProcessus,
          'pilote': _pilote,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _showSuccessAnimation = true;
          _typeProcessus = 'Management';
          _libelleProcessus = '';
          _pilote = '';
          _formKey.currentState?.reset();
        });

        // Cacher l'animation après 2 secondes
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showSuccessAnimation = false;
          });
        });
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Ajouter un Processus'),
      //   backgroundColor: Colors.deepPurple,
      // ),
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
                        'Ajouter un nouveau processus',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Sélection du type de processus
                      DropdownButtonFormField<String>(
                        value: _typeProcessus,
                        items: const [
                          DropdownMenuItem(value: 'Management', child: Text('Management')),
                          DropdownMenuItem(value: 'Operationnels', child: Text('Opérationnels')),
                          DropdownMenuItem(value: 'Support', child: Text('Support')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _typeProcessus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Type de processus',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Champ pour le libellé du processus
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nom du processus',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _libelleProcessus = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom du processus';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Champ pour le pilote du processus
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Responsabilité',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _pilote = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le rôle de ce processus';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Bouton pour soumettre le formulaire
                      ElevatedButton(
                        onPressed: _ajouterProcessus,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        ),
                        child: const Text('Ajouter'),
                      ),

                      // Animation de succès après l'ajout réussi
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
    super.dispose();
  }
}

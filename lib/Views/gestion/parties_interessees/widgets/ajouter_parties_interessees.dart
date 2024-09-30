import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

import '../../../../common.dart'; // Import the Lottie package

class AjouterPartiesInteressees extends StatefulWidget {
  @override
  _AjouterPartiesInteresseesState createState() => _AjouterPartiesInteresseesState();
}

class _AjouterPartiesInteresseesState extends State<AjouterPartiesInteressees> {
  final SupabaseClient supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _libelleController = TextEditingController();
  final TextEditingController _poidsPiController = TextEditingController();
  final TextEditingController _typePiController = TextEditingController();
  final TextEditingController _attenteController = TextEditingController();
  final TextEditingController _typeAttenteController = TextEditingController();
  final TextEditingController _modeReponseController = TextEditingController();

  final List<Map<String, String>> _attentes = [];

  // bool _showSuccessAnimation = false;

  @override
  void dispose() {
    // Dispose des contrôleurs pour éviter les fuites de mémoire
    _categorieController.dispose();
    _libelleController.dispose();
    _poidsPiController.dispose();
    _typePiController.dispose();
    _attenteController.dispose();
    _typeAttenteController.dispose();
    _modeReponseController.dispose();
    super.dispose();
  }

  void _visualiser_l_ajout() {
    setState(() {
      _attentes.add({
        'attente': _attenteController.text,
        'type_attente': _typeAttenteController.text,
        'mode_reponse': _modeReponseController.text,
        'categorie': _categorieController.text,
        'nom_pi': _libelleController.text,
        'poids_pi': _poidsPiController.text,
        'type_pi': _typeAttenteController.text,
      });
    });
  }

  Future<void> _enregistrerPartieInteressee() async {
    if (_formKey.currentState!.validate()) {
      // API URL for inserting Partie Interessee
      final partieInteresseeUrl = Uri.parse('$baseUrl/add_partie_interessee');

      // Partie Interessee data to send
      final partieInteresseeData = {
        'categorie': _categorieController.text,
        'libelle': _libelleController.text,
        'poids_pi': int.tryParse(_poidsPiController.text) ?? 0,
        'type_pi': _typePiController.text,
      };

      try {
        // Send Partie Interessee to the API
        final partieInteresseeResponse = await http.post(
          partieInteresseeUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(partieInteresseeData),
        );



        if (partieInteresseeResponse.statusCode == 201) {
          // Retrieve the inserted PartieInteressee ID
          final partieInteresseeResponseData = jsonDecode(partieInteresseeResponse.body);
          final idPi = partieInteresseeResponseData['id_pi'];

          // Insert each Attente using its corresponding id_pi
          final attenteData = {
            'id_pi': idPi, // Use the ID of the inserted PartieInteressee
            'libelle': _attenteController.text,
            'type_attente': _typeAttenteController.text,
            'mode_reponse': _modeReponseController.text,
          };

          // API URL for inserting Attente
          final attenteUrl = Uri.parse('$baseUrl/add_attente');

          // Log the request for debugging
          print('Sending attente data: $attenteData to $attenteUrl');

          final attenteResponse = await http.post(
            attenteUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(attenteData),
          );

          if (attenteResponse.statusCode == 201) {
            // Clear form fields after successful insertion
            setState(() {
              _categorieController.clear();
              _libelleController.clear();
              _poidsPiController.clear();
              _typePiController.clear();
              _attentes.clear();
              _attenteController.clear();
              _typeAttenteController.clear();
              _modeReponseController.clear();
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Partie intéressée et attente ajoutées avec succès',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4), // Affichage de 2 secondes
                behavior: SnackBarBehavior.floating, // Affichage immédiat
              ),
            );

          } else {
            print('Erreur lors de l\'ajout de l\'attente: ${attenteResponse.body}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Revoyez les informations de l\'attente',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2), // Affichage de 2 secondes
                behavior: SnackBarBehavior.floating, // Affichage immédiat
              ),
            );
          }
        } else {
          print('Erreur lors de l\'ajout de la partie intéressée: ${partieInteresseeResponse.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Revoyez les informations de la partie intéressée',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2), // Affichage de 2 secondes
              behavior: SnackBarBehavior.floating, // Affichage immédiat
            ),
          );
        }
      } catch (e) {
        print('Erreur de connexion au serveur: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Partie Intéressée'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Wrap the content in a Row to make two columns
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First column: Parties Intéressées
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Partie Intéressée',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildTextField(_categorieController, 'Catégorie'),
                        SizedBox(height: 12),
                        _buildTextField(_libelleController, 'Nom de la partie intéressée'),
                        SizedBox(height: 12),
                        _buildTextField(_poidsPiController, 'Poids de la partie intéressée', isNumber: true),
                        SizedBox(height: 12),
                        _buildTextField(_typePiController, 'Type de la partie intéressée'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20), // Space between the two columns

                  // Second column: Attentes
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attentes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildTextField(_attenteController, 'Attente'),
                        SizedBox(height: 12),
                        _buildTextField(_typeAttenteController, 'Type d\'attente'),
                        SizedBox(height: 12),
                        _buildTextField(_modeReponseController, 'Mode de dialogue'),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            _visualiser_l_ajout();
                            _enregistrerPartieInteressee();
                          },
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Enregistrer',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildAttentesList(),
              // if (_showSuccessAnimation)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 16.0),
              //     child: Lottie.asset(
              //       'assets/animations/success.json', // Ensure you have the correct path for the animation
              //       width: 200,
              //       height: 150,
              //       repeat: false,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey.shade700),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un $label';
        }
        return null;
      },
    );
  }

  Widget _buildAttentesList() {
    return SizedBox(
      height: 200, // Fixed height to prevent overflow
      child: ListView.builder(
        itemCount: _attentes.length,
        itemBuilder: (context, index) {
          final attente = _attentes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.list_alt_rounded, color: Colors.teal),
              title: Text(
                attente['attente']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Catégorie: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['categorie']} | '),
                    TextSpan(
                      text: 'Partie intéressée: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['nom_pi']} | '),
                    TextSpan(
                      text: 'Poids: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['poids_pi']} | '),
                    TextSpan(
                      text: 'Type partie intéressée: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['type_pi']} | '),
                    TextSpan(
                      text: 'Attente: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['type_attente']} | '),
                    TextSpan(
                      text: 'Type attente: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['type_attente']} | '),
                    TextSpan(
                      text: 'Mode: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${attente['mode_reponse']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

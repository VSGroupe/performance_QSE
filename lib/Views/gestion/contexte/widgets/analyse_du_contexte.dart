import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';


class AnalyseDuContexte extends StatefulWidget {
  const AnalyseDuContexte({Key? key}) : super(key: key);

  @override
  State<AnalyseDuContexte> createState() => _AnalyseDuContexteState();
}

class _AnalyseDuContexteState extends State<AnalyseDuContexte> {

  final String baseUrl = "http://localhost:5000"; // URL de votre API Flask

  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];
  Map<String, List<Map<String, dynamic>>> _risquesParEnjeu = {};
  Map<String, List<Map<String, dynamic>>> _opportunitesParEnjeu = {};
  Map<String, String> libellesEnjeux = {};// Créer une liste associative pour stocker les libellés avec leur id_enjeu comme clé

  @override
  void initState() {
    super.initState();
    _fetchEnjeuxEtRisquesEtOpportunites();
  }

  Future<void> _fetchEnjeuxEtRisquesEtOpportunites() async {

    // Récupérer les enjeux
    final enjeuxResponse = await http.get(Uri.parse('$baseUrl/enjeux'));
    // Récupérer les risques
    final risquesResponse = await http.get(Uri.parse('$baseUrl/risques'));
    // Récupérer les opportunités
    final opportunitesResponse = await http.get(Uri.parse('$baseUrl/opportunites'));

    if (enjeuxResponse.statusCode == 200) {
      final List<dynamic> enjeuxData = json.decode(enjeuxResponse.body);
      final List<Map<String, dynamic>> enjeuxList =
      enjeuxData.map((item) => item as Map<String, dynamic>).toList();

      // Remplir la liste associative
      for (var item in enjeuxList) {
        String idEnjeu = item['id_enjeu'];
        String libelle = item['libelle'];
        libellesEnjeux[idEnjeu] = libelle;
      }

      print("\nenjeuList:\n");
      print(enjeuxList);
      print("\n");

      _interneEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'interne').toList();
      _externeEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'externe').toList();

      // Traitement de la réponse sur la récupération des risques
      if (risquesResponse.statusCode == 200) {

        final List<dynamic> risquesData = json.decode(risquesResponse.body);

        print("\nrisqueData:\n");
        print(risquesData);
        print("\n");

        final List<Map<String, dynamic>> risquesList =
        risquesData.map((item) => item as Map<String, dynamic>).toList();

        print("\nrisqueList:\n");
        print(risquesList);
        print("\n");

        for (var risque in risquesList) {
          String idEnjeu = risque['id_enjeu'];
          if (_risquesParEnjeu.containsKey(idEnjeu)) {
            _risquesParEnjeu[idEnjeu]?.add(risque);
            print("Bonjour");
            print(_risquesParEnjeu[idEnjeu]);
          } else {
            _risquesParEnjeu[idEnjeu] = [risque];
          }
        }
      } else {
        print('Error fetching risks: ${risquesResponse.body}');
      }

      //Traitement de la réponse sur la récupération des opportunités
      if (opportunitesResponse.statusCode == 200) {
        final List<dynamic> opportunitesData = json.decode(opportunitesResponse.body);
        final List<Map<String, dynamic>> opportunitesList =
        opportunitesData.map((item) => item as Map<String, dynamic>).toList();

        for (var opportunite in opportunitesList) {
          String idEnjeu = opportunite['id_enjeu'];
          if (_opportunitesParEnjeu.containsKey(idEnjeu)) {
            _opportunitesParEnjeu[idEnjeu]?.add(opportunite);
          } else {
            _opportunitesParEnjeu[idEnjeu] = [opportunite];
          }
        }
      } else {
        print('Error fetching opportunities: ${opportunitesResponse.body}');
      }

      setState(() {});
    } else {
      print('Error fetching enjeux: ${enjeuxResponse.body}');
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  // Les détails sur le risque cliqué
  void _showRisqueDetails(Map<String, dynamic> risque) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400, // Fixer la largeur de la boîte de dialogue
                height: 300,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60, // Fixer la hauteur de la barre de titre
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                risque['libelle'] ?? 'Détails de l\'Opportunité',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditRisqueDialog(context, risque, setState),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _showDeleteRisqueConfirmationDialog(context, risque['id_risque'], risque['libelle']),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Poids du risque: ${risque['gravite'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Fréquence: ${risque['frequence'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Enjeu associé: ${libellesEnjeux[risque['id_enjeu']]}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Quitter'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditRisqueDialog(BuildContext context, Map<String, dynamic> risque, StateSetter setState) {
    final TextEditingController _libelleController = TextEditingController(text: risque['libelle']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 400, // Fixer la largeur de la boîte de dialogue
            height: 300, // Fixer la hauteur de la boîte de dialogue
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modifier le libelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _libelleController,
                  decoration: InputDecoration(
                    hintText: "Nouveau libelle",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 110),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        print('Enregistrement en cours...');  // Journalisation
                        await _updateRisque(risque['id_risque'], _libelleController.text);
                        setState(() {
                          risque['libelle'] = _libelleController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Enregistrer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _updateRisque(int idRisque, String nouveauLibelle) async {
    final url = '$baseUrl/update_risque/$idRisque';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'libelle': nouveauLibelle}),
    );

    if (response.statusCode == 200) {
      print('Risque mis à jour avec succès : $idRisque');
    } else {
      print('Erreur lors de la mise à jour du risque');
    }
  }

  void _showDeleteRisqueConfirmationDialog(BuildContext context, int idRisque, String libelle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 400, // Fixer la largeur de la boîte de dialogue
            height: 300, // Fixer la hauteur de la boîte de dialogue
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vous êtes sur le point de supprimer l\'élément suivant:',
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$libelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  'Cliquez sur Supprier pour continuer',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(), // Espacement flexible entre le texte et les boutons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        print('Suppression en cours...');  // Journalisation
                        await _deleteRisque(idRisque);
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue de confirmation
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue principale si nécessaire
                      },
                      child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _deleteRisque(int idRisque) async {
    final url = '$baseUrl/delete_risque/$idRisque';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Risque supprimé avec succès : $idRisque');
    } else {
      print('Erreur lors de la suppression du risque');
    }
  }


  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  // Les détails sur l'opportunité cliquée

  void _showOpportuniteDetails(Map<String, dynamic> opportunite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400, // Fixer la largeur de la boîte de dialogue
                height: 300,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60, // Fixer la hauteur de la barre de titre
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                opportunite['libelle'] ?? 'Détails de l\'Opportunité',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(context, opportunite, setState),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(context, opportunite['id_opportunite'], opportunite['libelle']),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Poids de l'opportunité: ${opportunite['gravite'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Fréquence: ${opportunite['frequence'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Enjeu associé: ${libellesEnjeux[opportunite['id_enjeu']]}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Quitter'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showEditDialog(BuildContext context, Map<String, dynamic> opportunite, StateSetter setState) {
    final TextEditingController _libelleController = TextEditingController(text: opportunite['libelle']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 400, // Fixer la largeur de la boîte de dialogue
            height: 300, // Fixer la hauteur de la boîte de dialogue
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modifier le libelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _libelleController,
                  decoration: InputDecoration(
                    hintText: "Nouveau libelle",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 110),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        print('Enregistrement en cours...');  // Journalisation
                        await _updateOpportunite(opportunite['id_opportunite'], _libelleController.text);
                        setState(() {
                          opportunite['libelle'] = _libelleController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Enregistrer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _updateOpportunite(int idOpportunite, String nouveauLibelle) async {
    final url = '$baseUrl/update_opportunite/$idOpportunite';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'libelle': nouveauLibelle}),
    );

    if (response.statusCode == 200) {
      print('Opportunité mise à jour avec succès : $idOpportunite');
    } else {
      print('Erreur lors de la mise à jour de l\'opportunité');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int idOpportunite, String libelle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 400, // Fixer la largeur de la boîte de dialogue
            height: 300, // Fixer la hauteur de la boîte de dialogue
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vous êtes sur le point de supprimer l\'élément suivant:',
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$libelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  'Cliquez sur Supprier pour continuer',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(), // Espacement flexible entre le texte et les boutons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        print('Suppression en cours...');  // Journalisation
                        await _deleteOpportunite(idOpportunite);
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue de confirmation
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue principale si nécessaire
                      },
                      child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _deleteOpportunite(int idOpportunite) async {
    final url = '$baseUrl/delete_opportunite/$idOpportunite';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Opportunité supprimée avec succès : $idOpportunite');
    } else {
      print('Erreur lors de la suppression de l\'opportunité');
    }
  }



  // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


  // Ajout d'enjeu
  Future<void> _showAddEnjeuDialog(BuildContext context) async {
    final TextEditingController _idEnjeuController = TextEditingController();
    final TextEditingController _libelleController = TextEditingController();
    String? _selectedAxeId;
    String? _selectedType;
    bool _idEnjeuExists = false;
    bool _showSuccessAnimation = false;
    bool _showFieldError = false;

    Future<void> _checkIdEnjeuExists(String idEnjeu) async {
      final response = await http.get(
        Uri.parse('$baseUrl/check_id_enjeu_exists?id_enjeu=$idEnjeu'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _idEnjeuExists = data['exists'];
      } else {
        print('Erreur lors de la vérification de l\'id enjeu: ${response.statusCode}');
      }
    }

    Future<List<Map<String, dynamic>>> _fetchAxes() async {
      final response = await http.get(
        Uri.parse('$baseUrl/get_axes'),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Erreur lors de la récupération des axes: ${response.statusCode}');
        return [];
      }
    }

    Future<void> _addEnjeu() async {
      final idEnjeu = _idEnjeuController.text;
      final libelle = _libelleController.text;

      await _checkIdEnjeuExists(idEnjeu);

      if (_idEnjeuExists) {
        print('L\'ID de l\'enjeu existe déjà, ajout annulé.');
        return;
      }

      if (idEnjeu.isNotEmpty && libelle.isNotEmpty && _selectedAxeId != null && _selectedType != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/add_enjeu'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_enjeu': idEnjeu,
            'libelle': libelle,
            'id_axe': _selectedAxeId,
            'type_enjeu': _selectedType,
          }),
        );

        if (response.statusCode == 201) {
          print('Enjeu ajouté avec succès');
          _idEnjeuController.clear();
          _libelleController.clear();
          _selectedAxeId = null;
          _selectedType = null;
          setState(() {
            _showSuccessAnimation = true;
            _showFieldError = false; // Réinitialiser l'erreur des champs
          });
        } else {
          print('Erreur lors de l\'ajout de l\'enjeu: ${response.statusCode}');
        }
      } else {
        setState(() {
          _showFieldError = true; // Afficher l'erreur si certains champs sont vides
        });
        print('Certains champs sont vides ou non sélectionnés');
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 600,
                height: 500,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajouter un Enjeu',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: _idEnjeuController,
                              labelText: "Identifiant de l'enjeu (Ex: enjeu1, enjeu2, enjeu15, ...)",
                              errorText: _idEnjeuExists ? 'Cet identifiant existe déjà' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _libelleController,
                              labelText: "Nom de l'enjeu",
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown(
                              labelText: "Sélectionner l'axe associé",
                              value: _selectedAxeId,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedAxeId = newValue;
                                });
                              },
                              itemsFuture: _fetchAxes,
                              itemLabel: (axe) => '${axe['libelle']}',
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown(
                              labelText: "Sélectionner le type de l'enjeu",
                              value: _selectedType,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedType = newValue!;
                                });
                              },
                              itemsFuture: () async => ['interne', 'externe']
                                  .map((type) => {'type_enjeu': type})
                                  .toList(),
                              itemLabel: (item) => item['type_enjeu']!,
                            ),
                            const SizedBox(height: 16),
                            if (_showFieldError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Veuillez remplir tous les champs obligatoires',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Visibility(
                              visible: _showSuccessAnimation,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Lottie.asset(
                                  'assets/animations/success.json',
                                  width: 200,
                                  height: 150,
                                  repeat: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await _addEnjeu();
                            if (!_idEnjeuExists && !_showFieldError) {
                              setState(() {
                                _showSuccessAnimation = true;
                              });
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                _showSuccessAnimation = false;
                              });
                            }
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String labelText,
    required T? value,
    required void Function(T?) onChanged,
    required Future<List<Map<String, dynamic>>> Function() itemsFuture,
    required String Function(Map<String, dynamic>) itemLabel,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: itemsFuture(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item['id_axe'] ?? item['type_enjeu'] as T?,
                child: Text(itemLabel(item)),
              );
            }).toList(),
          ),
        );
      },
    );
  }




  Future<void> _showAddRisqueDialog(BuildContext context) async {
    final TextEditingController _libelleController = TextEditingController();
    String? _selectedGravite;
    String? _selectedFrequence;
    String? _selectedEnjeuId;
    bool _showSuccessAnimation = false;
    bool _showFieldError = false;

    Future<List<Map<String, dynamic>>> _fetchEnjeux() async {
      final response = await http.get(
        Uri.parse('$baseUrl/enjeux'),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Erreur lors de la récupération des enjeux: ${response.statusCode}');
        return [];
      }
    }

    Future<bool> _addRisque() async {
      final libelle = _libelleController.text;

      if (libelle.isNotEmpty && _selectedGravite != null && _selectedFrequence != null && _selectedEnjeuId != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/add_risque'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'libelle': libelle,
            'gravite': _selectedGravite,
            'frequence': _selectedFrequence,
            'id_enjeu': _selectedEnjeuId,
          }),
        );

        if (response.statusCode == 201) {
          print('Risque ajouté avec succès');
          _libelleController.clear();
          _selectedGravite = null;
          _selectedFrequence = null;
          _selectedEnjeuId = null;
          return true;
        } else {
          print('Erreur lors de l\'ajout du risque: ${response.statusCode}');
          return false;
        }
      } else {
        return false;
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: 550,  // Largeur totale de la boîte de dialogue
                height: 500,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajouter un Risque',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _libelleController,
                              decoration: InputDecoration(
                                labelText: "Désignation du risque",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _fetchEnjeux(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                final enjeux = snapshot.data!;
                                return Container(
                                  // width: 520, // Réduction de la largeur des boîtes déroulantes
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: _selectedEnjeuId,
                                    decoration: InputDecoration(
                                      labelText: "Sélectionner l'enjeu associé",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                    ),
                                    items: enjeux.map((enjeu) {
                                      return DropdownMenuItem<String>(
                                        value: enjeu['id_enjeu'],
                                        child: Text('${enjeu['libelle']}'),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedEnjeuId = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    menuMaxHeight: 200,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              // width: 520, // Réduction de la largeur des boîtes déroulantes
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedGravite,
                                decoration: InputDecoration(
                                  labelText: "Sélectionner le Poids risque",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                items: ['-1', '-3', '-5'].map((gravite) {
                                  return DropdownMenuItem<String>(
                                    value: gravite,
                                    child: Text(gravite),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGravite = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                menuMaxHeight: 200,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              // width: 520, // Réduction de la largeur des boîtes déroulantes
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedFrequence,
                                decoration: InputDecoration(
                                  labelText: "Sélectionner la fréquence du risque",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                items: ['0.10', '0.25', '0.5', '0.75', '0.80', '0.90', '0.95'].map((frequence) {
                                  return DropdownMenuItem<String>(
                                    value: frequence,
                                    child: Text('${(double.parse(frequence) * 100).toStringAsFixed(0)}%'),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedFrequence = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                menuMaxHeight: 200,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_showFieldError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Veuillez remplir tous les champs obligatoires',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Visibility(
                              visible: _showSuccessAnimation,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Lottie.asset(
                                  'assets/animations/success.json',
                                  width: 200,
                                  height: 150,
                                  repeat: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final success = await _addRisque();
                            setState(() {
                              _showSuccessAnimation = success;
                              _showFieldError = !success;
                            });
                            if (success) {
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }




  void _showAddOpportuniteDialog(BuildContext context) async {
    final TextEditingController _libelleController = TextEditingController();
    String? _selectedEnjeuId;
    String? _selectedGravite;
    String? _selectedFrequence;
    bool _showSuccessAnimation = false;
    bool _showFieldError = false;

    Future<List<Map<String, dynamic>>> _fetchEnjeux() async {
      final response = await http.get(
        Uri.parse('$baseUrl/enjeux'),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Erreur lors de la récupération des enjeux: ${response.statusCode}');
        return [];
      }
    }

    Future<bool> _addOpportunite() async {
      final libelle = _libelleController.text;
      final gravite = int.tryParse(_selectedGravite ?? '');
      final frequence = double.tryParse(_selectedFrequence ?? '');

      print('Libellé: $libelle');
      print('ID Enjeu: $_selectedEnjeuId');
      print('Gravité: $gravite');
      print('Fréquence: $frequence');

      if (libelle.isNotEmpty && _selectedEnjeuId != null && gravite != null && frequence != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/add_opportunite'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'libelle': libelle,
            'id_enjeu': _selectedEnjeuId,
            'gravite': gravite,
            'frequence': frequence,
          }),
        );

        if (response.statusCode == 201) {
          print('Opportunité ajoutée avec succès');
          _libelleController.clear();
          _selectedEnjeuId = null;
          _selectedGravite = null;
          _selectedFrequence = null;
          return true;
        } else {
          print('Erreur lors de l\'ajout de l\'opportunité: ${response.statusCode}');
          return false;
        }
      } else {
        return false;
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: 550,  // Largeur totale de la boîte de dialogue
                height: 500,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajouter une Opportunité',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _libelleController,
                              decoration: InputDecoration(
                                labelText: "Désignation de l'opportunité",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _fetchEnjeux(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                final enjeux = snapshot.data!;
                                return Container(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: _selectedEnjeuId,
                                    decoration: InputDecoration(
                                      labelText: "Sélectionner l'enjeu associé",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                    ),
                                    items: enjeux.map((enjeu) {
                                      return DropdownMenuItem<String>(
                                        value: enjeu['id_enjeu'],
                                        child: Text('${enjeu['libelle']}'),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedEnjeuId = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    menuMaxHeight: 200,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedGravite,
                                decoration: InputDecoration(
                                  labelText: "Sélectionner le poids ",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                items: ['1', '3', '5'].map((gravite) {
                                  return DropdownMenuItem<String>(
                                    value: gravite,
                                    child: Text(gravite),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGravite = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                menuMaxHeight: 200,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedFrequence,
                                decoration: InputDecoration(
                                  labelText: "Sélectionner la fréquence",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                items: ['0.10', '0.25', '0.5', '0.75', '0.80', '0.90', '0.95'].map((frequence) {
                                  return DropdownMenuItem<String>(
                                    value: frequence,
                                    child: Text('${(double.parse(frequence) * 100).toStringAsFixed(0)}%'),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedFrequence = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                menuMaxHeight: 200,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_showFieldError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Veuillez remplir tous les champs obligatoires',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Visibility(
                              visible: _showSuccessAnimation,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Lottie.asset(
                                  'assets/animations/success.json',
                                  width: 200,
                                  height: 150,
                                  repeat: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final success = await _addOpportunite();
                            setState(() {
                              _showSuccessAnimation = success;
                              _showFieldError = !success;
                            });
                            if (success) {
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyse du Contexte"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FixedColumnWidth(350.0),
                2: FixedColumnWidth(350.0),
                3: FixedColumnWidth(350.0),
              },
              children: [
                TableRow(
                  children: [
                    tableCell("Type", isHeader: true),
                    headerCellWithButton("Enjeux", () => _showAddEnjeuDialog(context)),
                    headerCellWithButton("Risques", () => _showAddRisqueDialog(context)),
                    headerCellWithButton("Opportunités", () => _showAddOpportuniteDialog(context)),
                  ],
                ),
                TableRow(
                  children: [
                    tableCell("Interne", isHeader: true, rowSpan: 3),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _interneEnjeux
                            .map((enjeu) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            "-  ${enjeu['libelle'] ?? 'N/A'}\n",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _interneEnjeux
                            .map((enjeu) {
                          final risques = _risquesParEnjeu[enjeu['id_enjeu']];
                          if (risques != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: risques.map((risque) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: TextButton(
                                    onPressed: () => _showRisqueDetails(risque),
                                    child: Text(
                                      "${risque['libelle'] ?? 'N/A'}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(); // Retourne un widget vide si aucun risque n'est trouvé
                          }
                        })
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _interneEnjeux
                            .map((enjeu) {
                          final opportunites = _opportunitesParEnjeu[enjeu['id_enjeu']];
                          if (opportunites != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: opportunites.map((opportunite) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: TextButton(
                                    onPressed: () => _showOpportuniteDetails(opportunite),
                                    child: Text(
                                      "${opportunite['libelle'] ?? 'N/A'}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(); // Retourne un widget vide si aucune opportunité n'est trouvée
                          }
                        })
                            .toList(),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    tableCell("Externe", isHeader: true, rowSpan: 3),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _externeEnjeux
                            .map((enjeu) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            "-  ${enjeu['libelle'] ?? 'N/A'}\n",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _externeEnjeux
                            .map((enjeu) {
                          final risques = _risquesParEnjeu[enjeu['id_enjeu']];
                          if (risques != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: risques.map((risque) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: TextButton(
                                    onPressed: () => _showRisqueDetails(risque),
                                    child: Text(
                                      "${risque['libelle'] ?? 'N/A'}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(); // Retourne un widget vide si aucun risque n'est trouvé
                          }
                        })
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _externeEnjeux
                            .map((enjeu) {
                          final opportunites = _opportunitesParEnjeu[enjeu['id_enjeu']];
                          if (opportunites != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: opportunites.map((opportunite) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: TextButton(
                                    onPressed: () => _showOpportuniteDetails(opportunite),
                                    child: Text(
                                      "${opportunite['libelle'] ?? 'N/A'}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(); // Retourne un widget vide si aucune opportunité n'est trouvée
                          }
                        })
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableCell(String text, {bool isHeader = false, int rowSpan = 1}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: isHeader ? Colors.amber : Colors.white, // Choisis une couleur sombre pour l'en-tête
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.black, // Texte blanc pour les en-têtes
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: isHeader ? 18 : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget headerCellWithButton(String headerText, VoidCallback onPressed) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: Colors.amber, // Couleur de fond
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centre le texte
          children: [
            Expanded(
              child: Text(
                headerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }


  Widget scrollableTableCell(Widget child) {
    return SizedBox(
      height: 200, // hauteur fixe de chaque cellule
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

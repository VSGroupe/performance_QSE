import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

import '../../../../common.dart';


class RapportDuRisque extends StatefulWidget {
  const RapportDuRisque({Key? key}) : super(key: key);

  @override
  State<RapportDuRisque> createState() => _RapportDuRisqueState();
}

class _RapportDuRisqueState extends State<RapportDuRisque> {

  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];
  Map<int, List<Map<String, dynamic>>> _risquesParEnjeu = {};
  Map<int, List<Map<String, dynamic>>> _opportunitesParEnjeu = {};
  Map<int, String> libellesEnjeux = {};// Créer une liste associative pour stocker les libellés avec leur id_enjeu comme clé

  @override
  void initState() {
    super.initState();
    fetchEnjeuxEtRisquesEtOpportunites();
  }

  Future<void> fetchEnjeuxEtRisquesEtOpportunites() async {

    // Vider les listes avant de les remplir à nouveau, très important pour rafraîchir correctment la page après manipulation des resques et opportunités
    _interneEnjeux.clear();
    _externeEnjeux.clear();
    _risquesParEnjeu.clear();
    _opportunitesParEnjeu.clear();
    libellesEnjeux.clear();

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
        int idEnjeu = item['id'];
        String libelle = item['libelle'];
        libellesEnjeux[idEnjeu] = libelle;
      }

      _interneEnjeux = enjeuxList.where((item) => item['type'] == 'interne').toList();
      _externeEnjeux = enjeuxList.where((item) => item['type'] == 'externe').toList();

      // Traitement de la réponse sur la récupération des risques
      if (risquesResponse.statusCode == 200) {
        final List<dynamic> risquesData = json.decode(risquesResponse.body);
        final List<Map<String, dynamic>> risquesList =
        risquesData.map((item) => item as Map<String, dynamic>).toList();

        for (var risque in risquesList) {
          int idEnjeu = risque['id'];
          if (_risquesParEnjeu.containsKey(idEnjeu)) {
            _risquesParEnjeu[idEnjeu]?.add(risque);
          } else {
            _risquesParEnjeu[idEnjeu] = [risque];
          }
        }
      } else {
        print('Error fetching risks: ${risquesResponse.body}');
      }

      // Traitement de la réponse sur la récupération des opportunités
      if (opportunitesResponse.statusCode == 200) {
        final List<dynamic> opportunitesData = json.decode(opportunitesResponse.body);
        final List<Map<String, dynamic>> opportunitesList =
        opportunitesData.map((item) => item as Map<String, dynamic>).toList();

        for (var opportunite in opportunitesList) {
          int idEnjeu = opportunite['id'];
          if (_opportunitesParEnjeu.containsKey(idEnjeu)) {
            _opportunitesParEnjeu[idEnjeu]?.add(opportunite);
          } else {
            _opportunitesParEnjeu[idEnjeu] = [opportunite];
          }
        }
      } else {
        print('Error fetching opportunities: ${opportunitesResponse.body}');
      }

      setState(() {}); // Mettre à jour l'interface après avoir récupéré et mis à jour les données
    } else {
      print('Error fetching enjeux: ${enjeuxResponse.body}');
    }
  }


  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  // PARTIE concernant le RISQUE


  // Les détails sur le risque
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
                          Tooltip(
                            message: "Modifier",
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditRisqueDialog(context, risque, setState),
                            ),
                          ),
                          Tooltip(
                            message: "Supprimer ce risque",
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _showDeleteRisqueConfirmationDialog(context, risque['id_risque'], risque['libelle']),
                            ),
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
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Poids du risque : ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: "${risque['gravite'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Fréquence : ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: "${risque['frequence'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Enjeu associé : ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: "${libellesEnjeux[risque['id']]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                              ),
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


  // Fonctioin de mise à jour du risque
  Future<void> _updateRisque(int idRisque, String nouveauLibelle) async {
    final url = '$baseUrl/update_risque/$idRisque';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'libelle': nouveauLibelle}),
    );

    if (response.statusCode == 200) {
      print('Risque mis à jour avec succès : $idRisque');
      // Rafraîchir les données après la mise à jour
      await fetchEnjeuxEtRisquesEtOpportunites(); // Récupérer à nouveau les risques après modification
    } else {
      print('Erreur lors de la mise à jour du risque');
    }
  }



  // Modifier les informations du risque
  void _showEditRisqueDialog(BuildContext context, Map<String, dynamic> risque, StateSetter setState) {
    final TextEditingController _libelleController = TextEditingController(text: risque['libelle']);
    bool _showSuccessAnimation = false;  // Initialize the animation flag

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {  // Use StatefulBuilder for local dialog state management
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400,
                height: 350,  // Adjusted height for animation
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
                    SizedBox(height: 10),
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
                            print('Enregistrement en cours...');
                            await _updateRisque(risque['id_risque'], _libelleController.text);
                            setState(() {
                              risque['libelle'] = _libelleController.text;
                            });
                            dialogSetState(() {
                              _showSuccessAnimation = true;  // Trigger the animation
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop();  // Close the dialog after 2 seconds
                            });
                          },
                          child: Text('Enregistrer'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: _showSuccessAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Lottie.asset(
                          'assets/animations/success.json',
                          width: 150,
                          height: 100,
                          repeat: false,
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


  // La méthode pour la suppression d'un risque

  Future<void> _deleteRisque(int idRisque) async {
    final url = '$baseUrl/delete_risque/$idRisque';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Risque supprimé avec succès : $idRisque');
      // Rafraîchir les données après la mise à jour
      await fetchEnjeuxEtRisquesEtOpportunites(); // Récupérer à nouveau les risques après modification
    } else {
      print('Erreur lors de la suppression du risque');
    }
  }


  // Boîte de dialogue pour la suppression d'un risque
  void _showDeleteRisqueConfirmationDialog(BuildContext context, int idRisque, String libelle) {
    bool _showSuccessAnimation = false;  // Initialize the animation flag

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {  // Use StatefulBuilder for local dialog state management
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400,
                height: 400,  // Adjusted height for animation
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Vous êtes sur le point de supprimer l\'élément suivant:',
                      style: TextStyle(
                        fontSize: 18,
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
                      'Cliquez sur Supprimer pour continuer',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),  // Flexible spacing between text and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                          },
                          child: Text('Annuler'),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            print('Suppression en cours...');
                            await _deleteRisque(idRisque);
                            dialogSetState(() {
                              _showSuccessAnimation = true;  // Trigger the animation
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop();  // Close the confirmation dialog after 2 seconds
                              Navigator.of(context).pop();  // Close the main dialog if necessary
                            });
                          },
                          child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: _showSuccessAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Lottie.asset(
                          'assets/animations/success.json',
                          width: 150,
                          height: 100,
                          repeat: false,
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



  // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  // PARTIE concernant les opportunités

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
                          Tooltip(
                            message: "Modifier",
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(context, opportunite, setState),
                            ),
                          ),
                          Tooltip(
                            message: "Supprimer cette opportunité",
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(context, opportunite['id_opportunite'], opportunite['libelle']),
                            ),
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
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Poids de l'opportunité : ",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                  ),
                                  TextSpan(
                                    text: "${opportunite['gravite'] ?? 'N/A'}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Fréquence : ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: "${opportunite['frequence'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Enjeu associé : ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: "${libellesEnjeux[opportunite['id']]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                              ),
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

  // Méthode pour la modification d'un enjeu
  Future<void> _updateOpportunite(int idOpportunite, String nouveauLibelle) async {
    final url = '$baseUrl/update_opportunite/$idOpportunite';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'libelle': nouveauLibelle}),
    );

    if (response.statusCode == 200) {
      print('Opportunité mise à jour avec succès : $idOpportunite');
      // Rafraîchir les données après la mise à jour
      await fetchEnjeuxEtRisquesEtOpportunites(); // Récupérer à nouveau les risques après modification
    } else {
      print('Erreur lors de la mise à jour de l\'opportunité');
    }
  }


  // Boîte de dialogue pour la modification d'une opportunité
  void _showEditDialog(BuildContext context, Map<String, dynamic> opportunite, StateSetter setState) {
    final TextEditingController _libelleController = TextEditingController(text: opportunite['libelle']);
    bool _showSuccessAnimation = false;  // Initialize the animation flag

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {  // Use StatefulBuilder for local dialog state management
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400,
                height: 350,  // Adjusted height for animation
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                          },
                          child: Text('Annuler'),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            print('Enregistrement en cours...');
                            await _updateOpportunite(opportunite['id_opportunite'], _libelleController.text);
                            dialogSetState(() {
                              _showSuccessAnimation = true;  // Trigger the animation
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop();  // Close the dialog after 2 seconds
                            });
                            setState(() {
                              opportunite['libelle'] = _libelleController.text;
                            });
                          },
                          child: Text('Enregistrer'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: _showSuccessAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Lottie.asset(
                          'assets/animations/success.json',
                          width: 150,
                          height: 100,
                          repeat: false,
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


  // Méthode d'ajout d'une opportunité
  Future<void> _deleteOpportunite(int idOpportunite) async {
    final url = '$baseUrl/delete_opportunite/$idOpportunite';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Opportunité supprimée avec succès : $idOpportunite');
      // Rafraîchir les données après la mise à jour
      await fetchEnjeuxEtRisquesEtOpportunites(); // Récupérer à nouveau les risques après modification
    } else {
      print('Erreur lors de la suppression de l\'opportunité');
    }
  }


  // Boîte de dialogue pour la suppression d'une opportunité
  void _showDeleteConfirmationDialog(BuildContext context, int idOpportunite, String libelle) {
    bool _showSuccessAnimation = false;  // Initialize the animation flag

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {  // Use StatefulBuilder for local dialog state management
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400,
                height: 400,  // Adjusted height for animation
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Vous êtes sur le point de supprimer l\'élément suivant:',
                      style: TextStyle(
                        fontSize: 18,
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
                      'Cliquez sur Supprimer pour continuer',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),  // Flexible spacing between text and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                          },
                          child: Text('Annuler'),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            print('Suppression en cours...');
                            await _deleteOpportunite(idOpportunite);
                            dialogSetState(() {
                              _showSuccessAnimation = true;  // Trigger the animation
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop();  // Close the confirmation dialog after 2 seconds
                              Navigator.of(context).pop();  // Close the main dialog if necessary
                            });
                          },
                          child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: _showSuccessAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Lottie.asset(
                          'assets/animations/success.json',
                          width: 150,
                          height: 100,
                          repeat: false,
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



  // Fetch enjeux

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

  //Ajout d'un risque

  Future<void> _showAddRisqueDialog(BuildContext context) async {
    final TextEditingController _libelleController = TextEditingController();
    String? _selectedGravite;
    String? _selectedFrequence;
    String? _selectedEnjeuId;
    bool _showSuccessAnimation = false;
    bool _showFieldError = false;

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
            'id': _selectedEnjeuId,
          }),
        );

        if (response.statusCode == 201) {
          print('Risque ajouté avec succès');
          _libelleController.clear();
          _selectedGravite = null;
          _selectedFrequence = null;
          _selectedEnjeuId = null;
          await fetchEnjeuxEtRisquesEtOpportunites();
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
                                        value: enjeu['id'].toString(),
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
                              await Future.delayed(Duration(seconds: 2)); // Wait for the success animation to play
                              await fetchEnjeuxEtRisquesEtOpportunites(); // Refresh the list of enjeux after successful addition
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



  // Ajout d'une opportunité

  void _showAddOpportuniteDialog(BuildContext context) async {
    final TextEditingController _libelleController = TextEditingController();
    String? _selectedEnjeuId;
    String? _selectedGravite;
    String? _selectedFrequence;
    bool _showSuccessAnimation = false;
    bool _showFieldError = false;

    Future<bool> _addOpportunite() async {
      final libelle = _libelleController.text;
      final gravite = int.tryParse(_selectedGravite ?? '');
      final frequence = double.tryParse(_selectedFrequence ?? '');

      if (libelle.isNotEmpty && _selectedEnjeuId != null && gravite != null && frequence != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/add_opportunite'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'libelle': libelle,
            'id': _selectedEnjeuId,
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
          await fetchEnjeuxEtRisquesEtOpportunites(); // Rafraîchir les données
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
                                        value: enjeu['id'].toString(),
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
        title: const Text("Risques et Opportunités"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Table(
              border: TableBorder.all(color: Colors.grey, width: 0.7),
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
                    tableCell("Enjeux", isHeader: true),
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
                            "-  ${enjeu['libelle'] ?? 'N/A'}",
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
                          final risques = _risquesParEnjeu[enjeu['id']];
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
                          final opportunites = _opportunitesParEnjeu[enjeu['id']];
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
                            "-  ${enjeu['libelle'] ?? 'N/A'}",
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
                          final risques = _risquesParEnjeu[enjeu['id']];
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
                          final opportunites = _opportunitesParEnjeu[enjeu['id']];
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
        ],
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
            Tooltip(
              message: "Ajouter un élément",
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: onPressed,
              ),
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

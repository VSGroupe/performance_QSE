import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyseDuContexte extends StatefulWidget {
  const AnalyseDuContexte({Key? key}) : super(key: key);

  @override
  State<AnalyseDuContexte> createState() => _AnalyseDuContexteState();
}

class _AnalyseDuContexteState extends State<AnalyseDuContexte> {
  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];
  Map<String, List<Map<String, dynamic>>> _risquesParEnjeu = {};
  Map<String, List<Map<String, dynamic>>> _opportunitesParEnjeu = {};

  // Créer une liste associative pour stocker les libellés avec leur id_enjeu comme clé
  Map<String, String> libellesEnjeux = {};

  @override
  void initState() {
    super.initState();
    _fetchEnjeuxEtRisquesEtOpportunites();
  }

  Future<void> _fetchEnjeuxEtRisquesEtOpportunites() async {

    // Récupérer les enjeux
    final enjeuxResponse = await http.get(Uri.parse('http://localhost:5000/enjeux'));
    // Récupérer les risques
    final risquesResponse = await http.get(Uri.parse('http://localhost:5000/risques'));
    // Récupérer les opportunités
    final opportunitesResponse = await http.get(Uri.parse('http://localhost:5000/opportunites'));

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

  // Les détails sur le risque cliqué
  void _showRisqueDetails(Map<String, dynamic> risque) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 300,  // Fixe la largeur
            height: 250, // Fixe la hauteur
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0), // Arrondir les coins
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
              children: [
                // En-tête avec couleur de fond
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.amber, // Couleur de fond de l'entête
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0), // Arrondir les coins supérieurs
                    ),
                  ),
                  child: Text(
                    risque['libelle'] ?? 'Détails du Risque',
                    style: TextStyle(
                      fontSize: 18, // Taille de police de l'entête
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Couleur du texte de l'entête
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
                      children: [
                        Text(
                          "Poids du risque: ${risque['gravite'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Fréquence: ${risque['frequence'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enjeu associé: ${libellesEnjeux[risque['id_enjeu']]}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Quitter'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Les détails sur l'opportunité cliqué
  void _showOpportuniteDetails(Map<String, dynamic> opportunite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 300,  // Fixe la largeur
            height: 250, // Fixe la hauteur
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0), // Arrondir les coins
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
              children: [
                // En-tête avec couleur de fond
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.green, // Couleur de fond de l'entête
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0), // Arrondir les coins supérieurs
                    ),
                  ),
                  child: Text(
                    opportunite['libelle'] ?? 'Détails de l\'Opportunité',
                    style: TextStyle(
                      fontSize: 18, // Taille de police de l'entête
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Couleur du texte de l'entête
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
                      children: [
                        Text(
                          "Poids de l'opportunité: ${opportunite['gravite'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Fréquence: ${opportunite['frequence'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enjeu associé: ${libellesEnjeux[opportunite['id_enjeu']]}",
                          style: TextStyle(fontSize: 16), // Taille de police du corps
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Quitter'),
                  ),
                ),
              ],
            ),
          ),
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
                    tableCell("Enjeux", isHeader: true),
                    tableCell("Risques", isHeader: true),
                    tableCell("Opportunités", isHeader: true),
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

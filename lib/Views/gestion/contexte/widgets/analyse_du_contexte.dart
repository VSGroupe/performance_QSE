import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyseDuContexte extends StatefulWidget {
  const AnalyseDuContexte({Key? key}) : super(key: key);

  @override
  State<AnalyseDuContexte> createState() => _AnalyseDuContexteState();
}

class _AnalyseDuContexteState extends State<AnalyseDuContexte> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];
  Map<int, List<Map<String, dynamic>>> _risquesParEnjeu = {};
  Map<int, List<Map<String, dynamic>>> _opportunitesParEnjeu = {};

  @override
  void initState() {
    super.initState();
    _fetchEnjeuxEtRisquesEtOpportunites();
  }

  Future<void> _fetchEnjeuxEtRisquesEtOpportunites() async {
    final enjeuxResponse = await _supabaseClient
        .from('EnjeuTable')
        .select()
        .execute();

    if (enjeuxResponse.data != null) {
      final enjeuxData = enjeuxResponse.data as List<dynamic>;
      final List<Map<String, dynamic>> enjeuxList =
      enjeuxData.map((item) => item as Map<String, dynamic>).toList();

      // Filtrer les enjeux en fonction du type
      _interneEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'interne').toList();
      _externeEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'externe').toList();

      // Récupérer les risques associés à chaque enjeu
      final risquesResponse = await _supabaseClient
          .from('Risques')
          .select()
          .execute();

      if (risquesResponse.data != null) {
        final risquesData = risquesResponse.data as List<dynamic>;
        final List<Map<String, dynamic>> risquesList =
        risquesData.map((item) => item as Map<String, dynamic>).toList();

        // Organiser les risques par id_enjeu
        for (var risque in risquesList) {
          int idEnjeu = risque['id_enjeu'];
          if (_risquesParEnjeu.containsKey(idEnjeu)) {
            _risquesParEnjeu[idEnjeu]?.add(risque);
          } else {
            _risquesParEnjeu[idEnjeu] = [risque];
          }
        }
      } else {
        print('Error fetching risks: Erreur sur la récupération du risque');
      }

      // Récupérer les opportunités associées à chaque enjeu
      final opportunitesResponse = await _supabaseClient
          .from('Opportunites')
          .select()
          .execute();

      if (opportunitesResponse.data != null) {
        final opportunitesData = opportunitesResponse.data as List<dynamic>;
        final List<Map<String, dynamic>> opportunitesList =
        opportunitesData.map((item) => item as Map<String, dynamic>).toList();

        // Organiser les opportunités par id_enjeu
        for (var opportunite in opportunitesList) {
          int idEnjeu = opportunite['id_enjeu'];
          if (_opportunitesParEnjeu.containsKey(idEnjeu)) {
            _opportunitesParEnjeu[idEnjeu]?.add(opportunite);
          } else {
            _opportunitesParEnjeu[idEnjeu] = [opportunite];
          }
        }
      } else {
        print('Error fetching opportunities: Erreur sur la récupération des opportunités');
      }

      setState(() {});
    } else {
      print('Error fetching enjeux: Erreur sur la récupération de l\'enjeu');
    }
  }

  void _showRisqueDetails(Map<String, dynamic> risque) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(risque['libelle'] ?? 'Détails du Risque'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Gravité: ${risque['gravite'] ?? 'N/A'}"),
              Text("Fréquence: ${risque['frequence'] ?? 'N/A'}"),
              Text("Enjeu associé: ${risque['id_enjeu']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Quitter'),
            ),
          ],
        );
      },
    );
  }

  void _showOpportuniteDetails(Map<String, dynamic> opportunite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(opportunite['libelle'] ?? 'Détails de l\'Opportunité'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Gravité: ${opportunite['gravite'] ?? 'N/A'}"),
              Text("Fréquence: ${opportunite['frequence'] ?? 'N/A'}"),
              Text("Enjeu associé: ${opportunite['id_enjeu']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Quitter'),
            ),
          ],
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
                                      "-  ${risque['libelle'] ?? 'N/A'}",
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
                                      "-  ${opportunite['libelle'] ?? 'N/A'}",
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
                                      "-  ${risque['libelle'] ?? 'N/A'}",
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
                                      "-  ${opportunite['libelle'] ?? 'N/A'}",
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
        padding: const EdgeInsets.all(8.0),
        color: isHeader ? Colors.grey[300] : Colors.white,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
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

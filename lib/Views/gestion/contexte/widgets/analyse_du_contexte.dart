import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

import '../../../../common.dart';


class AnalyseDuContexte extends StatefulWidget {
  const AnalyseDuContexte({Key? key}) : super(key: key);

  @override
  State<AnalyseDuContexte> createState() => _AnalyseDuContexteState();
}

class _AnalyseDuContexteState extends State<AnalyseDuContexte> {

  final TextEditingController _libelleController = TextEditingController();
  String? _selectedType;
  bool _showSuccessAnimation = false;
  bool _showFieldError = false;

  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];
  Map<int, String> libellesEnjeux = {};// Créer une liste associative pour stocker les libellés avec leur id_enjeu comme clé

  @override
  void initState() {
    super.initState();
    fetchEnjeux();
  }


  // Récupération des enjeux

  Future<void> fetchEnjeux() async {

    // Récupérer les enjeux
    final enjeuxResponse = await http.get(Uri.parse('$baseUrl/enjeux'));
    _showSuccessAnimation = false;

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

      setState(() {});
    } else {
      print('Error fetching enjeux: ${enjeuxResponse.body}');
    }
  }

  // Ajout de l'enjeu

  Future<void> addEnjeu() async {
    final libelle = _libelleController.text.trim();

    if (libelle.isNotEmpty && _selectedType != null) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/add_enjeu'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'libelle': libelle,
            'type': _selectedType,
          }),
        );

        if (response.statusCode == 201) {
          print('Enjeu ajouté avec succès');
          _libelleController.clear();
          _selectedType = null;

          setState(() {
            _showSuccessAnimation = true;
            _showFieldError = false;
          });

          // Fetch the updated list of Enjeux
          await fetchEnjeux();

        } else {
          print('Erreur lors de l\'ajout de l\'enjeu: ${response.statusCode}');
        }
      } catch (e) {
        print('Erreur réseau: $e');
      }
    } else {
      setState(() {
        _showFieldError = true;
      });
      print('Certains champs sont vides ou non sélectionnés');
    }
  }



  // Boîte de dialogue d'ajout d'enjeu
  Future<void> _showAddEnjeuDialog(BuildContext context) async {
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
                width: 500,
                height: 400,
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
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _libelleController,
                              labelText: "Nom de l'enjeu",
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
                                  .map((type) => {'type': type})
                                  .toList(),
                              itemLabel: (item) => item['type']!,
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
                            await addEnjeu();

                            if (!_showFieldError) {
                              setState(() {
                                _showSuccessAnimation = true;
                              });
                              await Future.delayed(Duration(seconds: 2)); // Wait for the success animation to play
                              await fetchEnjeux(); // Refresh the list of enjeux after successful addition
                              Navigator.of(context).pop(); // Close the dialog
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
                value: item['id_axe'] ?? item['type'] as T?,
                child: Text(itemLabel(item)),
              );
            }).toList(),
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Table(
              border: TableBorder.all(color: Colors.grey, width: 0.7),
              columnWidths: const {
                0: FixedColumnWidth(300.0),
                1: FixedColumnWidth(500.0),
              },
              children: [
                TableRow(
                  children: [
                    tableCell("Type", isHeader: true),
                    headerCellWithButton("Enjeux", () => _showAddEnjeuDialog(context)),
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
                  ],
                ),
              ],
            ),
          ),
        ],
      )

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
              message: "Ajouter un enjeu",
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
      height: 200,
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

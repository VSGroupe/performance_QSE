import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = "http://localhost:5000"; // URL de votre API Flask

  Future<List<Map<String, dynamic>>> getModifications() async {
    final response = await http.get(Uri.parse("$baseUrl/modifications_matrice_RACI"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load modifications");
    }
  }

  Future<void> saveModification(int rowIndex, int columnIndex, String cellValue) async {
    final response = await http.post(
      Uri.parse("$baseUrl/modifications_matrice_RACI"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "row_index": rowIndex,
        "column_index": columnIndex,
        "cell_value": cellValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save modification");
    }
  }

  Future<void> deleteModification(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/modifications_matrice_RACI/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete modification");
    }
  }
}

class ModificationProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> modifications = [];
  bool _isLoaded = false;
  bool _isLoading = false;

  ModificationProvider() {
    loadModifications();
  }

  Future<void> loadModifications() async {
    if (!_isLoaded && !_isLoading) {
      _isLoading = true;
      notifyListeners();
      try {
        modifications = await apiService.getModifications();
        _isLoaded = true;
      } catch (e) {
        // Handle errors if necessary
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> saveModification(int rowIndex, int columnIndex, String cellValue) async {
    await Future.delayed(Duration(seconds: 1)); // Délai de 1 seconde
    await apiService.saveModification(rowIndex, columnIndex, cellValue);
    await refreshModifications();
  }


  Future<void> deleteModification(String id) async {
    await Future.delayed(Duration(seconds: 1)); // Délai de 1 seconde
    await apiService.deleteModification(id);
    await refreshModifications();
  }


  Future<void> refreshModifications() async {
    modifications = await apiService.getModifications();
    notifyListeners(); // Notifier les auditeurs pour mettre à jour les vues
  }

  String? getCellValue(int rowIndex, int columnIndex) {
    final modification = modifications.firstWhere(
          (mod) => mod['row_index'] == rowIndex && mod['column_index'] == columnIndex,
      orElse: () => {},
    );
    return modification['cell_value'];
  }

  String getIdForCell(int rowIndex, int columnIndex) {
    final modification = modifications.firstWhere(
          (mod) => mod['row_index'] == rowIndex && mod['column_index'] == columnIndex,
      orElse: () => {'id': ''},
    );
    return modification['id'] ?? '';
  }
}


class ResponsabilitesEtAutorites extends StatefulWidget {
  @override
  _ResponsabilitesEtAutoritesState createState() => _ResponsabilitesEtAutoritesState();
}

class _ResponsabilitesEtAutoritesState extends State<ResponsabilitesEtAutorites> {
  late List<List<TextEditingController>> _controllers;
  late List<List<FocusNode>> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
          (i) => List.generate(
        15,
            (j) => TextEditingController(),
      ),
    );

    _focusNodes = List.generate(
      3,
          (i) => List.generate(
        15,
            (j) => FocusNode(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  Future<void> _initializeControllers() async {
    final provider = Provider.of<ModificationProvider>(context, listen: false);

    // Charger les modifications avec un délai
    await Future.wait([
      provider.loadModifications(),
      Future.delayed(Duration(seconds: 2)), // Délai de 2 secondes
    ]);

    setState(() {
      // Effacer les contrôleurs existants
      for (var row in _controllers) {
        for (var controller in row) {
          controller.dispose();
        }
      }

      // Réinitialiser les contrôleurs avec les valeurs mises à jour
      _controllers = List.generate(
        3, // Nombre de lignes, ajustez selon votre structure
            (i) => List.generate(
          15, // Nombre de colonnes
              (j) {
            final cellValue = provider.getCellValue(i, j);
            return TextEditingController(text: cellValue ?? '');
          },
        ),
      );
    });
  }



  @override
  void dispose() {
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    for (var row in _focusNodes) {
      for (var focusNode in row) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsabilités et Autorités'),
      ),
      body: provider._isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FixedColumnWidth(250.0),
                1: FixedColumnWidth(120.0),
                2: FixedColumnWidth(120.0),
                3: FixedColumnWidth(120.0),
                4: FixedColumnWidth(120.0),
                5: FixedColumnWidth(120.0),
                6: FixedColumnWidth(120.0),
                7: FixedColumnWidth(120.0),
                8: FixedColumnWidth(120.0),
                9: FixedColumnWidth(120.0),
                10: FixedColumnWidth(120.0),
                11: FixedColumnWidth(120.0),
                12: FixedColumnWidth(120.0),
                13: FixedColumnWidth(120.0),
                14: FixedColumnWidth(120.0),
              },
              children: [
                // Header Row
                TableRow(
                  children: [
                    tableCell('ACTIVITES', isHeader: true),
                    tableCell('Chef de département C&GR', isHeader: true),
                    tableCell('Chargé Qualité', isHeader: true),
                    tableCell('DT', isHeader: true),
                    tableCell('Chef de service MIT', isHeader: true),
                    tableCell('Chef de service MI', isHeader: true),
                    tableCell('Chargé Electrotech', isHeader: true),
                    tableCell('Chef de service Etude et projet', isHeader: true),
                    tableCell('Responsable RH', isHeader: true),
                    tableCell('Responsable Comm', isHeader: true),
                    tableCell('Chargé Achat', isHeader: true),
                    tableCell('Chargé électroméca.', isHeader: true),
                    tableCell('Chargé Matériel et Logistique', isHeader: true),
                    tableCell('Chargé Audit et Méthodes', isHeader: true),
                    tableCell('DG/ DGA', isHeader: true),
                  ],
                ),
                // Dynamically create rows with data from the controllers
                ..._controllers.asMap().entries.map((rowEntry) {
                  final rowIndex = rowEntry.key;
                  final row = rowEntry.value;
                  return tableRow(row, rowIndex);
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableCell tableCell(String text, {bool isHeader = false}) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: isHeader ? 16.0 : 14.0,
            ),
          ),
        ),
      ),
    );
  }

  TableRow tableRow(List<TextEditingController> row, int rowIndex) {
    return TableRow(
      children: row.asMap().entries.map((cellEntry) {
        final columnIndex = cellEntry.key;
        final controller = cellEntry.value;
        final focusNode = _focusNodes[rowIndex][columnIndex];
        final letter = controller.text.isNotEmpty ? controller.text : ' '; // Get the text for color

        final color = _getColorForLetter(letter);

        return TableCell(
          child: Container(
            color: color.withOpacity(0.2),
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
              ),
              onFieldSubmitted: (value) async {
                final provider = Provider.of<ModificationProvider>(context, listen: false);

                if (value.isEmpty) {
                  // Suppression si le champ est vide
                  final id = provider.getIdForCell(rowIndex, columnIndex);
                  if (id.isNotEmpty) {
                    await provider.deleteModification(id);
                  }
                } else {
                  // Enregistrement de la modification
                  await provider.saveModification(rowIndex, columnIndex, value);
                }

                setState(() {
                  // Update the controller text and color based on the new value
                  controller.text = value;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForLetter(String letter) {
    switch (letter) {
      case 'R':
        return Colors.red;
      case 'A':
        return Colors.green;
      case 'C':
        return Colors.blue;
      case 'I':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}




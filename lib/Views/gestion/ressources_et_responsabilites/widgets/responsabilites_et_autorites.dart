import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = "http://localhost:5000"; // URL de l'API Flask

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

  Future<void> addRow(int rowIndex, List<String> rowData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ajout_ligne_matrice_RACI"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "row_number": rowIndex,
        "row_data": rowData,
      }),
    );

    if (response.statusCode != 201) {
      print("Echec de l'ajout");
      throw Exception("Failed to add row");
    }
    else if(response.statusCode == 201){
      print("Ajout réussi");
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
    await Future.delayed(Duration(seconds: 1)); // Délai de 1 seconde important
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
  int _rowCount = 14; // Nombre initial de lignes
  final ScrollController _firstColumnScrollController = ScrollController();
  final ScrollController _otherColumnsScrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _addScrollListeners();
    _controllers = List.generate(
      _rowCount,
          (i) => List.generate(
        18,
            (j) => TextEditingController(),
      ),
    );

    _focusNodes = List.generate(
      _rowCount,
          (i) => List.generate(
        18,
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
      Future.delayed(Duration(seconds: 2)), // Délai de 2 secondes Très importante
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
        _rowCount, // Nombre de lignes, ajustez selon votre structure
            (i) => List.generate(
          18, // Nombre de colonnes
              (j) {
            final cellValue = provider.getCellValue(i, j);
            return TextEditingController(text: cellValue ?? '');
          },
        ),
      );
    });
  }

  void _addScrollListeners() {
    _firstColumnScrollController.addListener(() {
      _syncVerticalScroll(_firstColumnScrollController, _otherColumnsScrollController);
    });

    _otherColumnsScrollController.addListener(() {
      _syncVerticalScroll(_otherColumnsScrollController, _firstColumnScrollController);
    });
  }

  void _syncVerticalScroll(ScrollController source, ScrollController target) {
    if (source.hasClients && target.hasClients) {
      target.jumpTo(source.offset);
    }
  }


  Future<void> _addNewRow() async {
    final provider = Provider.of<ModificationProvider>(context, listen: false);

    // Créer une nouvelle ligne avec des contrôleurs et des focus nodes
    List<TextEditingController> newControllers = List.generate(19, (j) => TextEditingController());
    List<FocusNode> newFocusNodes = List.generate(19, (j) => FocusNode());

    // Ajouter la nouvelle ligne à l'interface utilisateur
    setState(() {
      _rowCount++;
      _controllers.add(newControllers);
      _focusNodes.add(newFocusNodes);
    });

    try {
      // Capturer les valeurs des contrôleurs pour la nouvelle ligne
      List<String> newRowData = newControllers.map((controller) => controller.text).toList();

      // Envoyer les données de la nouvelle ligne à l'API pour les stocker dans la base de données
      await provider.apiService.addRow(_rowCount, newRowData);

      // Recharger les modifications depuis l'API pour inclure la nouvelle ligne
      await provider.refreshModifications();
    } catch (e) {
      // Gérer les erreurs
      print("Error adding new row: $e");
    }
  }



  @override
  void dispose() {
    _firstColumnScrollController.dispose();
    _otherColumnsScrollController.dispose();
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
      body: provider._isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Menu déroulant avec couleur de fond amber
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: ExpansionTile(
              title: Tooltip(
                message: 'LEGENDE',
                child: Container(
                  // color: Colors.blue,
                  padding: const EdgeInsets.all(5.0),
                  child: const Text(
                    'LEGENDE',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              initiallyExpanded: true, // Dérouler automatiquement au chargement
              children: [
                const SizedBox(height: 0), // Espace entre le titre et le tableau
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.990),
                    1: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(), // Ajout de bordures au tableau
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle, // Alignement vertical
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'R',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center, // Alignement horizontal
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Responsable (Celui qui réalise l\'activité)',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Approbateur (Celui qui approuve l\'activité)',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Consulté (Celui qui est consulté)',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'I',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Informé (Celui qui doit être informé)',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Text(
            "Responsabilités et autorités",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )
          ),
          SizedBox(height: 5,),
          // Contenu principal
          Expanded(
            child: Row(
              children: [
                // Première colonne fixe
                Column(
                  children: [
                    // Table pour l'en-tête (non scrollable)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FixedColumnWidth(400.0),
                        },
                        children: [
                          TableRow(
                            children: [
                              tableCell('ACTIVITES\n', isHeader: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Table avec les données qui peuvent défiler verticalement
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _firstColumnScrollController,
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Table(
                            border: TableBorder.all(color: Colors.black),
                            columnWidths: const {
                              0: FixedColumnWidth(400.0),
                            },
                            children: [
                              // Les données pour la première colonne
                              for (var i = 0; i < _rowCount; i++)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: _buildEditableCell(i, 0, provider),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                // Autres colonnes défilables horizontalement et verticalement
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        // En-tête des colonnes (fixe en vertical mais scrollable en horizontal)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.black),
                              columnWidths: const {
                                0: FixedColumnWidth(150.0),
                                1: FixedColumnWidth(150.0),
                                2: FixedColumnWidth(150.0),
                                3: FixedColumnWidth(150.0),
                                4: FixedColumnWidth(150.0),
                                5: FixedColumnWidth(150.0),
                                6: FixedColumnWidth(150.0),
                                7: FixedColumnWidth(150.0),
                                8: FixedColumnWidth(150.0),
                                9: FixedColumnWidth(150.0),
                                10: FixedColumnWidth(150.0),
                                11: FixedColumnWidth(150.0),
                                12: FixedColumnWidth(150.0),
                                13: FixedColumnWidth(50.0),
                                14: FixedColumnWidth(150.0),
                                15: FixedColumnWidth(150.0),
                                16: FixedColumnWidth(150.0),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    tableCell('Chef de département C&GR', isHeader: true),
                                    tableCell('Responsable Qualité', isHeader: true),
                                    tableCell('Directeur Technique', isHeader: true),
                                    tableCell('Responsable maintenance', isHeader: true),
                                    tableCell('Responsable production', isHeader: true),
                                    tableCell('Chargé Electrotechnique', isHeader: true),
                                    tableCell('Chef de service Etude et projet', isHeader: true),
                                    tableCell('Responsable RH', isHeader: true),
                                    tableCell('Responsable Communication', isHeader: true),
                                    tableCell('Responsable Achat', isHeader: true),
                                    tableCell('Responsable électromécanique.', isHeader: true),
                                    tableCell('Responsable Logistique', isHeader: true),
                                    tableCell('DG/DGA', isHeader: true),
                                    tableCell('', isHeader: true),
                                    tableCell('DELAI', isHeader: true),
                                    tableCell('TAUX DE REALISATION', isHeader: true),
                                    tableCell('OBSERVATION', isHeader: true),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Table scrollable verticalement et horizontalement pour les données
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _otherColumnsScrollController,
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Table(
                                  border: TableBorder.all(color: Colors.black),
                                  columnWidths: const {
                                    0: FixedColumnWidth(150.0),
                                    1: FixedColumnWidth(150.0),
                                    2: FixedColumnWidth(150.0),
                                    3: FixedColumnWidth(150.0),
                                    4: FixedColumnWidth(150.0),
                                    5: FixedColumnWidth(150.0),
                                    6: FixedColumnWidth(150.0),
                                    7: FixedColumnWidth(150.0),
                                    8: FixedColumnWidth(150.0),
                                    9: FixedColumnWidth(150.0),
                                    10: FixedColumnWidth(150.0),
                                    11: FixedColumnWidth(150.0),
                                    12: FixedColumnWidth(150.0),
                                    13: FixedColumnWidth(50.0),
                                    14: FixedColumnWidth(150.0),
                                    15: FixedColumnWidth(150.0),
                                    16: FixedColumnWidth(150.0),
                                  },
                                  children: [
                                    // Lignes de données
                                    for (var i = 0; i < _rowCount; i++)
                                      TableRow(
                                        children: [
                                          for (var j = 1; j < 18; j++)
                                            TableCell(
                                              child: _buildEditableCell(i, j, provider),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }


  Widget _buildEditableCell(int rowIndex, int columnIndex, ModificationProvider provider) {
    final controller = _controllers[rowIndex][columnIndex];
    final focusNode = _focusNodes[rowIndex][columnIndex];

    return Container(
      color: _getColorForLetter(controller.text), // Set the background color based on the cell value
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: const InputDecoration(border: InputBorder.none),
        textAlign: TextAlign.center,
        onSubmitted: (value) async {
          final provider = Provider.of<ModificationProvider>(context, listen: false);
          final id = provider.getIdForCell(rowIndex, columnIndex);

          if (value.isEmpty && id.isNotEmpty) {
            await provider.deleteModification(id);
          } else if (value.isNotEmpty) {
            await provider.saveModification(rowIndex, columnIndex, value);
          }

          // Met à jour la couleur de fond après la soumission
          setState(() {});
        },
      ),
    );
  }

  Color _getColorForLetter(String letter) {
    switch (letter.toUpperCase()) {
      case 'R':
        return Colors.green.shade100; // VerRot pour "R"
      case 'A':
        return Colors.red.shade100; // Rouge pour "A"
      case 'C':
        return Colors.blue.shade100; // Bleu pour "C"
      case 'I':
        return Colors.yellow.shade100; // Jaune pour "I"
      case '':
        return Colors.white; // Jaune pour "I"
      default:
        return Colors.grey.shade200; // Transparent pour les autres valeurs
    }
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}

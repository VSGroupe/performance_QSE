import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExclusionsEtJustifications extends StatefulWidget {
  const ExclusionsEtJustifications({Key? key}) : super(key: key);

  @override
  State<ExclusionsEtJustifications> createState() => _ExclusionsEtJustificationsState();
}

class _ExclusionsEtJustificationsState extends State<ExclusionsEtJustifications> {

  final String baseUrl = "http://localhost:5000"; // URL de votre API Flask

  final _textControllerExclusionDomaine = TextEditingController();
  final _textControllerExclusionPerimetre = TextEditingController();
  final _focusNodeExclusionDomaine = FocusNode();
  final _focusNodeExclusionPerimetre = FocusNode();
  bool _isEditingExclusionDomaine = false;
  bool _isEditingExclusionPerimetre = false;
  int? _existingIdExclusionDomaine;
  int? _existingIdExclusionPerimetre;

  Future<void> _fetchTextExclusionDomaineFromAPI() async {
    final response = await http.get(Uri.parse('$baseUrl/get-text-exclusions-domaines'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingIdExclusionDomaine = data['id'];
        _textControllerExclusionDomaine.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 1');
    }
  }

  Future<void> _fetchTextExclusionPerimetreFromAPI() async {
    final response = await http.get(Uri.parse('$baseUrl/get-text-exclusions-perimetres'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingIdExclusionPerimetre = data['id'];
        _textControllerExclusionPerimetre.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 2');
    }
  }

  Future<void> _saveTextExclusionDomaineToAPI(String newText) async {
    if (_existingIdExclusionDomaine == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/update-text-exclusions-domaines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingIdExclusionDomaine, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 1');
    }
  }

  Future<void> _saveTextExclusionPerimetreToAPI(String newText) async {
    if (_existingIdExclusionPerimetre == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/update-text-exclusions-perimetres'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingIdExclusionPerimetre, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 2');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTextExclusionDomaineFromAPI();
    _fetchTextExclusionPerimetreFromAPI();

    _focusNodeExclusionDomaine.addListener(() {
      if (!_focusNodeExclusionDomaine.hasFocus) {
        _saveTextExclusionDomaineToAPI(_textControllerExclusionDomaine.text);
      }
    });

    _focusNodeExclusionPerimetre.addListener(() {
      if (!_focusNodeExclusionPerimetre.hasFocus) {
        _saveTextExclusionPerimetreToAPI(_textControllerExclusionPerimetre.text);
      }
    });
  }

  @override
  void dispose() {
    _textControllerExclusionDomaine.dispose();
    _textControllerExclusionPerimetre.dispose();
    _focusNodeExclusionDomaine.dispose();
    _focusNodeExclusionPerimetre.dispose();
    super.dispose();
  }

  Widget buildCadre(
      String title,
      TextEditingController controller,
      FocusNode focusNode,
      bool isEditing,
      VoidCallback onEditPressed,
      ) {
    return Container(
      width: 500,
      height: 520,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.blueGrey.shade300,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: onEditPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: isEditing
                  ? TextFormField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 18,
                ),
              )
                  : Align(
                alignment: Alignment.topLeft,
                child: Text(
                  controller.text,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCadre(
            'Exclusions et justifications sur le domaine',
            _textControllerExclusionDomaine,
            _focusNodeExclusionDomaine,
            _isEditingExclusionDomaine,
                () {
              setState(() {
                _isEditingExclusionDomaine = !_isEditingExclusionDomaine;
                if (!_isEditingExclusionDomaine) {
                  _saveTextExclusionDomaineToAPI(_textControllerExclusionDomaine.text);
                }
              });
            },
          ),
          buildCadre(
            'Exclusions et justifications sur le périmètre',
            _textControllerExclusionPerimetre,
            _focusNodeExclusionPerimetre,
            _isEditingExclusionPerimetre,
                () {
              setState(() {
                _isEditingExclusionPerimetre = !_isEditingExclusionPerimetre;
                if (!_isEditingExclusionPerimetre) {
                  _saveTextExclusionPerimetreToAPI(_textControllerExclusionPerimetre.text);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

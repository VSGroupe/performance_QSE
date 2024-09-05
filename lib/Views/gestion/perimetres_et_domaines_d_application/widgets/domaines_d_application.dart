import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DomainesDApplication extends StatefulWidget {
  const DomainesDApplication({Key? key}) : super(key: key);

  @override
  State<DomainesDApplication> createState() => _DomainesDApplicationState();
}

class _DomainesDApplicationState extends State<DomainesDApplication> {

  final String baseUrl = "http://localhost:5000"; // URL de votre API Flask

  final _textDomainesController = TextEditingController();
  final _textPerimetresController = TextEditingController();
  final _focusNodeDomaines = FocusNode();
  final _focusNodePerimetres = FocusNode();
  bool _isEditingDomaines = false;
  bool _isEditingPerimetres = false;
  int? _existingIdDomaines;
  int? _existingIdPerimetres;

  Future<void> _fetchTextDomainesFromAPI() async {
    final response = await http.get(Uri.parse('$baseUrl/get-text-domaines'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingIdDomaines = data['id'];
        _textDomainesController.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 1');
    }
  }

  Future<void> _fetchTextPerimetresFromAPI() async {
    final response = await http.get(Uri.parse('$baseUrl/get-text-perimetres'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingIdPerimetres = data['id'];
        _textPerimetresController.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 2');
    }
  }

  Future<void> _saveTextDomainesToAPI(String newText) async {
    if (_existingIdDomaines == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/update-text-domaines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingIdDomaines, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 1');
    }
  }

  Future<void> _saveTextPerimetresToAPI(String newText) async {
    if (_existingIdPerimetres == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/update-text-perimetres'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingIdPerimetres, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 2');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTextDomainesFromAPI();
    _fetchTextPerimetresFromAPI();

    _focusNodeDomaines.addListener(() {
      if (!_focusNodeDomaines.hasFocus) {
        _saveTextDomainesToAPI(_textDomainesController.text);
      }
    });

    _focusNodePerimetres.addListener(() {
      if (!_focusNodePerimetres.hasFocus) {
        _saveTextPerimetresToAPI(_textPerimetresController.text);
      }
    });
  }

  @override
  void dispose() {
    _textDomainesController.dispose();
    _textPerimetresController.dispose();
    _focusNodeDomaines.dispose();
    _focusNodePerimetres.dispose();
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
            'Domaines',
            _textDomainesController,
            _focusNodeDomaines,
            _isEditingDomaines,
                () {
              setState(() {
                _isEditingDomaines = !_isEditingDomaines;
                if (!_isEditingDomaines) {
                  _saveTextDomainesToAPI(_textDomainesController.text);
                }
              });
            },
          ),
          buildCadre(
            'Périmètres',
            _textPerimetresController,
            _focusNodePerimetres,
            _isEditingPerimetres,
                () {
              setState(() {
                _isEditingPerimetres = !_isEditingPerimetres;
                if (!_isEditingPerimetres) {
                  _saveTextPerimetresToAPI(_textPerimetresController.text);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

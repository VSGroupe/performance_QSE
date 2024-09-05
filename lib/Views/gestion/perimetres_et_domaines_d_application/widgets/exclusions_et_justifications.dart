import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExclusionsEtJustifications extends StatefulWidget {
  const ExclusionsEtJustifications({Key? key}) : super(key: key);

  @override
  State<ExclusionsEtJustifications> createState() => _ExclusionsEtJustificationsState();
}

class _ExclusionsEtJustificationsState extends State<ExclusionsEtJustifications> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  bool _isEditing1 = false;
  bool _isEditing2 = false;
  int? _existingId1;
  int? _existingId2;

  Future<void> _fetchTextFromAPI1() async {
    final response = await http.get(Uri.parse('http://localhost:5000/get-text-exclusions-domaines'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingId1 = data['id'];
        _textController1.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 1');
    }
  }

  Future<void> _fetchTextFromAPI2() async {
    final response = await http.get(Uri.parse('http://localhost:5000/get-text-exclusions-perimetres'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingId2 = data['id'];
        _textController2.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text for cadre 2');
    }
  }

  Future<void> _saveTextToAPI1(String newText) async {
    if (_existingId1 == null) return;

    final response = await http.post(
      Uri.parse('http://localhost:5000/update-text-exclusions-domaines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingId1, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 1');
    }
  }

  Future<void> _saveTextToAPI2(String newText) async {
    if (_existingId2 == null) return;

    final response = await http.post(
      Uri.parse('http://localhost:5000/update-text-exclusions-perimetres'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingId2, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text for cadre 2');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTextFromAPI1();
    _fetchTextFromAPI2();

    _focusNode1.addListener(() {
      if (!_focusNode1.hasFocus) {
        _saveTextToAPI1(_textController1.text);
      }
    });

    _focusNode2.addListener(() {
      if (!_focusNode2.hasFocus) {
        _saveTextToAPI2(_textController2.text);
      }
    });
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
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
            'Environnement de l\'entreprise 1',
            _textController1,
            _focusNode1,
            _isEditing1,
                () {
              setState(() {
                _isEditing1 = !_isEditing1;
                if (!_isEditing1) {
                  _saveTextToAPI1(_textController1.text);
                }
              });
            },
          ),
          buildCadre(
            'Environnement de l\'entreprise 2',
            _textController2,
            _focusNode2,
            _isEditing2,
                () {
              setState(() {
                _isEditing2 = !_isEditing2;
                if (!_isEditing2) {
                  _saveTextToAPI2(_textController2.text);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

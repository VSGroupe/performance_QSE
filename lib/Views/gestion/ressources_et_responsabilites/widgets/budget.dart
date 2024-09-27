import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../common.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isEditing = false;
  int? _existingId;

  Future<void> _fetchTextBudgetFromAPI() async {
    final response = await http.get(Uri.parse('$baseUrl/get-text-budgets'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingId = data['id'];
        _textController.text = data['libelle'];
      });
    } else {
      throw Exception('Failed to load text');
    }
  }

  Future<void> _saveTextBudgetToAPI(String newText) async {
    if (_existingId == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/update-text-budgets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': _existingId, 'libelle': newText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save text');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTextBudgetFromAPI();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveTextBudgetToAPI(_textController.text);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700,
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
                  const Text(
                    'Renseignement des différents budgets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.check : Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                        if (!_isEditing) {
                          _saveTextBudgetToAPI(_textController.text);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: _isEditing
                    ? TextFormField(
                  controller: _textController,
                  focusNode: _focusNode,
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
                    _textController.text,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

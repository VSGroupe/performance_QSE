import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Assurez-vous d'ajouter lottie dans vos dépendances pubspec.yaml
import 'package:http/http.dart' as http;
import 'dart:convert';


class Ajouter extends StatefulWidget {
  const Ajouter({Key? key}) : super(key: key);

  @override
  State<Ajouter> createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
  final TextEditingController nomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showSuccessAnimation = false;
  int? selectedGraviteImpact;
  String titre = "Gravité de son impact sur une échelle de 5";

  Future<void> ajouterAspectEnvironnemental() async {
    if (_formKey.currentState!.validate()) {
      const url = 'http://localhost:5000/ajouter_aspect_environnemental';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'libelle': nomController.text,
          'gravite_impact': selectedGraviteImpact,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _showSuccessAnimation = true;
        });
        // Clear fields after successful submission
        nomController.clear();
        setState(() {
          selectedGraviteImpact = null;
        });

        // Reset _showSuccessAnimation after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showSuccessAnimation = false;
          });
        });
      } else {
        // Handle error (show a Snackbar, dialog, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Renseignez ces champs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de l\'aspect environnemental)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom de l\'aspect environnemental';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CustomDropdown(
                        items: [
                          {'label': '1', 'value': 1},
                          {'label': '2', 'value': 2},
                          {'label': '3', 'value': 3},
                          {'label': '4', 'value': 4},
                          {'label': '5', 'value': 5},
                        ],
                        selectedValue: selectedGraviteImpact,
                        onChanged: (value) {
                          setState(() {
                            selectedGraviteImpact = value!;
                          });
                        },
                        dropdownTitle: 'Gravité de son impact sur une échelle de 5',
                        dropdownWidth: 250.0,
                        dropdownHeight: 225.0,
                        dropdownOffsetX: 10.0,
                        dropdownOffsetY: 50.0,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: ajouterAspectEnvironnemental,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        ),
                        child: const Text('Ajouter'),
                      ),
                      if (_showSuccessAnimation)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Lottie.asset(
                            'assets/animations/success.json', // Assurez-vous d'avoir ce fichier d'animation
                            width: 200,
                            height: 150,
                            repeat: false,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    super.dispose();
  }
}



class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;
  final String dropdownTitle;
  final double dropdownWidth;
  final double dropdownHeight;
  final double dropdownOffsetX;
  final double dropdownOffsetY;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.dropdownTitle = '',
    this.dropdownWidth = 200.0,
    this.dropdownHeight = 200.0,
    this.dropdownOffsetX = 0.0,
    this.dropdownOffsetY = 0.0,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  int? selectedValue;
  bool isDropdownOpened = false;
  OverlayEntry? floatingDropdown;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  void toggleDropdown() {
    if (isDropdownOpened) {
      _closeDropdown();
    } else {
      floatingDropdown = _createFloatingDropdown();
      Overlay.of(context).insert(floatingDropdown!);
      isDropdownOpened = true;
    }
  }

  void _closeDropdown() {
    floatingDropdown?.remove();
    isDropdownOpened = false;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: _closeDropdown,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                width: widget.dropdownWidth,
                left: MediaQuery.of(context).size.width * 0.325 + widget.dropdownOffsetX,
                top: MediaQuery.of(context).size.height * 0.53 + widget.dropdownOffsetY,
                child: Material(
                  elevation: 5,
                  child: Container(
                    height: widget.dropdownHeight,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          color: Colors.grey[200],
                          child: Text(
                            widget.dropdownTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: widget.items
                                .map((item) => ListTile(
                              title: Text(item['label']),
                              onTap: () {
                                setState(() {
                                  selectedValue = item['value'];
                                  widget.onChanged(selectedValue);
                                  _closeDropdown();
                                });
                              },
                            ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue != null
                ? widget.items.firstWhere((item) => item['value'] == selectedValue)['label']
                : widget.dropdownTitle),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../widgets/customtext.dart';
import 'fleche_dangers_et_incidents.dart'; // Importation du fichier fleche.dart

const double defaultPadding = 16.0;

class Dangers extends StatefulWidget {
  const Dangers({Key? key}) : super(key: key);

  @override
  State<Dangers> createState() => _DangersState();
}

class _DangersState extends State<Dangers> {
  late Future<List<Map<String, dynamic>>> dangersFuture;

  @override
  void initState() {
    super.initState();
    dangersFuture = fetchDangers();
  }

  Future<List<Map<String, dynamic>>> fetchDangers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/get_dangers'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la récupération des données');
    }
  }

  Future<void> updateDanger(int id, String newName) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/update_danger/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'libelle': newName}),
    );

    if (response.statusCode == 200) {
      print('Mise à jour réussie : ${response.body}');
    } else {
      print('Erreur : ${response.body}');
      throw Exception('Erreur lors de la mise à jour du danger');
    }
  }

  Future<void> deleteDanger(int id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:5000/delete_danger/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du danger');
    }
  }

  void _showEditDialog(Map<String, dynamic> danger) {
    final TextEditingController _controller = TextEditingController(text: danger['libelle']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier l\'urgence'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'urgence',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await updateDanger(danger['id_alea'], _controller.text);
                setState(() {
                  dangersFuture = fetchDangers();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer cette urgence ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue sans supprimer
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteDanger(id);
                setState(() {
                  dangersFuture = fetchDangers();
                });
                Navigator.of(context).pop(); // Ferme la boîte de dialogue après suppression
              },
              child: const Text('Oui, supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          // Flèche dessinée à gauche
          CustomPaint(
            size: const Size(20, double.infinity),
            painter: ArrowPainter(), // Utilisation de ArrowPainter importé
          ),
          const SizedBox(width: 10), // Espace entre la flèche et la liste
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Les dangers',
                  size: 20,
                  weight: FontWeight.bold,
                  color: Color(0xFFF6871A),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: dangersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Aucune urgence trouvée.'));
                      } else {
                        final dangers = snapshot.data!;

                        return ListView.builder(
                          itemCount: dangers.length,
                          itemBuilder: (context, index) {
                            final danger = dangers[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text: danger['libelle'],
                                          size: 15,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditDialog(danger),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => _showDeleteConfirmationDialog(danger['id_alea']),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  late Future<List<Map<String, dynamic>>> urgencesFuture;

  @override
  void initState() {
    super.initState();
    urgencesFuture = fetchDangers();
  }

  Future<List<Map<String, dynamic>>> fetchDangers() async {
    final response = await Supabase.instance.client
        .from('Aleas')
        .select()
        .gt('poids_incident_danger', 5) // Condition sur poids_incident_danger
        .order('poids_incident_danger', ascending: false)
        .order('libelle', ascending: true)
        .execute();


    if (response.data == null) {
      throw Exception('Erreur lors de la récupération des données : ${response.data!.message}');
    }

    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> updateDanger(int id, String newName) async {
    final response = await Supabase.instance.client
        .from('Aleas')
        .update({'libelle': newName})
        .eq('id_alea', id)
        .execute();
  }

  Future<void> deleteDanger(int id) async {
    final response = await Supabase.instance.client
        .from('Aleas')
        .delete()
        .eq('id_alea', id)
        .execute();
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
                  urgencesFuture = fetchDangers();
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
                  urgencesFuture = fetchDangers();
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
                    future: urgencesFuture,
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

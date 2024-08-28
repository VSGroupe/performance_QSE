import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../../../widgets/customtext.dart';
import 'fleche.dart'; // Importation du fichier fleche.dart

const double defaultPadding = 16.0;

class ApercuSituationsDUrgence extends StatefulWidget {
  const ApercuSituationsDUrgence({Key? key}) : super(key: key);

  @override
  State<ApercuSituationsDUrgence> createState() => _ApercuSituationsDUrgenceState();
}

class _ApercuSituationsDUrgenceState extends State<ApercuSituationsDUrgence> {
  late Future<List<Map<String, dynamic>>> urgencesFuture;

  @override
  void initState() {
    super.initState();
    urgencesFuture = fetchUrgences();
  }

  Future<List<Map<String, dynamic>>> fetchUrgences() async {
    final response = await Supabase.instance.client
        .from('Urgences')
        .select()
        .order('poids_urgence', ascending: false)
        .order('nom_urgence', ascending: true)
        .execute();

    if (response.data == null) {
      throw Exception('Erreur lors de la récupération des données : ${response.data!.message}');
    }

    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> updateUrgence(int id, String newName) async {
    final response = await Supabase.instance.client
        .from('Urgences')
        .update({'nom_urgence': newName})
        .eq('id', id)
        .execute();
  }

  Future<void> deleteUrgence(int id) async {
    final response = await Supabase.instance.client
        .from('Urgences')
        .delete()
        .eq('id', id)
        .execute();
  }


  void _showEditDialog(Map<String, dynamic> urgence) {
    final TextEditingController _controller = TextEditingController(text: urgence['nom_urgence']);

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
                await updateUrgence(urgence['id'], _controller.text);
                setState(() {
                  urgencesFuture = fetchUrgences();
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
                await deleteUrgence(id);
                setState(() {
                  urgencesFuture = fetchUrgences();
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
                  text: 'Les urgences',
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
                        final urgences = snapshot.data!;

                        return ListView.builder(
                          itemCount: urgences.length,
                          itemBuilder: (context, index) {
                            final urgence = urgences[index];

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
                                          text: urgence['nom_urgence'],
                                          size: 15,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditDialog(urgence),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => _showDeleteConfirmationDialog(urgence['id']),
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

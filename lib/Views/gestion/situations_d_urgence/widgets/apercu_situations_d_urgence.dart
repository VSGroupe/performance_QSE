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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: 350.0, // Largeur fixe de la boîte de dialogue
            height: 200.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Modifier l\'urgence',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'urgence',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0), // Espacement entre le champ de texte et les boutons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Ferme la boîte de dialogue sans sauvegarder
                        },
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 8.0), // Espacement entre les boutons
                      ElevatedButton(
                        onPressed: () async {
                          await updateUrgence(urgence['id'], _controller.text);
                          setState(() {
                            urgencesFuture = fetchUrgences();
                          });
                          Navigator.of(context).pop(); // Ferme la boîte de dialogue après sauvegarde
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Couleur du texte et du fond du bouton
                          minimumSize: const Size(100, 45), // Taille minimale du bouton
                        ),
                        child: const Text('Sauvegarder'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: 350.0,  // Largeur souhaitée
            height: 200.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Confirmer la suppression',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Voulez-vous vraiment supprimer cette urgence ?',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left, // Aligner le texte à gauche
                  ),
                ),
                const SizedBox(height: 70.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajoute du padding horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Ferme la boîte de dialogue sans supprimer
                        },
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 8.0), // Espacement entre les boutons
                      ElevatedButton(
                        onPressed: () async {
                          await deleteUrgence(id);
                          setState(() {
                            urgencesFuture = fetchUrgences();
                          });
                          Navigator.of(context).pop(); // Ferme la boîte de dialogue après suppression
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.red, // Couleur du texte blanc
                          minimumSize: const Size(90, 40), // Taille minimale du bouton
                        ),
                        child: const Text('Oui, supprimer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

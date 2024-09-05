import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../widgets/customtext.dart';
import 'fleche_impacts.dart'; // Importation du fichier fleche.dart

const double defaultPadding = 16.0;

class ImpactsSocietaux extends StatefulWidget {
  const ImpactsSocietaux({Key? key}) : super(key: key);

  @override
  State<ImpactsSocietaux> createState() => _ImpactsSocietauxState();
}

class _ImpactsSocietauxState extends State<ImpactsSocietaux> {

  final String baseUrl = "http://localhost:5000"; // URL de l'API Flask

  late Future<List<Map<String, dynamic>>> impactsSocietauxFuture;

  @override
  void initState() {
    super.initState();
    impactsSocietauxFuture = fetchImpactsSocietaux();
  }

  Future<List<Map<String, dynamic>>> fetchImpactsSocietaux() async {
    final response = await http.get(Uri.parse('$baseUrl/get_impacts_societaux'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la récupération des données');
    }
  }

  Future<void> updateImpactSocietal(int id, String newName) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update_impact/$id'),
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

  Future<void> deleteImpactSocietal(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete_impact/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du danger');
    }
  }

  void _showEditDialog(Map<String, dynamic> danger) {
    final TextEditingController _controller = TextEditingController(text: danger['libelle']);

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
                    'Modifier le nom de l\'impact',
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
                      labelText: 'Nom de l\'impact',
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
                          await updateImpactSocietal(danger['id_impact'], _controller.text);
                          setState(() {
                            impactsSocietauxFuture = fetchImpactsSocietaux();
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
            width: 350.0, // Largeur souhaitée
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
                    'Voulez-vous vraiment supprimer l\'élément ?',
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
                          await deleteImpactSocietal(id);
                          setState(() {
                            impactsSocietauxFuture = fetchImpactsSocietaux();
                          });
                          Navigator.of(context).pop(); // Ferme la boîte de dialogue après suppression
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.red, // Couleur du texte blanc
                          minimumSize: const Size(100, 45), // Taille minimale du bouton
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
                  text: 'Les impacts sociétaux',
                  size: 20,
                  weight: FontWeight.bold,
                  color: Color(0xFFF6871A),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: impactsSocietauxFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Aucune urgence trouvée.'));
                      } else {
                        final impactsSocietaux = snapshot.data!;

                        return ListView.builder(
                          itemCount: impactsSocietaux.length,
                          itemBuilder: (context, index) {
                            final impactSocietal = impactsSocietaux[index];

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
                                          text: impactSocietal['libelle'],
                                          size: 15,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditDialog(impactSocietal),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => _showDeleteConfirmationDialog(impactSocietal['id_impact']),
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

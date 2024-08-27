import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../widgets/customtext.dart';

const double defaultPadding = 16.0;
const String apiUrl = 'http://127.0.0.1:5000/urgences'; // Remplacez par l'URL de votre API

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
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Erreur lors de la récupération des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: defaultPadding, bottom: defaultPadding),
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
                    elevation: 3,
                    child: ListTile(
                      title: CustomText(
                        text: urgence['nom_urgence'],
                        size: 15,
                      ),
                      subtitle: Text(
                        'Poids: ${urgence['poids_urgence']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

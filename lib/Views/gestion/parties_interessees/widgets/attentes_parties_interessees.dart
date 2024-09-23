import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttentesPartiesInteressees extends StatefulWidget {
  const AttentesPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<AttentesPartiesInteressees> createState() => _AttentesPartiesInteresseesState();
}

class _AttentesPartiesInteresseesState extends State<AttentesPartiesInteressees> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchPartiesInteressees() async {
    final response = await supabase
        .from('PartiesInteressees')
        .select('*, Attentes(*)') // Fetch related Attentes
        .execute();

    if (response.data == null) {
      return []; // Return an empty list if no data is available
    }

    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attentes des Parties Intéressées'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPartiesInteressees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée disponible'));
          }

          final partiesInteressees = snapshot.data!;

          // Group parties by category
          final Map<String, List<Map<String, dynamic>>> categorizedParties = {};
          for (var partie in partiesInteressees) {
            final category = partie['categorie'];
            categorizedParties.putIfAbsent(category, () => []).add(partie);
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: categorizedParties.entries.map((entry) {
              final category = entry.key;
              final parties = entry.value;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  children: parties.map<Widget>((partie) {
                    final attentes = partie['Attentes'] as List<dynamic>? ?? [];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              partie['libelle'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            leading: Icon(Icons.business, color: Colors.teal),
                          ),
                          if (attentes.isNotEmpty)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Attentes')),
                                  DataColumn(label: Text('Type d\'attente')),
                                  DataColumn(label: Text('Mode de réponse')),
                                ],
                                rows: attentes.map<DataRow>((attente) {
                                  return DataRow(cells: [
                                    DataCell(Text(attente['libelle'] ?? '')),
                                    DataCell(Text(attente['type_attente'] ?? '')),
                                    DataCell(Text(attente['mode_reponse'] ?? '')),
                                  ]);
                                }).toList(),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Aucune attente disponible',
                                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

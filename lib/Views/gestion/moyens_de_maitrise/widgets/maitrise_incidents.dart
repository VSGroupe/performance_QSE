import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaitriseIncidents extends StatefulWidget {
  const MaitriseIncidents({Key? key}) : super(key: key);

  @override
  State<MaitriseIncidents> createState() => _MaitriseIncidentsState();
}

class _MaitriseIncidentsState extends State<MaitriseIncidents> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> danger_et_incidentData = [];
  final Map<int, TextEditingController> _maitriseControllers = {};
  final Map<int, bool> _isEditing = {};

  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchDangersEtIncidents();
  }

  Future<void> fetchDangersEtIncidents() async {
    setState(() {
      isLoading = true;
    });

    final response = await supabase
        .from('Aleas')
        .select('*, MaitriseAleas(maitrise)')
        .order('libelle', ascending: true)
        .execute();

    if (response.data != null) {
      danger_et_incidentData = List<Map<String, dynamic>>.from(response.data);
      for (var alea in danger_et_incidentData) {
        final maitrise = alea['MaitriseAleas'].isNotEmpty
            ? alea['MaitriseAleas'][0]['maitrise']
            : '';
        _maitriseControllers[alea['id_alea'] as int] = TextEditingController(text: maitrise);
        _isEditing[alea['id_alea'] as int] = false;
      }
    }

    setState(() {
      isLoading = false;
    });
  }



  Future<void> addOrUpdateMaitrise(int aleaId) async {
    final maitrise = _maitriseControllers[aleaId]?.text ?? '';
    if (maitrise.isNotEmpty) {
      final responseMaitrises = await supabase
          .from('MaitriseAleas')
          .select()
          .eq('id_alea', aleaId)
          .execute();

      if (responseMaitrises.data != null && responseMaitrises.data.isNotEmpty) {
        await supabase
            .from('MaitriseAleas')
            .update({'maitrise': maitrise})
            .eq('id_alea', aleaId)
            .execute();
      } else {
        await supabase.from('MaitriseAleas').insert({
          'id_alea': aleaId,
          'maitrise': maitrise,
        }).execute();
      }
      setState(() {
        _isEditing[aleaId] = false; // Stop editing mode
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Maîtrise des Dangers et Incidents'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Affiche le spinner pendant le chargement
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // En-tête fixe
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      color: Colors.red.shade100,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Dangers et Incidents',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.green.shade200,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Maîtrise des dangers et incidents',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Contenu défilant du tableau
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    for (var alea in danger_et_incidentData)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              alea['libelle'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_isEditing[alea['id_alea'] as int] == true)
                                      Container(
                                        height: 150,
                                        child: TextField(
                                          controller: _maitriseControllers[alea['id_alea'] as int],
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            labelText: 'Ajouter Maîtrise',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        constraints: const BoxConstraints(minHeight: 35, maxHeight: 100, minWidth: 800),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _maitriseControllers[alea['id_alea'] as int]?.text ?? 'Aucune maîtrise ajoutée',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // Icone pour éditer
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      _isEditing[alea['id_alea'] as int] == true ? Icons.save : Icons.edit,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      if (_isEditing[alea['id_alea'] as int] == true) {
                                        addOrUpdateMaitrise(alea['id_alea'] as int);
                                      } else {
                                        setState(() {
                                          _isEditing[alea['id_alea'] as int] = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

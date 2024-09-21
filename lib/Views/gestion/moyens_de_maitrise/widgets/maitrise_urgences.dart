import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaitriseUrgences extends StatefulWidget {
  const MaitriseUrgences({Key? key}) : super(key: key);

  @override
  State<MaitriseUrgences> createState() => _MaitriseUrgencesState();
}

class _MaitriseUrgencesState extends State<MaitriseUrgences> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> urgenceData = [];
  final Map<int, TextEditingController> _maitriseControllers = {};
  final Map<int, bool> _isEditing = {};

  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchUrgences();
  }

  Future<void> fetchUrgences() async {
    setState(() {
      isLoading = true;
    });

    final response = await supabase
        .from('Urgences')
        .select('*, MaitriseUrgences(maitrise)')
        .order('nom_urgence', ascending: true)
        .execute();

    if (response.data != null) {
      urgenceData = List<Map<String, dynamic>>.from(response.data);
      for (var urgence in urgenceData) {
        final maitrise = urgence['MaitriseUrgences'].isNotEmpty
            ? urgence['MaitriseUrgences'][0]['maitrise']
            : '';
        _maitriseControllers[urgence['id'] as int] = TextEditingController(text: maitrise);
        _isEditing[urgence['id'] as int] = false;
      }
    }

    setState(() {
      isLoading = false;
    });
  }



  Future<void> addOrUpdateMaitrise(int urgenceId) async {
    final maitrise = _maitriseControllers[urgenceId]?.text ?? '';
    if (maitrise.isNotEmpty) {
      final responseMaitrises = await supabase
          .from('MaitriseUrgences')
          .select()
          .eq('id', urgenceId)
          .execute();

      if (responseMaitrises.data != null && responseMaitrises.data.isNotEmpty) {
        await supabase
            .from('MaitriseUrgences')
            .update({'maitrise': maitrise})
            .eq('id', urgenceId)
            .execute();
      } else {
        await supabase.from('MaitriseUrgences').insert({
          'id': urgenceId,
          'maitrise': maitrise,
        }).execute();
      }
      setState(() {
        _isEditing[urgenceId] = false; // Stop editing mode
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Maîtrise des Urgences'),
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
                      color: Colors.amber.shade100,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Urgences',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.green.shade200,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Maîtrise des Urgences',
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
                    for (var urgence in urgenceData)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              urgence['nom_urgence'],
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
                                    if (_isEditing[urgence['id'] as int] == true)
                                      Container(
                                        height: 150,
                                        child: TextField(
                                          controller: _maitriseControllers[urgence['id'] as int],
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            labelText: 'Ajouter une matrise',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        constraints: const BoxConstraints(minHeight: 35, maxHeight: 100, minWidth: 800),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _maitriseControllers[urgence['id'] as int]?.text ?? 'Aucune urgence ajoutée',
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
                                      _isEditing[urgence['id'] as int] == true ? Icons.save : Icons.edit,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      if (_isEditing[urgence['id'] as int] == true) {
                                        addOrUpdateMaitrise(urgence['id'] as int);
                                      } else {
                                        setState(() {
                                          _isEditing[urgence['id'] as int] = true;
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

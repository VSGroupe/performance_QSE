import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaitriseRisques extends StatefulWidget {
  const MaitriseRisques({Key? key}) : super(key: key);

  @override
  State<MaitriseRisques> createState() => _MaitriseRisquesState();
}

class _MaitriseRisquesState extends State<MaitriseRisques> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> risquesData = [];
  final Map<int, TextEditingController> _maitriseControllers = {};
  final Map<int, bool> _isEditing = {};

  @override
  void initState() {
    super.initState();
    fetchRisques();
  }

  Future<void> fetchRisques() async {
    final responseRisques = await supabase.from('Risques').select().execute();
    if (responseRisques.data != null) {
      risquesData = List<Map<String, dynamic>>.from(responseRisques.data);
      for (var risque in risquesData) {
        final responseMaitrises = await supabase
            .from('MoyensMaitrise')
            .select()
            .eq('id_risque', risque['id_risque'])
            .execute();

        String maitrise = (responseMaitrises.data != null && responseMaitrises.data.isNotEmpty)
            ? responseMaitrises.data[0]['maitrise']
            : '';
        _maitriseControllers[risque['id_risque'] as int] = TextEditingController(text: maitrise);
        _isEditing[risque['id_risque'] as int] = false;
      }
      setState(() {});
    }
  }

  Future<void> addOrUpdateMaitrise(int risqueId) async {
    final maitrise = _maitriseControllers[risqueId]?.text ?? '';
    if (maitrise.isNotEmpty) {
      final responseMaitrises = await supabase
          .from('MoyensMaitrise')
          .select()
          .eq('id_risque', risqueId)
          .execute();

      if (responseMaitrises.data != null && responseMaitrises.data.isNotEmpty) {
        await supabase
            .from('MoyensMaitrise')
            .update({'maitrise': maitrise})
            .eq('id_risque', risqueId)
            .execute();
      } else {
        await supabase.from('MoyensMaitrise').insert({
          'id_risque': risqueId,
          'maitrise': maitrise,
        }).execute();
      }
      setState(() {
        _isEditing[risqueId] = false; // Stop editing mode
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau des Risques et Maîtrises'),
      ),
      body: Padding(
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
                      color: Colors.amber.shade300,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Risques',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.green.shade300,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Maîtrise Risques',
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
                    for (var risque in risquesData)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              risque['libelle'],
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
                                    if (_isEditing[risque['id_risque'] as int] == true)
                                      Container(
                                        height: 150,
                                        child: TextField(
                                          controller: _maitriseControllers[risque['id_risque'] as int],
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            labelText: 'Ajouter Maîtrise',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        constraints: const BoxConstraints(minHeight: 35, maxHeight: 100),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _maitriseControllers[risque['id_risque'] as int]?.text ?? 'Aucune maîtrise ajoutée',
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
                                      _isEditing[risque['id_risque'] as int] == true ? Icons.save : Icons.edit,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      if (_isEditing[risque['id_risque'] as int] == true) {
                                        addOrUpdateMaitrise(risque['id_risque'] as int);
                                      } else {
                                        setState(() {
                                          _isEditing[risque['id_risque'] as int] = true;
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

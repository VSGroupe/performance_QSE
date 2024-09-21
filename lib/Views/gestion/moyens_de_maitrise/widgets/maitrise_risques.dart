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

  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchRisques();
  }

  Future<void> fetchRisques() async {
    setState(() {
      isLoading = true;
    });

    final response = await supabase
        .from('Risques')
        .select('*, MoyensMaitrise(maitrise)')
        .order('libelle', ascending: true)
        .execute();

    if (response.data != null) {
      risquesData = List<Map<String, dynamic>>.from(response.data);
      for (var risque in risquesData) {
        final maitrise = risque['MoyensMaitrise'].isNotEmpty
            ? risque['MoyensMaitrise'][0]['maitrise']
            : '';
        _maitriseControllers[risque['id_risque'] as int] = TextEditingController(text: maitrise);
        _isEditing[risque['id_risque'] as int] = false;
      }
    }

    setState(() {
      isLoading = false;
    });
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
        title: const Text('Tableau de Maîtrise des Risques'),
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
                      color: Colors.red.shade50,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Risques',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.green.shade200,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Maîtrise des risques',
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
                                        constraints: const BoxConstraints(minHeight: 35, maxHeight: 100, minWidth: 800),
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

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaitriseIes extends StatefulWidget {
  const MaitriseIes({Key? key}) : super(key: key);

  @override
  State<MaitriseIes> createState() => _MaitriseIesState();
}

class _MaitriseIesState extends State<MaitriseIes> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> impactData = [];
  final Map<int, TextEditingController> _maitriseControllers = {};
  final Map<int, bool> _isEditing = {};

  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchImapcts();
  }

  Future<void> fetchImapcts() async {
    setState(() {
      isLoading = true;
    });

    final response = await supabase
        .from('Impacts')
        .select('*, MaitriseImpacts(maitrise)')
        .order('libelle', ascending: true)
        .execute();

    if (response.data != null) {
      impactData = List<Map<String, dynamic>>.from(response.data);
      for (var impact in impactData) {
        final maitrise = impact['MaitriseImpacts'].isNotEmpty
            ? impact['MaitriseImpacts'][0]['maitrise']
            : '';
        _maitriseControllers[impact['id_impact'] as int] = TextEditingController(text: maitrise);
        _isEditing[impact['id_impact'] as int] = false;
      }
    }

    setState(() {
      isLoading = false;
    });
  }



  Future<void> addOrUpdateMaitrise(int impactId) async {
    final maitrise = _maitriseControllers[impactId]?.text ?? '';
    if (maitrise.isNotEmpty) {
      final responseMaitrises = await supabase
          .from('MaitriseImpacts')
          .select()
          .eq('id_impact', impactId)
          .execute();

      if (responseMaitrises.data != null && responseMaitrises.data.isNotEmpty) {
        await supabase
            .from('MaitriseImpacts')
            .update({'maitrise': maitrise})
            .eq('id_impact', impactId)
            .execute();
      } else {
        await supabase.from('MaitriseImpacts').insert({
          'id_impact': impactId,
          'maitrise': maitrise,
        }).execute();
      }
      setState(() {
        _isEditing[impactId] = false; // Stop editing mode
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Maîtrise des IES'),
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
                      color: Colors.green.shade100,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Impacts environnementaux et sociétaux',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.green.shade300,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Maîtrise des impacts environnementaux et sociétaux',
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
                    for (var impact in impactData)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              impact['libelle'],
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
                                    if (_isEditing[impact['id_impact'] as int] == true)
                                      Container(
                                        height: 150,
                                        child: TextField(
                                          controller: _maitriseControllers[impact['id_impact'] as int],
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            labelText: 'Ajouter Impact',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        constraints: const BoxConstraints(minHeight: 35, maxHeight: 100, minWidth: 800),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _maitriseControllers[impact['id_impact'] as int]?.text ?? 'Aucun impact ajouté',
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
                                      _isEditing[impact['id_impact'] as int] == true ? Icons.save : Icons.edit,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      if (_isEditing[impact['id_impact'] as int] == true) {
                                        addOrUpdateMaitrise(impact['id_impact'] as int);
                                      } else {
                                        setState(() {
                                          _isEditing[impact['id_impact'] as int] = true;
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

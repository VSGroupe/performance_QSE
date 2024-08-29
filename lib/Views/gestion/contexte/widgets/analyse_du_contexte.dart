import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyseDuContexte extends StatefulWidget {
  const AnalyseDuContexte({Key? key}) : super(key: key);

  @override
  State<AnalyseDuContexte> createState() => _AnalyseDuContexteState();
}

class _AnalyseDuContexteState extends State<AnalyseDuContexte> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> _interneEnjeux = [];
  List<Map<String, dynamic>> _externeEnjeux = [];

  @override
  void initState() {
    super.initState();
    _fetchEnjeux();
  }

  Future<void> _fetchEnjeux() async {
    final response = await _supabaseClient
        .from('EnjeuTable')
        .select()
        .execute();

    if (response.data != null) {
      final data = response.data as List<dynamic>;
      final List<Map<String, dynamic>> enjeuxList =
      data.map((item) => item as Map<String, dynamic>).toList();

      setState(() {
        _interneEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'interne').toList();
        _externeEnjeux = enjeuxList.where((item) => item['type_enjeu'] == 'externe').toList();
      });
    } else {
      print('Error fetching enjeux: ${response.data?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyse du Contexte"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            // width: 600, // largeur fixe du tableau
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FixedColumnWidth(350.0),
                2: FixedColumnWidth(350.0),
                3: FixedColumnWidth(350.0),
              },
              children: [
                TableRow(
                  children: [
                    tableCell("Type", isHeader: true),
                    tableCell("Enjeux", isHeader: true),
                    tableCell("Risques", isHeader: true),
                    tableCell("Opportunités", isHeader: true),
                  ],
                ),
                TableRow(
                  children: [
                    tableCell("Interne", isHeader: true, rowSpan: 3),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _interneEnjeux
                            .map((enjeu) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "-  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: enjeu['libelle'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const TextSpan(text: "\n"),
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(Text("")),
                    scrollableTableCell(Text("")),
                  ],
                ),
                TableRow(
                  children: [
                    tableCell("Externe", isHeader: true, rowSpan: 3),
                    scrollableTableCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _externeEnjeux
                            .map((enjeu) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "-  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: enjeu['libelle'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const TextSpan(text: "\n"),
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    scrollableTableCell(Text("")),
                    scrollableTableCell(Text("")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableCell(String text, {bool isHeader = false, int rowSpan = 1}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: isHeader ? 18 : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget scrollableTableCell(Widget child) {
    return SizedBox(
      height: 200, // hauteur fixe de chaque cellule
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResponsabilitesEtAutorites extends StatefulWidget {
  const ResponsabilitesEtAutorites({Key? key}) : super(key: key);

  @override
  State<ResponsabilitesEtAutorites> createState() => _ResponsabilitesEtAutoritesState();
}

class _ResponsabilitesEtAutoritesState extends State<ResponsabilitesEtAutorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsabilités et Autorités'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FixedColumnWidth(100.0),
                2: FixedColumnWidth(100.0),
                3: FixedColumnWidth(100.0),
                // Add other column widths as needed
              },
              children: [
                TableRow(
                  children: [
                    tableCell('ACTIVITES'),
                    tableCell('Chef de département C&GR'),
                    tableCell('Chargé Qualité'),
                    tableCell('DT'),
                    // Add other headers as needed
                  ],
                ),
                // Add table rows for each activity
                tableRow(['Mettre en place le Smé', 'A', 'R', 'I']),
                tableRow(['Assurer le bon fonctionnement du Smé', 'R', 'C', 'C']),
                tableRow(['Former les acteurs clés', 'A', 'R', 'I']),
                // Continue for all other activities...
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow tableRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) => tableCell(cell)).toList(),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}

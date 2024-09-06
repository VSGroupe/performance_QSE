import 'package:flutter/material.dart';

class ModifierInfosPartiesInteressees extends StatefulWidget {
  const ModifierInfosPartiesInteressees({Key? key}) : super(key: key);

  @override
  State<ModifierInfosPartiesInteressees> createState() => _ModifierInfosPartiesInteresseesState();
}

class _ModifierInfosPartiesInteresseesState extends State<ModifierInfosPartiesInteressees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            dataRowColor: MaterialStateColor.resolveWith(
                  (states) => states.contains(MaterialState.selected) ? Colors.blueGrey.shade50 : Colors.white,
            ),
            dataRowHeight: 60.0,
            columnSpacing: 24.0,
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1.0),
              verticalInside: BorderSide(color: Colors.grey.shade300, width: 1.0),
              top: BorderSide(color: Colors.grey.shade500, width: 2.0),
              bottom: BorderSide(color: Colors.grey.shade500, width: 2.0),
            ),
            columns: const [
              DataColumn(
                label: Text('Parties intéressées'),
              ),
              DataColumn(
                label: Text('Catégories'),
              ),
              DataColumn(
                label: Text('Attentes'),
              ),
              DataColumn(
                label: Text('Type d\'attente'),
              ),
              DataColumn(
                label: Text('Mode de réponse'),
              ),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Acme Corp')),
                DataCell(Text('Clients')),
                DataCell(Text('Livraison rapide')),
                DataCell(Text('Service')),
                DataCell(Text('Optimisation de la logistique')),
              ]),
              DataRow(cells: [
                DataCell(Text('XYZ Inc.')),
                DataCell(Text('Fournisseurs')),
                DataCell(Text('Paiement à temps')),
                DataCell(Text('Financier')),
                DataCell(Text('Respect des délais de paiement')),
              ]),
              DataRow(cells: [
                DataCell(Text('John Doe')),
                DataCell(Text('Actionnaires')),
                DataCell(Text('Retour sur investissement')),
                DataCell(Text('Économique')),
                DataCell(Text('Amélioration de la rentabilité')),
              ]),
              DataRow(cells: [
                DataCell(Text('Jane Smith')),
                DataCell(Text('Employés')),
                DataCell(Text('Conditions de travail')),
                DataCell(Text('Social')),
                DataCell(Text('Mise en place de formations')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PolitiqueQSE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique QSE'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/gestion/accueil");
          },
        ),
      ),
      body: SfPdfViewer.asset(
        'assets/pdf_Politique_QSE/planning_de_travail.pdf',
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'conditional_import.dart'
if (dart.library.html) 'web_pdf_extractor.dart';

class PolitiqueQse extends StatefulWidget {
  const PolitiqueQse({Key? key}) : super(key: key);

  @override
  _PolitiqueQseState createState() => _PolitiqueQseState();
}

class _PolitiqueQseState extends State<PolitiqueQse> {
  String _pdfText = 'Chargement...';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      registerHtmlView();
      extractPdfText((String extractedText) {
        setState(() {
          _pdfText = extractedText;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Politique QSE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/gestion/accueil");
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(_pdfText),
      ),
    );
  }
}

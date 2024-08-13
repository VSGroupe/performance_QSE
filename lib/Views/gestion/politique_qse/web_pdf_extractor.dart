import 'dart:html' as html;
import 'dart:ui' as ui;

void registerHtmlView() {
  ui.platformViewRegistry.registerViewFactory(
    'pdfExtractor',
        (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'pdf_extractor.html'
        ..style.width = '0'
        ..style.height = '0';

      iframe.onLoad.listen((event) {
        iframe.contentWindow?.postMessage({
          'type': 'extractText',
          'url': 'assets/pdf_Politique_QSE/planning_de_travail.pdf',
        }, '*');
      });

      return iframe;
    },
  );
}

void extractPdfText(Function(String) onExtracted) {
  html.window.addEventListener('message', (event) {
    final data = (event as html.MessageEvent).data;
    if (data is Map && data['type'] == 'textExtracted') {
      onExtracted(data['text']);
    }
  });
}

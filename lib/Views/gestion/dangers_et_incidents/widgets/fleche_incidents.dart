import 'package:flutter/material.dart';

class ArrowPainterIncident extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [Colors.yellow.shade900, Colors.yellow.shade500],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final arrowHeight = size.height * 0.1; // Pointe réduite à 20% de la hauteur totale

    path.moveTo(size.width / 2, 0); // Top center (pointe de la flèche)
    path.lineTo(0, arrowHeight); // Bottom left of the arrowhead
    path.lineTo(size.width, arrowHeight); // Bottom right of the arrowhead
    path.close();

    // Dessiner le corps de la flèche
    path.moveTo(size.width * 0.3, arrowHeight);
    path.lineTo(size.width * 0.3, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.lineTo(size.width * 0.7, arrowHeight);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

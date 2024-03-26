import 'package:flutter/material.dart';

class InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double width = size.width;
    final double height = size.height;

    final path = Path();
    path.moveTo(0, 0); // Top left corner

    path.lineTo(width, 0); // Top right corner
    path.lineTo(width / 2, height); // Top blunt corner
    path.lineTo(0, 0); // Top left corner
    path.close();

    final paint = Paint()..color = Colors.white;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double width = size.width;
    final double height = size.height;

    final path = Path();
    path.moveTo(0, height); // Bottom left corner

    path.lineTo(width, height); // Bottom right corner
    path.lineTo(width / 2, 0); // Top blunt corner
    path.lineTo(0, height); // Bottom left corner
    path.close();

    final paint = Paint()..color = Colors.white;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

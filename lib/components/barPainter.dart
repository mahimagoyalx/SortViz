import 'package:flutter/material.dart';

class ArrayBar extends CustomPainter {
  final double width;
  final int height;
  final int index;
  final Color sortColor;
  ArrayBar({this.width, this.height, this.index, this.sortColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.square;

    // PINK
    if (sortColor == Colors.pink) if (this.height < 500 * .10) {
      paint.color = Color(0xFFFCE4EC);
    } else if (this.height < 500 * .20) {
      paint.color = Color(0xFFF8BBD0);
    } else if (this.height < 500 * .30) {
      paint.color = Color(0xFFF48FB1);
    } else if (this.height < 500 * .40) {
      paint.color = Color(0xFFF06292);
    } else if (this.height < 500 * .50) {
      paint.color = Color(0xFFEC407A);
    } else if (this.height < 500 * .60) {
      paint.color = Color(0xFFE91E63);
    } else if (this.height < 500 * .70) {
      paint.color = Color(0xFFD81B60);
    } else if (this.height < 500 * .80) {
      paint.color = Color(0xFFC2185B);
    } else if (this.height < 500 * .90) {
      paint.color = Color(0xFFAD1457);
    } else {
      paint.color = Color(0xFF880E4F);
    }

    // TEAL
    else if (sortColor == Colors.teal) if (this.height < 500 * .10) {
      paint.color = Color(0xFFE0F2F1);
    } else if (this.height < 500 * .20) {
      paint.color = Color(0xFFB2DFDB);
    } else if (this.height < 500 * .30) {
      paint.color = Color(0xFF80CBC4);
    } else if (this.height < 500 * .40) {
      paint.color = Color(0xFF4DB6AC);
    } else if (this.height < 500 * .50) {
      paint.color = Color(0xFF26A69A);
    } else if (this.height < 500 * .60) {
      paint.color = Color(0xFF009688);
    } else if (this.height < 500 * .70) {
      paint.color = Color(0xFF00897B);
    } else if (this.height < 500 * .80) {
      paint.color = Color(0xFF00796B);
    } else if (this.height < 500 * .90) {
      paint.color = Color(0xFF00695C);
    } else {
      paint.color = Color(0xFF004D40);
    }

    // BLUE
    else if (sortColor == Colors.blue) if (this.height < 500 * .10) {
      paint.color = Color(0xFFE3F2FD);
    } else if (this.height < 500 * .20) {
      paint.color = Color(0xFFBBDEFB);
    } else if (this.height < 500 * .30) {
      paint.color = Color(0xFF90CAF9);
    } else if (this.height < 500 * .40) {
      paint.color = Color(0xFF64B5F6);
    } else if (this.height < 500 * .50) {
      paint.color = Color(0xFF42A5F5);
    } else if (this.height < 500 * .60) {
      paint.color = Color(0xFF2196F3);
    } else if (this.height < 500 * .70) {
      paint.color = Color(0xFF1E88E5);
    } else if (this.height < 500 * .80) {
      paint.color = Color(0xFF1976D2);
    } else if (this.height < 500 * .90) {
      paint.color = Color(0xFF1565C0);
    } else {
      paint.color = Color(0xFF0D47A1);
    }
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, height.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

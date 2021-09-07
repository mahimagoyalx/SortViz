import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ColorPicker {
  final Color _sortColor;
  final int _height;

  ColorPicker({required Color sortColor, required int height})
      : this._sortColor = sortColor,
        this._height = height,
        assert(sortColor != null),
        assert(height != null);

  Color get color {
    Color color = Colors.transparent;

    if (_sortColor == Colors.pink) if (this._height < 500 * .10) {
      color = Color(0xFFFCE4EC);
    } else if (this._height < 500 * .20) {
      color = Color(0xFFF8BBD0);
    } else if (this._height < 500 * .30) {
      color = Color(0xFFF48FB1);
    } else if (this._height < 500 * .40) {
      color = Color(0xFFF06292);
    } else if (this._height < 500 * .50) {
      color = Color(0xFFEC407A);
    } else if (this._height < 500 * .60) {
      color = Color(0xFFE91E63);
    } else if (this._height < 500 * .70) {
      color = Color(0xFFD81B60);
    } else if (this._height < 500 * .80) {
      color = Color(0xFFC2185B);
    } else if (this._height < 500 * .90) {
      color = Color(0xFFAD1457);
    } else {
      color = Color(0xFF880E4F);
    }

    // TEAL
    else if (_sortColor == Colors.teal) if (this._height < 500 * .10) {
      color = Color(0xFFE0F2F1);
    } else if (this._height < 500 * .20) {
      color = Color(0xFFB2DFDB);
    } else if (this._height < 500 * .30) {
      color = Color(0xFF80CBC4);
    } else if (this._height < 500 * .40) {
      color = Color(0xFF4DB6AC);
    } else if (this._height < 500 * .50) {
      color = Color(0xFF26A69A);
    } else if (this._height < 500 * .60) {
      color = Color(0xFF009688);
    } else if (this._height < 500 * .70) {
      color = Color(0xFF00897B);
    } else if (this._height < 500 * .80) {
      color = Color(0xFF00796B);
    } else if (this._height < 500 * .90) {
      color = Color(0xFF00695C);
    } else {
      color = Color(0xFF004D40);
    }

    // BLUE
    else if (_sortColor == Colors.blue) if (this._height < 500 * .10) {
      color = Color(0xFFE3F2FD);
    } else if (this._height < 500 * .20) {
      color = Color(0xFFBBDEFB);
    } else if (this._height < 500 * .30) {
      color = Color(0xFF90CAF9);
    } else if (this._height < 500 * .40) {
      color = Color(0xFF64B5F6);
    } else if (this._height < 500 * .50) {
      color = Color(0xFF42A5F5);
    } else if (this._height < 500 * .60) {
      color = Color(0xFF2196F3);
    } else if (this._height < 500 * .70) {
      color = Color(0xFF1E88E5);
    } else if (this._height < 500 * .80) {
      color = Color(0xFF1976D2);
    } else if (this._height < 500 * .90) {
      color = Color(0xFF1565C0);
    } else {
      color = Color(0xFF0D47A1);
    }

    return color;
  }
}

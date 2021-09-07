import 'package:flutter/material.dart';
import 'package:sortviz/util/color_picker.dart';

class Bar extends StatelessWidget {
  final int _height;
  final double _width;
  final ColorPicker _colorPicker;

  Bar(
      {required int index,
      required int height,
      required double width,
      required Color color,
      Key? key})
      : this._height = height,
        this._width = width,
        _colorPicker = ColorPicker(sortColor: color, height: height),
        assert(index != null),
        assert(height != null),
        assert(width != null),
        assert(color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bar = Container(
      height: _height.toDouble(),
      width: _width,
      color: _colorPicker.color,
    );
    return bar;
  }
}

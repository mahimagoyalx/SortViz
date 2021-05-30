import 'package:flutter/material.dart';
import 'package:sortviz/components/barPainter.dart';
import 'package:sortviz/utils.color_picker.dart';

class Bar extends StatelessWidget {
  final Color _color;
  final int _height;
  final double _width;
  final int _index;
  final ColorPicker _colorPicker;

  Bar(
      {@required Color color,
      @required int height,
      @required double width,
      @required int index,
      Key key})
      : this._color = color,
        this._height = height,
        this._width = width,
        this._index = index,
        _colorPicker = ColorPicker(sortColor: color, height: height),
        assert(color != null),
        assert(height != null),
        assert(width != null),
        assert(index != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bar = Container(
      height: _height.toDouble(),
      width: _width,
      color: _colorPicker.color,
    );

    return bar;

    // Todo: Although I had fixed it, I really liked your approach. So I'd like if you fix it by yourself

    return CustomPaint(
      painter: ArrayBar(
        sortColor: _color,
        width: _width,
        height: _height,
        index: _index,
      ),
    );
  }
}

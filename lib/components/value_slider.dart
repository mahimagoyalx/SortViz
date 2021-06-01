import 'package:flutter/material.dart';

class ValueSlider extends StatelessWidget {
  final String _title;
  final String _param;
  final double _value;
  final double _max;
  final double _min;
  final ValueChanged<double> _onChanged;
  final Color _backgroundColor;

  const ValueSlider({
    @required String title,
    String param,
    @required double value,
    @required double max,
    @required double min,
    @required ValueChanged<double> onChanged,
    @required Color backgroundColor,
    Key key,
  })  : this._title = title,
        this._param = param,
        this._value = value,
        this._max = max,
        this._min = min,
        this._onChanged = onChanged,
        this._backgroundColor = backgroundColor,
        assert(title != null),
        assert(value != null),
        assert(max != null),
        assert(min != null),
        assert(onChanged != null),
        assert(backgroundColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      _value.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _param != null
                        ? Text(
                            " " + _param,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Expanded(
                  child: Slider(
                    max: _max,
                    min: _min,
                    value: _value,
                    inactiveColor: Colors.white,
                    onChanged: _onChanged,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

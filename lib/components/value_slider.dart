import 'package:flutter/material.dart';

class ValueSlider extends StatelessWidget {
  final String _title;
  final String _param;
  final double _value;
  final double _max;
  final double _min;
  final ValueChanged<double> _onChanged;

  const ValueSlider({
    @required String title,
    String param,
    @required double value,
    @required double max,
    @required double min,
    @required ValueChanged<double> onChanged,
    Key key,
  })  : this._title = title,
        this._param = param,
        this._value = value,
        this._max = max,
        this._min = min,
        this._onChanged = onChanged,
        assert(title != null),
        assert(value != null),
        assert(max != null),
        assert(min != null),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                _title,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    _value.toString(),
                    style: TextStyle(
                      fontSize: 24.0,
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
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.black,
                  thumbColor: Color(0xFFEB1555),
                  overlayColor: Color(0x29EB1555),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                ),
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
    );
  }
}

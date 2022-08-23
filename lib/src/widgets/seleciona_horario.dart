import 'package:flutter/material.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;

class SelecionaHorarioDialog extends StatefulWidget {

  final String title;

  SelecionaHorarioDialog({this.title = 'Horário'});

  @override
  _SelecionaHorarioDialogState createState() => _SelecionaHorarioDialogState();
}

class _SelecionaHorarioDialogState extends State<SelecionaHorarioDialog> {
  double _hours = 0.0;
  double _minutes = 0.0;

  Widget _buildTextHour(BuildContext context) {
    int min = _minutes.floor();
    String _min = min < 10 ? '0$min' : '$min';

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${_hours.floor()}:$_min',
          style: TextStyle(fontSize: 30.0),
        ),
      ],
    );
  }

  @override
  void initState() {
    var today = DateTime.now();
    _hours = today.hour.toDouble();
    _minutes = today.minute.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.title}'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildTextHour(context),
          Slider(
            activeColor: gooexColors.primary,
            value: _hours,
            label: _hours.floor().toString(),
            divisions: 24,
            max: 23,
            min: 0,
            onChanged: (val) {
              setState(() {
                _hours = val;
              });
            },
            onChangeEnd: (v) {
              print(v.floor());
            },
          ),
          Slider(
            activeColor: gooexColors.secondary,
            value: _minutes,
            label: _minutes.floor().toString(),
            divisions: 60,
            max: 59,
            min: 0,
            onChanged: (val) {
              setState(() {
                _minutes = val;
              });
            },
            onChangeEnd: (v) {
              print(v.floor());
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'CANCELAR',
            style: TextStyle(color: gooexColors.primary),
          ),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text(
            'OK',
            style: TextStyle(color: gooexColors.primary),
          ),
          onPressed: () {
            String h = '${_hours.floor()}:';
            int min = _minutes.floor();
            String _min = min < 10 ? '0$min' : '$min';

            h += '$_min';

            Navigator.of(context).pop(h);
          },
        )
      ],
    );
  }
}

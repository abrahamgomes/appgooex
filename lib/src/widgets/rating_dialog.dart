import 'package:flutter/material.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;

enum RatingType { DELIVERY, TRANSPORT }

class RatingDialog extends StatefulWidget {
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _transportRating = 0;
  int _deliveryRating = 0;

  Widget _buildStar(int starCount, RatingType type, [int curRating = 0]) {
    return InkWell(
      child: Icon(
        Icons.star,
        size: 30.0,
        color: curRating >= starCount ? Colors.orange : gooexColors.primary,
      ),
      onTap: () {
        if (type == RatingType.DELIVERY) {
          setState(() {
            _deliveryRating = starCount;
          });
        } else {
          setState(() {
            _transportRating = starCount;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Avaliar o serviço'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Nota do ENTREGADOR:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildStar(1, RatingType.DELIVERY, _deliveryRating),
              _buildStar(2, RatingType.DELIVERY, _deliveryRating),
              _buildStar(3, RatingType.DELIVERY, _deliveryRating),
              _buildStar(4, RatingType.DELIVERY, _deliveryRating),
              _buildStar(5, RatingType.DELIVERY, _deliveryRating),
            ],
          ),

          // Divider(),
          SizedBox(height: 20,),

          Text('Nota do TRANSPORTADOR:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildStar(1, RatingType.TRANSPORT, _transportRating),
              _buildStar(2, RatingType.TRANSPORT, _transportRating),
              _buildStar(3, RatingType.TRANSPORT, _transportRating),
              _buildStar(4, RatingType.TRANSPORT, _transportRating),
              _buildStar(5, RatingType.TRANSPORT, _transportRating),
            ],
          )
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
            Navigator.of(context).pop({
              'transportador': _transportRating,
              'entregador': _deliveryRating
            });
          },
        )
      ],
    );
  }
}

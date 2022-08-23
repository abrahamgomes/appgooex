import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Consts {
  List<String> all = ['PENDENTE', 'CONFIRMADA'];
  static final df = DateFormat('dd/MM/yyyy HH:mm');
  static final nf = NumberFormat.currency(locale: 'pt-br', symbol: '');
  static final dfOnlyDate = DateFormat('dd/MM/yyyy');

  static Color getCardColor(int status) {
    switch (status) {
      case -1:
        return Colors.blue[50];
      break;

      case 0:
        return Colors.yellow[50];
        break;

      case 1:
        return Colors.green[50];
        break;

      case 2:
        return Colors.deepOrange[50];
      break;

        case 3:
        return Colors.deepPurple[50];
        break;

        case 4:
          return Colors.pink[50];
        break;

      default:
        return null;
  }
}
  static  String getStatus(int status) {
    switch (status) {
      case -1:
        return 'CRIADA';
        break;

      case 0:
        return 'CONFIRMAÇÃO PENDENTE';
        break;

      case 1:
        return 'CONFIRMADA';
        break;

      case 2:
        return 'CANCELADA';
        break;

        case 3:
        return 'RECEBIDO PELO TRANSPORTADOR';
        break;

        case 4:
          return 'ENTREGADOR PENDENTE';
        break;

        case 5:
          return 'ENTREGADOR DEFINIDO';
        break;

        case 6:
          return 'ENTREGADOR RECEBEU A ENTREGA';
        break;

        case 7:
          return 'PRODUTO ENTREGUE';
        break;

        case 8:
          return 'TRANPORTADOR PAGO';
        break;

        case 9:
          return 'FALHOU';
        break;

      default:
        return 'UNKNOW';
    }
  }
}
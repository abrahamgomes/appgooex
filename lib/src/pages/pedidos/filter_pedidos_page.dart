import 'package:flutter/material.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;

class StatusPedido {
  int code;
  String description;

  StatusPedido({this.code, this.description});
}

class FilterPedidosClientePage extends StatefulWidget {

  final String title;

  FilterPedidosClientePage({this.title = 'Filtrar Pedidos'});

  @override
  _FilterPedidosClientePageState createState() =>
      _FilterPedidosClientePageState();
}

class _FilterPedidosClientePageState extends State<FilterPedidosClientePage> {

  int dropdownValue;
  List<StatusPedido> optionsStatus = [
    StatusPedido(code: 9, description: 'TODOS'),
    StatusPedido(code: -1, description: 'CRIADO'),
    StatusPedido(code: 0, description: 'CONFIRMAÇÃO PENDENTE'),
    StatusPedido(code: 1, description: 'CONFIRMADO'),
    StatusPedido(code: 2, description: 'CANCELADO'),
    StatusPedido(code: 3, description: 'RECEBIDO PELO TRANSPORTADOR'),
    StatusPedido(code: 4, description: 'ENTREGADOR PENDENTE'),
    StatusPedido(code: 5, description: 'ENTREGADOR DEFINIDO'),
    StatusPedido(code: 6, description: 'ENTREGADOR RECEBEU A ENTREGA'),
    StatusPedido(code: 7, description: 'PRODUTO ENTREGUE'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Text(
                    '${widget.title}',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: gooexColors.primary),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Selecione o status',
                  border: OutlineInputBorder()
                ),
                value: dropdownValue,
                hint: Text('Selecione o status'),
                isExpanded: true,
                iconSize: 24,
                // elevation: 16,
                onChanged: (int newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: optionsStatus
                    .map<DropdownMenuItem<int>>((StatusPedido statusPedido) {
                  return DropdownMenuItem<int>(
                    value: statusPedido.code,
                    child: Container(
                      // padding: EdgeInsets.all(8.0),
                      child: Text(statusPedido.description),
                    ),
                  );
                }).toList(),
              ),
               SizedBox(
                height: 25,
              ),
              RaisedButton(
                color: gooexColors.primary,
                splashColor: gooexColors.primary.withOpacity(.4),
                onPressed: () {
                  Navigator.of(context).pop<int>(dropdownValue);
                },
                child: Text(
                  'PRONTO',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

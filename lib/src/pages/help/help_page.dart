import 'package:flutter/material.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: gooexColors.primary,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Text(
                    'Ajuda',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: gooexColors.primary),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ExpansionTile(
                      title: Text('Cores dos cards'),
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                  'As cores ajudam na visualização do status do seu pedido ou ordem de serviço. Abaixo há a listagem das cores e seus respectivos status'),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                alignment: WrapAlignment.spaceEvenly,
                                spacing: 10.0,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildColorLegend(Colors.blue[100], 'CRIADO'),
                                  _buildColorLegend(Colors.yellow[100], 'CONFIRMAÇÃO PENDENTE'),
                                  _buildColorLegend(Colors.green[100], 'CONFIRMADO'),
                                  _buildColorLegend(Colors.deepOrange[100], 'CANCELADO'),
                                  _buildColorLegend(Colors.deepPurple[100], 'RECEBIDO PELO TRANSPORTADOR'),
                                  _buildColorLegend(Colors.pink[100], 'ENTREGUE'),
                                
                                  
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorLegend(Color color, String text) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_buildCircle(color), Text('$text')],
      ),
    );
  }

  Widget _buildCircle(Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(
        width: .5
      )),
    );
  }
}

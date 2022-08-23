import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/viagem_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';
// import 'package:gooex_mobile/arc/colors.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }

class ListaPedidosPage extends StatefulWidget {
  final Viagem viagem;

  ListaPedidosPage({this.viagem});

  _ListaPedidosPageState createState() => _ListaPedidosPageState();
}

class _ListaPedidosPageState extends State<ListaPedidosPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  ViagemStore _viagemStore;

  @override
  void initState() {
    _viagemStore = ViagemStore();
    _viagemStore.listarPedidos(widget.viagem.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: DrawerApp(
        isTransporter: loginStore.usuario.transportador,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        await _viagemStore.listarPedidos(widget.viagem.uuid);
                      })
                ],
              ),
              Center(
                child: Text(
                  'Pedidos para esta viagem',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: gooexColors.primary),
                ),
              ),
      
              SizedBox(
                height: 25.0,
              ),
              Observer(
                builder: (_) {
                  final future = _viagemStore.pedidos;
                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      break;

                    case FutureStatus.fulfilled:
                      final List<Pedido> pedidos = future.result;

                      if (pedidos.length == 0) {
                        return Center(
                            child: Text(
                                'Não há solicitações PENDENTES para esta viagem'));
                      }

                      return Column(
                        children: pedidos.map((pedido) {
                          return CustomCard(
                            title: 'Pedido ${pedido.uuid.substring(0, 8)}',
                            rows: [
                              [
                                'Ordem de Serviço:',
                                '${pedido.ordemServico.uuid.substring(0, 8)}'
                              ],
                              [
                                'Comprimento:',
                                '${pedido.ordemServico.comprimento}cm'
                              ],
                              ['Altura:', '${pedido.ordemServico.altura}cm'],
                              ['Largura:', '${pedido.ordemServico.largura}cm'],
                              ['Peso:', '${pedido.ordemServico.peso}Kg'],
                              ['Valor:', 'R\$${Consts.nf.format(pedido.valor)}'],
                            ],
                            buttons: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                pedido.status > 0 ? Container() : Expanded(
                                  child: FlatButton(
                                    splashColor:
                                        Colors.red.withOpacity(.4),
                                      onPressed: () async {
                                        await _aceiteNoPedido(context: context, pedido: pedido, confirma: false);
                                      },
                                      child: Text('NEGAR',
                                          style: TextStyle(color: Colors.red))),
                                ),
                                pedido.status > 0 ? Container() : Expanded(
                                  child: FlatButton(
                                    splashColor:
                                        Colors.deepOrange.withOpacity(.4),
                                    onPressed: () async {
                                      await _aceiteNoPedido(context: context, pedido: pedido, confirma: true);
                                    },
                                    child: Text(
                                      'ACEITAR',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                      break;
                  }

                  return Center(
                    child: Text('Nenhuma OS ainda.'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _aceiteNoPedido({BuildContext context, Pedido pedido, bool confirma}) async {
    UtilDialog.presentLoader(context);

    String message = confirma ? 'Pedido aceito. Assim que receber o produto fotografe e envie para o cliente.' : 'Pedido negado. Você negou a solicitação.';

    try {
      await _viagemStore.aceitarPedido(
          pedido.viagem.uuid, pedido.ordemServico.uuid, confirma);
      Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: '$message',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
             
            },
            )..show();
  /*     UtilDialog.presentAlert(context,
          title: 'Sucesso',
          message:
              '$message'); */
      await _viagemStore.listarPedidos(widget.viagem.uuid);
    } on ApiResponseException catch (e) {
        Navigator.of(context).pop();
         AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc: e.message,
            btnCancelOnPress: () {},
            btnOkOnPress: () {
             
            },
            )..show();
       /*  UtilDialog.presentAlert(context, title: 'Erro', message: e.message); */
    } catch (e) {
      Navigator.of(context).pop();
      print(e.payload);
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc:'Houve um erro inesperado ao realizar a operação.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
             
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Erro',
          message: 'Houve um erro inesperado ao realizar a operação.'); */
    }
  }
}

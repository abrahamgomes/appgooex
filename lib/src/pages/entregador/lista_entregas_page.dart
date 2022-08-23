import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/ordem_servico_entregador.dart';
import 'package:gooex_mobile/src/pages/criar_ordem_servico/criar_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/detalhe_ordem_servico/detalhe_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/pagamento/pagamento_page.dart';
import 'package:gooex_mobile/src/pages/pedidos/filter_pedidos_page.dart';
import 'package:gooex_mobile/src/pages/transportadores_disponiveis/transportadores_disponiveis_page.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/entregas_store.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../colors.dart' as gooexColors;

import 'package:intl/intl.dart';

import 'envio_fotos_entrega.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }

class ListaEntregasPage extends StatefulWidget {
  _ListaEntregasPageState createState() => _ListaEntregasPageState();
}

class _ListaEntregasPageState extends State<ListaEntregasPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  final _entregaStore = EntregaStore();

  @override
  void initState() {
    _entregaStore.listarEntregasDisponiveis();
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
                  Builder(
                    builder: (context) {
                      return IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: gooexColors.primary,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                            // key.currentState.openDrawer();
                          });
                    },
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              await _entregaStore.listarEntregasDisponiveis();
                            })
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  'Entregas',
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
                  final future = _entregaStore.entregasDisponiveis;
                  switch (future.status) {

                    case FutureStatus.pending:
                      return LinearProgressIndicator();  
                    break;

                    case FutureStatus.rejected:
                      return Center(
                        child: Column(children: [
                          Text(
                              'Houve um erro ao listar as entregas disponíveis. Certifique-se de que a conexão é estável e tente novamente',
                              textAlign: TextAlign.center)
                        ]),
                      );
                      break;

                    case FutureStatus.fulfilled:
                      final entregasDisponiveis = future.value;

                      if(entregasDisponiveis.length == 0) return Center(
                        child: Text('Não há entregas disponíveis para aceite.'),
                      );

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: entregasDisponiveis.map((entrega) {
                            return CustomCard(
                              title: 'Entrega ${entrega.uuid.substring(0,8)}',
                              rows: [
                                ['Aeroporto', entrega.nomeAeroporto],
                                ['Hora de desembarque', Consts.df.format(DateTime.parse(entrega.horaDesembarque))],
                                ['Destino', '${entrega.destino}, ${entrega.municipio}'],
                                ['Peso da encomenda', '${entrega.peso}Kg'],
                              ],
                              buttons: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  entrega.status != null && entrega.status == 4 ?  Expanded(
                                    child: FlatButton(
                                      splashColor: Colors.green.withOpacity(.1),
                                      onPressed: () async {
                                        await _aceitarEntrega(context, uuidPedido: entrega.uuid);
                                      },
                                      child: Text('ACEITAR',
                                          style:
                                              TextStyle(color: Colors.green)),
                                    ),
                                  ) : Container(),
                                ],
                              ),
                            );
                          }).toList());
                      break;
                  }
                  return LinearProgressIndicator();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }


  Future<void> _aceitarEntrega(BuildContext context, {
    String uuidPedido
  }) async {
    OrdemServicoEntregador osEntregador;
    UtilDialog.presentLoader(context);
    try {
      osEntregador = await _entregaStore.aceitarEntrega(uuidPedido);
      Navigator.of(context).pop();
       AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: 'Aceite realizado na entrega. Encontre o transportador no local e horário combinados.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           _entregaStore.listarEntregasDisponiveis();
            Navigator.of(context).pop();
            },
            )..show();
     /*  UtilDialog.presentAlert(context, title: 'Sucesso', message: 'Aceite realizado na entrega. Encontre o transportador no local e horário combinados.', ok: () {
        _entregaStore.listarEntregasDisponiveis();
        Navigator.of(context).pop();
      }); */
    } on ApiResponseException catch (e) {
      Navigator.of(context).pop();
       AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro ao aceitar entrega',
            desc:  e.message != null ? e.message : 'Houve um erro ao aceitar a entrega',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           _entregaStore.listarEntregasDisponiveis();
            Navigator.of(context).pop();
            },
            )..show();
     /*  UtilDialog.presentAlert(context, title: 'Erro ao aceitar entrega', message: e.message != null ? e.message : 'Houve um erro ao aceitar a entrega'); */
    }
  }
}

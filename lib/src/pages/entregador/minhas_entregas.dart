import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/entregas_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';

import '../../../colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';

import 'envio_fotos_entrega.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }

class MinhasEntregasPage extends StatefulWidget {
  _MinhasEntregasPageState createState() => _MinhasEntregasPageState();
}

class _MinhasEntregasPageState extends State<MinhasEntregasPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  final _entregaStore = EntregaStore();

  @override
  void initState() {
    _entregaStore.listarMinhasEntregas();
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
                              await _entregaStore.listarMinhasEntregas();
                            })
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  'Minhas entregas',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: gooexColors.primary),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              // Observer(
              //   builder: (_) {
              //     int status = ordemServicoStore.statusAplicado;

              //     if (status == null)
              //       return Container(
              //         child: Text('Filtrado pelo status: TODAS'),
              //       );
              //     String statusText = Consts.getStatus(status);
              //     return Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text('Filtrado pelo status: $statusText'),
              //     );
              //   },
              // ),

              Observer(
                builder: (_) {
                  final future = _entregaStore.minhasEntregas;
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
                      final minhasEntregas = future.value;

                      if(minhasEntregas.length == 0) return Center(
                        child: Column(children: [
                          Text(
                              'Nenhuma entrega encontrada',
                              textAlign: TextAlign.center)
                        ]),
                      );

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: minhasEntregas.map((entrega) {

                            // var formattedDesembarque = entrega.horaDesembarque;
                            String formattedDesembarque = Consts.df.format(DateTime.parse(entrega.horaDesembarque));

                            return CustomCard(
                              title: 'Entrega ${entrega.uuid.substring(0,8)}',
                              rows: [
                                ['Aeroporto', entrega.nomeAeroporto],
                                ['Hora de desembarque', formattedDesembarque],
                                ['Destino', '${entrega.destino}, ${entrega.municipio}'],
                                ['Peso da encomenda', '${entrega.peso}Kg'],
                                ['Transportador', '${entrega.nomeTransportador}'],
                                ['Telefone Transportador', '${entrega.telefoneTransportador}'],
                                ['Status', '${Consts.getStatus(entrega.status)}'],
                              ],
                              buttons: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  entrega.status >= 6 ? Container() : Expanded(
                                      child: FlatButton(
                                          splashColor:
                                              Colors.red.withOpacity(.1),
                                          onPressed: () async {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        EnvioFotosEntrega(
                                                          osEntregador: entrega,
                                                        )));

                                            _entregaStore.listarMinhasEntregas();
                                          },
                                          child: Text('FOTOS',
                                              style: TextStyle(
                                                  color: Colors.orange)))
                                      // EnvioFotosEntrega
                                      ),
                                  entrega.status > 5 ? Container() :  Expanded(
                                    child: FlatButton(
                                        splashColor: Colors.red.withOpacity(.1),
                                        onPressed: () async {
                                          await _cancelarEntrega(context, uuidEntrega: entrega.uuid);
                                        },
                                        child: Text('DESISTIR',
                                            style:
                                                TextStyle(color: Colors.red))),
                                  ),
                                  entrega.status == 4 ?  Expanded(
                                    child: FlatButton(
                                      splashColor: Colors.green.withOpacity(.1),
                                      onPressed: () async {
                                        
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


  Future<void> _cancelarEntrega(BuildContext context, {
    String uuidEntrega
  }) async {
    // OrdemServicoEntregador osEntregador;
    UtilDialog.presentLoader(context);
    try {
      await _entregaStore.cancelarEntrega(uuidEntrega);
      Navigator.of(context).pop();  
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: 'Desistência da entrega confirmada.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           _entregaStore.listarMinhasEntregas();
            Navigator.of(context).pop();
            },
            )..show();
      /* UtilDialog.presentAlert(context
      , title: 'Sucesso', message: 'Desistência da entrega confirmada.', ok: () {
        _entregaStore.listarMinhasEntregas();
        Navigator.of(context).pop();
      }); */
    } on ApiResponseException catch(e) {
      Navigator.of(context).pop();  
         AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc: e.message != null ? e.message : 'Houve um erro na comunicação com o servidor.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
      /* UtilDialog.presentAlert(context
      , title: 'Erro', message: e.message != null ? e.message : 'Houve um erro na comunicação com o servidor.' );*/
    } on Exception  {
      Navigator.of(context).pop();  
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc:'Houve um erro inesperado. Certifique-se de que sua conexão está estável e tente novamente.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
   /*    UtilDialog.presentAlert(context
      , title: 'Erro', message: 'Houve um erro inesperado. Certifique-se de que sua conexão está estável e tente novamente.'); */
    }
  }
}

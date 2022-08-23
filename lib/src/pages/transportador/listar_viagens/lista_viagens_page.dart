import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/transportador/listar_viagens/lista_pedidos_page.dart';
import 'package:gooex_mobile/src/pages/transportador/registrar_viagem/registrar_viagem.dart';
import 'package:gooex_mobile/src/services/centro_distribuicao_service.dart';
import 'package:gooex_mobile/src/stores/viagem_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';
import '../../../../colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }

class ListaViagensPage extends StatefulWidget {
  _ListaViagensPageState createState() => _ListaViagensPageState();
}

class _ListaViagensPageState extends State<ListaViagensPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  ViagemStore _viagemStore;

  @override
  void initState() {
    _viagemStore = ViagemStore();
    _viagemStore.listarViagens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: DrawerApp(
        isTransporter: loginStore.usuario.transportador,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Registrar uma nova viagem',
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegistrarViagemPage()));
          await _viagemStore.listarViagens();
        },
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
                  IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        await _viagemStore.listarViagens();
                      })
                ],
              ),
              Center(
                child: Text(
                  'Viagens',
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
                  bool tudo = _viagemStore.mostrarTudo;

                  if (!tudo)
                    return Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child:
                                    Text('Mostrando apenas viagens correntes')),
                            TextButton(
                              child: Text('Mostrar tudo'),
                              onPressed: () {
                                _viagemStore.setMostrarTudo(true);
                              },
                            )
                          ]),
                    );

                  return Container(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text('Mostrando todas as viagens')),
                          TextButton(
                            child: Text('Mostrar menos'),
                            onPressed: () {
                              _viagemStore.setMostrarTudo(false);
                            },
                          )
                        ]),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  final future = _viagemStore.viagens;
                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      break;

                    case FutureStatus.fulfilled:
                      final List<Viagem> viagens = future.result;
                      List<Viagem> filtered;
                      if (_viagemStore.mostrarTudo) {
                        filtered = viagens;
                      } else {
                        filtered = viagens
                            .where((element) =>
                                DateTime.parse(element.dataChegada)
                                    .compareTo(DateTime.now()) >=
                                0)
                            .toList();
                        // filtered = viagens.where((element) => DateTime.parse(element.dataChegada).compareTo(DateTime(2020, 8, 1, 10, 59, 59)) >= 0).toList();

                      }

                      if (filtered.length == 0) {
                        return Center(child: Text('Nenhuma Viagem ainda'));
                      }

                      final DateTime today = DateTime.now();

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: filtered.map((viagem) {
                            final _dataChegada = DateTime.parse(viagem.dataChegada);
                            final _dataPartida = DateTime.parse(viagem.dataPartida);
                            String dataPartida = Consts.df
                                .format(_dataPartida);
                            String dataChegada = Consts.df
                                .format(_dataChegada);

                            var difference = _dataPartida.difference(today);
                            bool notificaUsuarios = difference.inHours <= 32 && difference.inHours > 0;

                            return CustomCard(
                              title: 'Viagem ${viagem.uuid.substring(0, 8)}',
                              rows: [
                                ['CEP de origem', '${viagem.cepOrigem}'],
                                ['CEP de destino', '${viagem.cepDestino}'],
                                ['Saindo em', '$dataChegada'],
                                ['Chegando em', '$dataPartida'],
                                ['Bagagem Livre', '${viagem.bagagemLivre} Kg']
                              ],
                              buttons: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: TextButton(
                                      
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ListaPedidosPage(
                                                      viagem: viagem,
                                                    )));
                                      },
                                      child: Text(
                                        'VER PEDIDOS',
                                        style:
                                            TextStyle(color: Colors.deepOrange),
                                      ),
                                    ),
                                  ),

                                  !notificaUsuarios ? Container() : Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        var service = CentroDistribuicaoService();
                                        UtilDialog.presentLoader(context);
                                        try {
                                          await service.notificarEntregadores();
                                          Navigator.of(context).pop();
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.SUCCES,
                                                  animType: AnimType.BOTTOMSLIDE,
                                                  title: 'Sucesso',
                                                  desc: 'Os entregadores foram notificados de sua chegada',
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () {
                                                
                                                  },
                                                  )..show();
                                          /* UtilDialog.presentAlert(context, 
                                            title: 'Sucesso', 
                                            message: 'Os entregadores foram notificados de sua chegada'
                                          ); */
                                        } on Exception {
                                          Navigator.of(context).pop();
                                           AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.ERROR,
                                                  animType: AnimType.BOTTOMSLIDE,
                                                  title: 'Erro',
                                                  desc: 'Houve um erro ao cofirmar o desembarque.',
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () {
                                                
                                                  },
                                                  )..show();
                                         /*  UtilDialog.presentAlert(context, 
                                            title: 'Erro', 
                                            message: 'Houve um erro ao cofirmar o desembarque.'
                                          ); */
                                        }
                                        service = null;
                                      },
                                      child: Text(
                                        'CONFIRMAR DESEMBARQUE',
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: gooexColors.primary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList());
                      // return _buildSolicitationList(context, ordensServico);
                      break;
                  }

                  return Center(
                    child: Text('Nenhuma viagem aqui.'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

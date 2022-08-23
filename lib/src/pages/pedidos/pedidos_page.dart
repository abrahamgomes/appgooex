import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/pedidos/filter_pedidos_page.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/stores/pedido_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:gooex_mobile/src/widgets/rating_dialog.dart';
import 'package:gooex_mobile/src/widgets/upload_foto.dart';
import 'package:mobx/mobx.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';

class PedidosPage extends StatefulWidget {
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  PedidoStore _pedidoStore;
  OrdemServicoStore _ordemServicoStore;

  @override
  void initState() {
    _pedidoStore = PedidoStore();
    _pedidoStore.listarPedidosCliente(status: null);
    _pedidoStore.setStatusAplicado(null);
    _ordemServicoStore = OrdemServicoStore();

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
                            icon: Icon(Icons.filter_list),
                            onPressed: () async {
                              int status = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (_) => FilterPedidosClientePage()
                                ));
                              status = status == 9 ? null : status;
                              _pedidoStore.setStatusAplicado(status);
                              await _pedidoStore.listarPedidosCliente(status: status);
                            }),

                            IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        await _pedidoStore.listarPedidosCliente(status: _pedidoStore.statusAplicado);
                      })
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  'Pedidos',
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
                  int status = _pedidoStore.statusAplicado;

                  if(status == null) return Container(
                    child: Text('Filtrado pelo status: TODOS'),
                  );
                  String statusText = Consts.getStatus(status);
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Filtrado pelo status: $statusText'),
                  );
                },
              ),
              SizedBox(height: 20,),
              Observer(
                builder: (_) {
                  final future = _pedidoStore.pedidosCliente;
                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      return Text('Houve um erro');
                      break;

                    case FutureStatus.fulfilled:
                      final List<Pedido> pedidos = future.result;

                      if (pedidos.length == 0) {
                        return Center(
                          child: Text('Nenhum pedido encontrado. Verifique se os filtros estão de acordo.'),
                        );
                      }

                      return Column(
                        children: pedidos.map((pedido) {
                          final inicioEm = Consts.df.format(
                              DateTime.parse(pedido.viagem.dataChegada));
                          final terminoEm = Consts.df.format(
                              DateTime.parse(pedido.viagem.dataPartida));
                          return CustomCard(
                            color: Consts.getCardColor(pedido.status),
                            title: 'Pedido ${pedido.uuid.substring(0, 8)}',
                            rows: [
                              ['Status:', '${Consts.getStatus(pedido.status)}'],
                              [
                                'Ordem de Serviço do cliente:',
                                '${pedido.ordemServico.uuid.substring(0, 8)}'
                              ],
                              [
                                'Viagem do transportador:',
                                '${pedido.viagem.uuid.substring(0, 8)}'
                              ],
                              ['Início em:', '$inicioEm'],
                              ['Término em:', '$terminoEm'],
                              ['Valor:', '${pedido.valor}'],
                            ],
                            buttons: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                pedido.status < 3 || pedido.status == 4
                                    ? Container()
                                    : Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            _ratingDialog(context, pedido);
                                          },
                                          child: Text(
                                            'AVALIAR',
                                            style: TextStyle(
                                                color: gooexColors.primary),
                                          ),
                                        ),
                                      ),
                                pedido.status < 3 ? Container() :  Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => UploadFoto(
                                                  ordemServico:
                                                      pedido.ordemServico,
                                                  isCustomer: true)));
                                    },
                                    child: Text(
                                      'FOTOS',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );

                      return Text('Hello world');
                      // return _buildSolicitationList(context, ordensServico);
                      break;
                  }

                  return Center(
                    child: Text('Nenhum pedido ainda.'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ratingDialog(BuildContext context, Pedido pedido) async {
    Map<String, int> starCount =
        await showDialog(context: context, builder: (c) => RatingDialog());
    print(starCount);
    if (starCount == null) return;

    UtilDialog.presentLoader(context);
    try {
      await _ordemServicoStore.avaliarServico(
          pedido.ordemServico.uuid,
          notaEntregador: starCount['entregador'],
          notaTransportador: starCount['transportador'],
          comentarioTransportador: '',
          comentarioEntregador: ''
      );
      Navigator.of(context).pop();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: 'Avaliação registrada.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
     
    } catch (e) {
      Navigator.of(context).pop();
      
       AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Falha na operação',
            desc: 'Não foi possível avaliar. Certifique-se de que selecionou o pedido correto e tente novamente.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {      
            },
            )..show();
     
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/pedidos/filter_pedidos_page.dart';
import 'package:gooex_mobile/src/stores/pedido_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:gooex_mobile/src/widgets/upload_foto.dart';
import 'package:mobx/mobx.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;

import 'package:intl/intl.dart';

class PedidosTransportadorPage extends StatefulWidget {
  _PedidosTransportadorPageState createState() =>
      _PedidosTransportadorPageState();
}

class _PedidosTransportadorPageState extends State<PedidosTransportadorPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  PedidoStore _pedidoStore;

  @override
  void initState() {
    _pedidoStore = PedidoStore();
    _pedidoStore.listarPedidosTransportador(status: null);
    _pedidoStore.setStatusAplicado(null);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                            tooltip: 'Filtrar',
                            icon: Icon(Icons.filter_list),
                            onPressed: () async {
                              int status = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          FilterPedidosClientePage()));
                              status = status == 9 ? null : status;
                              // _pedidoStore.
                              _pedidoStore.setStatusAplicado(status);
                              await _pedidoStore.listarPedidosTransportador(
                                  status: status);
                            }),
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              await _pedidoStore.listarPedidosTransportador();
                            })
                      ],
                    ),
                  ),
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
                  final future = _pedidoStore.pedidosTransportador;
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
                              'Nenhum pedido encontrado. Verifique se o filtro está de acordo.'),
                        );
                      }

                      return Column(
                        children: pedidos
                            .where((element) => element.status != 2)
                            .map((pedido) {
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
                              [
                                'Valor:',
                                'R\$${Consts.nf.format(pedido.valor)}'
                              ],
                            ],
                            buttons: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                pedido.status < 1 || pedido.status == 2
                                    ? Container()
                                    : Expanded(
                                        child: FlatButton(
                                          splashColor:
                                              Colors.deepOrange.withOpacity(.4),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) => UploadFoto(
                                                          ordemServico: pedido
                                                              .ordemServico,
                                                        )));
                                          },
                                          child: Text(
                                            'FOTOS',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
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

  Widget _buildSolicitationList(
      BuildContext context, List<dynamic> solicitations) {
    return Column(
      children: solicitations.map((solicitation) {
        // TODO: make this dynamic
        bool isTransporter = false;

        return Card(
          elevation: 10.0,
          child: InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Solicitação #${solicitation.id}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Transportador(a): ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('...'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cliente: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('...'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'De: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('...'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Para: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('....'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Status: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                            '${Consts.getStatus(solicitation.statusSolicitacao)}'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Valor: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.green,
                          ),
                          child: Text(
                            '...',
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.all(5.0),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          splashColor: gooexColors.primary.withOpacity(.3),
                          child: Text(
                            'DETALHES',
                            style: TextStyle(color: gooexColors.primary),
                          ),
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (c) => SolicitationDetailPage(),
                            //     settings:
                            //         RouteSettings(arguments: solicitation)));
                          },
                        ),
                      ),
                      isTransporter &&
                              solicitation.statusSolicitacao == 'PENDENTE'
                          ? Expanded(
                              child: FlatButton(
                                splashColor: Colors.red.withOpacity(.3),
                                child: Text(
                                  'NEGAR',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // _denySolicitation(context, solicitation, loginBloc.user.token);
                                },
                              ),
                            )
                          : Container(),
                      isTransporter &&
                              (solicitation.statusSolicitacao == 'PENDENTE')
                          ? Expanded(
                              child: FlatButton(
                                splashColor: Colors.green.withOpacity(.3),
                                child: Text(
                                  'ACEITAR',
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () {
                                  // _acceptSolicitation(context, solicitation, loginBloc.user.token);
                                },
                              ),
                            )
                          : Container(),
                      !isTransporter &&
                              solicitation.statusSolicitacao == 'PENDENTE'
                          ? Expanded(
                              child: FlatButton(
                                splashColor: Colors.red.withOpacity(.3),
                                child: Text(
                                  'CANCELAR',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // _calcelSolicitation(context, solicitation,
                                  //     loginBloc.user.token);
                                },
                              ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

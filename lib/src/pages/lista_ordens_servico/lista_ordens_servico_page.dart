import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/pages/criar_ordem_servico/criar_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/detalhe_ordem_servico/detalhe_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/pagamento/pagamento_page.dart';
import 'package:gooex_mobile/src/pages/pedidos/filter_pedidos_page.dart';
import 'package:gooex_mobile/src/pages/transportadores_disponiveis/transportadores_disponiveis_page.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';

import '../../../colors.dart' as gooexColors;

import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }

class ListaOrdensServico extends StatefulWidget {
  _ListaOrdensServicoState createState() => _ListaOrdensServicoState();
}

class _ListaOrdensServicoState extends State<ListaOrdensServico> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  OrdemServicoStore ordemServicoStore;

void refresh() async {
  await ordemServicoStore.listaOrdensServico(status: ordemServicoStore.statusAplicado);
}
  @override
  void initState() {
    ordemServicoStore = OrdemServicoStore();
    ordemServicoStore.listaOrdensServico(status: null);
    ordemServicoStore.setStatusAplicaco(null);
    
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: DrawerApp(
        isTransporter: loginStore.usuario.transportador,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: gooexColors.primary,
        tooltip: 'Criar Ordem de Serviço',
        onPressed: () async {
          var result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => CriarOrdemServicoPage()));

          if (result != null) {
            ordemServicoStore.listaOrdensServico();
          }
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
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            tooltip: 'Filtrar',
                            icon: Icon(Icons.filter_list),
                            onPressed: () async {
                              int status = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => FilterPedidosClientePage(title: 'Filtrar Ordens de Serviço'))
                              );
                              status = status == 9 ? null : status;
                              ordemServicoStore.setStatusAplicaco(status);
                              await ordemServicoStore.listaOrdensServico(status: status);
                            }),
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              await ordemServicoStore.listaOrdensServico(status: ordemServicoStore.statusAplicado);
                            })
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  'Ordens de Serviço',
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
                  int status = ordemServicoStore.statusAplicado;

                  if(status == null) return Container(
                    child: Text('Filtrado pelo status: TODAS'),
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
                  final future = ordemServicoStore.ordensServico;
                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      break;

                    case FutureStatus.fulfilled:
                      final List<OrdemServico> ordensServico = future.result;

                      if (ordensServico.length == 0) {
                        return Center(
                            child: Text('Nenhuma Ordem de Serviço ainda'));
                      }

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: ordensServico.map((ordemServico) {
                            return Card(
                              color: Consts.getCardColor(ordemServico.status),
                              elevation: 10.0,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Ordem de Serviço #${ordemServico.uuid.substring(0, 8)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'CEP: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text('${ordemServico.cep}'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Número:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child:
                                                Text('${ordemServico.numero}'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      ordemServico.complemento.isEmpty ? Container() : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Complemento:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '${ordemServico.complemento}'),
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Volume total:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '${ordemServico.largura * ordemServico.altura * ordemServico.comprimento} cm\u00B3'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Peso:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child:
                                                Text('${ordemServico.peso} Kg'),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Status:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '${Consts.getStatus(ordemServico.status)}'),
                                          )
                                        ],
                                      ),

                                      Divider(),
                                       SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Criada em:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),Text('${ordemServico.data_hora_criacao}')
                                         /*  Flexible(
                                            child: Text(
                                                '${(ordemServico.criacao == null? '---':ordemServico.criacao)}'),
                                          ) */
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextButton(
                                             // splashColor: gooexColors.primary
                                                //  .withOpacity(.4),
                                              onPressed: () {
                                                //DetalheOrdemServicoPage
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DetalheOrdemServicoPage(
                                                                ordemServico:
                                                                    ordemServico)));
                                              },
                                              child: Text(
                                                'Detalhes',
                                                style: TextStyle(
                                                    color: gooexColors.primary),
                                              ),
                                            ),
                                          ),
                                          ordemServico.status > 0 && ordemServico.status != 2
                                              ? Container()
                                              : Expanded(
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      await Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  TransportadoresDisponiveisPage(
                                                                      ordemServico:
                                                                          ordemServico)));
                                                    },
                                                    child: Text(
                                                      'Transportadores',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepOrange),
                                                    ),
                                                  ),
                                                ),
                                          ordemServico.status <= -1 || ordemServico.status == 1 || ordemServico.status >= 2
                                              ? Container()
                                              : Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) => PagamentoPage(
                                                                  ordemServicoUUID:
                                                                      ordemServico
                                                                          .uuid)));
                                                    },
                                                    child: Text(
                                                      'Pagamento',
                                                      style: TextStyle(
                                                          color: Colors.orange),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList());
                      // return _buildSolicitationList(context, ordensServico);
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
}

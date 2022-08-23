import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/ordem_pagamento.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:gooex_mobile/src/widgets/webview_mercadopago.dart';
import 'package:mobx/mobx.dart';

class PagamentoPage extends StatefulWidget {
  final String ordemServicoUUID;

  PagamentoPage({this.ordemServicoUUID});

  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();

  OrdemServicoStore _ordemServicoStore = OrdemServicoStore();

  @override
  void initState() {
    _ordemServicoStore.obterOrdemPagamento(widget.ordemServicoUUID);
    super.initState();
  }

  @override
  void dispose() {
    _ordemServicoStore = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        children: [
          Observer(
            builder: (_) {
              final future = _ordemServicoStore.ordemPagamento;

              switch (future.status) {
                case FutureStatus.pending:
                  return LinearProgressIndicator();
                  break;

                case FutureStatus.rejected:
                  return LinearProgressIndicator();
                  break;

                case FutureStatus.fulfilled:
                  final OrdemPagamento ordemPagamento = future.value;
                  bool isSandbox = ordemPagamento.paymentUrl == null;
                  String paymentUrl = isSandbox ? ordemPagamento.sandboxPaymentUrl : ordemPagamento.paymentUrl;

                  return CustomCard(
                    title: 'Pagamento da ordem de serviço',
                    rows: [
                      [
                        'Ordem de Serviço',
                        widget.ordemServicoUUID.substring(0, 8)
                      ],
                      ['Valor', 'R\$${Consts.nf.format(ordemPagamento.valor)}'],
                      ['Estado', '${ordemPagamento.stateVerbose}'],
                    ],
                    buttons: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ordemPagamento.state == 'pago' ?
                          Expanded(
                            child: Text('Sua ordem de serviço está paga', textAlign: TextAlign.center,),
                          )
                         : RaisedButton(
                          color: Colors.green[700],
                          onPressed: () async {
                            String response = await Navigator.of(context)
                              .push(
                                MaterialPageRoute(builder: (_) => WebViewMercadoPago(
                                  paymentUrl: paymentUrl,
                                  isSandbox: isSandbox
                                ))
                              );

                            if(response != null) {
                              await _ordemServicoStore.obterOrdemPagamento(widget.ordemServicoUUID);
                            }
                          },
                          child: Text(
                            'Efetuar Pagamento',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                  break;
              }

              return Text('Chegou algo');
            },
          ),
        ],
      ),
    );
  }
}

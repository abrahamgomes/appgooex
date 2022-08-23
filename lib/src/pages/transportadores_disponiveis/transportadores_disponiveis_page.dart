import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/pages/pagamento/pagamento_page.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/custom_card.dart';
import 'package:mobx/mobx.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

class TransportadoresDisponiveisPage extends StatefulWidget {
  final OrdemServico ordemServico;

  TransportadoresDisponiveisPage({this.ordemServico});

  @override
  _TransportadoresDisponiveisPageState createState() =>
      _TransportadoresDisponiveisPageState();
}

class _TransportadoresDisponiveisPageState
    extends State<TransportadoresDisponiveisPage> {
  OrdemServicoStore _ordemServicoStore;

  @override
  void initState() {
    _ordemServicoStore = OrdemServicoStore();
    print(widget.ordemServico.uuid);
    _ordemServicoStore
        .listarTransportadoresDisponiveis(widget.ordemServico.uuid);
    super.initState();
  }

  @override
  void dispose() {
    _ordemServicoStore = null;
    super.dispose();
  }

  Widget _buildTravelslist(BuildContext context, List<Viagem> viagens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: viagens.map((travel) {
        final dataPartida = DateTime.parse(travel.dataPartida);
        final dataChegada = DateTime.parse(travel.dataChegada);
        return CustomCard(
          title: 'Viagem #${travel.uuid.substring(0, 8)}',
          rows: [
            ['Avaliação', '${Consts.nf.format(travel.nota)}'],
            ['Saindo de', '${travel.municipioOrigem}'],
            ['Saindo na data', '${Consts.df.format(dataChegada)}'],
            ['Chegando em', '${travel.municipioDestino}'],
            ['Chegando na data', '${Consts.df.format(dataPartida)}'],
          ],
          buttons: Row(
            children: <Widget>[
              Container(
                child: Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await _selecionarTransportador(context, travel.uuid);
                    },
                    child: Text('Selecionar transportador',
                        style: TextStyle(color: Colors.deepOrange)),
                  ),
                ),
              )
            ],
          ),
        );
        // return Text('hello');
        // return Card(
        //   elevation: 10.0,
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     padding: EdgeInsets.all(18.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Text(
        //           'Viagem #${travel.uuid.substring(0,8)}',
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        //         ),
        //         Row(
        //           children: <Widget>[
        //             Text('Avaliação: ${travel.nota}',
        //                 style: TextStyle(fontSize: 15.0)),
        //             Icon(Icons.star, color: Colors.deepOrange)
        //           ],
        //         ),
        //         Divider(),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Text(
        //               'Saindo em:',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             Flexible(
        //               child: Text('${Consts.df.format(dataChegada)}'),
        //             )
        //           ],
        //         ),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Text(
        //               'Chegando em:',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             Flexible(
        //               child: Text('${Consts.df.format(dataPartida)}'),
        //             )
        //           ],
        //         ),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Text(
        //               'Bagagem livre:',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             Flexible(
        //               child: Text('${travel.bagagemLivre}Kg'),
        //             )
        //           ],
        //         ),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Divider(),
        //         Row(
        //           children: <Widget>[
        //             Container(
        //               child: Expanded(
        //                 child: FlatButton(
        //                   onPressed: () async {
        //                     await _selecionarTransportador(context, travel.uuid);
        //                   },
        //                   child: Text('Selecionar transportador',
        //                       style: TextStyle(color: Colors.deepOrange)),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      }).toList(),
    );
  }

  Future<void> _selecionarTransportador(
      BuildContext context, String viagemId) async {
    UtilDialog.presentLoader(context);

    try {
      await _ordemServicoStore.selecionarTransportador(
          widget.ordemServico.uuid, viagemId);
      Navigator.of(context).pop();
     AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: 'Sua solicitação foi enviada para o transportador. Faça o pagamento para que ele possa aceitar.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
               // Vai para o pagamento
            Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PagamentoPage(
                  ordemServicoUUID: widget.ordemServico.uuid,
                )));
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Sucesso',
          message:
              'Sua solicitação foi enviada para o transportador. Faça o pagamento para que ele possa aceitar.',
          ok: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Vai para o pagamento
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PagamentoPage(
                  ordemServicoUUID: widget.ordemServico.uuid,
                )));
      }); */
    } on ApiResponseException catch (e) {
      Navigator.of(context).pop();
       AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc: '${e.payload['message']}',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Erro', message: '${e.payload['message']}'); */
    } on Exception catch(err) {
      print('ERRO:');
      print(err);
      Navigator.of(context).pop();
       AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc: 'Erro inesperado. Não foi possível enviar a solicitação ao transportador',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Erro',
          message:
              'Erro inesperado. Não foi possível enviar a solicitação ao transportador'); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:  gooexColors.primary,
          title: Text('Transportadores disponíveis'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Observer(builder: (_) {
            final future = _ordemServicoStore.transportadoresDisponiveis;
            print(future.status);
            switch (future.status) {
              case FutureStatus.pending:
                return LinearProgressIndicator();
                break;

              case FutureStatus.rejected:
                print(future.error);
                return Text('Erro');
                break;

              case FutureStatus.fulfilled:
                final viagens =
                    _ordemServicoStore.transportadoresDisponiveis.result;

                if (viagens.length == 0) {
                  return Center(
                    child: Text(
                        'Nenhum transportador disponível para a sua Ordem de Serviço'),
                  );
                }

                return _buildTravelslist(context, viagens);
                break;
            }

            return Text('Error');

            // _buildTravelslist(context, []);
          }),
        ));
  }
}

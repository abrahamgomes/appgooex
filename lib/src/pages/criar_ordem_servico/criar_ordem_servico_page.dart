import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/pages/lista_ordens_servico/lista_ordens_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';
import 'package:date_format/date_format.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../colors.dart' as gooexColors;

import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

class CriarOrdemServicoPage extends StatefulWidget {
  _CriarOrdemServicoPageState createState() => _CriarOrdemServicoPageState();
}

class _CriarOrdemServicoPageState extends State<CriarOrdemServicoPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  OrdemServicoStore ordemServicoStore;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _cepCtrl,
      _numeroCtrl,
      _complementoCtrl,
      _comprimentoCtrl,
      _larguraCtrl,
      _alturaCtrl,
      _pesoCtrl;

final dataCriacao =  formatDate(DateTime.now(), [HH, ':', nn, ':', ss,'-',dd,'/', mm,'/',yyyy]);


void refresh() async {
  await ordemServicoStore.listaOrdensServico(status: ordemServicoStore.statusAplicado);
}

  @override
  void initState() {
    ordemServicoStore = OrdemServicoStore();
    ordemServicoStore.listaOrdensServico();

    _cepCtrl = TextEditingController();
    _numeroCtrl = TextEditingController();
    _complementoCtrl = TextEditingController();
    _comprimentoCtrl = TextEditingController();
    _larguraCtrl = TextEditingController();
    _alturaCtrl = TextEditingController();
    _pesoCtrl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _cepCtrl.dispose();
    _numeroCtrl.dispose();
    _complementoCtrl.dispose();
    _comprimentoCtrl.dispose();
    _larguraCtrl.dispose();
    _alturaCtrl.dispose();
    _pesoCtrl.dispose();
    super.dispose();
  }

  String _requiredValitation(String value) {
    return (value.isEmpty) ? 'Campo obrigatório' : null;
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  validator: _requiredValitation,
                  controller: _cepCtrl,
                  keyboardType: TextInputType.number,
                 /*  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], */
                  decoration: InputDecoration(
                      hintText: 'CEP',
                      labelText: 'CEP',
                      helperText: 'Informe somente números',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  // keyboardType: TextInputType.number,
                  controller: _numeroCtrl,
                  validator: _requiredValitation,
                  decoration: InputDecoration(
                      hintText: 'Número',
                      labelText: 'Número',
                      helperText: 'Número da residência',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: _complementoCtrl,
                  decoration: InputDecoration(
                      hintText: 'Complemento',
                      labelText: 'Complemento',
                      helperText: 'Complemento do endereço',
                      border: OutlineInputBorder()),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _comprimentoCtrl,
                  validator: _requiredValitation,
                 /*  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], */
                  decoration: InputDecoration(
                      hintText: 'Comprimento (cm)',
                      labelText: 'Comprimento (cm)',
                      helperText: 'Comprimento da mercadoria',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _larguraCtrl,
                  validator: _requiredValitation,
                 /*  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], */
                  decoration: InputDecoration(
                      hintText: 'Largura (cm)',
                      labelText: 'Largura (cm)',
                      helperText: 'Largura da mercadoria',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _alturaCtrl,
                  validator: _requiredValitation,
                 /*  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], */
                  decoration: InputDecoration(
                      hintText: 'Altura (cm)',
                      labelText: 'Altura (cm)',
                      helperText: 'Altura da mercadoria',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _pesoCtrl,
                  validator: _requiredValitation,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: 'Peso (Kg)',
                      helperText: 'Peso da mercadoria (máximo de 8Kg)',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) return;

                    Map<String, String> campos = {
                      'comprimento': 'Comprimento',
                      'largura': 'Largura',
                      'altura': 'Altura',
                      'peso': 'Peso',
                      'numero': 'Número',
                      'cep': 'CEP',
                      'data_hora_criacao': dataCriacao,
                     /*  'cliente': loginStore.usuario.user_id */
                    };

                    UtilDialog.presentLoader(context);
                    try {
                      final novaOrdemServico = OrdemServico(
                          data_hora_criacao:dataCriacao, 
                          altura: int.parse(_alturaCtrl.text),
                          largura: int.parse(_larguraCtrl.text),
                          comprimento: int.parse(_comprimentoCtrl.text),
                          complemento: _complementoCtrl.text,
                          cep: _cepCtrl.text,
                          numero: _numeroCtrl.text,
                          peso: double.parse(_pesoCtrl.text),
                          /* cliente:  loginStore.usuario.user_id */
                          );
                      await ordemServicoStore
                          .criarOrdemServico(novaOrdemServico);
                      Navigator.of(context).pop();
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.SUCCES,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Sucesso',
                            desc: 'Ordem de serviço registrada com sucesso',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              Navigator.of(context).pop();
                              //Navigator.of(context).pop(novaOrdemServico);
                              refresh();
                            },
                            )..show();
                     /*  UtilDialog.presentAlert(
                        context,
                        title: 'Sucesso',
                        message: 'Ordem de serviço registrada com sucesso',
                        ok: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(novaOrdemServico);
                        }
                      ); */
                    } on SocketException {
                      Navigator.of(context).pop();
                      AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Falha na conexão',
                            desc: 'Não conseguimos nos conectar ao servidor. Certifique-se de possui uma conexão com a internet e tente novamente',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                          
                            },
                            )..show();
                    /*   UtilDialog.presentAlert(context,
                          title: 'Falha na conexão',
                          message:
                              'Não conseguimos nos conectar ao servidor. Certifique-se de possui uma conexão com a internet e tente novamente'); */
                    } on ApiResponseException catch (e) {
                      Navigator.of(context).pop();

                      final payload = e.payload as Map;

                      if (payload['errors'] != null) {
                        final errors =
                            payload['errors'] as Map<String, dynamic>;
                        if (errors.keys.length > 0) {
                          final key = errors.keys.toList()[0];
                          final errorMessage = (errors[key] as List)[0];

                          final campo = campos[key];
                    
                          String message =
                              '${payload['message']}\n\nErro no campo $campo: $errorMessage';
                          print(message);
                            AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Houve um erro',
                            desc: message,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                          
                            },
                            )..show();
                     /*      UtilDialog.presentAlert(context,
                              title: 'Houve um erro', message: message); */
                        }
                      } else {
                         AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Houve um erro',
                            desc:payload['message'],
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                          
                            },
                            )..show();
                       /*  UtilDialog.presentAlert(context,
                            title: 'Houve um erro',
                            message: payload['message']); */
                      }
                    }
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Text(
                      'Nova Ordem de Serviço',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: gooexColors.primary),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    'Informe abaixo as características da sua mercadoria',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              _buildForm()
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
                        child: Text('${solicitation.statusSolicitacao}'),
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
                        child: TextButton(
                          //splashColor: gooexColors.primary.withOpacity(.3),
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
                              child: TextButton(
                               // splashColor: Colors.red.withOpacity(.3),
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
                              child: TextButton(
                               // splashColor: Colors.green.withOpacity(.3),
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
                              child: TextButton(
                               // splashColor: Colors.red.withOpacity(.3),
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

  // void _acceptSolicitation(BuildContext context, dynamic solicitation, String token) async {
  //   Utils.showLoader(context);
  //   try {
  //     var response = await service.acceptSolicitation(solicitation, token);
  //     var data = jsonDecode(response.body);
  //     Navigator.of(context).pop();
  //     switch (data['code']) {
  //       case 'SUCCESS':
  //         Utils.showAlert(context,
  //             title: 'Solicitação aceita',
  //             message: 'A solicitação foi aceita com sucesso');
  //         solicitationListBloc.listSolicitations();
  //         break;

  //       case 'ERROR':
  //         Utils.showAlert(context, title: 'Erro', message: data['message']);
  //         break;

  //       default:
  //         Utils.showAlert(context, title: 'Erro', message: 'Erro desconhecido');
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     Utils.showAlert(context, title: 'Erro', message: 'Falha na comunicação');
  //   }
  // }

  // void _denySolicitation(BuildContext context, SolicitacaoEntrega solicitation,
  //     String token) async {
  //   Utils.showLoader(context);
  //   try {
  //     var response = await service.denySolicitation(solicitation, token);
  //     var data = jsonDecode(response.body);
  //     Navigator.of(context).pop();
  //     switch (data['code']) {
  //       case 'SUCCESS':
  //         Utils.showAlert(context,
  //             title: 'Solicitação negada',
  //             message: 'A solicitação foi negada com sucesso');
  //         solicitationListBloc.listSolicitations();
  //         break;

  //       case 'ERROR':
  //         Utils.showAlert(context, title: 'Erro', message: data['message']);
  //         break;

  //       default:
  //         Utils.showAlert(context, title: 'Erro', message: 'Erro desconhecido');
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     Utils.showAlert(context, title: 'Erro', message: 'Falha na comunicação');
  //   }
  // }
}

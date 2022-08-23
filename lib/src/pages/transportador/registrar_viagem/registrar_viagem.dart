import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/aeroporto.dart';
import 'package:gooex_mobile/src/models/viagem.dart';

import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';

import 'package:gooex_mobile/src/stores/viagem_store.dart';

import 'package:gooex_mobile/src/widgets/seleciona_horario.dart';
import 'package:mobx/mobx.dart';

// import 'package:gooex_mobile/arc/colors.dart';
import '../../../../colors.dart' as gooexColors;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:intl/intl.dart';

class RegistrarViagemPage extends StatefulWidget {
  _RegistrarViagemPageState createState() => _RegistrarViagemPageState();
}

class _RegistrarViagemPageState extends State<RegistrarViagemPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  ViagemStore _viagemStore;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _cepOrigemCtrl,
      _numeroOrigemCtrl,
      _complementoOrigemCtrl,
      _cepDestinoCtrl,
      _numeroDestinoCtrl,
      _complementoDestinoCtrl,
      _pesoCtrl;

  @override
  void initState() {
    _viagemStore = ViagemStore();
    _viagemStore.listarAeroportos();

    _cepOrigemCtrl = TextEditingController();
    _numeroOrigemCtrl = TextEditingController();
    _complementoOrigemCtrl = TextEditingController();
    _cepDestinoCtrl = TextEditingController();
    _numeroDestinoCtrl = TextEditingController();
    _complementoDestinoCtrl = TextEditingController();
    _pesoCtrl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _cepOrigemCtrl.dispose();
    _numeroOrigemCtrl.dispose();
    _complementoOrigemCtrl.dispose();
    _cepDestinoCtrl.dispose();
    _numeroDestinoCtrl.dispose();
    _complementoDestinoCtrl.dispose();
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
                  controller: _cepOrigemCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: 'CEP de Origem',
                      labelText: 'CEP de Origem',
                      helperText: 'Informe somente números',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  // keyboardType: TextInputType.number,
                  controller: _numeroOrigemCtrl,
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
                  controller: _complementoOrigemCtrl,
                  decoration: InputDecoration(
                      hintText: 'Complemento de Origem',
                      labelText: 'Complemento de Origem',
                      helperText: 'Complemento do endereço',
                      border: OutlineInputBorder()),
                ),
              ),
              
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: TextFormField(
              //     validator: _requiredValitation,
              //     controller: _cepDestinoCtrl,
              //     keyboardType: TextInputType.number,
              //     inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              //     decoration: InputDecoration(
              //         hintText: 'CEP de Destino',
              //         labelText: 'CEP de Destino',
              //         helperText: 'Informe somente números',
              //         border: OutlineInputBorder()),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: TextFormField(
              //     // keyboardType: TextInputType.number,
              //     controller: _numeroDestinoCtrl,
              //     validator: _requiredValitation,
              //     decoration: InputDecoration(
              //         hintText: 'Número de Destino',
              //         labelText: 'Número de Destino',
              //         helperText: 'Número da residência',
              //         border: OutlineInputBorder()),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: TextFormField(
              //     controller: _complementoDestinoCtrl,
              //     decoration: InputDecoration(
              //         hintText: 'Complemento de Destino',
              //         labelText: 'Complemento de Destino',
              //         helperText: 'Complemento do endereço',
              //         border: OutlineInputBorder()),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Observer(
                builder: (_) {
                  final future = _viagemStore.aeroportos;

                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                    print(future.result);
                      return Text('Erro ao listar os aeroportos');
                      break;

                    case FutureStatus.fulfilled:
                      final aeroportos = future.value;

                      return DropdownButtonFormField<String>(
                        validator: (String v) {
                          return v == null || v.isEmpty ? '* Selecione o aeroporto de destino' : null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Aeroporto de destino',
                            border: OutlineInputBorder()),
                        value: _viagemStore.aeroporto,
                        // hint: Text('Selecione o status'),
                        isExpanded: true,
                        iconSize: 24,
                        // elevation: 16,
                        onChanged: (String newValue) {
                          print('${aeroportos.firstWhere((element) => element.nome == newValue).toJson()}');
                          _viagemStore.setAeroporto(newValue);
                        },
                        items: aeroportos
                            .map((a) => a.nome).toList()
                            .map<DropdownMenuItem<String>>((String aeroporto) {
                          return DropdownMenuItem<String>(
                            value: aeroporto,
                            child: Container(
                              // padding: EdgeInsets.all(8.0),
                              child: Text('$aeroporto'),
                            ),
                          );
                        }).toList(),
                      );
                      break;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),

              Divider(),

              SizedBox(
                height: 10,
              ),

              Observer(
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: ListTile(
                      title: Text(_viagemStore.dataPartida != null
                          ? Consts.dfOnlyDate.format(_viagemStore.dataPartida)
                          : 'Data de partida'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await UtilDialog.selectDate(context);
                        if (date != null) {
                          _viagemStore.setDataPartida(date);
                        }
                      },
                    ),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: ListTile(
                      title: Text(_viagemStore.horarioPartida != null
                          ? _viagemStore.horarioPartida
                          : 'Horário de partida (HH:mm)'),
                      trailing: Icon(Icons.timer),
                      onTap: () async {
                        String hour = await showDialog(
                            context: context,
                            builder: (c) => SelecionaHorarioDialog(
                                  title: 'Horário de partida',
                                ));
                        if (hour != null) {
                          _viagemStore.setHorarioPartida(hour);
                        }
                      },
                    ),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: ListTile(
                      title: Text(_viagemStore.dataChegada != null
                          ? Consts.dfOnlyDate.format(_viagemStore.dataChegada)
                          : 'Data volta'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await UtilDialog.selectDate(context);
                        if (date != null) {
                          _viagemStore.setDataChegada(date);
                        }
                      },
                    ),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: ListTile(
                      title: Text(_viagemStore.horarioChegada != null
                          ? _viagemStore.horarioChegada
                          : 'Horário da volta (HH:mm)'),
                      trailing: Icon(Icons.timer),
                      onTap: () async {
                        String hour = await showDialog(
                            context: context,
                            builder: (c) => SelecionaHorarioDialog(
                                  title: 'Horário da volta',
                                ));
                        if (hour != null) {
                          _viagemStore.setHorarioChegada(hour);
                        }
                      },
                    ),
                  );
                },
              ),
              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) return;

                    final aeroportos = _viagemStore.aeroportos.value;
                    final aeroportoSelecionado = aeroportos.firstWhere((element) => element.nome.toUpperCase() == _viagemStore.aeroporto.toUpperCase());


                    // return;
                    UtilDialog.presentLoader(context);
                    var hourComponents = _viagemStore.horarioPartida
                        .split(':')
                        .map((e) => int.parse(e))
                        .toList();
                    DateTime first = DateTime(
                        _viagemStore.dataPartida.year,
                        _viagemStore.dataPartida.month,
                        _viagemStore.dataPartida.day,
                        hourComponents[0],
                        hourComponents[1]);

                    hourComponents = _viagemStore.horarioChegada
                        .split(':')
                        .map((e) => int.parse(e))
                        .toList();
                    DateTime last = DateTime(
                        _viagemStore.dataChegada.year,
                        _viagemStore.dataChegada.month,
                        _viagemStore.dataChegada.day,
                        hourComponents[0],
                        hourComponents[1]);

                    final newViagem = Viagem(
                        dataChegada: first.toIso8601String() + 'Z',
                        dataPartida: last.toIso8601String() + 'Z',
                        cepOrigemString: _cepOrigemCtrl.text,
                        aeroporto: _viagemStore.aeroporto,
                        numeroOrigem: _numeroOrigemCtrl.text,
                        complementoOrigem: _complementoOrigemCtrl.text,
                        cepDestinoString: aeroportoSelecionado.cep.toString(),
                        numeroDestino: aeroportoSelecionado.numero,
                        complementoDestino: aeroportoSelecionado.complemento
                        // cepDestinoString: _cepDestinoCtrl.text,
                        // numeroDestino: _numeroDestinoCtrl.text,
                        // complementoDestino: _complementoDestinoCtrl.text
                        );
                    // print(newViagem.toJsonTransportador());
                    // return;

                    try {
                      await _viagemStore.registrarViagem(newViagem);
                      Navigator.of(context).pop();
                       AwesomeDialog(
                              context: context,
                               dialogType: DialogType.SUCCES,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Sucesso',
                                 desc: 'Viagem registrada com sucesso',
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {
                                 Navigator.of(context).pop();
                                // Navigator.of(context).pop();
                                 },
                              )..show();
                    /*   UtilDialog.presentAlert(context,
                          title: 'Sucesso',
                          message: 'Viagem registrada com sucesso', ok: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }); */
                    } on ApiResponseException catch (e) {
                      Navigator.of(context).pop();
                        AwesomeDialog(
                              context: context,
                               dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Erro',
                                 desc:  e.payload['message'],
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {                              
                                 },
                              )..show();
                     /*  UtilDialog.presentAlert(context,
                          title: 'Erro', message: e.payload['message']); */
                    } on SocketException catch (e) {
                      Navigator.of(context).pop();
                        AwesomeDialog(
                              context: context,
                               dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Erro',
                                 desc: 'Não foi possível conectar-se ao servidor',
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {                              
                                 },
                              )..show();
                   /*    UtilDialog.presentAlert(context,
                          title: 'Erro',
                          message: 'Não foi possível conectar-se ao servidor'); */
                    } on Exception catch (err) {
                      print('ESTE É O ERRO');
                      print(err);
                      Navigator.of(context).pop();
                       AwesomeDialog(
                              context: context,
                               dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Erro',
                                 desc: 'Ocorreu um erro inesperado ao registrar a viagem. Tente novamente em instantes',
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {                              
                                 },
                              )..show();
                     /*  UtilDialog.presentAlert(context,
                          title: 'Erro',
                          message:
                              'Ocorreu um erro inesperado ao registrar a viagem. Tente novamente em instantes'); */
                    }

                    print(newViagem.toJsonTransportador());
                  },
                  color: Colors.green,
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
                      'Registrar Viagem',
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
                    'Registre uma viagem para que os clientes possam encontrá-lo(a)',
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

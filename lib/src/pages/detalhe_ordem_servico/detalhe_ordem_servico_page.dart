import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/models/endereco_transportador.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:gooex_mobile/src/services/api.dart' as Api;
import 'package:http/http.dart' as http;
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class DetalheOrdemServicoPage extends StatefulWidget {
  final OrdemServico ordemServico;

  DetalheOrdemServicoPage({this.ordemServico});

  @override
  _DetalheOrdemServicoPageState createState() =>
      _DetalheOrdemServicoPageState();
}

class _DetalheOrdemServicoPageState extends State<DetalheOrdemServicoPage> {
  OrdemServicoStore ordemServicoStore = OrdemServicoStore();
final dataCriacao =  formatDate(DateTime.now(), [HH, ':', nn, ':', ss,'-',dd,'/', mm,'/',yyyy]);
var _ocorreJson = [];
bool _disabled;




void getOcorrencias (uuid) async {
  try{
  final response = await http.get(Uri.parse('${Api.Api.baseUrl}/ordem_servico/ocorrencias?uuid=${uuid}'),
  headers: {
      "Authorization" : "Token ${loginStore.usuario.token}",
      "Content-Type":"application/json;charset=utf-8;",
  });
  final json = jsonDecode(response.body)['results'] as List;
  print(json);
  setState(() {
    _ocorreJson = json;  
  });
  print(_ocorreJson);
  
  } catch(err){
    print('ERRO: '+err);
  }
} 
void changeOcorrencia () {
     if(_ocorrencia.text.length >= 3){
      setState(() {
        _disabled = true;
      });
    }
    else{
       setState(() {
        _disabled = false;
      });
    }
}

TextEditingController _ocorrencia;

  @override
  void initState() {
    _ocorrencia = TextEditingController();
    _disabled = false;
    getOcorrencias(widget.ordemServico.uuid);
    
    super.initState();
    if (widget.ordemServico.status >= 1 && widget.ordemServico.status != 2) {
      ordemServicoStore.buscarEndereco(widget.ordemServico.uuid).then((value) {
        setState(() {});
      });
    }
  }
  @override
  void dispose() {
    
    _ocorrencia.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: gooexColors.primary,
          title:
           Text(
              'Ordem de Serviço #${widget.ordemServico.uuid.substring(0, 8)}'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
          child: _buildContent(),
        ));
  }

  Widget _buildContent() {
    final os = widget.ordemServico;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Comprimento:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text('${os.comprimento}cm'),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Largura:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text('${os.largura}cm'),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Altura:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text('${os.altura}cm'),
              )
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 40,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Card(
                color: gooexColors.primary,
                child: Column(
                  children: [
              Padding(
                padding: const EdgeInsets.only(top: 5,left: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Ocorrências:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color:Colors.white),),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
               SizedBox(height: 5),
               Container(
                  margin: EdgeInsets.only(bottom:1),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: TextFormField(                  
                        onChanged:(value){
                          changeOcorrencia();
                        },
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        controller: _ocorrencia,                  
                        decoration: InputDecoration(  
                            
                            hintText: 'Nova Ocorrência',
                            labelText: 'Escreva aqui sua ocorrência',
                           labelStyle: TextStyle(color: Colors.black),
                           // helperText: ,                       
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:5,bottom: 5),
                  child: Align(
                    alignment: Alignment.centerRight,                 
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: _disabled == false ? Color(0xffc4c4c4) : Colors.orange[800]),
                      onPressed: _disabled == false ? null : () async {
                                try{
                                  final response = await http.post(Uri.parse('${Api.Api.baseUrl}/ordem_servico/ocorrencias'),
                                  body:jsonEncode({
                                      "uuid_ordem_servico": "${os.uuid}",
                                      "descricao":"${_ocorrencia.text}",
                                      
                                  }),headers: {
                                        "Content-Type":"application/json;charset=utf-8",
                                         "Connection" : "keep-alive",
                                         "Cache-Control" : "no-cache",
                                          "Accept" : "*/*",
                                         "Authorization" : "Token ${loginStore.usuario.token}"                                   
                                  });
                                  print('URL: ${Api.Api.baseUrl}');
                                  print(_ocorrencia.text);
                                print(response);
                                print(os.uuid);
                                print(response.statusCode);
                                 AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'Sucesso',
                                      desc: 'Ocorrência registrada com sucesso',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () { 
                                        getOcorrencias("${os.uuid}");                        
                                      },
                                      )..show();                         
                              setState(() {
                                _ocorrencia.text = '';
                                _disabled = false;
                              });
                                  print(response.body);
                                } catch(err){
                                  print('URL: ${Api.Api.baseUrl}');
                                  print(err);
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'ERRO',
                                      desc: 'Algo deu Errado, $err',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                    
                                      },
                                      )..show();                         
                                };
                              },
                       child: Container(
                         width: 90,
                         child: Row(                          
                           children: [
                             Icon(Icons.assignment_outlined,color:Colors.white,),
                             Text('Registrar',
                             style: TextStyle(color: Colors.white),),
                           ]),
                       )),
                  ))                   
                 ]),
              )),         
          ]),
         SizedBox(
           height: 20,
         ), 
        Observer(         
          builder: (_){
            final listaOcorrencias = _ocorreJson;
              if(listaOcorrencias.length == 0 || listaOcorrencias == null){
                return  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 15),
                      Text('Sem Ocorrências Registradas'),
                    ],
                  );             
              } else{
                return Column(                 
                  children: listaOcorrencias.map((ocorrencia){                 
                      return Container(
                        width: 360,
                        child: Card(                 
                          color: Color(0xffF7E892),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Divider(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('${ocorrencia['descricao']}',style: TextStyle(fontWeight:FontWeight.bold),)),
                                   Divider(height: 20,),
                                Align(
                                      alignment: Alignment.bottomRight,
                                     
                                      child: Text(formatDate(DateTime.parse(ocorrencia["data_hora_criacao"]), [HH, ':', nn, ':', ss,'-',dd,'/', mm,'/',yyyy]),style:TextStyle(fontSize: 12))
                                      ),
                              ],
                            ),
                          ),
                                                               
                        ),
                       
                      );
                   } ).toList(),              
                );
              }
          }),
        Builder(
          builder: (_) {
            final future = ordemServicoStore.enderecoTransportador;

            if (future == null) return Container();

            switch (future.status) {
              case FutureStatus.pending:
                return LinearProgressIndicator();
                break;

              case FutureStatus.rejected:
                return Text(
                    'Houve um erro ao buscar o endereço do transportador. Tente novamente. ${future.error}');
                break;

              case FutureStatus.fulfilled:
                final EnderecoTransportador endereco = future.value;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text('LOCALIZAÇÃO DO TRANSPORTADOR'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('Logradouro'),
                      subtitle: Text('${endereco.logradouro}'),
                    ),

                    ListTile(
                      title: Text('Município'),
                      subtitle: Text('${endereco.municipio}'),
                    ),

                    ListTile(
                      title: Text('Número'),
                      subtitle: Text('${endereco.numero}'),
                    ),

                    ListTile(
                      title: Text('CEP'),
                      subtitle: Text('${endereco.cep}'),
                    ),

                    ListTile(
                      title: Text('Complemento'),
                      subtitle: Text('${endereco.complemento}'),
                    )
                    // ListTile();
                  ],
                );
                break;
            }

            return Center(
              child: Text('Sem informação'),
            );
          },
        ),
      ],
    );
  }
}

//import 'dart:html';
import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gooex_mobile/src/services/api.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/pages/login/login_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/usuario_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:lean_file_picker/lean_file_picker.dart';
import '../../../colors.dart' as gooexColors;
import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

class CriarContaPage extends StatefulWidget {
  final bool transportador;

  CriarContaPage({this.transportador});

  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final nf = NumberFormat.currency(locale: 'pt-br', symbol: 'R\$');
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _tipoConta;
  final UsuarioStore usuarioStore = UsuarioStore();
  final int anoAtual = DateTime.now().year;
  bool isChecked = false;
  bool _isButtonDisabled;
  DateTime currentDate =DateTime.now(); /* DateTime.now();formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]) */
  String currentDateinString = null; 
  String anexoState = '';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
File file; // Arquivo da folha criminal que sera enviado


  TextEditingController _controller = TextEditingController();
  
 
  TextEditingController _firstNameCtrl,
      _lastNameCtrl,
      _emailCtrl,
      _cpfCtrl,
      _passwordCtrl,
      _confirmPasswordCtrl,
      _telefoneCtrl,
      _dataNasc;

  @override
  void initState() {
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _cpfCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
    _telefoneCtrl = TextEditingController();
    _dataNasc = TextEditingController();
    _tipoConta = widget.transportador ? 'Transportador' : 'Cliente';
   _isButtonDisabled = true;
   // ignore: unused_local_variable
   String anexoState = '';
    
    
    super.initState();
    
  }
  

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _cpfCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _telefoneCtrl.dispose();
    _dataNasc.dispose();
    super.dispose();
  }
 
void getFile() async {
  try{
final result = await pickFile(
  allowedExtensions: ['pdf','jpg'],
  allowedMimeTypes: ['image/jpeg', 'text/*'],
);
if (result != null) {
  setState(() {
    file = result;
    anexoState = result.path.substring(32);
  });
  print(result.path);
}
  }catch(err){
    print('ERRO: '+err);
  }

}

 Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1910),
        lastDate: DateTime(anoAtual + 5));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        currentDateinString = formatDate(currentDate, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
      });
    }
  }

  String _requiredValitation(String value) {
    return (value.isEmpty) ? 'Campo obrigatório' : null;
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  validator: _requiredValitation,
                  controller: _firstNameCtrl,
                  decoration: InputDecoration(
                      hintText: 'Nome',
                      labelText: "Nome ${_firstNameCtrl.text}",
                      border: const OutlineInputBorder()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  // keyboardType: TextInputType.number,
                  controller: _lastNameCtrl,
                  validator: _requiredValitation,
                  decoration:const InputDecoration(
                      hintText: 'Sobrenome',
                      labelText: 'Sobrenome',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: _emailCtrl,
                  validator: _requiredValitation,
                  decoration: const InputDecoration(
                      hintText: 'E-mail',
                      labelText: 'E-mail',
                      // helperText: widget.transportador ? 'Mesmo do mercado pago' : '',
                      border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                 
                  controller: _telefoneCtrl,
                  validator: _requiredValitation,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hintText: ' ex: 85 123456789',
                      labelText: 'Telefone',
                      // helperText: widget.transportador ? 'Mesmo do mercado pago' : '',
                      border: OutlineInputBorder()),
                ),
              ),
              
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _cpfCtrl,
                  inputFormatters: [
                  TextInputMask(
                      mask: '999.999.999-99',
                      maxPlaceHolders: 11,
                      reverse: false)
                ],
                  validator: _requiredValitation,
                  decoration: const InputDecoration(
                      hintText: 'CPF',
                      labelText: 'CPF',
                      border: OutlineInputBorder()),
                ),
              ),
             
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    TextButton(
                     style: TextButton.styleFrom(backgroundColor: gooexColors.primary),
              onPressed: () => _selectDate(context),
              child:Row(
                children: const [
                  Icon(Icons.calendar_today,color: Colors.white,),
                  SizedBox(width: 8,),
                  Text('Data de nascimento:',style: TextStyle(color: Colors.white),),
                  ],
                  ), 
            ),SizedBox(width: 8,)
            ,Text( currentDateinString == null ? 'Sem data selecionada' : currentDateinString.substring(0,10), style: TextStyle(color: gooexColors.primary),)
            
            ],),   
             ),
             Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: [                      
                         Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      
                      TextButton(
                          style: TextButton.styleFrom(backgroundColor: gooexColors.primary),
                          onPressed: () => getFile(),
                          child: Row(children: [Icon(Icons.file_upload,color: Colors.white,),SizedBox(width: 5,),
                          Text("Ficha de antecedentes criminais", style: TextStyle(color: Colors.white),),],) 
                        ),
                      
                      Text(anexoState != "" ? anexoState.length > 10 ? "..."+anexoState.substring(5) : "..."+anexoState
                      : "Procurar informações no tribunal de justiça do estado onde reside.", 
                      style:const TextStyle(fontSize: 10, color: Color.fromARGB(255, 255, 0, 0)))
              
                    ]),
                ),
                      ]) 
                  ]),

              ],
            ),
               Divider(height: 10),

              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  validator: _requiredValitation,
                  decoration: const InputDecoration(
                      hintText: 'Senha',
                      labelText: 'Senha',
                      helperText: "Obs: Mínimo de 6 caracteres, contendo letras e números", 
                      helperStyle: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 0, 0)),
                      border: OutlineInputBorder()),
                ),
              ),
              Container(     
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordCtrl,
                  validator: _requiredValitation,
                  decoration: const InputDecoration(
                      hintText: 'Confirme a senha',
                      labelText: 'Confirme a senha',
                       helperText: "As senhas devem ser idênticas",
                       helperStyle: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 0, 0)),
                      border: OutlineInputBorder()),
                ),
              ),
              Column(
                children: [
                  Row(                      
                    children: [
                    Checkbox(
                      side: const BorderSide(color: Color(0xff000000)),
                    value: isChecked,
                    checkColor: Colors.white,
                    activeColor: Colors.blue,                   
                   onChanged:(value){
                     setState(() {
                       isChecked = !isChecked;
                       _isButtonDisabled = !_isButtonDisabled;
                     });
                   }),
                   Text('Li, e Concordo com os',style: TextStyle(color:gooexColors.primary, fontSize: 14)),
                   TextButton( child: Text('Termos de uso.', style: TextStyle(color: gooexColors.primary, fontSize: 14, decoration:TextDecoration.underline),),
                   style: TextButton.styleFrom(backgroundColor: Colors.transparent),
                    onPressed: () async {
                            const url = 'https://app.gooex.com.br/termos-de-uso';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },)
                  ],),
                 
              ],),
              Container(
                width: 100,
                height: 50,
                child: TextButton(
                  onPressed:   currentDateinString == null || _isButtonDisabled? null : ()             
                    async {
                    String anoNasc = currentDateinString.substring(6,10);
                    double idade = anoAtual - double.parse(anoNasc);

                    if(file == null){
                      AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Atenção',
                            desc: 'Nenhum arquivo de ficha criminal anexado!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {                             
                            },
                            )..show();
                      return;
                    }

                    if(idade < 0){
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'Esta data é invalida!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {                             
                            },
                            )..show();
                      return;
                    }
                    if(idade < 18) {
                      print(idade);
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'Cadastro apenas para maiores de 18 anos!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {                            
                            },
                            )..show();
                      return;
                    }
                    if(idade > 115){
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'Esta data é invalida!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                            )..show();
                      return;
                    }
                    if (!_formKey.currentState.validate()) return;

                    if(_passwordCtrl.text.length < 6) {
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'A senha deve ter no minimo 6 caracteres!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              
                            },
                            )..show();
                      return;
                    }
                     if(!_passwordCtrl.text.contains(RegExp(r'[0-9]')) || !_passwordCtrl.text.contains(RegExp(r'[a-z]')) ) {
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'A senha deve conter letras e números!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              
                            },
                            )..show();
                      return;
                    }
                    if(_passwordCtrl.text != _confirmPasswordCtrl.text) {
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Erro',
                            desc: 'As senhas não correspondem!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              
                            },
                            )..show();
                      return;
                    }
                    if(_passwordCtrl.text.length < 6) {
                       AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.TOPSLIDE,
                            title: 'Senha inválida',
                            desc: 'A sua senha deve ter no minimo 6 caracteres',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                            )..show();
                      return;
                    }
                    if(!_passwordCtrl.text.contains(RegExp(r'[0-9]')) || !_passwordCtrl.text.contains(RegExp(r'[a-z]')) ){
                         AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.TOPSLIDE,
                            title: 'Senha inválida',
                            desc: 'A sua senha deve conter letras e números',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                            )..show();
                      return;
                    }
                    try {
                      UtilDialog.presentLoader(context);
                    
                      final newUser = Usuario(
                          firstName: _firstNameCtrl.text,
                          lastName: _lastNameCtrl.text,
                          cpf: _cpfCtrl.text,
                          telefone: _telefoneCtrl.text,
                          username: _emailCtrl.text,
                          email: _emailCtrl.text,
                          password: _passwordCtrl.text,
                          dataNasc: currentDateinString.substring(0,6),
                          transportador: widget.transportador,
                          ); 
                   //Nova requisição de criação de usuario com envio de arquivos
                      var request = http.MultipartRequest("POST", Uri.parse(Api.baseUrl+'/usuario/'));
                      var pic = await http.MultipartFile.fromPath("ficha_criminal_arquivo", file.path);
                      request.files.add(pic);
                       request.fields['first_name'] = _firstNameCtrl.text;
                      request.fields['last_name'] = _lastNameCtrl.text;
                      request.fields['cpf'] = _cpfCtrl.text;
                      request.fields['telefone'] = _telefoneCtrl.text;
                      request.fields['username'] = _emailCtrl.text;
                      request.fields['email'] = _emailCtrl.text;
                      request.fields['password'] = _passwordCtrl.text;
                      request.fields['transportador'] = widget.transportador.toString();
                      var response = await request.send();
                        var responseData = await response.stream.toBytes();
                        var responseString = String.fromCharCodes(responseData);
                        print(responseString);
                               
                      //await usuarioStore.criarConta(newUser); 
                      await loginStore.doLogin(newUser.email, _passwordCtrl.text);
                      await usuarioStore.criarTokenFCM('unset', 'unset');

                      Navigator.of(context).pop();
                          AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.SUCCES,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Sucesso',
                                    desc: 'Sua conta foi criada com sucesso. Faça login para utilizar o app',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                     Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                      builder: (_) => LoginPage()
                                    ));
                                            },
                                    )..show();
                    } on ApiResponseException catch (e) {
                      Navigator.of(context).pop();
                      if(e.payload != null && e.payload['message'] != null) {
                        String message = e.payload['message'];
                        final keys = (e.payload['errors'] as Map).keys.toList();
                        if(keys.length > 0) {
                          final errorFieldList = e.payload['errors'][keys[0]] as List;
                          message += '\n\n${errorFieldList[0].toString().toUpperCase()}';
                        }
                       AwesomeDialog(
                           context: context,
                           dialogType: DialogType.ERROR,
                           animType: AnimType.BOTTOMSLIDE,
                           title: 'Erro',
                           desc: message,
                           btnCancelOnPress: () {},
                           btnOkOnPress: () {},
                                    )..show();
                                }else {
                                    AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Erro',
                                    desc: e.toString(),
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                    )..show();                   
                      }       
                    } on SocketException {
                              AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Erro de conexão',
                                    desc:'Não foi possível se conectar com o servidor',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                    )..show();
                   
                    } on Exception catch(err){
                      print('ERRO');
                      print(err);
                       AwesomeDialog(
                           context: context,
                           dialogType: DialogType.ERROR,
                           animType: AnimType.BOTTOMSLIDE,
                           title: 'Erro',
                           desc:'Houve um erro desconhecido ao tentar criar a conta. Tente novamente em instantes',
                           btnCancelOnPress: () {},
                           btnOkOnPress: () {
                              Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                              builder: (_) => LoginPage()
                                    ));},
                                    )..show();}},
                        style:TextButton.styleFrom(
                        backgroundColor: Colors.green),
                  child: const Text('Registrar',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),              
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Text('Criar Conta', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: gooexColors.primary),
                    ),
                  ),
                ],
              ),
               const SizedBox(height: 25.0),
              _buildForm()
            ],
          ),
        ),
      ),
    );
  }
}

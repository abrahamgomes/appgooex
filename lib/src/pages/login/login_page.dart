import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/pages/criar_conta/criar_conta_page.dart';
import 'package:gooex_mobile/src/pages/entregador/lista_entregas_page.dart';
import 'package:gooex_mobile/src/pages/lista_ordens_servico/lista_ordens_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/login/resetar_senha_webview.dart';
import 'package:gooex_mobile/src/pages/transportador/listar_viagens/lista_viagens_page.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/stores/usuario_store.dart';
import 'package:gooex_mobile/src/widgets/confirmar_desembarque.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class LoginPage extends StatefulWidget {
  final bool isAdmin;
  LoginPage({this.isAdmin = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAdmin = false;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final UsuarioStore _usuarioStore = UsuarioStore();


  final TextEditingController _emailCtrl = TextEditingController(text: '');
  final TextEditingController _senhaCtrl = TextEditingController(text: '');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    isAdmin = widget.isAdmin;
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/logo.png'),
                    isAdmin ? Text('Administradores') : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Informe o e-mail';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                          hintText: 'E-mail', border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Informe a senha';
                        return null;
                      },
                      controller: _senhaCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Senha', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text('Esqueceu sua senha?',
                      style: TextStyle(color: gooexColors.primary)),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ResetarSenhaWebView()));
                    // String urlString =
                    //     'https://gooex.com.br/api/1.0/reset-password';
                    // if (await canLaunch(urlString)) {
                    //   await launch(
                    //       'https://gooex.com.br/api/1.0/reset-password');
                    // } else {
                    //   UtilDialog.presentAlert(context,
                    //       title: 'Erro',
                    //       message:
                    //           'Não foi possível abrir o link de redefinição.');
                    // }
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: gooexColors.primary,
                ),
                height: 50,
                child: TextButton(
                    onPressed: () async {
                      await _login(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )),
              ),
              SizedBox(
                height: 25.0,
              ),
              isAdmin
                  ? Container()
                  : Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Não possui conta?'),
                          TextButton(
                            child: Text('Cadastre-se',style: TextStyle(color: gooexColors.primary),),
                            onPressed: () {
                              Navigator.of(context)
                                // ..pop()
                                ..push(MaterialPageRoute(
                                    builder: (c) =>
                                        CriarContaPage(transportador: true)));
                            },
                          )
                        ],
                      ),
                    ),
              isAdmin
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('É usuário?'),
                          TextButton(
                            child: Text('Clique aqui'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (c) => LoginPage(
                                            isAdmin: false,
                                          )));
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    UtilDialog.presentLoader(context);
    String token;
    try {
      //token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Error to get token');
    }

    try {
      await loginStore.doLogin(_emailCtrl.text, _senhaCtrl.text);
      try {
        if (token != null) await _usuarioStore.atualizarTokenFCM(token);
      } catch (e) {
        print('Erro ao criar os tokens: $e');
      }

      if (loginStore.usuario.transportador) {
        await _showDialogOptionGeneral(
            context: context,
            isEntregador: loginStore.usuario.entregador,
            cliente: () {
              var user = loginStore.usuario;
              user.transportador = true;
              loginStore.setLoginType(LoginType.CLIENTE);
              loginStore.setUsuario(user);
              Navigator.of(context).pop();
            },
            entregador: () {
              Navigator.of(context).pop();
              loginStore.setLoginType(LoginType.ENTREGADOR);
            },
            transportador: () {
              Navigator.of(context).pop();
              loginStore.setLoginType(LoginType.TRANSPORTADOR);
            });
      }

      Navigator.of(context).pop();

      final page = loginStore.loggedAs == LoginType.TRANSPORTADOR
          ? ListaViagensPage()
          : (loginStore.loggedAs == LoginType.CLIENTE
              ? ListaOrdensServico()
              : ListaEntregasPage());

      var sp = await SharedPreferences.getInstance();
      var needConfirmation = sp.getBool('confirmar_desembarque');
      String iso = sp.getString('confirmacao_data');

      DateTime dataConfirmacao = iso != null ? DateTime.parse(iso) : null;

      if (needConfirmation != null && needConfirmation) {
        var duration = DateTime.now().difference(dataConfirmacao);
        // var duration = dataConfirmacao.difference(DateTime.now());
        var emailConfirmation = sp.getString('email_transportador');
        if (emailConfirmation != null &&
            emailConfirmation == loginStore.usuario.email && duration.inHours <= 13) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ConfirmarDesembarquePage()));

          return;
        }
      }

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => page));
    } on TimeoutException {
      Navigator.of(context).pop();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc: 'Não foi possível conectar-se ao servidor. Tente novamente em instantes',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
            
            },
            )..show();
    /*   UtilDialog.presentAlert(context,
          title: 'Erro',
          message:
              'Não foi possível conectar-se ao servidor. Tente novamente em instantes'); */
    } on ApiResponseException catch (e) {
      Navigator.of(context).pop();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc:e.message,
            btnCancelOnPress: () {},
            btnOkOnPress: () {
            
            },
            )..show();
      /* UtilDialog.presentAlert(context, title: 'Erro', message: e.message); */
    } catch (e) {   
      Navigator.of(context).pop();
       AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Erro',
            desc:'Não foi possível efetuar o login. Certifique-se de que informou corretamente as credenciais.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
            
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Erro',
          message:
              'Não foi possível efetuar o login. Certifique-se de que informou corretamente as credenciais.'); */
    }
  }

  Future<void> _showDialogOptionGeneral(
      {BuildContext context,
      Function cliente,
      Function transportador,
      Function entregador,
      bool isEntregador = false}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text('Selecione o tipo de conta'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Cliente'),
                          onTap: cliente,
                        ),
                        !isEntregador
                            ? Container()
                            : ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Entregador'),
                                onTap: entregador,
                              ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Transportador'),
                          onTap: transportador,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showDialogOption(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text('Selecione o tipo de conta'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Transportador'),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) =>
                                    CriarContaPage(transportador: true)));
                          },
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Cliente'),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) =>
                                    CriarContaPage(transportador: false)));
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'CANCELAR',
                    // style: greenText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}

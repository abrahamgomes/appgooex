import 'package:flutter/material.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/pages/entregador/lista_entregas_page.dart';
import 'package:gooex_mobile/src/pages/lista_ordens_servico/lista_ordens_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/transportador/listar_viagens/lista_viagens_page.dart';
import 'package:gooex_mobile/src/services/centro_distribuicao_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ConfirmarDesembarquePage extends StatefulWidget {
  @override
  _ConfirmarDesembarquePageState createState() =>
      _ConfirmarDesembarquePageState();
}

class _ConfirmarDesembarquePageState extends State<ConfirmarDesembarquePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/logo.png'),
                  ],
                ),
              ),
                Text(
                  'Você tem uma viagem programada em breve. Para isso, precisamos que você confirme, clicando no botão abaixo, para que um de nossos entregadores possa receber sua encomenda no aeroporto.',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 40,
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text('CONFIRMAR EMBARQUE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: _confirmarDesembarque,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarDesembarque() async {
    final page = loginStore.loggedAs == LoginType.TRANSPORTADOR
        ? ListaViagensPage()
        : (loginStore.loggedAs == LoginType.CLIENTE
            ? ListaOrdensServico()
            : ListaEntregasPage());

    var service = CentroDistribuicaoService();
    UtilDialog.presentLoader(context);
    try {
      await service.notificarEntregadores();
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove('confirmar_desembarque');
      await prefs.remove('confirmacao_data');
      await prefs.remove('email_transportador');
      Navigator.of(context).pop();
         AwesomeDialog(
                              context: context,
                               dialogType: DialogType.SUCCES,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Sucesso',
                                 desc: 'Os entregadores foram notificados de sua chegada',
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {  
                                   Navigator.of(context).pop();
                                   Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(builder: (_) => page));                            
                                 },
                              )..show();
      /* UtilDialog.presentAlert(context,
          title: 'Sucesso',
          message: 'Os entregadores foram notificados de sua chegada', ok: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => page));
      }); */
    } on Exception {
      Navigator.of(context).pop();
       AwesomeDialog(
         context: context,
           dialogType: DialogType.ERROR,
         animType: AnimType.BOTTOMSLIDE,
         title: 'Erro',
            desc: 'Houve um erro ao cofirmar o desembarque.',
             btnCancelOnPress: () {},
         btnOkOnPress: () {  
             Navigator.of(context).pop();
               Navigator.of(context)
             .pushReplacement(MaterialPageRoute(builder: (_) => page));                            
                                 },
                              ).show();
    /*   UtilDialog.presentAlert(context,
          title: 'Erro', message: 'Houve um erro ao cofirmar o desembarque.'); */
    }
    service = null;
  }
}

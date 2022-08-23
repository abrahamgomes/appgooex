import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/pages/entregador/lista_entregas_page.dart';
import 'package:gooex_mobile/src/pages/entregador/minhas_entregas.dart';
import 'package:gooex_mobile/src/pages/help/help_page.dart';
import 'package:gooex_mobile/src/pages/lista_ordens_servico/lista_ordens_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';

// import 'package:gooex/colors.dart' as gooexColors;
import 'package:gooex_mobile/colors.dart' as gooexColors;
import 'package:gooex_mobile/src/pages/login/login_page.dart';
import 'package:gooex_mobile/src/pages/manifesto/manifesto.dart';
import 'package:gooex_mobile/src/pages/pedidos/pedidos_page.dart';
import 'package:gooex_mobile/src/pages/transportador/listar_viagens/lista_viagens_page.dart';
import 'package:gooex_mobile/src/pages/transportador/pedidos_transportador/pedidos_transportador_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerApp extends StatefulWidget {

  final _textStyleTile = TextStyle(color: Colors.white);
  final bool isTransporter;
  final Map<LoginType, String> mapTypeLogin = {
    LoginType.CLIENTE: 'Cliente',
    LoginType.TRANSPORTADOR: 'Transportador',
    LoginType.ENTREGADOR: 'Entregador',
  };

  DrawerApp({this.isTransporter = false});

  @override
  _DrawerAppState createState() => _DrawerAppState();
}

// class _DrawerAppState extends State<DrawerApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }


// class DrawerApp extends StatelessWidget {
class _DrawerAppState extends State<DrawerApp> {

  @override
  void initState() {
    // _firebaseMessaging.configure(
    //   onMessage: (message) async {
    //     print('Drawer: $message');
    //   }
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = loginStore.usuario;

    String avatar =
        '${usuario.firstName[0]}${usuario.lastName[0]}'.toUpperCase();

    double numItemsAlternate = usuario.entregador ? 120 : 60;

    return Drawer(
      child: Container(
        color: gooexColors.secondary,
        child: ListView(
          children: <Widget>[
            Observer(
              builder: (_) {
                return UserAccountsDrawerHeader(
                  onDetailsPressed: !loginStore.canToggle
                      ? null
                      : () {
                          loginStore
                              .setDrawerToggle(!loginStore.drawerToggleOpen);
                        },
                  decoration: BoxDecoration(color: Color(0xff263445)),
                  accountEmail: Text(
                      '${loginStore.usuario.firstName} ${loginStore.usuario.lastName}'),
                  accountName: Text(widget.mapTypeLogin[loginStore.loggedAs]),
                  // accountName: Text(loginStore.usuario.transportador
                  //     ? 'Transportador'
                  //     : 'Cliente'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(avatar),
                  ),
                );
              },
            ),
            Observer(
              builder: (_) {
                if (!loginStore.canToggle) return Container();

                return AnimatedContainer(
                  height: loginStore.drawerToggleOpen ? numItemsAlternate : 0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        loginStore.loggedAs == LoginType.CLIENTE ? Container() : ListTile(
                          onTap: () {
                            var usuario = loginStore.usuario;
                            loginStore.setLoginType(LoginType.CLIENTE);
                            // usuario.transportador = !usuario.transportador;
                            loginStore.setUsuario(usuario);
                            // final page = loginStore.usuario.transportador
                            //     ? ListaViagensPage()
                            //     : ListaOrdensServico();
                            final page = ListaOrdensServico();
                            Navigator.of(context)
                              ..pop()
                              ..pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => page),
                                  (route) => false);
                          },
                          title: Text('Alternar para Cliente'),
                        ),

                        loginStore.loggedAs == LoginType.TRANSPORTADOR ? Container() : ListTile(
                          onTap: () {
                            var usuario = loginStore.usuario;
                            loginStore.setLoginType(LoginType.TRANSPORTADOR);
                            usuario.transportador = true;
                            loginStore.setUsuario(usuario);
                            final page = ListaViagensPage();
                            Navigator.of(context)
                              ..pop()
                              ..pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => page),
                                  (route) => false);
                          },
                          title: Text('Alternar para Transportador'),
                        ),

                        loginStore.loggedAs == LoginType.ENTREGADOR || !loginStore.usuario.entregador ? Container() : ListTile(
                          onTap: () {
                            var usuario = loginStore.usuario;
                            usuario.transportador = true;
                            loginStore.setUsuario(usuario);
                            loginStore.setLoginType(LoginType.ENTREGADOR);
                            final page = ListaEntregasPage();
                            Navigator.of(context)
                              ..pop()
                              ..pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => page),
                                  (route) => false);
                          },
                          title: Text('Alternar para Entregador'),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Observer(
              builder: (_) {
                bool _isTransporter = loginStore.loggedAs == LoginType.TRANSPORTADOR;
                return Column(
                  children: [
                    _isTransporter
                        ? ListTile(
                            title: Text(
                              'Viagens',
                              style: widget._textStyleTile,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (c) => ListaViagensPage()));
                            },
                          )
                        : Container(),
                    loginStore.loggedAs == LoginType.ENTREGADOR ? Container() :  ListTile(
                      title: Text(
                        'Pedidos',
                        style: widget._textStyleTile,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        final page = _isTransporter
                            ? PedidosTransportadorPage()
                            : PedidosPage();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (c) => page));
                      },
                    ),
                    _isTransporter || loginStore.loggedAs == LoginType.ENTREGADOR 
                        ? Container()
                        : ListTile(
                            title: Text(
                              'Ordem de Serviço',
                              style: widget._textStyleTile,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (c) => ListaOrdensServico()));
                            },
                          ),
                  ],
                );
              },
            ),
            loginStore.loggedAs == LoginType.ENTREGADOR ? ListTile(
              title: Text(
                'Entregas disponíveis',
                style: widget._textStyleTile,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => ListaEntregasPage()));
              },
            ) : Container(),

            loginStore.loggedAs == LoginType.ENTREGADOR ? ListTile(
              title: Text(
                'Minhas entregas',
                style: widget._textStyleTile,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => MinhasEntregasPage()));
              },
            ) : Container(),

            // MinhasEntregasPage

            ListTile(
              title: Text(
                'Manifesto',
                style: widget._textStyleTile,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => Manifesto()));
              },
            ),

            ListTile(
              title: Text(
                'Ajuda',
                style: widget._textStyleTile,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => HelpPage()));
              },
            ),
             ListTile(
              title: Text(
                'FAQ',
                style: widget._textStyleTile,
              ),
              onTap: () async {
                              const url = 'https://gooex.com.br/faq/';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text(
                'Sair',
                style: widget._textStyleTile,
              ),
              onTap: () {
                loginStore.doLogout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false);
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (c) => LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}

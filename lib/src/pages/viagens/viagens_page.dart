import 'package:flutter/material.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:intl/intl.dart';

import 'package:gooex_mobile/colors.dart' as gooexColors;

class ViagensPage extends StatefulWidget {
  @override
  _ViagensPageState createState() => _ViagensPageState();
}

class _ViagensPageState extends State<ViagensPage> {

  final df = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: DrawerApp(
        isTransporter: loginStore.usuario.transportador
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: gooexColors.secondary,
        onPressed: () async {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (c) => AddTravelPage()));
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Text(
                'Últimas viagens',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: gooexColors.primary),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            // StreamBuilder<List<ViagemModel>>(
            //   stream: travelsBloc.travelsStream,
            //   builder: (c, snapshot) {

            //     if(snapshot.hasData) {
            //       if(snapshot.data.length == 0) {
            //         return Center(
            //           child: Text('Nenhuma viagem ainda'),
            //         );
            //       }
            //       return _buildTravelslist(context, snapshot.data);
            //     }

            //     if (snapshot.hasError) {
            //       return Column(
            //         children: <Widget>[
            //           Text(
            //               'Erro ao listar as viagens. Verifique sua conexão com a internet e tente novamente'),
            //           FlatButton(
            //             child: Text('TENTAR NOVAMENTE'),
            //             onPressed: () {
            //               travelsBloc.listShippings();
            //             },
            //           )
            //         ],
            //       );
            //     }

            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }


  Widget _buildTravelslist(BuildContext context, List<dynamic> travels) {
    return Column(
      children: travels.map((travel) {
        return Card(
          elevation: 10.0,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (c) => ShippingDetailPage(),
              //     settings: RouteSettings(arguments: shipping)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Viagem ${travel.id}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                 
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
                        child: Text('${travel.origem.logradouro} - ${travel.origem.estado}'),
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
                        child: Text('${travel.destino.logradouro} - ${travel.destino.estado}'),
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
                        'Início em: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('${df.format(travel.dataInicio)}'),
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
                        'Término em: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text('${df.format(travel.dataFim)}'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
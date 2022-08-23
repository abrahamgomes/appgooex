import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/consts.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/pages/criar_ordem_servico/criar_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/detalhe_ordem_servico/detalhe_ordem_servico_page.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/pages/pagamento/pagamento_page.dart';
import 'package:gooex_mobile/src/pages/pedidos/filter_pedidos_page.dart';
import 'package:gooex_mobile/src/pages/transportadores_disponiveis/transportadores_disponiveis_page.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/app_scaffold.dart';
import 'package:gooex_mobile/src/widgets/drawer_app.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../colors.dart' as gooexColors;
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

// https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext

// enum StatusOrdemServico { CONFIRMACAO_PENDENTE, CONFIRMADA }








class Manifesto extends StatefulWidget {
  _ManifestoState createState() => _ManifestoState();
}

class _ManifestoState extends State<Manifesto> {
  
  OrdemServicoStore ordemServicoStore;

final data_hora_atual =  formatDate(DateTime.now(), [HH, ':', nn, ':', ss,'-',dd,'/', mm,'/',yyyy]);


_generatePdf() async {
final pw.Document doc = pw.Document();
final imageLogo = ( await rootBundle.load('assets/logo.png')).buffer.asUint8List();
List<pw.Widget> _buildContent(pw.Context context) {
final future = ordemServicoStore.ordensServico;
final List<OrdemServico> ordensServico = future.result;

  return [ 
    
     pw.Column( 
       crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                       //  ordensServico.map((ordemServico) {}
                           children:[
                             pw.SizedBox(height: 40),
                              pw.Row(
                                children: [ pw.Image(
                                pw.MemoryImage(imageLogo), width: 100),
                                pw.SizedBox(width: 50),
                                pw.Column(children: [
                                    pw.Text('Gooex Serviço de Logistica LTDA', 
                                    style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold )),

                                    pw.Text('CNPJ: 37.076.142/001-42', style: pw.TextStyle(fontSize: 15)), 

                                    pw.Text('Av santos Dumont, 2789, sala 1006, Aldeota, Fortaleza - CE', 
                                    style: pw.TextStyle(fontSize: 12)),
                                ])

                                ]),
                              pw.SizedBox(height: 20 ),
                              
                              pw.Table(     
                                defaultColumnWidth: const pw.FixedColumnWidth(150.0),                         
                                border: pw.TableBorder.all( width: 2),                                                            
                                children: [
                                  pw.TableRow(
                                    
                                    children: [
                                      pw.Container(
                                        color: PdfColors.blue,                                        
                                         child:
                                           pw.Center(
                                             child:
                                              pw.Padding(
                                          padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
                                          child: pw.Text('ID Ordem', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                                        )),
                                      ),
                                      pw.Container(
                                        color: PdfColors.blue,
                                          child: 
                                          pw.Center(
                                            child: 
                                            pw.Padding(
                                          padding: const pw.EdgeInsets.only(top:5, bottom: 5),
                                          child: pw.Text('Data Criação', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                                        )),
                                      ),
                                       pw.Container(
                                         color: PdfColors.blue,                                   
                                           child:
                                            pw.Center(
                                              child: 
                                              pw.Center(
                                                child:
                                                 pw.Padding(
                                           padding: const pw.EdgeInsets.only(top: 5, bottom: 6),
                                           child: pw.Text('Nome Cliente',
                                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.white)),
                                         ))),
                                       ),
                                        pw.Container(
                                          color: PdfColors.blue,
                                            child: pw.Center(child: pw.Center(child: pw.Padding(
                                            padding: const pw.EdgeInsets.only(top: 5, bottom: 6),
                                            child: pw.Text('Telefone',
                                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.white)),
                                          ))),
                                        ),
                                    ]
                                  )
                                ],
                              ),
                              pw.Table(     
                               defaultColumnWidth: const pw.FixedColumnWidth(150.0),                          
                               border: pw.TableBorder.all( width: 2),                              
                                children: ordensServico.map((ordemServico) {
                                  return pw.TableRow(
                                    children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(8.0),
                                        child: pw.Text('${ordemServico.uuid.substring(0, 8)}'),
                                      ),
                                      pw.Text('${ordemServico.data_hora_criacao.substring(0, 8)}\n${ordemServico.data_hora_criacao.substring(9)}'),
                                       pw.Padding(
                                         padding: const pw.EdgeInsets.all(8.0),
                                         child: pw.Text('${ordemServico.cliente["first_name"]}'),
                                       ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(8.0),
                                          child: pw.Text('${ordemServico.cliente["telefone"]}', style: pw.TextStyle(fontSize: 12),),
                                        )
                                    ]
                                  );
                                }
                              ).toList()
                              )]
                      )];
                      }

doc.addPage(
  pw.MultiPage(
    pageTheme: pw.PageTheme(margin: pw.EdgeInsets.zero),
    header: _buildHeader,
    footer: _buildPrice,
    build: (context) => _buildContent(context),
     )
);

await Printing.layoutPdf(
  onLayout: (PdfPageFormat format) async => doc.save());



   
}

pw.Widget _buildHeader(pw.Context context) {
  return pw.Center(child: pw.Column(children: [
    pw.SizedBox(height: 30),
    pw.Text('Manifesto')
  ]));
}
pw.Widget _buildPrice(pw.Context context) {
  return pw.Center(child: pw.Text('${data_hora_atual}'));
}



void refresh() async {
  await ordemServicoStore.listaOrdensServico(status: ordemServicoStore.statusAplicado);
}
  @override
  void initState() {
    ordemServicoStore = OrdemServicoStore();
    ordemServicoStore.listaOrdensServico(status: null);
    ordemServicoStore.setStatusAplicaco(null);
    
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: DrawerApp(
        isTransporter: loginStore.usuario.transportador,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        backgroundColor: gooexColors.primary,
        tooltip: 'Criar Ordem de Serviço',
        onPressed: () => _generatePdf()
        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    child: Row(
                      children: [                   
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              await ordemServicoStore.listaOrdensServico(status: ordemServicoStore.statusAplicado);
                            })
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  ' Manifesto de Ordens de Serviço',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: gooexColors.primary),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(height: 20,),
              Observer(
                builder: (_) {
                  final future = ordemServicoStore.ordensServico;
                  
                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      break;

                    case FutureStatus.fulfilled:
                      final List<OrdemServico> ordensServico = future.result;

                      if (ordensServico.length == 0) {
                        return Center(
                            child: Text('Nenhuma Ordem de Serviço ainda'));
                      }
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                       //  ordensServico.map((ordemServico) {}
                           children:[
                             Row(
                               children: [
                                 Image.asset('assets/logo.png', width: 100),
                                SizedBox(width: 35),
                                Column(
                                  children: [
                                    Text('Gooex Serviço de Logistica LTDA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold )),

                                    Text('CNPJ: 37.076.142/001-42', style: TextStyle(fontSize: 12)), 

                                    Text('Av santos Dumont, 2789, sala 1006 \n Aldeota, Fortaleza - CE', 
                                      style: TextStyle(fontSize: 12), textAlign: TextAlign.left,),
                                    
                                  ],
                                )
                               ],
                             ),
                             SizedBox(height: 20),
                              Table(                              
                                border: TableBorder.all( width: 2),                                                            
                                children: [
                                  TableRow(                                 
                                    children: [
                                      Container(
                                        color: Colors.blue,
                                        child: TableCell(
                                          child:
                                           Center(
                                             child:
                                              Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text('ID Ordem', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ))),
                                      ),
                                      Container(
                                        color: Colors.blue,
                                        child: TableCell(
                                          child: 
                                          Center(
                                            child: 
                                            Padding(
                                          padding: const EdgeInsets.only(top:5, bottom: 5),
                                          child: Text('Data Criação', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ))),
                                      ),
                                       Container(
                                         color: Colors.blue,
                                         child: TableCell(
                                           child:
                                            Center(
                                              child: 
                                              Center(
                                                child:
                                                 Padding(
                                           padding: const EdgeInsets.only(top: 5, bottom: 6),
                                           child: Text('Nome Cliente',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                         )))),
                                       ),
                                        Container(
                                          color: Colors.blue,
                                          child: TableCell(child: Center(child: Center(child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 6),
                                            child: Text('Telefone',
                                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                          )))),
                                        ),
                                    ]
                                  )
                                ],
                              ),


                              Table(                              
                               border: TableBorder.all( width: 2),    
                                
                                children: ordensServico.map((ordemServico) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${ordemServico.uuid.substring(0, 8)}'),
                                      ),
                                      Text('${ordemServico.data_hora_criacao.substring(0, 8)}\n${ordemServico.data_hora_criacao.substring(9)}'),
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text('${ordemServico.cliente["first_name"]}'),
                                       ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${ordemServico.cliente["telefone"]}', style: TextStyle(fontSize: 12),),
                                        )
                                    ]
                                  );
                                }
                              ).toList()



                              )]

                      );
                            
                      // return _buildSolicitationList(context, ordensServico);
                      break;
                  }

                  return Center(
                    child: Text('Nenhuma OS ainda.'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

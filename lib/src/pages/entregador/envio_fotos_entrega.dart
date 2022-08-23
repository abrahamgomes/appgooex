import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/models/ordem_servico_entregador.dart';
import 'package:gooex_mobile/src/stores/entregas_store.dart';
import 'package:gooex_mobile/src/widgets/card_picture.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EnvioFotosEntrega extends StatefulWidget {
  final OrdemServicoEntregador osEntregador;
  final bool isCustomer;

  EnvioFotosEntrega({this.osEntregador, this.isCustomer = false});

  @override
  _EnvioFotosEntregaState createState() => _EnvioFotosEntregaState();
}

class _EnvioFotosEntregaState extends State<EnvioFotosEntrega> {
  CameraDescription _cameraDescription;
  EntregaStore _entregaStore;


  @override
  void initState() {
    _entregaStore = EntregaStore();
    
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          ?.first;
      setState(() {
        _cameraDescription = camera;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _listaImagensPedido() {
    
  }

  Future<String> _openCamera(BuildContext context) async {
    final String imagePath = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TakePicture(
              camera: _cameraDescription,
            )));

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Entrega ${widget.osEntregador.uuid.substring(0, 8)}'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Clique nos cards para capturar a foto do produto',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              Observer(
                builder: (_) {
                  final future = _entregaStore.shippingImages;

                  switch(future.status) {

                    case FutureStatus.fulfilled:
                      final images = future.value;
                      return Container(
                        height: 260,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (_, index) {
                            final img = images[index];
                            return CardPicture(
                              imageUpload: img,
                              onTap: () async {
                                // clientes não enviam foto
                                if(widget.isCustomer) return;
                                final String imagePath =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => TakePicture(
                                                  camera: _cameraDescription,
                                                )));

                                if (imagePath == null) return;
                                setState(() {
                                  img.path = imagePath;
                                });

                                // _ordemServicoStore.updateImageContainer(index, img);
                              },
                            );
                          }
                        ),
                      );
                    break;

                    case FutureStatus.rejected:
                      return Text('Error');
                    break;

                    case FutureStatus.pending:
                    default:
                      return LinearProgressIndicator();
                    break;
                  }
                }
              ),

              // Observer(
              //   builder: (_) {
              //     final future = _ordemServicoStore.imagensPedido;

              //     if(future == null) return Container();

              //     switch (future.status) {
              //       case FutureStatus.pending:
              //         return LinearProgressIndicator();
              //         break;

              //       case FutureStatus.rejected:
              //         return Text('Error');
              //         break;

              //       case FutureStatus.fulfilled:
              //         final List<ImageUpload> images = future.value;
              //         // print(images[0].toJson());
              //         return Container(
              //           height: 260,
              //           padding: EdgeInsets.symmetric(horizontal: 10),
              //           child: ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             itemCount: images.length,
              //             itemBuilder: (_, index) {
              //               final img = images[index];

              //               return CardPicture(
              //                 imageUpload: img,
              //                 onTap: () async {
              //                   // clientes não enviam foto
              //                   if(widget.isCustomer) return;
              //                   final String imagePath =
              //                       await Navigator.of(context)
              //                           .push(MaterialPageRoute(
              //                               builder: (_) => TakePicture(
              //                                     camera: _cameraDescription,
              //                                   )));

              //                   if (imagePath == null) return;
              //                   setState(() {
              //                     img.path = imagePath;
              //                   });

              //                   // _ordemServicoStore.updateImageContainer(index, img);
              //                 },
              //               );
              //             },
              //           ),
              //         );
              //         break;
              //     }

              //     return Text('Hello world');
              //   },
              // ),
              SizedBox(
                height: 50,
              ),
              Observer(
                builder: (_) {
                  if (!_entregaStore.progressoUploadIsWorking) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(_entregaStore.progressoUploadTexto),
                        SizedBox(
                          height: 10,
                        ),
                        LinearProgressIndicator()
                      ],
                    ),
                  );
                  // return LinearProgressIndicator();
                },
              ),
              SizedBox(
                height: 18,
              ),
              Observer(
                builder: (_) {
                  if (_entregaStore.progressoUploadIsWorking) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 50,
                      child: widget.osEntregador.status > 7 || !_temFotoParaEnviar() ? Container() : RaisedButton(
                        onPressed: () async {
                          await _enviarFotos(context);
                        },
                        color: Colors.green,
                        child: Text(
                          'Enviar fotos',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }

  _temFotoParaEnviar() {
    // final fotosParaUpload = _ordemServicoStore.imagensPedido.value
    //     .where((img) =>
    //         !img.fromNetwork &&
    //         img.canEdit &&
    //         img.path != null &&
    //         img.path.isNotEmpty)
    //     .toList();
    // return fotosParaUpload.length > 0;
    return true;
  }

  Future<void> _enviarFotos(BuildContext context) async {
    final fotosParaUpload = _entregaStore.shippingImages.value
        .where((img) =>
            !img.fromNetwork &&
            img.canEdit &&
            img.path != null &&
            img.path.isNotEmpty)
        .toList();
  


    if (fotosParaUpload.length < 3) {
         AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Atenção',
            desc: 'Selecione as três fotos para fazer o envio.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Atenção',
          message:
              'Selecione as três fotos para fazer o envio.'); */
      return;
    }
    _entregaStore.setWorkingUpload(true);
    int total = fotosParaUpload.length;
    int current = 1;
    int errors = 0, success = 0;

    // UtilDialog.presentLoader(context);
    for (final img in fotosParaUpload) {
      _entregaStore.setProgressoUploadTexto('Enviando $current de $total');
      try {
        await _entregaStore.sendPicture(widget.osEntregador.uuid, img.path);
        success++;
        _entregaStore.setProgressoUploadTexto('Sucesso no envio');
      } catch (e) {
        errors++;
        _entregaStore.setProgressoUploadTexto('Erro no envio');
      }

      current++;
    }

    _entregaStore.setWorkingUpload(false);
    _listaImagensPedido();
    Navigator.of(context).pop();
    if (errors > 0) {
      AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Ocorreram erros',
            desc: 'Alguns dos arquivos não puderam ser enviados. Isso pode ocorrer por conta da sua conexão. Verifique se está tudo correto e tente novamente.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
   /*    UtilDialog.presentAlert(context,
          title: 'Ocorreram erros',
          message:
              'Alguns dos arquivos não puderam ser enviados. Isso pode ocorrer por conta da sua conexão. Verifique se está tudo correto e tente novamente.'); */
    }else {
       AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sucesso',
            desc: 'Todos os arquivos foram enviados com sucesso!',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
           
            },
            )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Sucesso',
          message:
              'Todos os arquivos foram enviados com sucesso!'); */
    }
  }
}

class TakePicture extends StatefulWidget {
  final CameraDescription camera;

  TakePicture({this.camera});

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen.
      Navigator.of(context).pop(path);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(imagePath: path),
      //   ),
      // );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enquadre o produto')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          await _takePicture(context);
        },
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

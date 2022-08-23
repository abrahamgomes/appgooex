import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gooex_mobile/src/components/util_dialogs.dart';
import 'package:gooex_mobile/src/models/image_upload.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/stores/ordem_servico_store.dart';
import 'package:gooex_mobile/src/widgets/card_picture.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UploadFoto extends StatefulWidget {
  final OrdemServico ordemServico;
  final bool isCustomer;

  UploadFoto({this.ordemServico, this.isCustomer = false});

  @override
  _UploadFotoState createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  CameraDescription _cameraDescription;
  OrdemServicoStore _ordemServicoStore;


  @override
  void initState() {
    _ordemServicoStore = OrdemServicoStore();
    _listaImagensPedido();
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
    _ordemServicoStore
        .listarImagensPedido(widget.ordemServico.uuid)
        .then((value) {
      final int rest = 3 - _ordemServicoStore.imagensPedido.value.length;
      print(rest);
      for (int i = 0; i < rest; i++) {
        _ordemServicoStore.addImageContainer();
      }
    });
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
          title: Text('OS ${widget.ordemServico.uuid.substring(0, 8)}'),
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
                  final future = _ordemServicoStore.imagensPedido;

                  if(future == null) return Container();

                  switch (future.status) {
                    case FutureStatus.pending:
                      return LinearProgressIndicator();
                      break;

                    case FutureStatus.rejected:
                      return Text('Error');
                      break;

                    case FutureStatus.fulfilled:
                      final List<ImageUpload> images = future.value;
                      // print(images[0].toJson());
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
                          },
                        ),
                      );
                      break;
                  }

                  return Text('Hello world');
                },
              ),
              SizedBox(
                height: 50,
              ),
              Observer(
                builder: (_) {
                  if (!_ordemServicoStore.progressoUploadIsWorking) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(_ordemServicoStore.progressoUploadTexto),
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
                  if (_ordemServicoStore.progressoUploadIsWorking) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 50,
                      child: !loginStore.usuario.transportador || widget.ordemServico.status == 2 || !_temFotoParaEnviar() ? Container() : RaisedButton(
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
    final fotosParaUpload = _ordemServicoStore.imagensPedido.value
        .where((img) =>
            !img.fromNetwork &&
            img.canEdit &&
            img.path != null &&
            img.path.isNotEmpty)
        .toList();
    return fotosParaUpload.length > 0;
  }

  Future<void> _enviarFotos(BuildContext context) async {
    final fotosParaUpload = _ordemServicoStore.imagensPedido.value
        .where((img) =>
            !img.fromNetwork &&
            img.canEdit &&
            img.path != null &&
            img.path.isNotEmpty)
        .toList();
    if (fotosParaUpload.length == 0) {
         AwesomeDialog(
                              context: context,
                               dialogType: DialogType.INFO_REVERSED,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Atenção',
                                 desc: 'Nenhuma foto foi selecionada para envio. As fotos exibidas acima já foram enviadas.',
                                 btnCancelOnPress: () {},
                                 btnOkOnPress: () {                              
                                 },
                              )..show();
     /*  UtilDialog.presentAlert(context,
          title: 'Atenção',
          message:
              'Nenhuma foto foi selecionada para envio. As fotos exibidas acima já foram enviadas.'); */
      return;
    }
    _ordemServicoStore.setWorkingUpload(true);
    int total = fotosParaUpload.length;
    int current = 1;
    int errors = 0, success = 0;

    print('${fotosParaUpload.length} para subir');
    // UtilDialog.presentLoader(context);
    for (final img in fotosParaUpload) {
      _ordemServicoStore.setProgressoUploadTexto('Enviando $current de $total');
      try {
        await _ordemServicoStore.sendPicture(widget.ordemServico.uuid, img.path);
        success++;
        _ordemServicoStore.setProgressoUploadTexto('Sucesso no envio');
      } catch (e) {
        errors++;
        _ordemServicoStore.setProgressoUploadTexto('Erro no envio');
      }

      current++;
    }

    _ordemServicoStore.setWorkingUpload(false);
    _listaImagensPedido();

    if (errors > 0) {
         AwesomeDialog(
              context: context,
            dialogType: DialogType.ERROR,
             animType: AnimType.BOTTOMSLIDE,
              title: 'Ocorreram erros',
                 desc: 'Alguns dos arquivos não puderam ser enviados. Isso pode ocorrer por conta da sua conexão. Verifique se está tudo correto e tente novamente.',
                    btnCancelOnPress: () {},
                 btnOkOnPress: () {                              
                                 },
                              )..show();
    /*   UtilDialog.presentAlert(context,
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
      /* UtilDialog.presentAlert(context,
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

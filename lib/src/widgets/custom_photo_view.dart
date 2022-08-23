import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomPhotoView extends StatelessWidget {
  final String url;

  CustomPhotoView({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: PhotoView(
            // enableRotation: true,
            minScale: .6,
            loadFailedChild: Center(
              child: Text('Falha ao carregar a imagem'),
            ),
        imageProvider: NetworkImage(url),
      )),
    );
  }
}

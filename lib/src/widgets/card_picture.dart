import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gooex_mobile/src/models/image_upload.dart';
import 'package:gooex_mobile/src/widgets/custom_photo_view.dart';

class CardPicture extends StatelessWidget {
  final Function onTap;
  final ImageUpload imageUpload;

  CardPicture({this.onTap, this.imageUpload});

  DecorationImage _getImage() {
    if (imageUpload.fromNetwork) {
      return DecorationImage(
          image: NetworkImage(imageUpload.foto), fit: BoxFit.fill);
    }

    return DecorationImage(
        image: FileImage(File(imageUpload.path)), fit: BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 12,
      child: InkWell(
        onTap: imageUpload.canEdit ? onTap : null,
        child: imageUpload.path != null || imageUpload.fromNetwork
            ? InkWell(
                onTap: () {
                  Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (_) => CustomPhotoView(
                        url: imageUpload.foto,
                      ))
                    );
                },
                child: Container(
                  height: 260,
                  width: size.width * .7,
                  decoration: BoxDecoration(image: _getImage()),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                width: size.width * .7,
                height: 260,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicionar foto',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333),
                          fontSize: 18),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.image,
                        size: 35,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

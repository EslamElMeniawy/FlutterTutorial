import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, this.product);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });

      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Pick an Image',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              FlatButton(
                onPressed: () => _getImage(context, ImageSource.camera),
                textColor: primaryColor,
                child: Text('Use Camera'),
              ),
              FlatButton(
                onPressed: () => _getImage(context, ImageSource.gallery),
                textColor: primaryColor,
                child: Text('Use Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;
    Widget previewImage = Text('Please pick an image');

    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 300.0,
        alignment: Alignment.topCenter,
      );
    } else if (widget.product != null) {
      previewImage = Image.network(
        widget.product.imagePath,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 300.0,
        alignment: Alignment.topCenter,
      );
    }

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: accentColor,
            width: 2.0,
          ),
          onPressed: () => _openImagePicker(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: accentColor,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Add Image',
                style: TextStyle(
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        previewImage,
      ],
    );
  }
}

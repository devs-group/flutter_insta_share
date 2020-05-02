import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:instashare/instashare.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Instashare'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('1. Pick A Photo:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FlatButton(
                      onPressed: () => _getImage(),
                      child: Text('Pick Photo'),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
              if (_image != null)
                Image.file(
                  _image,
                  height: 160,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('2. Share To Instagram:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FlatButton(
                      onPressed: () => _share(),
                      child: Text('Share To Instagram'),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void _share() {
    Instashare.shareToFeedInstagram("image/*", _image.path);
  }
}

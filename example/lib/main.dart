import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instashare/instashare.dart';
import 'package:instashare/instashare_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Map<int, String> _errors = {
    1: "There was an error writing your file.",
    2: "There was an error saving to your album.",
    3: "Instagram is not installed on your device. Please install it first before sharing.",
    4: "We need access to your photo library otherwise you won`t be able to share your image."
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldkey,
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
                      onPressed: () {
                        _getImage().catchError((_) {
                          _scaffoldkey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Sorry we can't access your gallery. Please allow access to the gallery first."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      },
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
                      onPressed: _image != null ? () => _share() : null,
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

  void _share() async {
    int result = await Instashare.shareToFeedInstagram("image/*", _image.path);
    if (result != InstashareStatus.Done.index) {
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text(_errors[result]),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

import 'package:ImplementacionFlutter/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Acceso a cámara y despliegue de fotos y videos",
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
          accentColor: Colors.grey),
      home: LoginPage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile; //imagen seleccionada de galería
  File _imageFileCamera; //imagen tomada de camara
  File _videoFile; //video seleccionado de galería
  VideoPlayerController _controller;
  File _videoFileCamera; //video grabado de camara

  void _pickImageFromGallery() async {
    var picture = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imageFile = File(picture.path);
    });
  }

  void _openCamera() async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    if (picture != null && picture.path != null) {
      GallerySaver.saveImage(picture.path);
    }
    setState(() {
      _imageFileCamera = File(picture.path);
    });
  }

  void _pickVideoFromGallery() async {
    var video = await ImagePicker().getVideo(source: ImageSource.gallery);
    _videoFile = File(video.path);
    _controller = VideoPlayerController.file(_videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _openVideo() async {
    var video = await ImagePicker().getVideo(source: ImageSource.camera);
    if (video != null && video.path != null) {
      GallerySaver.saveVideo(video.path);
    }
    setState(() {
      _videoFileCamera = File(video.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        if (_imageFile != null) Image.file(_imageFile),
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 8, 60, 8),
          child: RaisedButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              color: Colors.black,
              child: Text("Elige una Imagen de Galería")),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(60, 0, 60, 8),
          child: RaisedButton(
            onPressed: () {
              _openCamera();
            },
            color: Colors.black,
            child: Text("Toma una Foto"),
          ),
        ),
        if (_videoFile != null)
          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(60, 0, 60, 8),
          child: RaisedButton(
            onPressed: () {
              _pickVideoFromGallery();
            },
            color: Colors.black,
            child: Text("Elige un Video de Galería"),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(60, 0, 60, 8),
          child: RaisedButton(
            onPressed: () {
              _openVideo();
            },
            color: Colors.black,
            child: Text("Graba un Video"),
          ),
        ),
      ])),
    );
  }
}

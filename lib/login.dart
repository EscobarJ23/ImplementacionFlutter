import 'package:ImplementacionFlutter/main.dart';
import 'package:ImplementacionFlutter/registro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = new GlobalKey<FormState>();
  String usu = null;
  String contra = null;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 15.0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            //endDrawer: DrawerWicom(),
            appBar: AppBar(
                elevation: 20,
                title: Text(widget.title),
                centerTitle: true,
                leading: new Container(
                  child: Icon(Icons.face),
                )),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 40.0, top: 50.0),
                    child: Text(
                      'Bienvenid@!',
                      style: TextStyle(fontSize: 20),
                    )),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                  width: 300.0,
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  child: TextFormField(
                                    validator: validateEmail,
                                    controller: _emailController,
                                    keyboardType: (TextInputType.emailAddress),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25.0),
                                          ),
                                        ),
                                        filled: true,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[800]),
                                        hintText: "Correo Electronico",
                                        fillColor: Colors.white70),
                                  )),
                              Container(
                                  width: 300.0,
                                  child: TextFormField(
                                    validator: validarContra,
                                    controller: _passwordController,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25.0),
                                          ),
                                        ),
                                        filled: true,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[800]),
                                        hintText: "Contraseña",
                                        fillColor: Colors.white70),
                                  )),
                              Container(
                                margin: const EdgeInsets.only(top: 40.0),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  minWidth: 200.0,
                                  height: 40.0,
                                  onPressed: () {
                                    usu = null;
                                    contra = null;
                                    if (formKey.currentState.validate()) {
                                      _validEmail(_emailController.text,
                                              _passwordController.text)
                                          .then((value) {
                                        if (value == "OK") {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyHomePage(
                                                      title:
                                                          'Acceso a cámara y despliegue de fotos y videos')),
                                              (route) => false);
                                        } else {
                                          if (value == "Contraseña invalida") {
                                            contra = value;
                                          } else {
                                            usu = value;
                                          }
                                          formKey.currentState.validate();
                                        }
                                      });
                                    }
                                  },
                                  color: Colors.blue,
                                  child: Text('Ingresar',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          )),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'No tienes cuenta? Registrate',
                                style: linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Registro()),
                                    );
                                  })
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
                // This trailing comma makes auto-formatting nicer for build methods.
                )));
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El correo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      String a = usu;
      return a;
    }
  }

  Future<String> _validEmail(email, password) async {
    authProblems errorType;
    String res = null;
    try {
      var us = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "OK";
    } catch (e) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          res = "Usuario no encontrado";
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          res = "Contraseña invalida";
          break;
        default:
          print('Case ${e.message} is not yet implemented');
      }
    }
    print("El Error es: $errorType");
    return res;
  }

  String validarContra(String value) {
    String pattern = r"^[A-Za-z0-9]*$";
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "La contraseña es necesaria";
    } else if (!regExp.hasMatch(value)) {
      return "No se admiten espacios";
    } else {
      String a = contra;
      return a;
    }
  }
}

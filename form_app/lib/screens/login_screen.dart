import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:form_app/components/loader_component.dart';
import 'package:form_app/helpers/constans.dart';
import 'package:form_app/models/token.dart';
import 'package:form_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;

  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF120E43),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40,),
                  _showLogo(),
                  SizedBox(height: 20, width: 40,),
                  Center(
                      child: Text(
                        '"Form app" es una aplicación en donde los estudiantes del ITM dan su calificación acerca de lo aprendido en el curso Programación Distribuida.',
                        style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
                      ),
                  ),     
                  SizedBox(height: 20,),
                _showButtons(),
                ],
              ),
            ),
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...') : Container(),
        ],
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/form_logo.png'),
      width: 300,
      fit: BoxFit.fill,
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          _showFacebookLoginButton(),
        ],
      ),
    );
  }


  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }


  Widget _showFacebookLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _loginFacebook(), 
            icon: FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ), 
            label: Text('Iniciar sesión con Facebook'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF3B5998),
              onPrimary: Colors.white
            )
          )
        )
      ],
    );
  }

  void _loginFacebook() async {
    setState(() {
      _showLoader = true;
    });

    await FacebookAuth.i.logOut();
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );

    if (result.status != LoginStatus.success) {
      setState(() {
        _showLoader = false;
      });
 
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Hubo un problema al obtener el usuario de Facebook, por favor intenta más tarde.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    final requestData = await FacebookAuth.i.getUserData(
      fields: "email, name, picture.width(800).heigth(800), first_name, last_name",
    );

    var picture = requestData['picture'];
    var data = picture['data'];

    Map<String, dynamic> request = {
      'email': requestData['email'],
      'id': requestData['id'],
      'loginType': 2,
      'fullName': requestData['name'],
      'photoURL': data['url'],
      'firtsName': requestData['first_name'],
      'lastName': requestData['last_name'],
    };

    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Account/SocialLogin');
    var bodyRequest = jsonEncode(request);
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
      body: bodyRequest,
    );

    setState(() {
      _showLoader = false;
    });

    if(response.statusCode >= 400) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'El usuario ya inció sesión previamente por email o por otra red social.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    var body = response.body;

    if (_rememberme) {
      _storeUser(body);
    }

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen(token: token,)
      )
    );
  }
}
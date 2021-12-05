import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_app/models/final.dart';
import 'package:form_app/models/response.dart';
import 'package:form_app/models/user.dart';
import 'package:form_app/screens/final_screen.dart';
import 'package:form_app/screens/final_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:form_app/models/token.dart';
import 'package:form_app/screens/login_screen.dart';
import 'package:form_app/components/loader_component.dart';
import 'package:form_app/helpers/api_helper.dart';



class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programación Distribuida'),
        backgroundColor: Colors.black,
      ),
      body: _getBody(),
      drawer: widget.token.user.userType == 0 
        ? _getMechanicMenu() 
        : _getCustomerMenu(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                imageUrl: widget.token.user.imageFullPath,
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                height: 300,
                width: 300,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/form_logo.png'),
                  fit: BoxFit.cover,
                  height: 300,
                  width: 300,
                ),
              )
            ),
            SizedBox(height: 30,),
            Center(
              child: Text(
                'Bienvenid@ ${widget.token.user.fullName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 30,),
            _showFillFormButton(),     
          ],
        ),
      ),
    );
  }

  Widget _getMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/form_logo.png'),
            )
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => _logOut(),
          ),
        ],
      ),
    );
  }

  Widget _getCustomerMenu() {
     return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/form_logo.png'),
            )
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => _logOut(),
          ),
        ],
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => LoginScreen()
      )
    ); 
  }

  Widget _showFillFormButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _goToFinals(), 
            icon: FaIcon(
              FontAwesomeIcons.fileAlt,
              color: Colors.white,
            ), 
            label: Text('Ir a Encuesta'), 
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF8D3DAF),
              onPrimary: Colors.white
            )
          )
        )
      ],
    );
  }

  void _goToFinals() async {
    String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => FinalInfoScreen(token: widget.token)
      )
    );
    if (result == 'yes') {
    }
  }

}



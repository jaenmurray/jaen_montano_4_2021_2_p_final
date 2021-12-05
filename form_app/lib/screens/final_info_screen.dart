import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_app/models/final.dart';
import 'package:form_app/screens/final_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:form_app/components/loader_component.dart';
import 'package:form_app/helpers/api_helper.dart';
import 'package:form_app/models/response.dart';
import 'package:form_app/models/token.dart';
import 'package:form_app/models/user.dart';

class FinalInfoScreen extends StatefulWidget {
  final Token token;

  FinalInfoScreen({required this.token});

  @override
  _FinalInfoScreenState createState() => _FinalInfoScreenState();
}

class _FinalInfoScreenState extends State<FinalInfoScreen> {
  bool _showLoader = false;
  late Final _final;


  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      )
    );
  }

  Widget _showUserInfo() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
               width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(                      
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft, 
                      colors: [
                        Color(0xffB2BABD),
                        Color(0xffDEFAE8),
                      ],
                    ),
                    border: Border.all(
                      style: BorderStyle.solid, color: Colors.grey
                    ),
                      borderRadius: BorderRadius.circular(15),                         
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(16.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded( 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              'Calificación',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                        RatingBarIndicator(
                        rating: _final.qualification.toDouble(),
                        itemBuilder: (
                          context, 
                          index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 50.0,
                          unratedColor: Colors.amber.withAlpha(50),
                        direction:  Axis.horizontal,
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Fecha Encuesta: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17.0),
                            ),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    _final.date,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 5,),
                             ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Email: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17.0),
                            ),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    _final.email.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 5,),
                             ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Que te gustó del curso: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17.0),
                            ),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    _final.theBest.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 5,),
                             ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Que no te gustó del curso: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17.0),
                            ),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    _final.theWorst.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 5,),
                             ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Que recomendarías: ',  
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17.0),
                            ),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    _final.remarks.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 5,),
                             ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _getInfo() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response = await ApiHelper.getFinals(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    setState(() {
      _final = response.result;
    });
  }

   Widget _getContent() {
    return _final==null
      ? _noContent()
      : _Content();
  }

 Widget _Content() {

    setState(() {
      _showLoader = false;
    });

    return Column(
    children: <Widget>[
       _showUserInfo(),
       _showEditInfoButton()
      ],
    );
 }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'El usuario no tiene vehículos registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _showEditInfoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () => _fillFinal(),
                label: Text('Editar Encuesta'),
                icon: FaIcon(
                   FontAwesomeIcons.fileAlt,
                    color: Colors.white,
                ),
                backgroundColor: Color(0xFF8D3DAF),
              ),
            ]
          ),
        ),
      ],
    );
  }

  void _fillFinal() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalScreen(token: widget.token)
      )
    );

    _getInfo();

  }

}
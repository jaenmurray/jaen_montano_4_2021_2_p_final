import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_app/models/user.dart';
import 'package:intl/intl.dart';

import 'package:form_app/components/loader_component.dart';
import 'package:form_app/helpers/api_helper.dart';
import 'package:form_app/models/final.dart';
import 'package:form_app/models/response.dart';
import 'package:form_app/models/token.dart';

class FinalScreen extends StatefulWidget {
  final Token token;


  FinalScreen({required this.token});

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  bool _showLoader = false;
  double _userRating = 1.0;

  late final _ratingController;
  late double _rating;
  double _initialRating = 1.0;

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _qualification = '';
  String _qualificationError = '';
  bool _qualificationShowError = false;
  TextEditingController _qualificationController = TextEditingController();

  String _theBest = '';
  String _theBestError = '';
  bool _theBestShowError = false;
  TextEditingController _theBestController = TextEditingController();

  String _theWorst = '';
  String _theWorstError = '';
  bool _theWorstShowError = false;
  TextEditingController _theWorstController = TextEditingController();

  String _remarks = '';
  String _remarksError = '';
  bool _remarksShowError = false;
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ratingController = TextEditingController(text: '1.0');
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Nueva encuesta'
        ),
        backgroundColor: Colors.black,
      ),
      body: new SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 5,),
              _showEmail(),
              SizedBox(height: 5,),
              _showTheBest(),
              SizedBox(height: 5,),
              _showTheWorst(),
              SizedBox(height: 5,),
              _showRemarks(),
              SizedBox(height: 5,),
              SizedBox(height: 5,),
              _showStarsBar(),
              _showQualification(),
              SizedBox(height: 5,),
              _showButtons(),
            ],
          ),
        ),
      );
  }

  
  

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'Ingresa tu email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showTheBest() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _theBestController,
        decoration: InputDecoration(
          hintText: 'Ingresa Lo que más te gustó del curso...',
          labelText: 'Danos tu opinión',
          errorText: _theBestShowError ? _theBestError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theBest = value;
        },
      ),
    );
  }

  Widget _showTheWorst() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _theWorstController,
        decoration: InputDecoration(
          hintText: 'Ingresa Lo que menos te gustó del curso...',
          labelText: 'Desahogate',
          errorText: _theWorstShowError ? _theWorstError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theWorst = value;
        },
      ),
    );
  }

  Widget _showRemarks() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _remarksController,
        decoration: InputDecoration(
          hintText: '¿Que mejorarias en el curso?',
          labelText: 'Danos tu opinión',
          errorText: _remarksShowError ? _remarksError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _remarks = value;
        },
      ),
    );
  }

  Widget _showQualification() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _ratingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Ingrese Calificación',
          labelText: 'Calificacion',
          suffixIcon: MaterialButton(
          onPressed: () {
            _userRating = double.parse(_ratingController.text ?? '0.0');
            setState(() {});
          },
          child: Text('Calificación'),
          ),
        ),
      ),
    );
  }

  Widget _showStarsBar(){
    return RatingBar.builder(
      initialRating: _initialRating,
      itemCount: 5,
      itemSize: 50.0,
      unratedColor: Colors.amber.withAlpha(50),
      direction:  Axis.horizontal,
      itemBuilder: (context, _) => Icon(
        Icons.star,
            color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _ratingController.text = rating.toString();
          _userRating = double.parse(_ratingController.text);
          _qualification = _userRating.toString();
        });
        
      },
          updateOnDrag: true,
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF120E43);
                  }
                ),
              ),
              onPressed: () => _save(),
            )
          ),
        ],
      ),
    );
  }



  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un correo.';
    } else if(!_email.contains('.itm.')){
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un correo con dominio del ITM.';
    }else{
       _emailShowError = false;
    }

    if (_theBest.isEmpty) {
      isValid = false;
      _theBestShowError = true;
      _theBestError = 'Debes ingresar algo.';
    } else {
      _theBestShowError = false;
    }

    if (_theWorst.isEmpty) {
      isValid = false;
      _theWorstShowError = true;
      _theWorstError = 'Debes ingresar algo.';
    } else {
      _theWorstShowError = false;
    }

    int nota = _userRating.toInt();

    if (_qualification.isEmpty) {
      isValid = false;
      _qualificationShowError = true;
      _qualificationError = 'Debes ingresar una calificación.';
    } else {
      if (nota <= 0 || nota > 5 ) {
        isValid = false;
        _qualificationShowError = true;
        _qualificationError = 'Debes ingresar una calificación mayor a cero y menor que 5.';
      } else {
        _qualificationShowError = false;
      }
    }

    if (_remarks.isEmpty) {
      isValid = false;
      _remarksShowError = true;
      _remarksError = 'Debes ingresar algo.';
    } else {
      _remarksShowError = false;
    }

    setState(() { });
    return isValid;
  }

  _save() async {

    if (!_validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

   _saveRecord();

  }

  void _saveRecord() async {
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

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String filldate = formatter.format(now);

    Map<String, dynamic> request = {
      'id': 0,
      'date': filldate,
      'email': _email,
      'qualification': _userRating.toInt(),
      'theBest': _theBest,
      'theWorst': _theWorst,
      'remarks': _remarks,
    };

    Response response = await ApiHelper.post(
      '/api/Finals/', 
      request, 
      widget.token
    );

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

    Navigator.pop(context, 'yes');
  }


}
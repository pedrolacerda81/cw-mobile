//Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pages Imports
import './home.dart';
import '../helpers/authHelper.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {'email': null, 'password': null};

  Text _buildTitle() {
    return Text(
      'Entrar',
      style: TextStyle(
          fontSize: 38.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5),
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Theme.of(context).accentColor,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20.0),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          hintText: 'E-mail',
          hintStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 20.0,
          ),
          border:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Theme.of(context).accentColor))),
      style: TextStyle(fontSize: 20.0, color: Colors.grey[200]),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Por favor, insira um e-mail válido.';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      cursorColor: Theme.of(context).accentColor,
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20.0),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          hintText: 'Senha',
          hintStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 20.0,
          ),
          border:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Theme.of(context).accentColor))),
      style: TextStyle(fontSize: 20.0, color: Colors.grey[200]),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Por favor, insira sua senha.';
        } else if (value.length < 6) {
          return 'Senha deve conter ao menos 6 caracteres.';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Column _buildLoginButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 45.0,
          child: RaisedButton(
            elevation: 2.0,
            color: Theme.of(context).accentColor,
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              this.isLoading = true;
              await _submitForm();
              setState(() {
                this.isLoading = false;
              });
            },
          ),
        )
      ],
    );
  }

  Future<bool> _submitForm() async {
    debugPrint('Entrou na _submitForm');
    if (!_formKey.currentState.validate()) {
      return false;
    }
    _formKey.currentState.save();

    bool loginResponse =
        await AuthHelper.login(_formData['email'], _formData['password']);
    if (loginResponse) {
      bool isLogged = await AuthHelper.me();
      if (isLogged) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } else {
        _showSnackBar();
      }
    } else {
      _showSnackBar();
    }
    return true;
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.report,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'Ocorreu um erro! Tente novamente.',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      duration: Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor.withAlpha(1000),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
      decoration: _buildContainerDecoration(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTitle(),
            SizedBox(
              height: 40.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 35.0,
                  ),
                  isLoading
                      ? SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ))
                      : _buildLoginButton(),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Colors.grey[200], fontSize: 16.0),
                    ),
                    onPressed: () {
                      debugPrint('Forgot Password button pressed');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

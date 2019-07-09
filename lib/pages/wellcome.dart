// Packages Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Pages Imports
import './auth.dart';

class WellCome extends StatelessWidget {
  BoxDecoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor.withAlpha(1000),
      ]),
    );
  }

  Column _buildLoginButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 40.0,
          child: RaisedButton(
            elevation: 2.0,
            color: Colors.white,
            child: Text(
              'ENTRAR',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => Auth()));
            },
          ),
        )
      ],
    );
  }

  Column _buildCapturaButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 40.0,
          child: RaisedButton(
            elevation: 2.0,
            color: Theme.of(context).accentColor,
            child: Text(
              'CONHEÇA O CAPTURAWEB',
              style: TextStyle(
                  fontSize: 18.0, color: Theme.of(context).primaryColor),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              debugPrint('Captura Button pressed');
              _launchCapturawebUrl();
            },
          ),
        )
      ],
    );
  }

  Column _buildCodiloButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 40.0,
          child: RaisedButton(
            elevation: 2.0,
            color: Color.fromRGBO(53, 29, 103, 1),
            child: Text(
              'CONHEÇA A CODILO',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              debugPrint('Codilo Button pressed');
              _launchCodiloUrl();
            },
          ),
        )
      ],
    );
  }

  Row _buildWellcomeTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Bem-vindo(a) ao Capturaweb.',
          style: TextStyle(
              fontSize: 26.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3),
        ),
      ],
    );
  }

  void _launchCapturawebUrl() async {
    const url = 'https://www.capturaweb.com.br/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não consegui acessar $url';
    }
  }

  void _launchCodiloUrl() async {
    const url = 'https://www.codilo.com.br/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não consegui acessar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
      decoration: _buildContainerDecoration(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(child: Image.asset('assets/images/logo-gray.png')),
            Container(
              child: Column(
                children: <Widget>[
                  _buildWellcomeTitle(context),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'O Capturaweb é a API que vai revolucionar a forma como o seu sistema de informação captura dados públicos no Brasil inteiro!',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18.0,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  _buildCodiloButton(context),
                  SizedBox(height: 15.0),
                  _buildCapturaButton(context),
                  SizedBox(height: 15.0),
                  _buildLoginButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Packages Imports
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

//Pages Imports
import '../pages/home.dart';
import '../pages/wellcome.dart';

class Splash extends StatefulWidget {
  Splash({
    Key key,
    this.isLogged,
  }) : super(key: key);
  final bool isLogged;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((_) async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => widget.isLogged ? Home() : WellCome()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 100,
            width: 100,
            child: FlareActor(
              'assets/animations/captura02.flr',
              animation: 'spin',
            ),
          ),
        ],
      ),
    );
  }
}

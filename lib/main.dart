//Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Pages Imports
import './pages/splash.dart';
import './helpers/authHelper.dart';

void main() async {
  await DotEnv().load('.env');
  bool isLogged;
  Map<String, String> authPrefs = await AuthHelper.getAuthPreferences();
  if (authPrefs['token'] == null) {
    isLogged = false;
  } else {
    isLogged = await AuthHelper.me();
  }
  runApp(CapturaWebApp(logged: isLogged));
}

//TODO: revisar splash screen: Android e iOS

class CapturaWebApp extends StatefulWidget {
  CapturaWebApp({
    Key key,
    this.logged,
  }) : super(key: key);

  final bool logged;

  @override
  State<StatefulWidget> createState() {
    return _CapturaWebAppState();
  }
}

class _CapturaWebAppState extends State<CapturaWebApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('pt', 'BR'),
        ],
        title: 'CapturaWeb',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(68, 81, 86, 1.0),
          accentColor: Color.fromRGBO(44, 235, 148, 1.0),
        ),
        routes: {
          '/': (BuildContext context) => Splash(
                isLogged: widget.logged,
              ),
        });
  }
}

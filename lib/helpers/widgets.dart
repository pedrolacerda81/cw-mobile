//Packages Imports
import 'package:flutter/material.dart';

//Pages Imports
import '../helpers/authHelper.dart';
import '../pages/home.dart';

class CapturaDrawer {
  static Drawer buildDrawer(BuildContext context, String name, String email) {
    String user = name;
    String userEmail = email;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withAlpha(1000),
          ]),
        ),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Image.asset('assets/images/app-foreground.png')),
              accountName: Text(
                user,
                style: TextStyle(
                    fontSize: 22.0, color: Theme.of(context).primaryColor),
              ),
              accountEmail: Text(
                userEmail,
                style: TextStyle(
                    fontSize: 18.0, color: Theme.of(context).primaryColor),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).accentColor.withAlpha(1000),
                ]),
              ),
            ),
            ListTile(
              title: Text(
                'Consumo',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 16.0),
              ),
              leading: Icon(
                Icons.timeline,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
              },
            ),
            Divider(),
            ListTile(
                title: Text(
                  'Sair',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 16.0),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onTap: () async {
                  await AuthHelper.logout(context);
                }),
          ],
        ),
      ),
    );
  }

  static SizedBox _buildPreLabel(double h, double w, Color c1, Color c2) {
    return SizedBox(
      height: h,
      width: w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(colors: [
            c1,
            c2,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
    );
  }

  static Drawer buildLoadingDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withAlpha(1000),
          ]),
        ),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 40.0),
              ),
              accountName: _buildPreLabel(
                  8.0, 20.0, Colors.greenAccent[100], Colors.greenAccent[700]),
              accountEmail: _buildPreLabel(
                  8.0, 40.0, Colors.greenAccent[100], Colors.greenAccent[700]),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).accentColor.withAlpha(1000),
                ]),
              ),
            ),
            ListTile(
              title: Text(
                'Consumo',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 16.0),
              ),
              leading: Icon(
                Icons.timeline,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
              },
            ),
            Divider(),
            ListTile(
                title: Text(
                  'Sair',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 16.0),
                ),
                leading: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onTap: () async {
                  await AuthHelper.logout(context);
                }),
          ],
        ),
      ),
    );
  }
}

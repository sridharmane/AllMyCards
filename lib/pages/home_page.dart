import 'package:all_my_cards/models/g_sheets.dart';
import 'package:all_my_cards/models/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All My Cards'),
      ),
      body: Center(
        child: Center(
            child: Column(
          children: [
            Icon(Icons.home),
            TextButton.icon(
              onPressed: () {
                Auth().init();
              },
              icon: Icon(Icons.security_rounded),
              label: Text('Authenticate'),
            ),
            TextButton.icon(
              onPressed: () {
                GSheetsAPI().getAll();
              },
              icon: Icon(Icons.get_app),
              label: Text('Get All'),
            ),
            TextButton.icon(
              onPressed: () {
                GSheetsAPI().get();
              },
              icon: Icon(Icons.get_app),
              label: Text('Get'),
            ),
            TextButton.icon(
              onPressed: () {
                GSheetsAPI().create();
              },
              icon: Icon(Icons.add),
              label: Text('Create'),
            ),
            TextButton.icon(
              onPressed: () {
                Auth().signIn();
              },
              icon: Icon(Icons.security_rounded),
              label: Text('Sign In'),
            ),
            TextButton.icon(
              onPressed: () {
                Auth().googleSignIn();
              },
              icon: Icon(Icons.security_rounded),
              label: Text('Google Sign In'),
            ),
          ],
        )),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

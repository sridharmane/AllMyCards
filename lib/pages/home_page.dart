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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All My Cards'),
      ),
      body: Center(
        child: Icon(Icons.home),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

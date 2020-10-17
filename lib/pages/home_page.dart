import 'package:all_my_cards/widgets/summary_view.dart';
import 'package:all_my_cards/widgets/welcome_message.dart';
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
      body: ListView(
        children: [
          WelcomeMessage(),
          SummaryView(),
        ],
      ),
    );
  }
}

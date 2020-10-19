import 'package:all_my_cards/pages/manage_card_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/profile_menu.dart';
import 'package:all_my_cards/widgets/summary_view.dart';
import 'package:all_my_cards/widgets/welcome_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ManageCardPage()));
            },
            icon: Icon(Icons.add),
            tooltip: 'Add Card',
          ),
          ProfileMenu(),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 3),
          child: Consumer<AppState>(
            builder: (_, state, __) {
              if (state.isLoading) {
                return LinearProgressIndicator();
              }
              return SizedBox();
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              WelcomeMessage(),
              SummaryView(),
            ]),
          ),
        ],
      ),
    );
  }
}

import 'package:all_my_cards/pages/home_page.dart';
import 'package:all_my_cards/pages/sign_in_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider<AppState>(
    create: (context) {
      return AppState();
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kThemeLight,
      darkTheme: kThemeDark,
      home: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.auth.isSignedIn) {
            return child;
          } else {
            return SignInPage();
          }
        },
        child: HomePage(),
      ),
    );
  }
}

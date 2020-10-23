import 'package:all_my_cards/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(builder: (context, state, child) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('All My Cards',
                    style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 8),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state.auth.signIn,
                  child: Text('Sign In with Google'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

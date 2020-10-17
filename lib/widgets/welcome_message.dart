import 'package:all_my_cards/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => Center(
        child: Center(
            child: Column(
          children: [
            Card(
              elevation: 1,
              margin: EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 300,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.auth.isSignedIn) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: 8.0,
                        ),
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(state.auth.user.photoUrl),
                        ),
                        title: Text(
                          '${state.auth.user.displayName}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Divider(
                      //   height: 1,
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text('Sign out'),
                      //   trailing: Icon(Icons.chevron_right),
                      //   onTap: state.auth.signOut,
                      // ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

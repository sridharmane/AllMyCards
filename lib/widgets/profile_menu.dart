import 'package:all_my_cards/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ProfileMenuOptions {
  signout,
}

class ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) => PopupMenuButton<ProfileMenuOptions>(
        offset: Offset(0.0, 56.0),
        icon: CircleAvatar(
          backgroundImage: NetworkImage(state.auth.user.photoUrl),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(
                  width: 16,
                ),
                Text('Sign out'),
              ],
            ),
            value: ProfileMenuOptions.signout,
          )
        ],
        onSelected: (value) async {
          switch (value) {
            case ProfileMenuOptions.signout:
              await state.auth.signOut();
              break;
          }
        },
      ),
    );
  }
}

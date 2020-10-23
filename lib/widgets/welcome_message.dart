import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => Center(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.auth.isSignedIn) ...[
                SectionHeader(label: 'Welcome'),
                ListTile(
                  title: Text(
                    '${state.auth.user.displayName}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

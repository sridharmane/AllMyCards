import 'package:all_my_cards/models/g_sheets.dart';
import 'package:all_my_cards/pages/sign_in_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Hero(
                    tag: 'user-avatar',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(state.auth.user.photoUrl),
                      radius: 75.0,
                    ),
                  ),
                ),
              ),
              Text(
                '${state.auth.user.displayName}',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 16,
              ),
              OutlineButton(
                child: Text('Sign out'),
                onPressed: () async {
                  await state.auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false,
                  );
                },
              ),
              FutureBuilder<List<GDriveFile>>(
                  future: state.gSheets.getAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final files = snapshot.data;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          label: 'Google Drive',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            'Files created by the app in google drive.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        for (var file in files)
                          ListTile(
                            leading: Icon(
                              Icons.insert_drive_file,
                              color: Colors.black26,
                            ),
                            title: Text('${file.name}'),
                            subtitle: file.id == state.fileId
                                ? Text(
                                    'Default - this file is used to store all app generated data.')
                                : null,
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.open_in_new),
                                        SizedBox(
                                          width: 16.0,
                                        ),
                                        Text('Open file'),
                                      ],
                                    ),
                                  ),
                                  if (file.id != state.fileId)
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Theme.of(context).errorColor,
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          Text('Delete file'),
                                        ],
                                      ),
                                    )
                                ];
                              },
                            ),
                            onTap: () {
                              print(file.kind);
                            },
                          ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

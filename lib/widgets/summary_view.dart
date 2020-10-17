import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/card_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
        builder: (context, state, child) => Column(children: [
              ButtonBar(children: [
                TextButton.icon(
                  onPressed: () {
                    state.gSheets.getAll();
                  },
                  icon: Icon(Icons.get_app),
                  label: Text('Get All'),
                ),
                TextButton.icon(
                  onPressed: () {
                    state.gSheets.create();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Create'),
                ),
              ]),
              Card(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.gSheets.all.length == 0) Text('No Files'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${state.gSheets.all.length} file${state.gSheets.all.length != 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    for (var sheet in state.gSheets.all) ...[
                      ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text('${sheet.name}'),
                        onTap: () {
                          state.gSheets.get(sheet.id);
                        },
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(height: 1),
                    ]
                  ],
                ),
              ),
              // Card(
              //   elevation: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       if (state.gSheets.selected != null)
              //         Text('${state.gSheets.selected.}'),
              //     ],
              //   ),
              // ),
              Card(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.gSheets.cards != null)
                      for (var card in state.gSheets.cards) CardView(card),
                  ],
                ),
              ),
            ]));
  }
}

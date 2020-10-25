import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/card_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardViewModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => ButtonBar(
        mainAxisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.end,
        children: [
          IconButton(
              icon: Icon(Icons.view_agenda),
              iconSize: 20,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              color: state.cardViewMode == CardViewMode.info
                  ? Theme.of(context).accentColor
                  : Theme.of(context).iconTheme.color,
              onPressed: () => state.cardViewMode = CardViewMode.info),
          IconButton(
            icon: Icon(Icons.view_list),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            color: state.cardViewMode == CardViewMode.row
                ? Theme.of(context).accentColor
                : Theme.of(context).iconTheme.color,
            onPressed: () => state.cardViewMode = CardViewMode.row,
          ),
        ],
      ),
    );
  }
}

import 'package:all_my_cards/pages/manage_card_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/card_view.dart';
import 'package:all_my_cards/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              '${DateFormat(DateFormat.ABBR_MONTH_DAY).format(state.today)}',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: state.today,
                firstDate: state.today.subtract(Duration(days: 365)),
                lastDate: state.today.add(Duration(days: 365)),
              );
              if (picked != null) {
                state.today = picked;
              }
            },
          ),
          Divider(
            height: 1,
          ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 16,
          //     ),
          //     Icon(Icons.calendar_today),
          //     SizedBox(
          //       width: 32,
          //     ),
          //     Text(
          //         '${DateFormat(DateFormat.ABBR_MONTH_DAY).format(state.today)}',
          //         style: Theme.of(context).textTheme.headline5),
          //   ],
          // ),
          if (state.cardsAll.length == 0)
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                          'Add cards to see which card is safe to use today.'),
                    ),
                    ButtonBar(
                      children: [
                        RaisedButton(
                            child: Text('Add Card'),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ManageCardPage()));
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (state.cardsAll.length > 0) ...[
            ChipTheme(
              data: Theme.of(context).chipTheme.copyWith(
                    selectedColor: Theme.of(context).accentColor,
                  ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.filter_list,
                    color: Colors.black45,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  FilterChip(
                    label: Text('All'),
                    selected: state.cardsFilter == CardsFilters.all,
                    onSelected: (bool value) {
                      if (value) {
                        state.cardsFilter = CardsFilters.all;
                      }
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FilterChip(
                    label: Text('Usable today'),
                    selected: state.cardsFilter == CardsFilters.usableToday,
                    // selectedColor: Theme.of(context).primaryColor,
                    onSelected: (bool value) {
                      if (value) {
                        state.cardsFilter = CardsFilters.usableToday;
                      }
                    },
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
          ],
          if (state.cardsFilter == CardsFilters.all) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SectionHeader(label: '${state.cardsAll.length} cards'),
                Spacer(),
                ButtonBar(
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
                        onPressed: () =>
                            state.cardViewMode = CardViewMode.info),
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
              ],
            ),
            for (var card in state.cardsAll)
              CardView(
                key: ValueKey(card),
                card: card,
                mode: state.cardViewMode,
                today: state.today,
              ),
          ],
          if (state.cardsFilter == CardsFilters.usableToday) ...[
            if (state.cardsToday.length == 0 && state.cardsAll.length > 0)
              SectionHeader(label: 'No cards usable today'),
            if (state.cardsToday.length > 0) ...[
              SectionHeader(
                  label:
                      '${state.cardsToday.length} of ${state.cardsAll.length} cards usable today'),
              for (var card in state.cardsToday)
                CardView(
                  key: ValueKey(card),
                  card: card,
                  mode: state.cardViewMode,
                  today: state.today,
                ),
            ],
          ],
        ],
      ),
    );
  }
}

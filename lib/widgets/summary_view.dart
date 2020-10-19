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
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16,
              top: 32,
            ),
            child: Text(
                '${DateFormat(DateFormat.ABBR_MONTH_DAY).format(state.today)}',
                style: Theme.of(context).textTheme.headline5),
          ),
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
          if (state.cardsAll.length > 0)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                ),
                Icon(Icons.filter_list),
                SizedBox(
                  width: 8,
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
          if (state.cardsFilter == CardsFilters.all) ...[
            SectionHeader(label: '${state.cardsAll.length} cards'),
            for (var card in state.cardsAll) CardView(card),
          ],
          if (state.cardsFilter == CardsFilters.usableToday) ...[
            if (state.cardsToday.length == 0 && state.cardsAll.length > 0)
              SectionHeader(label: 'No cards usable today'),
            if (state.cardsToday.length > 0) ...[
              SectionHeader(
                  label:
                      '${state.cardsToday.length} of ${state.cardsAll.length} cards usable today'),
              for (var card in state.cardsToday) CardView(card),
            ],
          ],
        ],
      ),
    );
  }
}

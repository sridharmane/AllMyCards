import 'package:all_my_cards/pages/manage_card_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/card_view.dart';
import 'package:all_my_cards/widgets/card_view_mode_selector.dart';
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
          if (state.cards.length == 0)
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
          if (state.cards.length > 0) ...[
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
                    showCheckmark: false,
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
                    showCheckmark: false,
                    selected: state.cardsFilter == CardsFilters.usableToday,
                    // selectedColor: Theme.of(context).primaryColor,
                    onSelected: (bool value) {
                      if (value) {
                        state.cardsFilter = CardsFilters.usableToday;
                        state.date = state.today;
                      }
                    },
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  if (state.date != state.today)
                    FilterChip(
                      label: Text('Usable on ${state.date.day}'),
                      showCheckmark: false,
                      selected:
                          state.cardsFilter == CardsFilters.usableAnotherDay,
                      // selectedColor: Theme.of(context).primaryColor,
                      onSelected: (bool value) async {
                        if (!value) {
                          // await pickDay(context, state);
                          state.cardsFilter = CardsFilters.usableToday;
                          state.date = state.today;
                        }
                      },
                    ),
                  if (state.date == state.today)
                    FilterChip(
                      avatar: Icon(
                        Icons.add,
                        size: 16,
                      ),
                      label: Text('Select day'),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      showCheckmark: false,
                      selected:
                          state.cardsFilter == CardsFilters.usableAnotherDay,
                      // selectedColor: Theme.of(context).primaryColor,
                      onSelected: (bool value) async {
                        if (value) {
                          await pickDay(context, state);
                          state.cardsFilter = CardsFilters.usableAnotherDay;
                        }
                      },
                    ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
          ],

          if (state.cards.length == 0 && state.cards.length > 0)
            SectionHeader(label: 'No cards usable today'),
          if (state.cards.length > 0) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SectionHeader(
                    label:
                        '${state.cards.length} of ${state.totalCards} cards usable today'),
                Spacer(),
                CardViewModeSelector(),
              ],
            ),
            for (var card in state.cards)
              CardView(
                key: ValueKey(card),
                card: card,
                mode: state.cardViewMode,
                today: state.date,
              ),
          ],
        ],
      ),
    );
  }

  Future pickDay(BuildContext context, AppState state) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: state.date.subtract(Duration(days: 365)),
      lastDate: state.date.add(Duration(days: 365)),
    );
    if (picked != null) {
      state.date = picked;
    }
  }
}

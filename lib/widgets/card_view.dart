import 'package:all_my_cards/models/payment_card.dart';
import 'package:all_my_cards/pages/manage_card_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardView extends StatefulWidget {
  const CardView(this.card);

  final PaymentCard card;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  bool _expanded = false;
  // NumberFormat currencyFormat =
  //     NumberFormat.currency(locale: 'en_CA', symbol: '\$', decimalDigits: 0);
  NumberFormat currencyFormat =
      NumberFormat.simpleCurrency(locale: 'en_CA', decimalDigits: 0);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {
            _expanded = !_expanded;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              top: 16.0,
              right: 16.0,
              bottom: _expanded ? 0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.card.label}',
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.card.cardHolderName}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${currencyFormat.format(int.tryParse(widget.card.limit))}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                if (_expanded) ...[
                  ListTile(
                    title: Text('${widget.card.paymentDueDate}'),
                    subtitle: Text('Payment due date'),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text('${widget.card.statementDate}'),
                    subtitle: Text('Statement date'),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Row(
                    // alignment: MainAxisAlignment.spaceAround,
                    // buttonPadding: EdgeInsets.all(0),
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.delete),
                          label: Row(
                            children: [
                              Text('Delete'),
                            ],
                          ),
                          onPressed: () async {
                            final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Confirm Dete?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    ));
                            if (result) {
                              Provider.of<AppState>(context, listen: false)
                                  .deleteCard(widget.card);
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 25,
                        child: VerticalDivider(),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ManageCardPage(
                                  mode: ManageCardPageModes.edit,
                                  card: widget.card,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:all_my_cards/models/payment_card.dart';
import 'package:all_my_cards/pages/manage_card_page.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum CardViewMode {
  info,
  row,
}

class CardView extends StatefulWidget {
  const CardView({
    Key key,
    @required this.card,
    @required this.today,
    this.mode = CardViewMode.info,
  }) : super(key: key);

  final PaymentCard card;
  final CardViewMode mode;
  final DateTime today;

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
    Widget main, expanded;
    double elevation;
    EdgeInsets margin, padding;
    switch (widget.mode) {
      case CardViewMode.info:
        margin = EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        );
        padding = EdgeInsets.only(
          left: 16.0,
          top: 16.0,
          right: 16.0,
          bottom: _expanded ? 0 : 16.0,
        );
        main = _buildDefault(context);
        expanded = _buildDefaultExpanded(context);
        break;
      case CardViewMode.row:
        elevation = 0;
        margin = EdgeInsets.zero;
        padding = EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 16.0,
        );
        main = _buildRow(context, widget.today);
        expanded = _buildRowExpanded(context);
        break;
    }
    return Card(
      elevation: _expanded ? 4 : elevation,
      clipBehavior: Clip.antiAlias,
      shape: widget.mode == CardViewMode.row
          ? ContinuousRectangleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
      margin: _expanded
          ? margin.copyWith(
              top: min(16, margin.top + 4),
              bottom: min(16, margin.top + 8),
            )
          : margin,
      child: InkWell(
        onTap: () {
          _expanded = !_expanded;
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: StatusColors.get(widget.card.status),
                width: 4.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                main,
                if (_expanded) expanded,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefault(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${widget.card.name}',
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
          '${widget.card.nameOnCard}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '${currencyFormat.format(widget.card.limit)}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _buildDefaultExpanded(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          )
        ]);
  }

  Widget _buildRow(BuildContext context, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.card.name,
          style: Theme.of(context).textTheme.caption,
        ),
        StatusBar(
          paymentDate: widget.card.paymentDueDate,
          statementDate: widget.card.statementDate,
          today: date,
        ),
      ],
    );
  }

  Widget _buildRowExpanded(BuildContext context) {
    return _buildDefaultExpanded(context);
  }
}

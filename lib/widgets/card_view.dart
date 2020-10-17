import 'package:all_my_cards/models/payment_card.dart';
import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView(this.card);

  final PaymentCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${card.label}',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '${card.cardHolderName}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              ListTile(
                title: Text('${card.paymentDueDate}'),
                subtitle: Text('Payment due date'),
              ),
              ListTile(
                title: Text('${card.statementDate}'),
                subtitle: Text('Statement date'),
                dense: true,
              ),
            ],
          ),
        ));
  }
}

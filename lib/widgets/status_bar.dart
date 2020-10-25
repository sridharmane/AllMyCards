import 'dart:math';

import 'package:all_my_cards/models/payment_card.dart';
import 'package:flutter/material.dart';

class Status {
  final Color color;
  final Size size;
  const Status.today()
      : this.color = Colors.black,
        this.size = const Size(2.5, 20);
  const Status.paymentDate()
      : this.color = StatusColors.paymentDate,
        this.size = const Size(50, 5);
  const Status.statementDate()
      : this.color = StatusColors.statementDate,
        this.size = const Size(50, 5);
  const Status.use()
      : this.color = StatusColors.use,
        this.size = const Size(50, 5);
  const Status.doNotUse()
      : this.color = StatusColors.doNotUse,
        this.size = const Size(50, 5);
  const Status.warn()
      : this.color = Colors.orange,
        this.size = const Size(50, 5);
  const Status.alert()
      : this.color = StatusColors.alert,
        this.size = const Size(50, 5);
}

class StatusBar extends StatelessWidget {
  StatusBar({
    this.paymentDate,
    this.statementDate,
    @required this.today,
  });

  final int paymentDate;
  final int statementDate;
  final DateTime today;
  int _daysInMonth = 0;
  int get daysInMonth {
    if (_daysInMonth == 0) {
      DateTime lastDate =
          DateTime(today.year, today.month == 12 ? 1 : today.month + 1, 1);
      lastDate = lastDate.subtract(Duration(days: 1));
      _daysInMonth = lastDate.day;
    }
    return _daysInMonth;
  }

  @override
  Widget build(BuildContext context) {
    List<Status> list = List.generate(daysInMonth, (i) {
      var d = i + 1;
      if (d == today.day) {
        return Status.today();
      } else if (d == paymentDate) {
        return Status.paymentDate();
      } else if (d == statementDate) {
        return Status.statementDate();
      } else {
        if (paymentDate < statementDate) {
          if (d < paymentDate - 4) {
            return Status.use();
          } else if (d < paymentDate) {
            return Status.alert();
          } else if (d > paymentDate && d < statementDate) {
            return Status.doNotUse();
          } else if (d > statementDate) {
            return Status.use();
          } else {
            return Status.doNotUse();
          }
        } else {
          if (d > statementDate && d < paymentDate - 4) {
            return Status.use();
          } else if (d < statementDate || d > paymentDate) {
            return Status.doNotUse();
          } else {
            return Status.alert();
          }
        }
      }
    });

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var status in list) ...[
              Container(
                height: status.size.height,
                width:
                    min(status.size.width, constraints.maxWidth / list.length),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: status.color,
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(10),
                  // ),
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}

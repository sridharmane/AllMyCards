import 'package:flutter/material.dart';

enum PaymentCardStatus {
  use,
  alert,
  paymentDate,
  doNotuse,
  statementDate,
}

class StatusColors {
  static const Color use = Colors.green;
  static const Color alert = Colors.orange;
  static const Color paymentDate = Colors.brown;
  static const Color doNotUse = Colors.red;
  static const Color statementDate = Colors.indigo;

  static Color get(PaymentCardStatus status) {
    switch (status) {
      case PaymentCardStatus.use:
        return use;
        break;
      case PaymentCardStatus.alert:
        return alert;
        break;
      case PaymentCardStatus.paymentDate:
        return paymentDate;
        break;
      case PaymentCardStatus.doNotuse:
        return doNotUse;
        break;
      case PaymentCardStatus.statementDate:
        return statementDate;
        break;
      default:
        return use;
    }
  }
}

class PaymentCard {
  PaymentCard({
    this.id,
    this.label,
    this.cardHolderName,
    this.paymentDueDate,
    this.statementDate,
    this.limit,
  }) {
    if (paymentDueDate != null && statementDate != null) {
      var today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);
      var pmtDate = DateTime(today.year, today.month, paymentDueDate);
      var stmtDate = DateTime(today.year, today.month, statementDate);

      if (pmtDate.isAfter(stmtDate)) {
        stmtDate = DateTime(stmtDate.year, stmtDate.month + 1, stmtDate.day);
      }

      if (today.isBefore(pmtDate)) {
        if (today.isBefore(pmtDate.subtract(Duration(days: 4)))) {
          status = PaymentCardStatus.use;
        } else {
          status = PaymentCardStatus.alert;
        }
      } else if (today.isAfter(stmtDate)) {
        status = PaymentCardStatus.use;
      } else if (today.isAtSameMomentAs(pmtDate)) {
        status = PaymentCardStatus.paymentDate;
      } else if (today.isAtSameMomentAs(stmtDate)) {
        status = PaymentCardStatus.statementDate;
      } else if (today.isAfter(pmtDate) && today.isBefore(stmtDate)) {
        status = PaymentCardStatus.doNotuse;
      } else {
        status = PaymentCardStatus.doNotuse;
      }
    }
  }

  String id;
  String label;
  String cardHolderName;
  int paymentDueDate;
  int statementDate;
  String limit;
  PaymentCardStatus status;

  factory PaymentCard.fromRow(String id, List<dynamic> row) {
    if (row.length < 5) {
      return null;
    }
    return PaymentCard(
      id: id,
      label: row[0] ?? 'No-Label',
      cardHolderName: row[1] ?? 'No-CardHolder',
      limit: row[2] ?? 'No-Limit',
      paymentDueDate: int.tryParse(row[3]) ?? 0,
      statementDate: int.tryParse(row[4]) ?? 0,
    );
  }

  List<dynamic> toRow() {
    return [label, cardHolderName, limit, paymentDueDate, statementDate];
  }
}

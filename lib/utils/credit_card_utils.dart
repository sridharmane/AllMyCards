import 'package:all_my_cards/models/credit_card.dart';
import 'package:flutter/material.dart';

enum CreditCardStatus {
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

  static Color get(CreditCardStatus status) {
    switch (status) {
      case CreditCardStatus.use:
        return use;
        break;
      case CreditCardStatus.alert:
        return alert;
        break;
      case CreditCardStatus.paymentDate:
        return paymentDate;
        break;
      case CreditCardStatus.doNotuse:
        return doNotUse;
        break;
      case CreditCardStatus.statementDate:
        return statementDate;
        break;
      default:
        return use;
    }
  }
}

class CreditCardUtils {
  static Map<int, CreditCardStatus> _statuses = {};

  static CreditCardStatus status(DateTime date, CreditCard card) {
    return _statuses.putIfAbsent(card.hashCode, () {
      var pmtDate = DateTime(date.year, date.month, card.paymentDueDate);
      var stmtDate = DateTime(date.year, date.month, card.statementDate);

      if (pmtDate.isAfter(stmtDate)) {
        stmtDate = DateTime(stmtDate.year, stmtDate.month + 1, stmtDate.day);
      }
      CreditCardStatus _status;
      if (date.isBefore(pmtDate)) {
        if (date.isBefore(pmtDate.subtract(Duration(days: 4)))) {
          _status = CreditCardStatus.use;
        } else {
          _status = CreditCardStatus.alert;
        }
      } else if (date.isAfter(stmtDate)) {
        _status = CreditCardStatus.use;
      } else if (date.isAtSameMomentAs(pmtDate)) {
        _status = CreditCardStatus.paymentDate;
      } else if (date.isAtSameMomentAs(stmtDate)) {
        _status = CreditCardStatus.statementDate;
      } else if (date.isAfter(pmtDate) && date.isBefore(stmtDate)) {
        _status = CreditCardStatus.doNotuse;
      } else {
        _status = CreditCardStatus.doNotuse;
      }

      return _status;
    });
  }
}

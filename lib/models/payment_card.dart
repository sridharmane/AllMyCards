import 'package:all_my_cards/utils/color_utils.dart';
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

class CardNetwork {
  static const String visa = 'visa';
  static const String masterCard = 'mastercard';
  static const String discover = 'discover';
  static const String amex = 'amex';
}

class PaymentCard {
  final String id;
  final DateTime date;
  final String name;
  final String issuer;
  final String lastFourDigits;
  final String nameOnCard;
  final int limit;
  final int paymentDueDate;
  final int statementDate;
  final Color color;
  final String network;

  PaymentCardStatus _status;
  PaymentCardStatus get status {
    if (_status == null) {
      if (date != null && paymentDueDate != null && statementDate != null) {
        var pmtDate = DateTime(date.year, date.month, paymentDueDate);
        var stmtDate = DateTime(date.year, date.month, statementDate);

        if (pmtDate.isAfter(stmtDate)) {
          stmtDate = DateTime(stmtDate.year, stmtDate.month + 1, stmtDate.day);
        }

        if (date.isBefore(pmtDate)) {
          if (date.isBefore(pmtDate.subtract(Duration(days: 4)))) {
            _status = PaymentCardStatus.use;
          } else {
            _status = PaymentCardStatus.alert;
          }
        } else if (date.isAfter(stmtDate)) {
          _status = PaymentCardStatus.use;
        } else if (date.isAtSameMomentAs(pmtDate)) {
          _status = PaymentCardStatus.paymentDate;
        } else if (date.isAtSameMomentAs(stmtDate)) {
          _status = PaymentCardStatus.statementDate;
        } else if (date.isAfter(pmtDate) && date.isBefore(stmtDate)) {
          _status = PaymentCardStatus.doNotuse;
        } else {
          _status = PaymentCardStatus.doNotuse;
        }
      }
    }
    return _status;
  }

  PaymentCard({
    this.id,
    DateTime date,
    this.name,
    this.issuer,
    this.lastFourDigits,
    this.nameOnCard,
    this.limit,
    this.paymentDueDate,
    this.statementDate,
    this.color,
    this.network,
  }) : date = DateTime(date.year, date.month, date.day) {
    assert(date != null);
  }

  PaymentCard copyWith({
    String id,
    DateTime date,
    String name,
    String issuer,
    String lastFourDigits,
    String nameOnCard,
    int limit,
    int paymentDueDate,
    int statementDate,
    Color color,
    String network,
    PaymentCardStatus stauts,
  }) {
    _status = null;
    return PaymentCard(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      nameOnCard: nameOnCard ?? this.nameOnCard,
      limit: limit ?? this.limit,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      statementDate: statementDate ?? this.statementDate,
      color: color ?? this.color,
      network: network ?? this.network,
    );
  }

  factory PaymentCard.fromRow({String id, DateTime date, List<dynamic> row}) {
    if (row.length < 5) {
      return null;
    }
    return PaymentCard(
      id: id,
      date: date,
      name: row[0] ?? '',
      issuer: row[1] ?? '',
      lastFourDigits: row[2] ?? '',
      nameOnCard: row[3] ?? '',
      limit: int.tryParse(row[4]) ?? 0,
      paymentDueDate: int.tryParse(row[5]) ?? 0,
      statementDate: int.tryParse(row[6]) ?? 0,
      color: ColorUtils.fromHex(row[7]),
      network: row[8] ?? '',
    );
  }

  List<dynamic> toRow() {
    return [
      id,
      date,
      name,
      issuer,
      lastFourDigits,
      nameOnCard,
      limit,
      paymentDueDate,
      statementDate,
      color,
      network,
    ];
  }

  static const List<String> headerRow = [
    "Name",
    "Issuer",
    "Last 4 Digits",
    "Name on Card",
    "Limit",
    "Payment Due Date",
    "Statement Date",
    "Color",
    "Network"
  ];

  @override
  int get hashCode => toRow().hashCode;

  @override
  bool operator ==(Object other) {
    return this.hashCode == other.hashCode;
  }
}

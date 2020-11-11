library credit_card;

import 'dart:convert';

import 'package:all_my_cards/models/serializers.dart';
import 'package:all_my_cards/utils/credit_card_utils.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';

part 'credit_card.g.dart';

abstract class CreditCard implements Built<CreditCard, CreditCardBuilder> {
  CreditCard._();

  factory CreditCard([updates(CreditCardBuilder b)]) = _$CreditCard;

  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'issuer')
  String get issuer;
  @BuiltValueField(wireName: 'limit')
  int get limit;
  @BuiltValueField(wireName: 'lastFourDigits')
  String get lastFourDigits;
  @BuiltValueField(wireName: 'nameOnCard')
  String get nameOnCard;
  @BuiltValueField(wireName: 'paymentDueDate')
  int get paymentDueDate;
  @BuiltValueField(wireName: 'statementDate')
  int get statementDate;
  @BuiltValueField(wireName: 'color')
  String get color;
  @BuiltValueField(wireName: 'network')
  String get network;
  String toJson() {
    return json.encode(serializers.serializeWith(CreditCard.serializer, this));
  }

  static CreditCard fromJson(String jsonString) {
    return serializers.deserializeWith(
        CreditCard.serializer, json.decode(jsonString));
  }

  static Serializer<CreditCard> get serializer => _$creditCardSerializer;

  static CreditCard fromRow({List<dynamic> row}) {
    if (row.length < 5) {
      return null;
    }
    return CreditCard(
      (b) => b
        ..name = row[0] ?? ''
        ..issuer = row[1] ?? ''
        ..lastFourDigits = row[2] ?? ''
        ..nameOnCard = row[3] ?? ''
        ..limit = int.tryParse(row[4]) ?? 0
        ..paymentDueDate = int.tryParse(row[5]) ?? 0
        ..statementDate = int.tryParse(row[6]) ?? 0
        ..color = row[7]
        ..network = row[8] ?? '',
    );
  }

  List<dynamic> toRow() {
    return [
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
}

class CreditCardWithStatus {
  CreditCardWithStatus({@required this.card, @required this.status});
  final CreditCard card;
  final CreditCardStatus status;
}

class CardNetwork {
  static const String visa = 'visa';
  static const String masterCard = 'mastercard';
  static const String discover = 'discover';
  static const String amex = 'amex';
}

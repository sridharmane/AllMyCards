import 'dart:convert';

import 'package:all_my_cards/models/payment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class GDriveFile {
  const GDriveFile({
    this.id,
    this.kind,
    this.name,
    this.mimeType,
  });
  static GDriveFile fromMap(Map map) {
    try {
      return GDriveFile(
        id: map.containsKey('id') ? map['id'] : null,
        kind: map.containsKey('kind') ? map['kind'] : null,
        name: map.containsKey('name') ? map['name'] : null,
        mimeType: map.containsKey('mimeType') ? map['mimeType'] : null,
      );
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }

  final String id;
  final String kind;
  final String name;
  final String mimeType;
}

class URLS {
  static const String baseDrive = 'https://www.googleapis.com/drive/v3';
  static const String baseSheets = 'https://sheets.googleapis.com/v4';
}

class GSheets extends ChangeNotifier {
  GSheets(this.client);

  final BaseClient client;
  List<GDriveFile> all = [];
  dynamic selected;
  List<dynamic> selectedValues;
  List<PaymentCard> cards = [];

  Future<List<GDriveFile>> getAll() async {
    final resp = await client.get('${URLS.baseDrive}/files');
    Logger().d(resp.body);
    final json = jsonDecode(resp.body);
    all = json['files']
        .map<GDriveFile>((file) => GDriveFile.fromMap(file))
        .toList();

    notifyListeners();
    return all;
  }

  Future<dynamic> get(String id) async {
    assert(id != null);
    if (id == null) {
      return null;
    }
    final resp = await client.get('${URLS.baseSheets}/spreadsheets/$id');

    Logger().d(resp.body);
    final json = jsonDecode(resp.body);
    selected = json;
    await getValues(id);

    notifyListeners();
    return selected;
  }

  Future<dynamic> getValues(String id,
      {int sheetNumber = 1,
      String cellRange = 'A1:Z100',
      String majorDimension = 'ROWS' // COLUMNS, ROWS
      }) async {
    assert(id != null);
    if (id == null) {
      return null;
    }
    String range = '';
    if (sheetNumber != null && sheetNumber > 0) {
      range += 'Sheet$sheetNumber!';
    }
    if (cellRange != null && cellRange.isNotEmpty) {
      range += '$cellRange';
    }
    final resp = await client.get(
        '${URLS.baseSheets}/spreadsheets/$id/values/$range?majorDimension=$majorDimension');

    Logger().d(resp.body);
    final json = jsonDecode(resp.body);
    selectedValues = json["values"];

    Logger().d('CARDS JSON: Total ${selectedValues.length}: $selectedValues');

    cards = selectedValues
        .map<PaymentCard>((row) {
          Logger().d('ROW:${row.length}: $row');
          if (row.length < 5) {
            Logger().d('ROW rejected: $row');

            return null;
          }
          return PaymentCard(
            label: row[0] ?? 'No-Label',
            cardHolderName: row[1] ?? 'No-CardHolder',
            limit: row[2] ?? 'No-Limit',
            paymentDueDate: row[3] ?? 'No-PaymentDueDate',
            statementDate: row[4] ?? 'No-StatementDueDate',
          );
        })
        .where((card) => card != null)
        // .takeWhile((card) => card != null)
        .toList();
    Logger().d('CARDS: ${cards.length}');
    notifyListeners();
    return selectedValues;
  }

  void create() async {
    Logger log = Logger();

    final resp = await client.post('${URLS.baseSheets}/spreadsheets');
    log.d('Body: ${resp.body}');
    notifyListeners();
  }

  Future<void> selectDefault() async {
    if (all.isEmpty || selected == null || selectedValues == null) {
      await getAll();
      if (all.length > 0) {
        // await get(all[0].id);
        await getValues(all.first.id);
      }
    }
  }
}

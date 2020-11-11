import 'dart:convert';
import 'package:all_my_cards/models/credit_card.dart';
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

class GSheets {
  GSheets(this.client);
  Logger _log = Logger();
  final BaseClient client;
  dynamic selected;
  List<GDriveFile> _files;

  Future<List<GDriveFile>> getAll() async {
    if (_files != null) {
      return _files;
    }
    final resp = await client.get('${URLS.baseDrive}/files');
    Logger().d(resp.body);
    final json = jsonDecode(resp.body);
    _files = json['files']
        .map<GDriveFile>((file) => GDriveFile.fromMap(file))
        .toList();
    return _files;
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

    return selected;
  }

  Future<List<dynamic>> getValues(String id,
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

    Logger().d('getAll: response: ${resp.body}');
    Map json = jsonDecode(resp.body);
    final values = json.containsKey('values') ? json['values'] : [];
    if (values.length > 0) {
      // remove the header
      if (values.first.first == CreditCard.headerRow.first) {
        values.removeAt(0);
      }
    }
    return values;
  }

  Future<dynamic> updateValues(
    String id,
    List<dynamic> values, {
    int sheetNumber = 1,
    String cellRange = 'A1:Z100',
    String majorDimension = 'ROWS', // COLUMNS, ROWS
  }) async {
    assert(id != null);
    assert(values != null);

    String range = '';
    if (sheetNumber != null && sheetNumber > 0) {
      range += 'Sheet$sheetNumber!';
    }
    if (cellRange != null && cellRange.isNotEmpty) {
      range += '$cellRange';
    }

    // add default header row
    values.insert(0, CreditCard.headerRow);

    Map<String, dynamic> data = {
      'values': values,
      'majorDimension': majorDimension,
      'range': range,
    };
    _log.d('updateValues: data: $data');

    String bodyStr = json.encode(data);
    final resp = await client.put(
      '${URLS.baseSheets}/spreadsheets/$id/values/$range?valueInputOption=1',
      body: bodyStr,
    );

    _log.d('updateValues: complete, ${resp.body}');
  }

  Future<String> create(String fileName) async {
    Logger log = Logger();

    final spreadSheet = Map<String, dynamic>.from({
      'properties': {
        'title': fileName,
      }
    });

    final resp = await client.post('${URLS.baseSheets}/spreadsheets',
        body: json.encode(spreadSheet));

    log.d('Body: ${resp.body}');
    final data = json.decode(resp.body);
    return data['spreadsheetId'];
  }
}

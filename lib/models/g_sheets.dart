import 'package:all_my_cards/models/auth.dart';
import 'package:logger/logger.dart';

class GSheetsAPI {
  static GSheetsAPI _instance;
  factory GSheetsAPI() {
    if (_instance == null) {
      _instance = GSheetsAPI._internal();
    }
    return _instance;
  }
  GSheetsAPI._internal() {
    // _gsheets = GSheets(_credentials);
  }

  getAll() async {
    final resp =
        await Auth().client.get('https://www.googleapis.com/drive/v3/files');
    Logger().d(resp.body.toString());
  }

  get({String id}) async {
    final resp =
        await Auth().client.get('https://sheets.googleapis.com/v4/spreadshe'
            'ets/${id ?? '1iJdR1H4Uu3Rc6e9r8p-O-gDRMkXqamM7TQdggW6ruIw'}');
    Logger().d(resp.body.toString());
  }

  void create() async {
    Logger log = Logger();

    final resp = await Auth()
        .client
        .post('https://sheets.googleapis.com/v4/spreadsheets');
    log.d('Body: ${resp.body}');
  }
}

import 'package:all_my_cards/models/auth.dart';
import 'package:all_my_cards/models/g_sheets.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class AppState extends ChangeNotifier {
  Logger _log = Logger();
  AppState({Auth auth}) : _auth = auth != null ? auth : Auth() {
    _auth?.addListener(() {
      if (_auth != null) {
        _log.d("AUTH CHANGED:${_auth?.isSignedIn}, client:${_auth.client}");
        _gSheets = GSheets(_auth.client);
        _gSheets.addListener(notifyListeners);
        _gSheets.selectDefault();
      }
      notifyListeners();
    });
  }

  final Auth _auth;
  Auth get auth => _auth;

  GSheets _gSheets;
  GSheets get gSheets => _gSheets;
}

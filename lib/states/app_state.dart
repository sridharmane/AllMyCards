import 'package:all_my_cards/models/auth.dart';
import 'package:all_my_cards/models/g_sheets.dart';
import 'package:all_my_cards/models/payment_card.dart';
import 'package:all_my_cards/models/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

enum CardsFilters {
  all,
  usableToday,
}

class AppState extends ChangeNotifier {
  Logger _log = Logger();
  AppState({Auth auth}) : _auth = auth != null ? auth : Auth() {
    _auth?.addListener(_onAuthChanged);
  }

  final Auth _auth;
  Auth get auth => _auth;

  GSheets _gSheets;
  GSheets get gSheets => _gSheets;
  String _sheetId;
  String _defaultFileName = 'AllMyCards DB';
  PaymentCard tempCard;
  List<PaymentCard> cardsAll = [];
  List<PaymentCard> cardsToday = [];
  DateTime today = DateTime.now().toLocal();
  bool isLoading = false;

  CardsFilters _cardsFilter = CardsFilters.usableToday;
  CardsFilters get cardsFilter => _cardsFilter;
  set cardsFilter(CardsFilters filter) {
    _cardsFilter = filter;
    notifyListeners();
  }

  _onAuthChanged() async {
    if (_auth != null) {
      _log.d("AUTH CHANGED: signedIn: ${_auth?.isSignedIn}");
      try {
        isLoading = true;
        notifyListeners();
        await _setupGSheets();
      } catch (e) {
        _log.e('Error occured: $e');
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _setupGSheets() async {
    _log.d('_setupGSheets: Start');
    _gSheets = GSheets(_auth.client);

    if (_sheetId == null) {
      _sheetId = await SecureStorage().get(SecureStorageKeys.sheetId);
      _log.d('_setupGSheets: sheetId from storage: $_sheetId');
    }
    if (_sheetId == null) {
      final files = await _gSheets.getAll();
      final file = files.firstWhere((f) => f.name == _defaultFileName,
          orElse: () => null);
      if (file == null) {
        _sheetId = await _gSheets.create(_defaultFileName);
        _log.d('_setupGSheets: sheetId created: $_sheetId');
      } else {
        _sheetId = file.id;
        _log.d('_setupGSheets: sheetId from drive: $_sheetId');
      }
      await SecureStorage().set(SecureStorageKeys.sheetId, _sheetId);
    }
    final values = await _gSheets.getValues(_sheetId);
    cardsAll = values
        .map<PaymentCard>(
            (row) => PaymentCard.fromRow('${values.indexOf(row)}', row))
        .where((card) => card != null)
        .toList();
    _log.d('_setupGSheets: parsed cards: total ${cardsAll.length}');
    cardsToday = _getCardsForToday(cardsAll);
    _log.d('_setupGSheets: filtered cards: total ${cardsToday.length}');
    _log.d('_setupGSheets: Done');
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> addCard() async {
    cardsAll.add(tempCard);
    await _gSheets.updateValues(_sheetId, _cardsAsSheetValues(cardsAll));
    tempCard = null;
    notifyListeners();
  }

  Future<void> editCard() async {
    int index = cardsAll.indexWhere((c) => c.id == tempCard.id);
    cardsAll[index] = tempCard;
    await _gSheets.updateValues(_sheetId, _cardsAsSheetValues(cardsAll));
    tempCard = null;
    notifyListeners();
  }

  Future<void> deleteCard(PaymentCard card) async {
    cardsAll.removeWhere((c) => c.id == card.id);
    await _gSheets.updateValues(_sheetId, _cardsAsSheetValues(cardsAll));
    notifyListeners();
  }

  List<List<dynamic>> _cardsAsSheetValues(List<PaymentCard> cards) {
    return cards.map<List<dynamic>>((c) => c.toRow()).toList();
  }

  List<PaymentCard> _getCardsForToday(List<PaymentCard> cards) {
    return cards
        .where((card) =>
            (today.day < card.paymentDueDate && today.day > card.statementDate))
        .toList();
  }
}

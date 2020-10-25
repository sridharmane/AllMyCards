import 'package:all_my_cards/models/auth.dart';
import 'package:all_my_cards/models/g_sheets.dart';
import 'package:all_my_cards/models/payment_card.dart';
import 'package:all_my_cards/models/secure_storage.dart';
import 'package:all_my_cards/widgets/card_view.dart';
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
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _date = _today;
  }

  final Auth _auth;
  Auth get auth => _auth;

  GSheets _gSheets;
  GSheets get gSheets => _gSheets;

  String _fileId;
  String get fileId => _fileId;

  String _defaultFileName = 'AllMyCards DB';
  PaymentCard tempCard;

  CardViewMode _cardViewMode = CardViewMode.info;
  CardViewMode get cardViewMode => _cardViewMode;
  set cardViewMode(CardViewMode value) {
    if (value != _cardViewMode) {
      _cardViewMode = value;
      notifyListeners();
    }
  }

  List<PaymentCard> cardsAll = [];
  List<PaymentCard> cardsForDate = [];

  DateTime _today;
  DateTime get today => _today;
  DateTime _date;
  DateTime get date => _date;
  set date(DateTime value) {
    if (value != _date) {
      _date = DateTime(value.year, value.month, value.day);
      cardsForDate = _getCardsForToday(cardsAll);
      notifyListeners();
    }
  }

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

    if (_fileId == null) {
      _fileId = await SecureStorage().get(SecureStorageKeys.sheetId);
      _log.d('_setupGSheets: sheetId from storage: $_fileId');
    }
    if (_fileId == null) {
      final files = await _gSheets.getAll();
      final file = files.firstWhere((f) => f.name == _defaultFileName,
          orElse: () => null);
      if (file == null) {
        _fileId = await _gSheets.create(_defaultFileName);
        _log.d('_setupGSheets: sheetId created: $_fileId');
      } else {
        _fileId = file.id;
        _log.d('_setupGSheets: sheetId from drive: $_fileId');
      }
      await SecureStorage().set(SecureStorageKeys.sheetId, _fileId);
    }
    final values = await _gSheets.getValues(_fileId);
    cardsAll = values
        .map<PaymentCard>(
            (row) => PaymentCard.fromRow('${values.indexOf(row)}', row))
        .where((card) => card != null)
        .toList();
    _log.d('_setupGSheets: parsed cards: total ${cardsAll.length}');
    cardsForDate = _getCardsForToday(cardsAll);
    _log.d('_setupGSheets: filtered cards: total ${cardsForDate.length}');
    _log.d('_setupGSheets: Done');
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> addCard() async {
    cardsAll.add(tempCard);
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(cardsAll));
    tempCard = null;
    notifyListeners();
  }

  Future<void> editCard() async {
    int index = cardsAll.indexWhere((c) => c.id == tempCard.id);
    cardsAll[index] = tempCard;
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(cardsAll));
    tempCard = null;
    notifyListeners();
  }

  Future<void> deleteCard(PaymentCard card) async {
    cardsAll.removeWhere((c) => c.id == card.id);
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(cardsAll));
    notifyListeners();
  }

  List<List<dynamic>> _cardsAsSheetValues(List<PaymentCard> cards) {
    return cards.map<List<dynamic>>((c) => c.toRow()).toList();
  }

  List<PaymentCard> _getCardsForToday(List<PaymentCard> cards) {
    final list = cards
        .where((card) =>
            [
              PaymentCardStatus.use,
              PaymentCardStatus.alert,
            ].indexOf(card.status) >
            -1)
        .toList();
    list.sort((a, b) {
      if (a.status == b.status) {
        return 0;
      }
      if (a.status == PaymentCardStatus.use &&
          b.status != PaymentCardStatus.use) {
        return -1;
      }
      return 1;
    });
    return list;
  }
}

import 'package:all_my_cards/models/auth.dart';
import 'package:all_my_cards/models/credit_card.dart';
import 'package:all_my_cards/models/g_sheets.dart';
import 'package:all_my_cards/models/secure_storage.dart';
import 'package:all_my_cards/utils/credit_card_utils.dart';
import 'package:all_my_cards/widgets/card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

enum CardsFilters {
  all,
  usableToday,
  usableAnotherDay,
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
  CreditCard _tempCard;

  CreditCard get tempCard => _tempCard;
  set tempCard(CreditCard value) {
    if (value != _tempCard) {
      _tempCard = value;
      notifyListeners();
    }
  }

  CardViewMode _cardViewMode = CardViewMode.info;
  CardViewMode get cardViewMode => _cardViewMode;
  set cardViewMode(CardViewMode value) {
    if (value != _cardViewMode) {
      _cardViewMode = value;
      notifyListeners();
    }
  }

  List<CreditCard> _cards = [];
  int get totalCards => _cards.length;

  List<CreditCardWithStatus> cards = [];

  DateTime _today;
  DateTime get today => _today;
  DateTime _date;
  DateTime get date => _date;
  set date(DateTime value) {
    if (value != _date) {
      isLoading = true;
      notifyListeners();
      _date = DateTime(value.year, value.month, value.day);
      _refreshCards();
      isLoading = false;
      notifyListeners();
    }
  }

  bool isLoading = false;

  CardsFilters _cardsFilter = CardsFilters.usableToday;
  CardsFilters get cardsFilter => _cardsFilter;
  set cardsFilter(CardsFilters filter) {
    isLoading = true;
    notifyListeners();
    _cardsFilter = filter;
    _refreshCards();
    isLoading = false;
    notifyListeners();
  }

  _onAuthChanged() async {
    if (_auth != null) {
      _log.d("AUTH CHANGED: signedIn: ${_auth?.isSignedIn}");
      try {
        isLoading = true;
        notifyListeners();
        await _setupGSheets();
        await loadData();
      } catch (e, stackTrace) {
        _log.e('Error occured in GSheets', e, stackTrace);
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

    _log.d('_setupGSheets: Done');
  }

  Future<List<CreditCard>> loadData() async {
    _log.d('#################################################################');
    _log.d('loadData: start');
    final values = await _gSheets.getValues(_fileId);
    _cards = values
        .map<CreditCard>((row) => CreditCard.fromRow(
              row: row,
            ))
        .where((card) => card != null)
        .toList();

    _log.d(cards);
    _log.d('#################################################################');
    _log.d('loadData: parsed cards: total ${_cards.length}');
    _refreshCards();
    _log.d('loadData: filtered cards: total ${cards.length}');
    _log.d('loadData: end');
    notifyListeners();
    return _cards;
  }

  void applyFilters() {
    cards = _cards
        .map<CreditCardWithStatus>((c) => CreditCardWithStatus(
              card: c,
              status: CreditCardUtils.status(date, c),
            ))
        .where((ccs) {
      if (cardsFilter == CardsFilters.all) {
        return true;
      } else {
        return ccs.status == CreditCardStatus.use ||
            ccs.status == CreditCardStatus.alert;
      }
    }).toList();
    print('${cards.length}/${_cards.length}');
  }

  void applySorting() {
    cards.sort((a, b) {
      if (a == b) {
        return 0;
      }
      if (a.status == CreditCardStatus.use &&
          b.status != CreditCardStatus.use) {
        return -1;
      }
      return 1;
    });
  }

  _refreshCards() {
    applyFilters();
    applySorting();
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> addCard() async {
    _cards.add(tempCard);
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(_cards));
    tempCard = null;
    notifyListeners();
  }

  Future<void> editCard() async {
    int index = _cards.indexWhere((c) => c.hashCode == tempCard.hashCode);
    _cards[index] = tempCard;
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(_cards));
    tempCard = null;
    notifyListeners();
  }

  Future<void> deleteCard(CreditCard card) async {
    _cards.removeWhere((c) => c.hashCode == card.hashCode);
    await _gSheets.updateValues(_fileId, _cardsAsSheetValues(_cards));
    notifyListeners();
  }

  List<List<dynamic>> _cardsAsSheetValues(List<CreditCard> cards) {
    return cards.map<List<dynamic>>((c) => c.toRow()).toList();
  }
}

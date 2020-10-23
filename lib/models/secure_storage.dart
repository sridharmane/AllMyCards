import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorageKeys {
  static const String credentials = 'credentials';
  static const String user = 'user';
  static const String sheetId = 'sheetId';
}

class SecureStorage {
  static SecureStorage _instance;
  static FlutterSecureStorage _ss;
  static Logger _log;

  SecureStorage._internal() {
    _log = Logger();
  }

  factory SecureStorage() {
    if (_instance == null || _ss == null) {
      _instance = SecureStorage._internal();
      _ss = FlutterSecureStorage();
    }
    return _instance;
  }

  Future<bool> exists(String key) async {
    if (await _ss.containsKey(key: key)) {
      _log.i('$runtimeType: exists: $key: true');
      String value = await get(key);
      return value != null && value.isNotEmpty;
    }
    _log.i('$runtimeType: exists: $key: false');
    return false;
  }

  Future<String> get(String key) async {
    _log.i('$runtimeType: get: $key');
    if (await _ss.containsKey(key: key)) {
      return await _ss.read(key: key);
    }
    return null;
  }

  Future<void> set(String key, String value) async {
    _log.i('$runtimeType: set: $key:$value');
    return await _ss.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    _log.i('$runtimeType: delete: $key');
    return await _ss.delete(key: key);
  }

  Future<void> deleteAll() async {
    _log.i('$runtimeType: deleteAll');
    return await _ss.deleteAll();
  }
}

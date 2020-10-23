import 'dart:convert';

import 'package:all_my_cards/models/http_client.dart';
import 'package:all_my_cards/models/secure_storage.dart';
import 'package:all_my_cards/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

const SCOPES = ["https://www.googleapis.com/auth/drive.file"];

const String CLIENT_ID =
    "1060428360512-ap4lere3or38bsj34l4t3k23enhdbofj.apps.googleusercontent.com";

class Auth extends ChangeNotifier {
  Auth() {
    _gs = GoogleSignIn(
      clientId: CLIENT_ID,
      signInOption: SignInOption.standard,
      scopes: SCOPES,
    );
    signInSilently();
  }

  GoogleSignIn _gs;
  Logger _log = Logger();
  Map<String, String> headers;
  HttpClient client;
  User user;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  Future<GoogleSignInAccount> signIn() async {
    try {
      if (await SecureStorage().exists(SecureStorageKeys.credentials)) {
        final cred = await SecureStorage().get(SecureStorageKeys.credentials);
        _log.i('Found credentials: $cred');
        final user = await SecureStorage().get(SecureStorageKeys.user);
        _log.i('Found user: $user');
      }

      final account = await _gs.signIn();
      if (account != null) {
        await _onSignIn(account);

        await SecureStorage()
            .set(SecureStorageKeys.credentials, jsonEncode(headers));
        await SecureStorage().set(SecureStorageKeys.user, user.toString());
      }

      return account;
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  Future<GoogleSignInAccount> signInSilently() async {
    final account = await _gs.signInSilently();
    if (account != null) {
      await _onSignIn(account);
    }
    return account;
  }

  Future<void> signOut() async {
    await _gs.signOut();
    _onSignOut();
  }

  Future<void> _onSignIn(GoogleSignInAccount account) async {
    headers = await account.authHeaders;
    client = HttpClient(authHeaders: headers);
    user = User(
      id: account.id,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
    );
    _isSignedIn = await _gs.isSignedIn();

    notifyListeners();
  }

  Future<void> _onSignOut() async {
    user = null;
    headers = null;
    if (client != null) {
      client.close();
      client = null;
    }
    _isSignedIn = await _gs.isSignedIn();

    notifyListeners();
  }
}

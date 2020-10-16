import 'dart:convert';
import 'dart:typed_data';

import 'package:all_my_cards/models/http_client.dart';
import 'package:all_my_cards/models/secure_storage.dart';
import 'package:all_my_cards/models/user.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

const SCOPES = ["https://www.googleapis.com/auth/drive.file"];

class Auth {
  static Auth _instance;
  static GoogleSignIn _gs;
  static Logger _log = Logger();
  static Map<String, String> headers;
  factory Auth() {
    if (_instance == null) {
      _instance = Auth._internal();
    }
    return _instance;
  }
  Auth._internal() {
    appAuth = FlutterAppAuth();

    _clientId = ClientId(
        "1060428360512-ap4lere3or38bsj34l4t3k23enhdbofj.apps.googleusercontent.com",
        "");
    _gs = GoogleSignIn(
      clientId: _clientId.identifier,
      signInOption: SignInOption.standard,
      scopes: SCOPES,
    );
  }

  ClientId _clientId;
  HttpClient client;
  FlutterAppAuth appAuth;

  init() async {
    final AuthorizationTokenResponse result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        _clientId.identifier,
        'com.sridharmane.all_my_cards://oauthredirect',
        serviceConfiguration: AuthorizationServiceConfiguration(
          'https://accounts.google.com/o/oauth2/auth',
          'https://oauth2.googleapis.com/token',
        ),
        scopes: SCOPES,
      ),
    );

    // log.d('init');
    // if (client == null) {
    // client = await clientViaUserConsent(_clientId, SCOPES, (url) async {
    //     log.d('URl: $url');
    //     if (await canLaunch(url.toString())) {
    //       Uri uri = Uri.parse(url);
    //       if (Uri.parse(url).queryParameters.containsKey('redirect_uri')) {
    //         log.d('redirect_uri: ${uri.queryParameters['redirect_uri']}');
    //         // uri.queryParameters['redirect_uri'] = 'all_my_cards://success';
    //       }
    //       log.d('can launch');
    //       await launch(uri.toString(), enableJavaScript: true);
    //       log.d('completd');
    //     }
    //   });

    // _log.d('''
    // Credentials:
    // idToken: ${client.credentials.idToken}
    // acessToken: ${client.credentials.accessToken}
    // refreshToken: ${client.credentials.refreshToken}
    // ''');

    // final client2 =
    // await clientViaUserConsentManual(_clientId, SCOPES, (uri) async {
    //   log.d('URI 2: $uri');
    //   await launch(uri.toString(), enableJavaScript: true);
    //   log.d('After launch');

    //   return uri;
    // });

    // log.d('''
    // Credentials:
    // idToken: ${client2.credentials.idToken}
    // acessToken: ${client2.credentials.accessToken}
    // refreshToken: ${client2.credentials.refreshToken}
    // ''');
  }

  Future<GoogleSignInAccount> signIn() async {
    try {
      if (await SecureStorage().exists(SecureStorageKeys.credentials)) {
        final cred = await SecureStorage().get(SecureStorageKeys.credentials);
        _log.i('Found credentials: $cred');
        final user = await SecureStorage().get(SecureStorageKeys.user);
        _log.i('Found user: $user');
      }

      final account = await _gs.signIn();
      headers = await account.authHeaders;
      client = HttpClient(authHeaders: headers);

      await SecureStorage()
          .set(SecureStorageKeys.credentials, jsonEncode(headers));
      await SecureStorage().set(
          SecureStorageKeys.user,
          User(
            id: account.id,
            displayName: account.displayName,
            photoUrl: account.photoUrl,
          ).toString());

      return account;
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  googleSignIn() async {
    _log.d('googleSignIn');
    //Instantiate an OAuth2Client...
    GoogleOAuth2Client client = GoogleOAuth2Client(
      customUriScheme:
          'com.sridharmane.all_my_cards', //Must correspond to the AndroidManifest's "android:scheme" attribute
      redirectUri:
          'com.sridharmane.all_my_cards://oauth2redirect', //Can be any URI, but the scheme part must correspond to the customeUriScheme
    );
    _log.d('googleSignIn: client');
    //Then, instantiate the helper passing the previously instantiated client
    OAuth2Helper oauth2Helper = OAuth2Helper(
      client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: _clientId.identifier,
      clientSecret: '',
      scopes: SCOPES,
    );

    _log.d('googleSignIn: heper');
    final resp = await oauth2Helper.get(
        'https://sheets.googleapis.com/v4/spreadsheets/1iJdR1H4Uu3Rc6e9r8p-O-gDRMkXqamM7TQdggW6ruIw');
    _log.d('Body: ${resp.body}');
  }
}

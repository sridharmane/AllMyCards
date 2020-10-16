import 'package:http/http.dart';

class HttpClient extends BaseClient {
  final Map<String, String> _authHeaders;
  final Client _client;
  HttpClient({Map<String, String> authHeaders})
      : _authHeaders = authHeaders,
        _client = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(_authHeaders);
    return _client.send(request);
  }
}

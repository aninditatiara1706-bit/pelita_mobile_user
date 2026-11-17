import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client createAuthHttpClient() => _CookieClient(IOClient());

class _CookieClient extends http.BaseClient {
  _CookieClient(this._inner);

  final http.Client _inner;
  String? _cookie;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final cookie = _cookie;
    if (cookie != null) {
      request.headers['cookie'] = cookie;
    }

    final response = await _inner.send(request);
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      final parsedCookie = Cookie.fromSetCookieValue(setCookie);
      if (parsedCookie.maxAge == 0 ||
          (parsedCookie.expires?.isBefore(DateTime.now()) ?? false)) {
        _cookie = null;
      } else {
        _cookie = '${parsedCookie.name}=${parsedCookie.value}';
      }
    }
    return response;
  }

  @override
  void close() {
    _inner.close();
  }
}

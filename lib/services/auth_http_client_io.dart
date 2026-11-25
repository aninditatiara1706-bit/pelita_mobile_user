import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client createAuthHttpClient() => _CookieClient(IOClient());

class _CookieClient extends http.BaseClient {
  _CookieClient(this._inner);

  final http.Client _inner;

  String? _cookie;

  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest request,
  ) async {
    // Kirim cookie jika sudah tersimpan
    if (_cookie != null) {
      request.headers['cookie'] = _cookie!;
    }

    debugPrint('HTTP REQUEST: ${request.method} ${request.url}');
    debugPrint('COOKIE SENT: ${_cookie != null}');

    final response = await _inner.send(request);

    // Ambil cookie dari response server
    final setCookie = response.headers['set-cookie'];

    if (setCookie != null) {
      try {
        final parsedCookie =
            Cookie.fromSetCookieValue(setCookie);

        if (parsedCookie.maxAge == 0 ||
            (parsedCookie.expires != null &&
                parsedCookie.expires!
                    .isBefore(DateTime.now()))) {
          _cookie = null;

          debugPrint('COOKIE CLEARED');
        } else {
        _cookie = '${parsedCookie.name}=${parsedCookie.value}';
          debugPrint(
            'COOKIE SAVED: ${parsedCookie.name}',
          );
        }
      } catch (e) {
        debugPrint('COOKIE PARSE ERROR: $e');
      }
    }

    debugPrint('HTTP STATUS: ${response.statusCode}');

    return response;
  }

  @override
  void close() {
    _inner.close();
  }
}
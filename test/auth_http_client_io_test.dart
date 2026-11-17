import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pelita_user/services/auth_http_client_io.dart';

void main() {
  test('keeps a session cookie with a future expiry', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    String? receivedCookie;
    server.listen((request) async {
      if (request.uri.path == '/auth/login') {
        request.response.headers.add(
          HttpHeaders.setCookieHeader,
          'pelita_session=token; Max-Age=28800; '
              'Expires=${HttpDate.format(DateTime.now().add(const Duration(hours: 8)))}; '
              'Path=/; HttpOnly; SameSite=Lax',
        );
      } else {
        receivedCookie = request.headers.value(HttpHeaders.cookieHeader);
      }
      await request.response.close();
    });

    final client = createAuthHttpClient();
    addTearDown(() async {
      client.close();
      await server.close(force: true);
    });

    final baseUri = Uri(
      scheme: 'http',
      host: '127.0.0.1',
      port: server.port,
    );
    await client.post(baseUri.resolve('/auth/login'));
    await client.get(baseUri.resolve('/auth/me'));

    expect(receivedCookie, 'pelita_session=token');
  });
}

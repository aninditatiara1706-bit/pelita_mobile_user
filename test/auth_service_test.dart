import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pelita_user/services/auth_service.dart';

void main() {
  final originalPlatform = debugDefaultTargetPlatformOverride;

  tearDown(() {
    debugDefaultTargetPlatformOverride = originalPlatform;
  });

  test('uses the Android emulator host on Android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(AuthService.baseUrl, 'http://10.0.2.2:4000/api');
  });

  test('uses localhost on non-Android platforms', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    expect(AuthService.baseUrl, 'http://localhost:4000/api');
  });
}

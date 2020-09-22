import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zrd_base_tools/zrd_base_tools.dart';

void main() {
  const MethodChannel channel = MethodChannel('zrd_base_tools');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ZrdBaseTools.platformVersion, '42');
  });
}

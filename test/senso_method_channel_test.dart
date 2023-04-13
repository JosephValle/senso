import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senso/senso_method_channel.dart';

void main() {
  MethodChannelSenso platform = MethodChannelSenso();
  const MethodChannel channel = MethodChannel('senso');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}

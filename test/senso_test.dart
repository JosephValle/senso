import 'package:flutter_test/flutter_test.dart';
import 'package:senso/senso.dart';
import 'package:senso/senso_platform_interface.dart';
import 'package:senso/senso_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSensoPlatform
    with MockPlatformInterfaceMixin
    implements SensoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SensoPlatform initialPlatform = SensoPlatform.instance;

  test('$MethodChannelSenso is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSenso>());
  });

  test('getPlatformVersion', () async {
    Senso sensoPlugin = Senso();
    MockSensoPlatform fakePlatform = MockSensoPlatform();
    SensoPlatform.instance = fakePlatform;

    expect(await sensoPlugin.getPlatformVersion(), '42');
  });
}

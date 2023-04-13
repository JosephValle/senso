import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'senso_method_channel.dart';

abstract class SensoPlatform extends PlatformInterface {
  /// Constructs a SensoPlatform.
  SensoPlatform() : super(token: _token);

  static final Object _token = Object();

  static SensoPlatform _instance = MethodChannelSenso();

  static SensoPlatform get instance => _instance;

  static set instance(SensoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<GravityEvent> get gravityEvents {
    throw UnimplementedError('gravityEvent has not been implemented.');
  }
}

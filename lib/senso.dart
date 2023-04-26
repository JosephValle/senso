import 'package:senso/senso_method_channel.dart';

import 'senso_platform_interface.dart';

class Senso extends SensoPlatform {
  factory Senso() => _singleton ??= Senso._();

  Senso._();

  static Senso? _singleton;

  static SensoPlatform get _platform => SensoPlatform.instance;

  @override
  Stream<GravityEvent> get gravityEvents {
    return _platform.gravityEvents;
  }

  @override
  Stream<RotationEvent> get deviceRotationEvents {
    return _platform.deviceRotationEvents;
  }
}

final _sensors = Senso();

Stream<GravityEvent> get gravityEvents {
  return _sensors.gravityEvents;
}

Stream<RotationEvent> get deviceRotationEvents {
  return _sensors.deviceRotationEvents;
}

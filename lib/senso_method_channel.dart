import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'senso_platform_interface.dart';

class GravityEvent {
  GravityEvent(this.x, this.y, this.z);
  final double x;
  final double y;
  final double z;
  @override
  String toString() => '[GravityEvent (x: $x, y: $y, z: $z)]';
}

class MethodChannelSenso extends SensoPlatform {
  static const EventChannel _gravityEventChannel =
      EventChannel('np.com.satkardhakal/senso/gravity');
  Stream<GravityEvent>? _gravityEvents;

  @visibleForTesting
  final methodChannel = const MethodChannel('senso');

  @override
  Stream<GravityEvent> get gravityEvents {
    _gravityEvents ??=
        _gravityEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return GravityEvent(list[0]!, list[1]!, list[2]!);
    });
    return _gravityEvents!;
  }
}

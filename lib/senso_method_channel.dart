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

class RotationEvent {
  RotationEvent(
      this.roll, this.pitch, this.yaw, this.x, this.y, this.z, this.w);
  final double roll;
  final double pitch;
  final double yaw;
  final double x, y, z, w;
  @override
  String toString() =>
      '[RotationEvent (roll: $roll, pitch: $pitch, yaw: $yaw, x: $x, y: $y, z: $z, w: $w)]';
}

class MethodChannelSenso extends SensoPlatform {
  static const EventChannel _gravityEventChannel =
      EventChannel('np.com.satkardhakal/senso/gravity');
  static const EventChannel _deviceRotationChannel =
      EventChannel('np.com.satkardhakal/senso/rotation');
  Stream<GravityEvent>? _gravityEvents;
  Stream<RotationEvent>? _deviceRotationEvents;

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

  @override
  Stream<RotationEvent> get deviceRotationEvents {
    _deviceRotationEvents ??=
        _deviceRotationChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return RotationEvent(
          list[0]!, list[1]!, list[2]!, list[3]!, list[4]!, list[5]!, list[6]!);
    });
    return _deviceRotationEvents!;
  }
}

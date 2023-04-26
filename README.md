# senso

A Flutter plugin to get force of gravity, attitude values(pitch,roll,yaw,Quaternion.x, Quaternion.y, Quaternion.z), through sensor for Android and IOS. I intend to add more sensor events to this, hence the name 'senso'.

## Example

```
import 'package:senso/senso.dart';

gravityEvents.listen((GravityEvent event) {
  print(event);
});
deviceRotationEvents.listen((RotationEvent event) {
  print(event);
});
```

package np.com.satkardhakal.senso

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BinaryMessenger
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager


/** SensoPlugin */
class SensoPlugin: FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var gravityChannel: EventChannel
  private lateinit var deviceRotationChannel: EventChannel
  private lateinit var gravityStreamHandler: StreamHandlerImpl
  private lateinit var deviceRotStreamHandler: DeviceRoatationStreamHandlerImpl

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setupEventChannels(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }
   override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        teardownEventChannels()
    }

  private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
        val sensorsManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        gravityChannel = EventChannel(messenger, "np.com.satkardhakal/senso/gravity")
        gravityStreamHandler = StreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_GRAVITY
        )
        gravityChannel.setStreamHandler(gravityStreamHandler)
        deviceRotationChannel = EventChannel(messenger, "np.com.satkardhakal/senso/rotation")
        deviceRotStreamHandler = DeviceRoatationStreamHandlerImpl(
                sensorsManager,
                Sensor.TYPE_ROTATION_VECTOR
        )
        deviceRotationChannel.setStreamHandler(deviceRotStreamHandler)
    }

  private fun teardownEventChannels() {
        gravityChannel.setStreamHandler(null)
        deviceRotationChannel.setStreamHandler(null)
      
      }
}

package np.com.satkardhakal.senso

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

internal class StreamHandlerImpl(
        private val sensorManager: SensorManager,
        sensorType: Int
) : EventChannel.StreamHandler {
    private var sensorEventListener: SensorEventListener? = null

    private val sensor: Sensor by lazy {
        sensorManager.getDefaultSensor(sensorType)
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        sensorEventListener = createSensorEventListener(events)
        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorEventListener)
    }

    private fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size)
                var multiplier : Double = 1.0/9.8;
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble() * multiplier
                }
                events.success(sensorValues)
            }
        }
    }
}


internal class DeviceRoatationStreamHandlerImpl(
        private val sensorManager: SensorManager,
        sensorType: Int
) : EventChannel.StreamHandler  {
    private var sensorEventListener: SensorEventListener? = null

    private val sensor: Sensor by lazy {
        sensorManager.getDefaultSensor(sensorType)
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        sensorEventListener = createSensorEventListener(events)
        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
    }
    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorEventListener)
    }
     private fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                var rotationVector = event.values;
                var rotationMatrix = FloatArray(9); 
                SensorManager.getRotationMatrixFromVector(rotationMatrix, rotationVector);
                

                // Remap the axes to match xMagneticNorthZVertical reference system in IOS.
                val worldAxisForDeviceAxisX = SensorManager.AXIS_Y;
                val worldAxisForDeviceAxisY = SensorManager.AXIS_MINUS_X;

                
                val adjustedRotationMatrix = FloatArray(9);
                SensorManager.remapCoordinateSystem(rotationMatrix, worldAxisForDeviceAxisX,
                        worldAxisForDeviceAxisY, adjustedRotationMatrix);

                // Transform rotation matrix into azimuth/pitch/roll
                val orientation = FloatArray(9);
                SensorManager.getOrientation(adjustedRotationMatrix, orientation);
                val pitch =  orientation[1];
                val roll  =  orientation[2];
                val azimuth = orientation[0];
                var sensorValues = FloatArray(7);
                sensorValues[0] = pitch;
                sensorValues[1] = roll;
                sensorValues[2] = azimuth;
                //For quaternion, again changing the axes to match xMagneticNorthZVertical reference system in IOS.
                sensorValues[3] = rotationVector[1];
                sensorValues[4] = -rotationVector[0];
                sensorValues[5] = rotationVector[2];
                sensorValues[6] = rotationVector[3];

                events.success(sensorValues);
            }
        }
    }
}


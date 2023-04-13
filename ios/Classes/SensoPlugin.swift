import Flutter
import UIKit
import CoreMotion

public class SensoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "senso", binaryMessenger: registrar.messenger())
    let instance = SensoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let gravityChannel = FlutterEventChannel(name: "np.com.satkardhakal/senso/gravity", binaryMessenger: registrar.messenger())                                                                            
    gravityChannel.setStreamHandler(GravityStreamHandler())   
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

class GravityStreamHandler: NSObject, FlutterStreamHandler {                                                                                                                                  
  let motionManager = CMMotionManager()

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {                                                                     
      if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { (data, error) in
              if let gravityData = data?.gravity {
                // Send gravity data to a callback function
                self.gravityCallback(gravityData,events)
              }
            }
          }
        return nil                                                                                                                                                                           
    }                                                                                                                                                                                        
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
  func gravityCallback(_ data: CMAcceleration, _ sink:FlutterEventSink) {
    sink([data.x,data.y,data.z])
  }
}    

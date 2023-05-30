import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "battery",
                                              binaryMessenger: controller.binaryMessenger)
    let counterEventChannel = FlutterEventChannel(name: "counter", binaryMessenger: controller.binaryMessenger)

    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.receiveBatteryLevel(result: result)
    })

    counterEventChannel.setStreamHandler(CounterHandler())
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Battery info unavailable",
                          details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
}

class CounterHandler: NSObject, FlutterStreamHandler {
    private let handler = DispatchQueue.main
    private var eventSink: FlutterEventSink?
    private var counter: Int = 0
    private var timer: Timer?

    @objc func countUp() {
        eventSink?(counter)
        counter += 1
    }

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        timer?.invalidate()
        timer = nil
        return nil
    }
}

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let registrar = registrar(forPlugin: "com.example.flutterNativeCodeSample")

    // PlatformView用に、UIの登録
    if let registrarUnwrapped = registrar {
      let factory = NativeViewFactory(messenger: registrarUnwrapped.messenger())
      registrarUnwrapped.register(
        factory,
        withId: "native_view"
      )
    } else {
      print("Error: Could not obtain FlutterPluginRegistrar")
    }

    // 各チャンネルの定義
    let methodChannel = FlutterMethodChannel(name: "battery",
                                              binaryMessenger: controller.binaryMessenger)
    let eventChannel = FlutterEventChannel(name: "counter", binaryMessenger: controller.binaryMessenger)
    let basicMessageChannel = FlutterBasicMessageChannel(name: "message",
                                                  binaryMessenger: controller.binaryMessenger,
                                                  codec: FlutterStringCodec.sharedInstance())

    // Method Channel Handler
    methodChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.receiveBatteryLevel(result: result)
    })

    // Event Channel Handler
    eventChannel.setStreamHandler(CounterHandler())

    // Basic Message Channel Handler
    basicMessageChannel.setMessageHandler { (message: Any?, reply: @escaping FlutterReply) in
      print("iOS: Received message = \(String(describing: message))")
      reply("Reply from iOS")
    }

    // Basic Message ChannelでFlutterにReply
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      basicMessageChannel.sendMessage("Hello World from iOS") { (reply) in
        print("iOS: \(String(describing: reply))")
      }
    }

    // Pigeonの設定
    let api = MessageApiImpl()
    MessageApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Method ChannelのHandler本体
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

// Event ChannelのHandler本体
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

// Pigeonのプロトコルから実体の定義
class MessageApiImpl: NSObject, MessageApi {
  private var message: String?

  func sendMessage(msg: Message) {
    message = msg.content
  }

  func receiveMessage() -> Message {
    return Message(content: message)
  }
}

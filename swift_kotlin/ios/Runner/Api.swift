// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct Message {
  var content: String? = nil

  static func fromList(_ list: [Any?]) -> Message? {
    let content: String? = nilOrValue(list[0])

    return Message(
      content: content
    )
  }
  func toList() -> [Any?] {
    return [
      content,
    ]
  }
}
private class MessageApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return Message.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class MessageApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? Message {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class MessageApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MessageApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MessageApiCodecWriter(data: data)
  }
}

class MessageApiCodec: FlutterStandardMessageCodec {
  static let shared = MessageApiCodec(readerWriter: MessageApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol MessageApi {
  func sendMessage(msg: Message) throws
  func receiveMessage() throws -> Message
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class MessageApiSetup {
  /// The codec used by MessageApi.
  static var codec: FlutterStandardMessageCodec { MessageApiCodec.shared }
  /// Sets up an instance of `MessageApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: MessageApi?) {
    let sendMessageChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_native_code_sample.MessageApi.sendMessage", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      sendMessageChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let msgArg = args[0] as! Message
        do {
          try api.sendMessage(msg: msgArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      sendMessageChannel.setMessageHandler(nil)
    }
    let receiveMessageChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_native_code_sample.MessageApi.receiveMessage", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      receiveMessageChannel.setMessageHandler { _, reply in
        do {
          let result = try api.receiveMessage()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      receiveMessageChannel.setMessageHandler(nil)
    }
  }
}
import UIKit
import Flutter

class NativeView: NSObject, FlutterPlatformView {
    let textView: UILabel
    let frame: CGRect
    let viewId: Int64

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId
        
        textView = UILabel(frame: frame)
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if let args = args as? [String: Any], let id = args["id"] as? Int {
            textView.text = "Native iOS view (id: \(id))"
        } else {
            textView.text = "Native iOS view (id: \(viewId))"
        }
        super.init()
    }

    func view() -> UIView {
        return textView
    }
}

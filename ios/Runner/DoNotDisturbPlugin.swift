import Flutter
import UIKit
import UserNotifications

@objc public class DoNotDisturbPlugin: NSObject {
    private var eventSink: FlutterEventSink?
    private var observer: NSObjectProtocol?
    
    @objc public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "canSendNotifications":
            checkNotificationStatus { status in
                result(status)
            }
        case "isDoNotDisturbEnabled":
            // iOS لا يوفر واجهة برمجة مباشرة للتحقق من وضع عدم الإزعاج
            // يمكن استخدام حالة أذونات الإشعارات كبديل
            checkNotificationStatus { status in
                result(!status)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(settings.authorizationStatus == .authorized)
                }
            }
        } else {
            // للإصدارات القديمة من iOS
            let settings = UIApplication.shared.currentUserNotificationSettings
            completion(settings?.types.contains(.alert) ?? false)
        }
    }
    
    @objc public func getNotificationSettingsStreamHandler() -> NotificationSettingsStreamHandler {
        return NotificationSettingsStreamHandler()
    }
}

// تنفيذ StreamHandler لمراقبة تغييرات إعدادات الإشعارات
@objc public class NotificationSettingsStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var observer: NSObjectProtocol?
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        
        // مراقبة تغييرات إعدادات الإشعارات عند عودة التطبيق للواجهة
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            self?.checkAndSendNotificationStatus()
        }
        
        // إرسال الحالة الأولية
        checkAndSendNotificationStatus()
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        eventSink = nil
        return nil
    }
    
    private func checkAndSendNotificationStatus() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                DispatchQueue.main.async {
                    // عكس الحالة لتتوافق مع معنى وضع عدم الإزعاج (true = وضع عدم الإزعاج مفعل = لا يمكن إرسال إشعارات)
                    let dndEnabled = settings.authorizationStatus != .authorized
                    self?.eventSink?(dndEnabled)
                }
            }
        } else {
            // للإصدارات القديمة من iOS
            let settings = UIApplication.shared.currentUserNotificationSettings
            let dndEnabled = settings?.types.contains(.alert) != true
            eventSink?(dndEnabled)
        }
    }
}
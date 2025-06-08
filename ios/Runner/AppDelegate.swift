import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // مراجع لقنوات الاتصال
    private var dndMethodChannel: FlutterMethodChannel?
    private var dndEventChannel: FlutterEventChannel?
    private var batteryMethodChannel: FlutterMethodChannel?
    
    // مراجع للبلج-ان
    private var doNotDisturbPlugin: DoNotDisturbPlugin?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        
        // إعداد قنوات الاتصال
        setupMethodChannels(controller: controller)
        
        // تسجيل البلج-ان
        registerPlugins(controller: controller)
        
        // تهيئة إعدادات الإشعارات
        setupNotifications(application: application)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannels(controller: FlutterViewController) {
        // إعداد قناة وضع عدم الإزعاج
        dndMethodChannel = FlutterMethodChannel(
            name: "com.athkar.app/do_not_disturb",
            binaryMessenger: controller.binaryMessenger
        )
        
        // إعداد قناة أحداث وضع عدم الإزعاج
        dndEventChannel = FlutterEventChannel(
            name: "com.athkar.app/notification_settings_events",
            binaryMessenger: controller.binaryMessenger
        )
        
        // إعداد قناة تحسينات البطارية
        batteryMethodChannel = FlutterMethodChannel(
            name: "com.athkar.app/battery_optimization",
            binaryMessenger: controller.binaryMessenger
        )
    }
    
    private func registerPlugins(controller: FlutterViewController) {
        // إنشاء وتسجيل بلج-ان وضع عدم الإزعاج
        doNotDisturbPlugin = DoNotDisturbPlugin()
        
        // ربط البلج-ان بالقنوات
        if let methodChannel = dndMethodChannel {
            methodChannel.setMethodCallHandler(doNotDisturbPlugin?.handle)
        }
        
        if let eventChannel = dndEventChannel {
            eventChannel.setStreamHandler(doNotDisturbPlugin?.getNotificationSettingsStreamHandler())
        }
        
        // ربط قناة البطارية
        if let batteryChannel = batteryMethodChannel {
            batteryChannel.setMethodCallHandler { [weak self] (call, result) in
                self?.handleBatteryMethodCall(call, result: result)
            }
        }
    }
    
    private func setupNotifications(application: UIApplication) {
        // طلب أذونات الإشعارات
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // معالجة استدعاءات قناة البطارية
    private func handleBatteryMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isBatteryOptimizationEnabled":
            // iOS لا يوجد به تحسين بطارية مشابه لأندرويد
            result(false)
        case "requestBatteryOptimizationDisable":
            // توجيه المستخدم إلى إعدادات البطارية على iOS
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(true)
            } else {
                result(false)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // التعامل مع الإشعارات أثناء تشغيل التطبيق
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }
    
    // التعامل مع التفاعل مع الإشعارات
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // تنفيذ المنطق المطلوب عند النقر على الإشعار
        
        completionHandler()
    }
}
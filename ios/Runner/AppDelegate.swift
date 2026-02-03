import ApphudSDK
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        registerForNotifications()
        return super.application(
            application, didFinishLaunchingWithOptions: launchOptions)
    }

    func registerForNotifications() {
        UNUserNotificationCenter.current().delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            UNUserNotificationCenter.current().requestAuthorization(options: [
                .alert, .badge, .sound,
            ]) { (_, _) in }
        }

        UIApplication.shared.registerForRemoteNotifications()
    }

    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        super.application(
            application, didFailToRegisterForRemoteNotificationsWithError: error
        )
    }

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Apphud.submitPushNotificationsToken(token: deviceToken, callback: nil)
        super.application(
            application,
            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let isHandled = Apphud.handlePushNotification(
            apsInfo: response.notification.request.content.userInfo)
        if !isHandled {
            completionHandler()
            super.userNotificationCenter(
                center, didReceive: response,
                withCompletionHandler: completionHandler)
        }
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        let isHandled = Apphud.handlePushNotification(
            apsInfo: notification.request.content.userInfo)
        if !isHandled {
            completionHandler([.alert, .badge, .sound])
            super.userNotificationCenter(
                center, willPresent: notification,
                withCompletionHandler: completionHandler)
        }
    }
}

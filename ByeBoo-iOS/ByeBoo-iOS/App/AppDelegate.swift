//
//  AppDelegate.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/23/25.
//

import UIKit

import Firebase
import FirebaseMessaging
import KakaoSDKCommon
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)

        KakaoSDK.initSDK(appKey: ConfigManager.kakaoNativeAppKey)
        Mixpanel.initialize(token: ConfigManager.mixpanelToken, trackAutomaticEvents: true)
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        guard let notificationRepository = DIContainer.shared.resolve(type: DefaultNotificationRepository.self) else {
            return
        }
        
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error {
                ByeBooLogger.error(error)
                return
            }
            guard let token else {
                return
            }
            
            Task {
                do {
                    try await notificationRepository.updateToken(token: token)
                } catch (let error) {
                    ByeBooLogger.error(error)
                }
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        ByeBooLogger.error(error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        if #available(iOS 14.0, *) {
            return [.sound, .banner, .list]
        }
        return []
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let bottomNavigationViewController = ByeBooTabBar()
        bottomNavigationViewController.selectedIndex = 1
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: bottomNavigationViewController,
                withAnimation: false
            )
        }
    }
}

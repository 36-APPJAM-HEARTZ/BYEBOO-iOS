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
        
        if let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        } else {
            fatalError("카카오 네이티브 앱 키 없음")
        }
        
        if let mixpanelToken = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_TOKEN") as? String {
            Mixpanel.initialize(token: mixpanelToken, trackAutomaticEvents: true)
        } else {
            ByeBooLogger.debug("믹스 패널 토큰 없음")
        }
        
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
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken,
              let notificationRepository = DIContainer.shared.resolve(type: DefaultNotificationRepository.self),
              let originalToken: String = notificationRepository.loadToken() else {
            return
        }
        
        if fcmToken != originalToken {
            Task {
                do {
                    try await notificationRepository.updateToken(token: fcmToken)
                } catch (let error) {
                    ByeBooLogger.error(error)
                }
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        ByeBooLogger.error(error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let userDefaultsService = DefaultUserDefaultService()
        
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error {
                ByeBooLogger.error(error)
            }
            if let token {
                let _ = userDefaultsService.save(token, key: .fcmToken)
            }
        }
    }
    
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
        let bottomNavigationViewController = BottomNavigationViewController()
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

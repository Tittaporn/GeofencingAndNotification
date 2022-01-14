//
//  AppDelegate.swift
//  Geofencing
//
//  Created by M3ts LLC on 1/13/22.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // To Register Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized, error) in
            if let error = error {
                print("\(Date()) -- There was an error requesting authorization to use notifications. Error: \(error.localizedDescription) -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            }
            if authorized {
                UNUserNotificationCenter.current().delegate = self
                print("\(Date()) -- ✅ The user authorized notifications. -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            } else {
                print("\(Date()) -- ❌ The user did not authorized notifications. -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            }
        }
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

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(Date()) -- Notification will present... -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
        completionHandler([.sound, .banner])
    }
}

//
//  TimerLoopAppDelegate.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/30/20.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // Allows notifications to be received when the app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        log.debug("Notification received while in foreground.")
        
        completionHandler([.banner, .sound])
    }
}

//
//  TimerLoopAppDelegate.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/30/20.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // Allows notifications to be received when the app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

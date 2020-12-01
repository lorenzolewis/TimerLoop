//
//  NotificationManager.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/29/20.
//

// https://stackoverflow.com/questions/30852870/displaying-a-stock-ios-notification-banner-when-your-app-is-open-and-in-the-fore/40756060#40756060

import SwiftUI
import UserNotifications
import CoreData

struct NotificationManager {
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    
    private struct NotificationData {
        let title: String
        var components: DateComponents
        let threadIdentifier: String
    }
        
    func refreshNotifications() {
        log.info("Attempting to refresh the notifications...")
        guard let loops = fetchCoreDataLoops() else {
            log.error("Problem fetching loops from core data")
            return
        }
        let notifications = createNotificationData(from: loops)
        center.removeAllPendingNotificationRequests()
        schedule(with: notifications)
    }
    
    private func createNotificationData(from loops: [CoreDataLoop]) -> [NotificationData] {
        var notifications = [NotificationData]()
        
        for loop in loops {
            if loop.isEnabled {
                // Makes sure that startTime and endTime are non-nil
                guard var startTime = loop.startTime,
                      var endTime = loop.endTime else { continue }
                
                // Set times to current date
                var startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
                startTime = Calendar.current.date(from: startTimeComponents)!
                
                let endTimeComponenets = Calendar.current.dateComponents([.hour, .minute], from: endTime)
                endTime = Calendar.current.date(from: endTimeComponenets)!
                
                // If end time is prior to start time, move ahead a day (past midnight)
                if endTime < startTime {
                    endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
                }
                                
                // Create notification to work with
                var notification = NotificationData(
                    title: loop.name ?? "Your timer has looped!",
                    components: startTimeComponents,
                    threadIdentifier: loop.id!.uuidString
                )
                
                while startTime < endTime {
                    notification.components = startTimeComponents
                    notifications.append(notification)
                    
                    // Add the interval to the start time
                    startTime = Calendar.current.date(byAdding: .minute, value: Int(loop.interval * 60), to: startTime)!
                    startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
                }
            }
        }
        log.info("Created \(notifications.count) notification data to try to schedule")
        return notifications
    }
    
    private func schedule(with notifications: [NotificationData]) {
        log.info("Checking notification authorization status...")
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Request authorization
                log.info("Requesting notification authorization...")
                center.requestAuthorization(options: [.alert]) { granted, error in
                    if granted && error == nil {
                        log.info("Granted.")
                        scheduleNotifications(with: notifications)
                    } else {
                        log.info("Not granted: \(granted) \(String(describing: error))")
                        scheduleAlerts(with: notifications)
                    }
                }
            case .authorized, .provisional, .ephemeral:
                log.info("Notifications are allowed.")
                scheduleNotifications(with: notifications)
            case .denied:
                log.info("Notifications are denied.")
                scheduleAlerts(with: notifications)
            default:
                log.error("An issue occured while checking for notification authorization status: \(settings.authorizationStatus)")
                scheduleAlerts(with: notifications)
            }
        }
    }
    
    private func scheduleNotifications(with notifications: [NotificationData]) {
        log.info("Attempting to schedule \(notifications.count) notification(s)...")
        for notification in notifications {
            log.debug("Scheduling notification: \(notification)")
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.threadIdentifier = notification.threadIdentifier
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.components, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    log.error("Issue adding notification request to UserNotificationCenter: \(error)")
                }
            }
        }
        log.info("Complete.")
    }
    
    private func scheduleAlerts(with notifications: [NotificationData]) {
        
        log.info("Scheduling alerts.")
                
        // Sort by dates, getting next one that will occur
        let notifications = notifications.sorted {
            Calendar.current.nextDate(after: Date(), matching: $0.components, matchingPolicy: .nextTime)! < Calendar.current.nextDate(after: Date(), matching: $1.components, matchingPolicy: .nextTime)!
        }
                
        guard let nextNotification = notifications.first else {
            log.error("No notifications to create an alert for")
            return
        }
        
        let date = Calendar.current.nextDate(after: Date(), matching: nextNotification.components, matchingPolicy: .nextTime)
        
        let timer = Timer(fire: date!, interval: 0, repeats: false) { _ in
            log.info("Firing in-app timer for alert notification")
            
            let alert = Alert(title: Text(nextNotification.title), message: nil, dismissButton: .default(Text("Dismiss")))
            AlertManager.shared.enqueue(alert)
            
            refreshNotifications()
        }
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func fetchCoreDataLoops() -> [CoreDataLoop]? {
        let context = PersistenceManager.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataLoop> = CoreDataLoop.fetchRequest()
        let loops = try? context.fetch(fetchRequest)
        return loops
    }
    
    private init() {}
}

//
//  NotificationManager.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/29/20.
//

// https://stackoverflow.com/questions/30852870/displaying-a-stock-ios-notification-banner-when-your-app-is-open-and-in-the-fore/40756060#40756060

import Foundation
import UserNotifications
import CoreData

struct NotificationManager {
    static let shared = NotificationManager()
    
    private struct NotificationData {
        let title: String
        var time: Date
        let threadIdentifier: String
    }
    
    func refreshNotifications() {
        guard let loops = fetchCoreDataLoops() else { return }
        let notifications = createNotificationData(from: loops)
    }
    
    private func createNotificationData(from loops: [CoreDataLoop]) -> [NotificationData] {
        var notifications = [NotificationData]()
        
        for loop in loops {
            if loop.isEnabled {
                // Makes sure that startTime and endTime are non-nil
                guard var startTime = loop.startTime,
                      var endTime = loop.endTime else { continue }
                
                // Set times to current date
                let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
                startTime = Calendar.current.date(byAdding: startTimeComponents, to: Date())!
                
                let endTimeComponenets = Calendar.current.dateComponents([.hour, .minute], from: endTime)
                endTime = Calendar.current.date(byAdding: endTimeComponenets, to: Date())!
                
                // If end time is prior to start time, move ahead a day (past midnight)
                if endTime < startTime {
                    endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
                }
                
                // Create notification to work with
                var notification = NotificationData(
                    title: loop.name ?? "Your timer has looped!",
                    time: startTime,
                    threadIdentifier: loop.id!.uuidString
                )
                
                while startTime < endTime {
                    notification.time = startTime
                    notifications.append(notification)
                    
                    // Add the interval to the start time
                    startTime = Calendar.current.date(byAdding: .minute, value: Int(loop.interval * 60), to: startTime)!
                }
            }
        }
        
        return notifications
    }
    
    private func fetchCoreDataLoops() -> [CoreDataLoop]? {
        let context = PersistenceManager.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataLoop> = CoreDataLoop.fetchRequest()
        let loops = try? context.fetch(fetchRequest)
        return loops
    }
    
    private init() {}
}

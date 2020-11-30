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
        
    }
    
    func refreshNotifications() {
        guard let loops = fetchCoreDataLoops() else { return }
        let notifications = createNotificationData(from: loops)
        // Create notification array
    }
    
    private func createNotificationData(from loops: [CoreDataLoop]) -> [NotificationData] {
        var notifications = [NotificationData]()
        
        for loop in loops {
            if loop.isEnabled {
                
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

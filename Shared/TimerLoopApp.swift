//
//  TimerLoopApp.swift
//  Shared
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import SwiftUI

let log = LoggingManager.shared.log

@main
struct TimerLoopApp: App {
    
    init() {
        alertManager = AlertManager.shared
        persistenceController = PersistenceManager.shared
        
        DispatchQueue.global().async {
            VersionManager()
            NotificationManager.shared.refreshNotifications()
        }
    }
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    @ObservedObject private var alertManager: AlertManager
    let persistenceController: PersistenceManager
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(isPresented: $alertManager.isPresented) { alertManager.dequeue() }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

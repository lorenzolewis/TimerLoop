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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var alertManager = AlertManager.shared
    
    let persistenceController = PersistenceManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(isPresented: $alertManager.isPresented) { alertManager.dequeue() }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

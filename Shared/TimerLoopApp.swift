//
//  TimerLoopApp.swift
//  Shared
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import SwiftUI

@main
struct TimerLoopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceManager.shared
    @ObservedObject private var alertManager = AlertManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(isPresented: $alertManager.isPresented) { alertManager.dequeue() }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

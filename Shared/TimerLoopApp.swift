//
//  TimerLoopApp.swift
//  Shared
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import SwiftUI

@main
struct TimerLoopApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

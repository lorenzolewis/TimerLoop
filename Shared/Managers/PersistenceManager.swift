//
//  PersistenceManager.swift
//  Shared
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()

    static var preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newLoop = CoreDataLoop(context: viewContext)
            newLoop.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            log.error("An issue occured while attempting to save the preview loops: \(error)")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TimerLoop")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                log.error("Something really bad happened when trying to load the CoreData persistent store: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

//
//  LoopViewModel.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import Foundation
import Combine
import CoreData

class LoopViewModel: Identifiable, ObservableObject {
    private var coreDataLoop: CoreDataLoop?
    private var context: NSManagedObjectContext
    
    let id: UUID
    var name: String {
        didSet { unsavedChanges = true }
    }
    var isEnabled: Bool {
        didSet { unsavedChanges = true }
    }
    @Published var interval: Double {
        didSet { unsavedChanges = true }
    }
    
    @Published var unsavedChanges = false
    
    static var previewLoop: LoopViewModel {
        let context = PersistenceManager.preview.container.viewContext
        let coreDataLoop = CoreDataLoop(context: context)
        coreDataLoop.interval = 1
        return LoopViewModel(coreDataLoop)
    }
    
    /// Instantiate a LoopViewModel using an existing CoreDataLoop
    /// - Parameter coreDataLoop: Existing CoreDataLoop
    init(_ coreDataLoop: CoreDataLoop) {
        id = coreDataLoop.id ?? UUID()
        name = coreDataLoop.name ?? ""
        isEnabled = coreDataLoop.isEnabled
        interval = coreDataLoop.interval
        
        self.coreDataLoop = coreDataLoop
        context = coreDataLoop.managedObjectContext!
    }
    
    /// Instantiate for a draft LoopViewModel
    /// - Parameter context: Context that the CoreDataLoop should be saved to
    init(context: NSManagedObjectContext) {
        id = UUID()
        name = ""
        isEnabled = true
        interval = 1.0
        
        unsavedChanges = true
        
        self.context = context
    }
    
    // MARK: Functions
    
    func save() {
        // Check to see if working with a commited loop or draft loop
        if coreDataLoop == nil {
            coreDataLoop = CoreDataLoop(context: context)
        }
        
        coreDataLoop?.id = id
        coreDataLoop?.name = name
        coreDataLoop?.isEnabled = isEnabled
        coreDataLoop?.interval = interval
        
        try? context.save()
    }
    
    // MARK: Calculated Values
    
    var intervalString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        if let string = formatter.string(from: interval * 60 * 60) {
            return "Every \(string)"
        }
        else {
            return "Error"
        }
    }
    
    var displayName: String {
        return name != "" ? name : "Loop"
    }
}

//
//  LoopViewModel.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/28/20.
//

import Foundation
import Combine

class LoopViewModel: Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var isEnabled: Bool
    @Published var interval: Double
    
    static var previewLoop: LoopViewModel {
        let context = PersistenceController.preview.container.viewContext
        let coreDataLoop = CoreDataLoop(context: context)
        coreDataLoop.interval = 1
        return LoopViewModel(coreDataLoop)
    }
    
    init(_ coreDataLoop: CoreDataLoop) {
        id = coreDataLoop.id ?? UUID()
        name = coreDataLoop.name ?? ""
        isEnabled = coreDataLoop.isEnabled
        interval = coreDataLoop.interval
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
}

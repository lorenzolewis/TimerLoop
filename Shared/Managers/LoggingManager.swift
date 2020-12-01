//
//  LoggingManager.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/30/20.
//

import SwiftyBeaver

struct LoggingManager {
    static let shared = LoggingManager()
    let log = SwiftyBeaver.self
    
    private init() {
        let file = FileDestination()
        let console = ConsoleDestination()
        log.addDestination(file)
        log.addDestination(console)
    }
}

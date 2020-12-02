//
//  VersionManager.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 12/1/20.
//

import Foundation

struct VersionManager {
    
    let runningVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @discardableResult init() {
        guard let storedVersion = UserDefaults.standard.string(forKey: "version") else {
            log.info("No previous version found, saving \(String(describing: runningVersion))")
            UserDefaults.standard.setValue(runningVersion, forKey: "version")
            return
        }
        
        log.info("Found version \(storedVersion)")
    }
}

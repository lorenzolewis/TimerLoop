//
//  AlertManager.swift
//  TimerLoop
//
//  Created by Lorenzo Lewis on 11/30/20.
//

// Adapted from https://gist.github.com/2no/175a6f405f26896a4a515bb59122baf6

import Combine
import SwiftUI

class AlertManager: ObservableObject {
    @Published var isPresented = false
    
    static let shared = AlertManager()

    private var queues: [Alert] = []
    private var cancellable: AnyCancellable?

    private init() {
        cancellable = $isPresented
            .filter({ [weak self] isPresented in
                guard let self = self else {
                    return false
                }
                return !isPresented && !self.queues.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.isPresented = true
            })
    }

    func enqueue(_ alert: Alert) {
        queues.append(alert)
        isPresented = true
    }

    func dequeue() -> Alert {
        queues.removeFirst()
    }
}

//
//  Debouncer.swift
//  WorkoutTracker
//
//  Created by Austin  on 8/3/23.
//

import Foundation

class Debouncer {
    private let interval: TimeInterval
    private var timer: Timer?
    private var action: () -> Void
    
    init(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
    }
    
    func debounce() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.action()
        }
    }
    
    func cancel() {
        timer?.invalidate()
    }
}

//
//  Untitled.swift
//  Focusie
//
//  Created by Anastasia Mousa on 9/3/26.
//

import Foundation
import Combine

final class FocusViewModel: ObservableObject {
   
    @Published private(set) var state = FocusState()
    
    private var timer: Timer?
    
    func send(action: FocusIntent) {
        switch action {
        case .startTapped:
            startTimer()
        case .pauseTapped:
            pauseTimer()
        case .resetTapped:
            resetTimer()
        case .timeSecPassed:
            handleTimeSecs()
        case .setDuration(let seconds):
            setDuration(seconds)
        }
    }
}

private extension FocusViewModel {
    func startTimer() {
        guard !state.isRunning else { return }
        state.isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.send(action: .timeSecPassed)
        }
    }
    
    func pauseTimer() {
        state.isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        pauseTimer()
        state.remainingSeconds = state.totalSeconds
    }
    
    func handleTimeSecs() {
        guard state.remainingSeconds > 0 else {
            pauseTimer()
            return
        }
        
        state.remainingSeconds -= 1
        if state.remainingSeconds == 0 {
            pauseTimer()
        }
    }
    
    func setDuration(_ seconds: Int) {
        // Clamp to a sensible minimum to avoid zero/negative durations
        let clamped = max(0, seconds)
        // If the timer is running, pause before changing duration
        if state.isRunning { pauseTimer() }
        state.totalSeconds = clamped
        // Reset remaining to the new total
        state.remainingSeconds = clamped
    }
}

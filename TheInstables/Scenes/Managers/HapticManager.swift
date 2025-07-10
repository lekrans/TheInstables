//
//  HapticManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-07-08.
//

import CoreHaptics

class HapticManager {
    private var engine: CHHapticEngine?
    public static let shared = HapticManager()
    
    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return nil
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Error: \(error)")
            return nil
        }
    }
    
    func playRumble() {
        // Define a single event: 0.5 sec long rumble
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2) // less sharp = more rumble
            ],
            relativeTime: 0,
            duration: 0.5
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play rumble: \(error)")
        }
    }
    
    func playRackOpenEffect(duration: Double = 0.5, ) {
        print("In playRackOpenEffect")

        let click1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 1),
                .init(parameterID: .hapticSharpness, value: 1)
            ],
            relativeTime: duration * 0.05
        )


        let rumble = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.9),
                .init(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0,
            duration: duration * 1
        )
        
        let click2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 1),
                .init(parameterID: .hapticSharpness, value: 1)
            ],
            relativeTime: duration * 0.7
        )
        
        playEvents([click1, rumble, click2])
    }

    
    
    func playRackCloseEffect(duration: Double = 0.5) {
        print("closeHaptic")

        let click1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.5),
                .init(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: duration * 0.2
        )
        
        
        let rumble = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.7),
                .init(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0,
            duration: duration
        )
        
        let click2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.8),
                .init(parameterID: .hapticSharpness, value: 0.1),
                
            ],
            relativeTime: duration * 0.9
        )
        
        playEvents([click1, rumble, click2])
    }

    func playWeaponSelectFastEffect() {
        let time1 = 0.04
        let time2 = 0.25
        let click1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.7),
                .init(parameterID: .hapticSharpness, value: 0.7)
            ],
            relativeTime: time1,
            duration: 0.5
        )
        
        
        let rumble = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.4),
                .init(parameterID: .hapticSharpness, value: 0.2),
            ],
            relativeTime: 0,
            duration: 0.5
        )
        
        let click2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 1),
                .init(parameterID: .hapticSharpness, value: 1),
                
            ],
            relativeTime: time2,
            duration: 0.5
        )
        
//        playEvents([click1, rumble, click2])
        playEvents([click1, rumble,  click2])
    }

    
    
    func playEvents(_ events: [CHHapticEvent]) {
        guard let engine = engine else { return }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Error: \(error)")
        }
    }

}

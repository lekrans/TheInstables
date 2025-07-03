//
//  gameAnimations.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-29.
//
//
//var oldReturnTime: Float = 0.0
//let diff: Float = 0.15

import SpriteKit
import Foundation

// SOUND: hydraulic1, hydraulic2 Custom_starwars_inspired_scifi_corridor_door_sound by Artninja -- https://freesound.org/s/744170/ -- License: Attribution 4.0


func CloseWeaponRackAction(x: CGFloat) -> SKAction {
    print(" in closeRack action")
    let action = MLMoveToEaseOutAction(x: x, startProgress: 0.85, progress: 0.06)
    let sound = SKAction.playSoundFileNamed("hydraulic2.wav", waitForCompletion: false)
    let group = SKAction.group([action, sound])
    return group
}


func MLEaseOut(startProgress: Float, progress: Float) -> (Float) -> Float {
    var oldReturnTime: Float = 0.0
    let diff: Float = progress
    
    return {(time: Float) -> Float in
        print("oldReturnTime: \(oldReturnTime)")
        var factor: Float = 1.0
        if oldReturnTime > startProgress {
            factor = 1 - (oldReturnTime / 1)
        }
        let timeChange = diff * factor
        let newTime = oldReturnTime + timeChange
        if newTime - oldReturnTime < 0.0001 {
            return 1
        }
        oldReturnTime = newTime
        return newTime
    }
}


func OpenWeaponRackAction(x: CGFloat) -> SKAction {
    let action = MLMoveToEaseOutAction(x: x, startProgress: 0.7, progress: 0.06)
    let sound = SKAction.playSoundFileNamed("hydraulic1.wav", waitForCompletion: false)
    let group = SKAction.group([sound,action])
    return group
}


func MLMoveToEaseOutAction(x: CGFloat, startProgress: Float, progress: Float) -> SKAction {
    let action = SKAction.moveTo(x: x, duration: 0.5)
    action.timingFunction =  MLEaseOut(startProgress: startProgress, progress: progress)
    return action
}

func MLButtonPressAction(duration: TimeInterval) -> SKAction {
    let scaleDown = SKAction.scale(to: 0.9, duration: duration / 2)
    let scaleUp = SKAction.scale(to: 1.0, duration: duration / 2)
    let pulse = SKAction.sequence([scaleDown, scaleUp])
    return pulse
}

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
// LETHRCreak_Leather Stretching Creak 01_KVV AUDIO_FREE by KVV_Audio -- https://freesound.org/s/797919/ -- License: Attribution 4.0


func CloseWeaponRackActionOld(x: CGFloat) -> SKAction {
    let action = MLMoveToEaseOutAction(x: x, startProgress: 0.85, progress: 0.06)
    let sound = SKAction.playSoundFileNamed("hydraulic2.wav", waitForCompletion: false)
    let group = SKAction.group([action, sound])
    return group
}


func MLEaseOut(startProgress: Float, progress: Float) -> (Float) -> Float {
    var oldReturnTime: Float = 0.0
    let diff: Float = progress
    var callCount = 0
    
    return {(time: Float) -> Float in
        callCount += 1
        print("time = \(time)")
        if callCount == 1 && time == 1.0 {
            print("⚠️ Ignoring warm-up call")
            return 1.0
        }
        var factor: Float = 1.0
        if time > startProgress {
            factor = 1 - (oldReturnTime / 1)
            print("calculating out")
        } else {
            print("time \(time), oldReturnTime \(oldReturnTime)")
            oldReturnTime = time
            return time
        }
        let timeChange = diff * factor
        let newTime = oldReturnTime + timeChange
        print("time \(time), newTime \(newTime) oldReturnTime \(oldReturnTime)")
        
        if newTime - oldReturnTime < 0.0001 {
            return 1
        }
        oldReturnTime = newTime
        return newTime
    }
}


func OpenWeaponRackActionOld(x: CGFloat) -> SKAction {
    let startProgress = AgarAnimProgress.atEnding.latest()
    let action = MLMoveToEaseOutAction(x: x, startProgress: startProgress, progress: 0.06, duration: 0.7)
    let openSound = AS.construction.building.door.metal.heavy.hydraulic.sliding.opening
    let sound = SKAction.playSoundFileNamed(openSound.fileName, waitForCompletion: false)
    let group = SKAction.group([sound,action, SKAction.run { HapticManager.shared!.playRackOpenEffect()}])
    return group
}


func MLMoveToEaseOutAction(x: CGFloat, startProgress: Float, progress: Float, duration: TimeInterval = 0.5) -> SKAction {
    let action = SKAction.moveTo(x: x, duration: duration)
    action.timingMode = .linear
    action.timingFunction =  MLEaseOut(startProgress: startProgress, progress: progress)
    return action
}

func MLButtonPressAction(duration: TimeInterval) -> SKAction {
    let scaleDown = SKAction.scale(to: 0.9, duration: duration / 2)
    let scaleUp = SKAction.scale(to: 1.0, duration: duration / 2)
    let pulse = SKAction.sequence([scaleDown, scaleUp])
    return pulse
}

func MLScaleUpAction(duration: TimeInterval) -> SKAction {
    let scaleDown = SKAction.scale(to: 1.0, duration: duration * 0.9)
    let scaleUp = SKAction.scale(to: AN_weaponRackItemPressScaleUP_DEFAULT, duration: duration * 0.1)
    let pulse = SKAction.sequence([scaleUp, SKAction.wait(forDuration: 0.2), scaleDown])
    return pulse
}




/// ******************************************************************************
///             SEQUENCES

enum MLDurations: Float {
    case veryShort = 0.5
    case short = 1
    case medium = 1.5
    case long = 2.0
    case veryLong = 5
    
    func slow() -> Float {
        self.rawValue * 0.9
    }
    
    func slower() -> Float {
        self.rawValue * 0.8
    }
    
    func slowest() -> Float {
        self.rawValue * 0.7
    }
    
    func fast() -> Float {
        self.rawValue * 1.1
    }
    
    func faster() -> Float {
        self.rawValue * 1.2
    }
    
    func fastest() -> Float {
        self.rawValue * 1.3
    }
}



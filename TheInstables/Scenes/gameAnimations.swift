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

func MLEaseOut(progress: Float) -> (Float) -> Float {
    var oldReturnTime: Float = 0.0
    let diff: Float = progress
    
//    return {(time: Float) -> Float in
//        let overshoot: Float = 1.70158
//        let t = Float(time - 1.0)
//        return Float(t * t * ((overshoot + 1.0) * t + overshoot) + 1.0)
//    }
    
    return {(time: Float) -> Float in
        let factor = 1 - (oldReturnTime / 1)
        let timeChange = diff * factor
        let newTime = oldReturnTime + timeChange
        if newTime - oldReturnTime < 0.00001 {
            return 1
        }
        oldReturnTime = newTime
        return newTime
    }
}

func MLMoveToEaseOutAction(x: CGFloat, duration: TimeInterval, progress: Float) -> SKAction {
    let action = SKAction.moveTo(x: x, duration: duration)
    action.timingFunction =  MLEaseOut(progress: progress)
    return action
}

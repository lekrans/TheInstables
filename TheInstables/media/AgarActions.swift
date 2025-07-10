//
//  AgarAnimations.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-07-09.
//


/// =====================================================
///    module:          `AgarAnimations.swift`
///    Author:            `Michael Lekrans`
///    shortDesc:       Collection of animation related things
///    description:      Collection of animation things like SpriteKit things, alghoritms
/// =====================================================

import SpriteKit

/// ******************************************************************************
// MARK: - Durations
///     enum with predefined values for animation durations
/// ******************************************************************************

enum AgarDurationType {
    /// real = the value of the duration is the TimerInterval
    case real
    /// factor = the value of the duration is a factor of a general duration
    case factor
    /// is calculated after all other durations has been calculated
    case reminder
}


enum AgarDurations: TimeInterval {
    ///veryShort: TimeInterval = 0.5
    case veryShort = 0.5
    /// short: TimeInterval = 1.0
    case short = 1.0
    /// medium: TimeInterval = 1.5
    case medium = 1.5
    /// long: TimeInterval = 2.0
    case long = 2.0
    /// veryLong: TimeInterval = 5.0
    case veryLong = 5
    
    ///  TimeInterval * 0.9
    func slow()     -> TimeInterval { self.rawValue * 0.9 }
    /// TimeInterval * 0.8
    func slower()   -> TimeInterval{ self.rawValue * 0.8 }
    /// TimerInterval * 0.7
    func slowest()  -> TimeInterval { self.rawValue * 0.7 }
    /// TimeInterval * 1.1
    func fast()     -> TimeInterval { self.rawValue * 1.1 }
    /// TimeInterval * 1.2
    func faster()   -> TimeInterval { self.rawValue * 1.2 }
    /// TimeInterval * 1.3
    func fastest()  -> TimeInterval { self.rawValue * 1.3 }
}


/// ******************************************************************************
// MARK: - AnimProgress
/// ******************************************************************************

enum AgarAnimProgress: Float {
    /// asStart: Float = 0
    case atStart = 0
    /// atStarted: Float = 0.25
    case atStarted = 0.25
    /// atMiddle: Float = 0.5
    case atMiddle = 0.5
    /// atEnding: Float = 0.75
    case atEnding = 0.75
    /// atEnd: Float = 1
    case atEnd = 1
    
    /// progress - 0.15
    func earliest() -> Float {
        self.rawValue - 0.15
    }
    /// progress - 0.05
    func littleEarlier() -> Float {
        self.rawValue - 0.05
    }
    /// progress - 0.1
    func earlier() -> Float {
        self.rawValue - 0.1
    }
    /// progress + 0.05
    func littleLater() -> Float {
        self.rawValue + 0.05
    }
    /// progress + 0.1
    func later() -> Float {
        self.rawValue + 0.1
    }
    /// progress + 0.15
    func latest() -> Float {
        self.rawValue + 0.15
    }
}


/// ******************************************************************************
// MARK: - EASE
/// ******************************************************************************


/// ******************************************************************************
// MARK: - EASE Functions
///  Functions to be used by SKAction.timingFunction
///     Ex:
//         func doSomething(x: CGFloat) {
//             let action = SKAction.moveTo(x: x, duration: 0.5)
//             action.timingFunction = MyEasingFunction...
//}
///
///     `AgarEAseOutExp`: Ease out exponentially from `startProgress` (0-1) by `progress` (a progress value to be added to each iteration of the timingFunction
///
/// ******************************************************************************

func AgarEaseOutExp(startProgress: Float, progress: Float) -> (Float) -> Float {
    var oldReturnTime: Float = 0.0
    let diff: Float = progress
    var callCount = 0
    
    return {(time: Float) -> Float in
        callCount += 1
        if callCount == 1 && time == 1.0 {
            print("⚠️ Ignoring warm up call")
            return 1.0
        }
        
        var factor: Float = 1.0
        if time > startProgress {
            factor = 1 - (oldReturnTime / 1)
        } else {
            oldReturnTime = time
            return time
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


/// ******************************************************************************
// MARK: - BASIC Actions
/// ******************************************************************************
struct ScaleUp_wait_scaleDown_settings {
    let scaleUp: CGFloat
    let scaleUpDurationType: AgarDurationType
    private let scaleUpDurationValue: TimeInterval
    
    let waitDurationType: AgarDurationType
    private let waitDurationValue: TimeInterval
    
    let scaleDown: CGFloat
    let scaleDownDurationType: AgarDurationType 
    private let scaleDownDurationValue: TimeInterval
    
    let duration: TimeInterval
    
    init(duration: TimeInterval = AgarDurations.short.rawValue, scaleUp: CGFloat = 2.0, scaleUpDurationType: AgarDurationType = .real, scaleUpDurationValue: TimeInterval = 0.1,  waitDurationType: AgarDurationType = .real, waitDurationValue: TimeInterval = 0.1, scaleDown: CGFloat = 1.0, scaleDownDurationType: AgarDurationType = .reminder, scaleDownDurationValue:  TimeInterval = 0) {
        self.duration = duration
        self.scaleUp = scaleUp
        self.scaleUpDurationType = scaleUpDurationType
        self.scaleUpDurationValue = scaleUpDurationValue
        self.waitDurationType = waitDurationType
        self.waitDurationValue = waitDurationValue
        self.scaleDown = scaleDown
        self.scaleDownDurationType = scaleDownDurationType
        self.scaleDownDurationValue = scaleDownDurationValue
    }
    
    func scaleUpDuration() -> TimeInterval {
        if scaleUpDurationType == .real {
            return TimeInterval(scaleUpDurationValue)
        } else {
            return duration * scaleUpDurationValue
        }
    }
    
    func waitDuration() -> TimeInterval {
        switch waitDurationType {
            case .reminder:
                return duration - scaleUpDuration() - scaleDownDuration()
            case .factor:
                return duration * waitDurationValue
            case .real:
                return waitDurationValue
        }
    }
    
    func scaleDownDuration() -> TimeInterval {
        switch scaleDownDurationType {
        case .reminder:
            return duration - scaleUpDuration() - waitDuration()
        case .factor:
            return duration * scaleDownDurationValue
        case .real:
            return scaleDownDurationValue
        }
    }
}




func Agar_Action_ScaleUp_Wait_ScaleDown(settings: ScaleUp_wait_scaleDown_settings) -> SKAction {
    
    let scaleDown = SKAction.scale(to: settings.scaleDown, duration: settings.scaleDownDuration())
    let scaleUp = SKAction.scale(to: settings.scaleUp, duration: settings.scaleUpDuration())
    let pulse = SKAction.sequence([scaleUp, SKAction.wait(forDuration: settings.waitDuration()), scaleDown])
    return pulse
}




func Agar_Action_moveToX_EaseOutExp(x: CGFloat, startProgress: Float, progress: Float, duration: TimeInterval = 0.5) -> SKAction {
    let action = SKAction.moveTo(x: x, duration: duration)
    action.timingMode = .easeIn
    action.timingFunction =  AgarEaseOutExp(startProgress: startProgress, progress: progress)
    return action
}

func Agar_Action_moveToY_EaseOutExp(y: CGFloat, startProgress: Float, progress: Float, duration: TimeInterval = 0.5) -> SKAction {
    let action = SKAction.moveTo(y: y, duration: duration)
    action.timingMode = .easeIn
    action.timingFunction =  AgarEaseOutExp(startProgress: startProgress, progress: progress)
    return action
}


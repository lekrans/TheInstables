//
//  InstablesActions.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-07-09.
//

/// =====================================================
///    module:          `InstablesActions.swift`
///    Author:            `Michael Lekrans`
///    shortDesc:      `Specialized actions/animations for the game`
///    description:     `
/// =====================================================

import SpriteKit

func InstablesWeaponItemPress() -> SKAction {
    let settings = ScaleUp_wait_scaleDown_settings(duration: AgarDurations.veryShort.slowest())
    let action = Agar_Action_ScaleUp_Wait_ScaleDown(settings: settings)
    return action
}


func instablesSelectWeaponFastAction() -> SKAction {
    let settings = ScaleUp_wait_scaleDown_settings(duration: AgarDurations.veryLong.rawValue, scaleUpDurationType: .real, scaleUpDurationValue: 0.05, waitDurationType: .real, waitDurationValue: 0.15, scaleDownDurationType: .real , scaleDownDurationValue: 0.15)
    let animation = Agar_Action_ScaleUp_Wait_ScaleDown(settings: settings)
    
    let swooshSound = AS.effects.swooshes.short
    let swoosh = SKAction.playSoundFileNamed(swooshSound.fileName, waitForCompletion: false)
   
    let cockingSound = AS.weapons.small.guns.cocking.short
    let cocking = SKAction.playSoundFileNamed(cockingSound.fileName, waitForCompletion: false)
    let group = SKAction.group([animation, swoosh, cocking, SKAction.run {HapticManager.shared?.playWeaponSelectFastEffect()}])
    return group
}


func instablesSelectWeaponSlowAction() -> SKAction {
    let settings = ScaleUp_wait_scaleDown_settings(duration: 0.5, scaleUpDurationType: .real, scaleUpDurationValue: 0.1, waitDurationType: .real, waitDurationValue: 0.3, scaleDownDurationType: .reminder , scaleDownDurationValue: 0.3)
    let animation = Agar_Action_ScaleUp_Wait_ScaleDown(settings: settings)
    
    let swooshSound = AS.effects.swooshes.short
    let swoosh = SKAction.playSoundFileNamed(swooshSound.fileName, waitForCompletion: false)

    let cockingSound = AS.weapons.small.guns.cocking.long
    let cocking = SKAction.playSoundFileNamed(cockingSound.fileName, waitForCompletion: false)
    let group = SKAction.group([animation, swoosh, cocking])
    
    return group
}


func SelectWeaponAction() -> SKAction {
    let buttonPressAction = instablesSelectWeaponFastAction()
    return buttonPressAction
}


func OpenWeaponRackAction(x: CGFloat) -> SKAction {
    let startProgress = AgarAnimProgress.atEnding.latest()
    let action = Agar_Action_moveToX_EaseOutExp(x: x, startProgress: startProgress, progress: 0.06, duration: 0.4)
    let openSound = AS.construction.building.door.metal.heavy.hydraulic.sliding.opening

    let group = SKAction.group([
        SKAction.run { playModifiedSound(fileName: openSound.fileName, rate: 1.7, pitch: 600)},
        action,
        SKAction.run {HapticManager.shared?.playRackOpenEffect(duration: 0.5)}
    ])
    return group
}


func CloseWeaponRackAction(x: CGFloat) -> SKAction {
    let startProgress = AgarAnimProgress.atEnding.latest()
    let action = Agar_Action_moveToX_EaseOutExp(x: x, startProgress: startProgress, progress: 0.06, duration: 0.4)
    let closeSound = AS.construction.building.door.metal.heavy.hydraulic.sliding.closing

    let group = SKAction.group([SKAction.run {
        playModifiedSound(fileName: closeSound.fileName, rate: 1.6, pitch: 0)
    },action, SKAction.run { HapticManager.shared?.playRackCloseEffect(duration: 0.5)}])
    return group
}




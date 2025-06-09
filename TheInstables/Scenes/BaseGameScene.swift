//
//  BaseGameScene.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

import SpriteKit

class BaseGameScene: SKScene {
    var layerManager: LayerManager!
    var positionManager: PositionManager!

    
    func configure(with layerManager: LayerManager, positionManager: PositionManager) {
        self.layerManager = layerManager
        self.positionManager = positionManager
    }
    
    func loadSceneContent() {
        print("onConfigureDone not overridden")
    }
}

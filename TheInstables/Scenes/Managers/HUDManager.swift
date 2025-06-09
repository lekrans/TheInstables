//
//  HUDManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-07.
//

// HUDManager.swift
// Utility to manage HUD elements fixed to the screen

import SpriteKit

import SpriteKit

class HUDManager {
    private let hudNode = SKNode()
    private let sceneSize: CGSize
    
    private let gameLayer = SKNode()
    private let setupScreenLayer = SKNode()
    
    init(sceneSize: CGSize) {
        self.sceneSize = sceneSize
        hudNode.zPosition = 1000
        
        gameLayer.name = "gameLayer"
        setupScreenLayer.name = "setupScreenLayer"
        hudNode.addChild(gameLayer)
        hudNode.addChild(setupScreenLayer)
        
        setupScreenLayer.isHidden = true
    }
    
    func getNode() -> SKNode {
        return hudNode
    }
    
    func showGameHUD() {
        gameLayer.isHidden = false
        setupScreenLayer.isHidden = true
    }
    
    func showSetupScreen() {
        gameLayer.isHidden = true
        setupScreenLayer.isHidden = false
    }
    
    func addPauseButton(action: @escaping () -> Void) {
        let button = SKSpriteNode(imageNamed: "pause")
        button.name = "pauseButton"
        button.size = CGSize(width: 48, height: 48)
        button.position = CGPoint(x: -sceneSize.width / 2 + 60, y: sceneSize.height / 2 - 60)
        button.zPosition = 1
        button.userData = ["onTap": action]
        
        gameLayer.addChild(button)
    }
    
    func addScoreLabel(initialScore: Int = 0) {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.name = "scoreLabel"
        label.fontSize = 24
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Score: \(initialScore)"
        label.position = CGPoint(x: 0, y: sceneSize.height / 2 - 50)
        
        gameLayer.addChild(label)
    }
    
    func updateScore(to value: Int) {
        if let label = gameLayer.childNode(withName: "scoreLabel") as? SKLabelNode {
            label.text = "Score: \(value)"
        }
    }
    
    func handleTouch(at point: CGPoint) {
        for node in gameLayer.nodes(at: point) {
            if let action = node.userData?["onTap"] as? () -> Void {
                action()
            }
        }
    }
}



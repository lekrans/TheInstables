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
    private let viewSize: CGSize
    private var gameLayer: SKNode!
    private var gameHUD: GameHUD!
    private var settingsLayer: SKNode!
    private let settingsHUD: SKNode = SKNode()
    private var theme: ThemeTextureProvider?
        
    private func setupLayers() {
        guard let theme = theme else {
            return
        }
        hudNode.removeAllChildren()
        hudNode.name = NodeNames.HUDNode.name

        gameHUD = GameHUD(theme: theme, viewSize: viewSize)
        gameLayer = gameHUD.node
        
        
        settingsHUD.name = NodeNames.settingsHUDNode.name
        settingsLayer = settingsHUD // NEED TO CHANGE THIS WHEN CREATING THE SETTINGSHUD
        
        hudNode.addChild(gameLayer)
        hudNode.addChild(settingsLayer)
        
        settingsLayer.isHidden = true
        gameLayer.isHidden = true
    }
    
    init(theme: ThemeTextureProvider, viewSize: CGSize) {
        self.viewSize = viewSize
        self.theme = theme
        
        hudNode.zPosition = RenderLayer.hud.rawValue
        print("before setupLayers")
        setupLayers()
        print("after setuplayers")
    }
    
    func updateTheme(theme: ThemeTextureProvider) {
        self.theme = theme
        setupLayers()
    }
    
    func getNode() -> SKNode {
        return hudNode
    }
    
    func getGameLayer() -> SKNode {
        return gameHUD.node
    }
        
    func showGameHUD() {
        gameHUD.node.isHidden = false
        settingsHUD.isHidden = true
    }
    
    func showSetupScreen() {
        gameHUD.node.isHidden = true
        settingsHUD.isHidden = false
    }
    
    func addPauseButton(action: @escaping () -> Void) {
        let button = SKSpriteNode(imageNamed: "pause")
        button.name = "pauseButton"
        button.size = CGSize(width: 48, height: 48)
        button.position = CGPoint(x: -viewSize.width / 2 + 60, y: viewSize.height / 2 - 60)
        button.zPosition = 1
        button.userData = ["onTap": action]
        
        gameHUD.node.addChild(button)
    }
    
    func addScoreLabel(initialScore: Int = 0) {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.name = "scoreLabel"
        label.fontSize = 24
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Score: \(initialScore)"
        label.position = CGPoint(x: 0, y: viewSize.height / 2 - 50)
        
        gameHUD.node.addChild(label)
    }
    
    func updateScore(to value: Int) {
        if let label = gameHUD.node.childNode(withName: "scoreLabel") as? SKLabelNode {
            label.text = "Score: \(value)"
        }
    }
    
    func handleTouch(at point: CGPoint) {
        for node in gameHUD.node.nodes(at: point) {
            if let action = node.userData?["onTap"] as? () -> Void {
                action()
            }
        }
    }
}



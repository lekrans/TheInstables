//
//  SceneManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

// SceneManager.swift
// Handles scene transitions and preparation

import SpriteKit

final class SceneManager {
    private weak var skView: SKView?
    
    init(skView: SKView) {
        self.skView = skView
    }
    
    func loadScene(named name: String, gameManager: GameManager) {
        let scene: SKScene
        
        switch name {
        case "BackyardScene":
            scene = BackyardScene()
            // Add more cases here for other chapters
        default:
            fatalError("Unknown scene name: \(name)")
        }
        
        scene.scaleMode = .resizeFill
        skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
        gameManager.onSceneDidLoad(scene: scene)
    }
}


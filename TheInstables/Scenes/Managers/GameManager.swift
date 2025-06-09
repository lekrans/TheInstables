//
//  GameManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//


// GameManager.swift
// Central coordinator for high-level game logic

import SpriteKit



final class GameManager {
    static let shared = GameManager()
    
    private(set) var hudManager: HUDManager!
    private(set) var sceneManager: SceneManager!
    
    private init() { }
    
    func configure(view: SKView, initialScene: String) {
        sceneManager = SceneManager(skView: view)
        hudManager = HUDManager(sceneSize: view.bounds.size)
        
        // Load initial scene
        sceneManager.loadScene(named: initialScene, gameManager: self)
    }
    
    
    func onSceneDidLoad(scene: SKScene) {
        
        guard let scene = scene as? BaseGameScene else {
            return
        }
        
        
        // Create managers for this scene
        let layerManager = LayerManager(parent: scene)
        let positionManager = PositionManager(sceneSize: scene.size)
        
        // Inject them
        scene.configure(with: layerManager, positionManager: positionManager)
        scene.loadSceneContent()

        guard let camera = scene.camera else {
            print(" ERROR: could not get camera from scene")
            return
        }

        
        
        // Add launcher using layout logic
        let launcher = BombLauncher(theme: "Backyard")
        launcher.position = positionManager.ground(anchor: .left)
        layerManager.add(launcher, to: .player)
        
        // Attach HUD
        camera.addChild(hudManager.getNode())
        hudManager.showGameHUD()
    }

    
//    func onSceneDidLoad(scene: SKScene) {
//        // Attach HUD to camera
//        guard let camera = scene.camera else {
//            print(" ERROR: could not get camera from scene")
//            return
//        }
//        
//        camera.addChild(hudManager.getNode())
//        
//        // Provide launch system into scene
//        let bombLauncher = BombLauncher()
//        scene.addChild(bombLauncher)
//        
//        // Tell launcher where it should be placed
//        if let spawnPoint = (scene as? PlayerSpawnProvider)?.playerSpawnPoint {
//            bombLauncher.position = spawnPoint
//        }
//        
//        hudManager.showGameHUD()
//    }
    
    // Example external call to update HUD
    func updateScore(to newValue: Int) {
        hudManager.updateScore(to: newValue)
    }
    
    func switchToSetupMenu() {
        hudManager.showSetupScreen()
    }
    
    func resumeGameHUD() {
        hudManager.showGameHUD()
    }
}


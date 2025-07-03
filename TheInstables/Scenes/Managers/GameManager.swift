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
    private var view: SKView?
    
    private init() { }
    
    func configure(view: SKView, initialScene: SceneType) {
        print("initial scene: \(initialScene)")
        self.view = view
        self.createManagers(for: view)
        
        // Load initial scene
        sceneManager.loadScene(type: initialScene, sceneLoadingDelegate: self)
    }
    
    
    private func createManagers(for view: SKView) {
        sceneManager = SceneManager(skView: view)
//        hudManager = HUDManager(sceneSize: view.bounds.size)
    }
    
    
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




//MARK: - refactored/convenience
extension GameManager {
    fileprivate func setupBombLauncher(_ positionManager: PositionManager, _ layerManager: LayerManager) {
        // Add launcher using layout logic
        let launcher = BombLauncher(theme: "Backyard")
        launcher.position = positionManager.ground(anchor: .left)
        layerManager.add(launcher, to: .player)
    }
}




//MARK: - SceneLoadingDelegate
extension GameManager: SceneLoadingDelegate {
    
    
    func onSceneDidLoad(scene: SKScene) {
        
        guard let scene = scene as? BaseGameScene else {
            return
        }
        
        
        // Create managers for this scene
        hudManager = HUDManager(theme: scene.theme, viewSize: view!.bounds.size)

        let layerManager = LayerManager(parent: scene)
        let positionManager = PositionManager(resourceData: scene.resourceData)
        
        // Inject them
        scene.configure(with: layerManager, positionManager: positionManager)

        scene.loadSceneContent()
        
        guard let camera = scene.camera else {
            print(" ERROR: could not get camera from scene")
            return
        }
        
        
        
        setupBombLauncher(positionManager, layerManager)
        
        // Attach HUD
        camera.addChild(hudManager.getNode())
        camera.name = "camera"
        hudManager.showGameHUD()
        showCameraNodes(root: scene as SKNode)
    }
    
    func showCameraNodes(root: SKNode, level: Int = 0) {
        let indent = String(repeating: "    ", count: level)
        let name = root.name ?? "ROOT"
//        if root.name == nil { print(root) }
        print(indent + name)
        for child in root.children {
            showCameraNodes(root: child, level: level + 1)
        }
        
    }
}

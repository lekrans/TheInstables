//
//  SceneManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

// SceneManager.swift
// Handles scene transitions and preparation


/// =====================================================
///    module:           SceneManager
///    shortDesc:       Handle loading/unloading of scenes
///    description:      A manager that is responsible for scene related things like loading/unloading a
///                     named scene.
///                Keeping a reference to the SKView where the scene will be displayed and also
///                     presenting the scene (through the view)
///                Also notifies (SceneLoadingDelegate) when the loading is done.
/// =====================================================

import SpriteKit

enum SceneType: String {
    case backyardMayhem = "BackyardMayhem"
}

final class SceneManager {
    private weak var view: SKView?
    
    init(skView: SKView) {
        self.view = skView
    }
    
    ///
    func loadScene(type: SceneType, sceneLoadingDelegate: SceneLoadingDelegate) {
        
        let scene: BaseGameScene?
        switch type {
            case SceneType.backyardMayhem: scene = BackyardScene()
        }
        
        guard let scene = scene else {
            print("Scene not set!")
            return
        }
        
        scene.name = type.rawValue
        scene.theme = ThemeTextureProvider(themeName: type.rawValue)
        scene.scaleMode = .resizeFill
        view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
        sceneLoadingDelegate.onSceneDidLoad(scene: scene)
    }
}


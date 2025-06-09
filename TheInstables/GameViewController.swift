//
//  GameViewController.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-04.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {        
        super.viewDidLoad()
        guard let skView = self.view as? SKView else {
            fatalError("View is not an SKView")
        }
        
        // Optional: Debug toggles
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        // Kick off the game from the shared GameManager
        GameManager.shared.configure(view: skView, initialScene: "BackyardScene")
    }
    
    // Optional: lock to landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

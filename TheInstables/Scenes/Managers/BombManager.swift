//
//  BombManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//
// BombLauncher.swift
// Handles visual + logic of launching bombs (theme-aware)

import SpriteKit

final class BombLauncher: SKNode {
    private var armSprite: SKSpriteNode!
    private var slingSprite: SKSpriteNode!
    private var theme: String = "Default"
    
    init(theme: String = "Default") {
        super.init()
        self.theme = theme
        self.name = "bombLauncher"
        setupGraphics()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGraphics() {
        // Theme-based assets
        let armImage = "launcherArm_\(theme)"
        let slingImage = "launcherSling_\(theme)"
        
        armSprite = SKSpriteNode(imageNamed: armImage)
        armSprite.name = "arm"
        slingSprite = SKSpriteNode(imageNamed: slingImage)
        slingSprite.name = "sling"
        
        armSprite.position = .zero
        slingSprite.position = CGPoint(x: 0, y: 10)
        
        addChild(armSprite)
        addChild(slingSprite)
    }
    
    func loadBomb(_ bomb: SKSpriteNode) {
        bomb.position = CGPoint(x: 0, y: 20)
        bomb.zRotation = 0
        addChild(bomb)
    }
    
    func fireBomb(to target: CGPoint) {
        guard let bomb = children.compactMap({ $0 as? SKSpriteNode }).last else { return }
        
        let vector = CGVector(dx: target.x - position.x, dy: target.y - position.y)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
        bomb.physicsBody?.restitution = 0.5
        bomb.physicsBody?.applyImpulse(vector)
    }
}


//class BombManager {
//    var launcher: BombLauncher
//}

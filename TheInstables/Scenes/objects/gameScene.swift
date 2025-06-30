//
//  weaponRack.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-28.
//

import SpriteKit

class GameScene2: SKScene {
    var weaponRack: SKSpriteNode!
    var isRackOpen = false
    var weaponIcons: [SKSpriteNode] = []
    var unlockedWeapons = 1
    
    override func didMove(to view: SKView) {
        setupWeaponRack()
    }
    
    func setupWeaponRack() {
        let rackWidth: CGFloat = 240
        weaponRack = SKSpriteNode(color: .lightGray, size: CGSize(width: rackWidth, height: size.height))
        weaponRack.anchorPoint = CGPoint(x: 0, y: 0.5)
        weaponRack.position = CGPoint(x: -rackWidth, y: size.height / 2)
        weaponRack.zPosition = 100
        addChild(weaponRack)
        
        // Add a handle
        let handle = SKSpriteNode(color: .black, size: CGSize(width: 20, height: 60))
        handle.position = CGPoint(x: rackWidth - 10, y: weaponRack.size.height / 2)
        handle.name = "handle"
        weaponRack.addChild(handle)
        
        // Add dangling sign
        let sign = SKLabelNode(text: "Keep Out!!")
        sign.fontName = "ChalkboardSE-Bold"
        sign.fontSize = 16
        sign.fontColor = .yellow
        sign.position = CGPoint(x: 0, y: -40)
        handle.addChild(sign)
        
        updateWeaponGrid()
    }
    
    func toggleWeaponRack() {
        isRackOpen.toggle()
        let targetX: CGFloat = isRackOpen ? 0 : -weaponRack.size.width
        weaponRack.run(SKAction.moveTo(x: targetX, duration: 0.3))
    }
    
    func updateWeaponGrid() {
        // Remove old icons
        weaponIcons.forEach { $0.removeFromParent() }
        weaponIcons.removeAll()
        
        // Decide layout
        let columns = unlockedWeapons >= 10 ? 4 : 3
        let rows = Int(ceil(Double(unlockedWeapons) / Double(columns)))
        let spacing: CGFloat = 60
        let startX: CGFloat = 40
        let startY = weaponRack.size.height / 2 - 100
        
        for i in 0..<unlockedWeapons {
            let icon = SKSpriteNode(color: .cyan, size: CGSize(width: 50, height: 50))
            let row = i / columns
            let col = i % columns
            icon.position = CGPoint(
                x: startX + CGFloat(col) * spacing,
                y: startY - CGFloat(row) * spacing
            )
            icon.name = "weapon_\(i)"
            weaponRack.addChild(icon)
            weaponIcons.append(icon)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "handle" {
                toggleWeaponRack()
                return
            } else if node.name?.starts(with: "weapon_") == true {
                // Handle weapon selection
                print("Selected: \(node.name ?? "")")
                toggleWeaponRack()
                return
            }
        }
    }
    
    func unlockNewWeapon() {
        unlockedWeapons += 1
        updateWeaponGrid()
    }
}

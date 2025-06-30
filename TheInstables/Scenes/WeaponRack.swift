//
//  WeaponRack.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-29.
//

import SpriteKit

public class WeaponRack {
    private var background: SKSpriteNode! // rack background
    private var handle: SKSpriteNode!
    private var sizeFactor: CGFloat = 1.0
    private var closedRackVisibleWidth: CGFloat = 20
    private var closedPos : CGPoint!
    private var openedPos : CGPoint!
    
    public var node: SKNode!
    
    var weaponIcons: [SKSpriteNode] = []
    var unlockedWeapons = 1

    
    var isRackOpen: Bool = false
    
    
    //MARK: - init
    init(theme: ThemeTextureProvider, viewSize: CGSize) {
        setup(with: theme)
        configure(for: viewSize)
        updateWeaponGrid()
    }

    
    private func setup(with theme: ThemeTextureProvider) {
        node = SKNode()
        node.name = NodeNames.weaponRack.name
        
        
        background = SKSpriteNode(texture: theme.weaponRack())
        background.name = NodeNames.weaponRackBG.name
        background.anchorPoint = CGPoint(x: 1, y: 0.5)
        node.addChild(background)

        handle = SKSpriteNode(texture: theme.weaponRackHandle())
        handle.name = NodeNames.weaponRackHandle.name
        handle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        handle.position = CGPoint(x: closedRackVisibleWidth, y: 0)
        background.addChild(handle)
    }
    
    private func configure(for viewSize: CGSize) {
        let scaleFactor = viewSize.height / self.node.calculateAccumulatedFrame().height
        self.node.xScale = scaleFactor
        self.node.yScale = scaleFactor
        
        
        closedPos = CGPoint(x: -viewSize.width/2 + (closedRackVisibleWidth * self.node.xScale), y: 0)
        openedPos = CGPoint(x: closedPos.x + (self.background.size.width - closedRackVisibleWidth) * self.node.xScale , y: 0)

        self.node.position = isRackOpen ? openedPos : closedPos
        
        // TODO: - change this to be handled by the layerManager
        self.node.zPosition = 100
    }

    
    // MARK: - toggleWeaponRack
    func toggleWeaponRack() {
        print("toggleWeaponRack")
        isRackOpen.toggle()
        let targetX: CGFloat = isRackOpen ? openedPos.x : closedPos.x
        
        
        let slide = SKAction.moveTo(x: targetX, duration: 0.4)
        slide.timingMode = .easeOut
        
        slide.timingFunction = MLEaseOut(progress: 0.15)
        
        self.node.run(slide)
    }

    // MARK: - updateWeaponGrid
    func updateWeaponGrid() {
        // Remove old icons
        weaponIcons.forEach { $0.removeFromParent() }
        weaponIcons.removeAll()
        
        
        // Decide layout
        let columns = unlockedWeapons >= 10 ? 4 : 3
//        let rows = Int(ceil(Double(unlockedWeapons) / Double(columns)))
        let spacing: CGFloat = 60
        let startX: CGFloat = 40
        let startY = background.size.height / 2 - 100
        
        for i in 0..<unlockedWeapons {
            let icon = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
            let row = i / columns
            let col = i % columns
            icon.position = CGPoint(
                x: startX + CGFloat(col) * spacing,
                y: startY - CGFloat(row) * spacing
            )
            icon.name = "weapon_\(i)"
            background.addChild(icon)
            weaponIcons.append(icon)
        }
    }
    
    // MARK: - unlockNewWeapon
    func unlockNewWeapon() {
        self.unlockedWeapons += 1
        self.updateWeaponGrid()
    }


}

//
//  GameHUD.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-30.
//

import SpriteKit

class GameHUD {
    private var weaponRack: WeaponRack!
    
    public var node = SKNode()
    
    init(theme: ThemeTextureProvider, viewSize: CGSize) {
        setup(with: theme)
        configure(for: viewSize)
        weaponRack = WeaponRack(theme: theme, viewSize: viewSize)
        node.addChild(weaponRack.node)
    }

    
    private func setup(with theme: ThemeTextureProvider) {
        node.name = NodeNames.gameHUDNode.name
    }
    
    private func configure(for viewSize: CGSize) {
    }
    
    
    
    
    
}

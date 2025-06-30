//
//  GameHUD.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-30.
//

import SpriteKit

class GameHUD: SKNode {
    private var WeaponRack: WeaponRack!
    
    // MARK: - Designated initializer
    override init() {
        super.init()
        setup()
    }
    
    
    // MARK: - Convenience init
    convenience init(viewSize: CGSize) {
        self.init()
        configure(for: viewSize)
    }
    
    // MARK: - Required Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        
    }
    
    private func configure(for size: CGSize) {
        
    }
    
    
    
    
}

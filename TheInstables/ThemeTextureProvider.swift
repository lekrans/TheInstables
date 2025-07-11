//
//  ThemeTextureProvider.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-04.
//
// ThemeTextureProvider.swift
// Utility to load textures from theme-based .atlas folders

import SpriteKit

class ThemeTextureProvider {
    let weapons = ["Bomb", "Grenade", "FireBomb", "WaterBomb", "BatteryRamFat", "ScatterBomb", "Spear", "wreckingBall"]
    private let atlas: SKTextureAtlas
    
    init(themeName: String) {
        self.atlas = SKTextureAtlas(named: themeName)
        if self.atlas.textureNames.isEmpty {
            fatalError("No texture atlas found for theme \(themeName). Make sure the theme is added to the bundle and has a .atlas file")
                
        }
    }
    
    func texture(named name: String) -> SKTexture {
        return atlas.textureNamed(name)
    }
    
    func ground(index: Int) -> SKTexture {
        let index = Int.random(in: 1...9) // no of grounds
        return texture(named: "ground\(index)")
    }
    
    func cloud(index: Int) -> SKTexture {
        return texture(named: "cloud\(index)")
    }
    
    func weaponRack() -> SKTexture {
        return texture(named: "weaponRackV2_9")
    }
    
    func weaponRackHandle() -> SKTexture {
        return texture(named: "handle")
    }
    
    func weaponRackItem(at index: Int) -> SKTexture {
        if index >= weapons.count {
            return texture(named: "pot_of_gold")
        } else {
            return texture(named: weapons[index])
        }
    }
    
    func weaponRackSelectedItem(at index: Int) -> SKTexture {
        if index >= weapons.count {
            return texture(named: "pot_of_gold")
        } else {
            return texture(named: "\(weapons[index])Selected")
        }
    }
    
    func weaponRackUnknownItem() -> SKTexture {
        return texture(named: "unknown")
    }
    
    func randomCloud(cloudCount: Int = 3) -> SKTexture {
        let index = Int.random(in: 1...cloudCount)
        return cloud(index: index)
    }
    
    func weaponRackItemLock() -> SKTexture {
        return texture(named: "lock1")
    }
    
    func allTextures(startingWith prefix: String) -> [SKTexture] {
        return atlas.textureNames
            .filter { $0.hasPrefix(prefix) }
            .sorted() // assumes naming like bomb_1, bomb_2, etc.
            .map { atlas.textureNamed($0) }
    }
    
    func preload(completion: @escaping () -> Void) {
        print("atlas = \(atlas)")
        atlas.preload(completionHandler: completion)
    }
}



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
    private let atlas: SKTextureAtlas
    
    init(themeName: String) {
        self.atlas = SKTextureAtlas(named: themeName)
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
    
    func randomCloud(cloudCount: Int = 3) -> SKTexture {
        let index = Int.random(in: 1...cloudCount)
        return cloud(index: index)
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



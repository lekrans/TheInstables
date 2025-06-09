//
//  LayerManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

// LayerManager.swift
// Creates and organizes render layers for a scene

import SpriteKit

enum RenderLayer: CGFloat, CaseIterable {
    case background = 0
    case terrain     = 100
    case objects     = 200
    case player      = 300
    case particles   = 400
    case hud         = 1000
    case debug       = 10_000 // always on top unless intentianally below HUD
}

class LayerManager {
    private var layers: [RenderLayer: SKNode] = [:]
    private unowned let parent: SKNode
    
    init(parent: SKNode) {
        self.parent = parent
        setupLayers()
    }
    
    private func setupLayers() {
        for layer in RenderLayer.allCases {
            let node = SKNode()
            node.zPosition = layer.rawValue
            parent.addChild(node)
            layers[layer] = node
        }
    }
    
    func add(_ node: SKNode, to layer: RenderLayer) {
        layers[layer]?.addChild(node)
    }
    
    func node(for layer: RenderLayer) -> SKNode? {
        return layers[layer]
    }
}

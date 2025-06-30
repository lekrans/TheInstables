//
//  PositionManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

// PositionManager.swift
// Computes positions based on scene dimensions

/// =====================================================
///    module:           PositionManager
///    shortDesc:       <#shortDescr#>
///    description:      <#description#>
/// =====================================================


import CoreGraphics

enum Anchor {
    case left
    case center
    case right
}

class PositionManager {
    private let sceneSize: CGSize
    private let groundTileSize: CGSize
    private let safeMargin: CGFloat
    
    init(resourceData: ResourceData) {
        self.sceneSize = resourceData.sceneSize
        self.groundTileSize = resourceData.groundTileSize
        self.safeMargin = resourceData.safeMargin
    }

    func ground(anchor: Anchor) -> CGPoint {
        let y = self.groundTileSize.height / 2
        let x: CGFloat
        switch anchor {
        case .left: x = sceneSize.width * 0.1
        case .center: x = sceneSize.width / 2
        case .right: x = sceneSize.width * 0.9
        }
        return CGPoint(x: x, y: y)
    }
    
    func top(anchor: Anchor) -> CGPoint {
        let y = sceneSize.height - safeMargin
        let x: CGFloat
        switch anchor {
        case .left: x = sceneSize.width * 0.1
        case .center: x = sceneSize.width / 2
        case .right: x = sceneSize.width * 0.9
        }
        return CGPoint(x: x, y: y)
    }
    
    func fullHeightFromGround() -> CGFloat {
        return sceneSize.height - groundTileSize.height
    }
    
    // Optional: relative placement within a layer height
    func position(in layer: RenderLayer, anchor: Anchor) -> CGPoint {
        // This is a placeholder. You can define vertical bounds per layer type if needed.
        return ground(anchor: anchor)
    }
}

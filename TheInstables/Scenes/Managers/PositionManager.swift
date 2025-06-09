//
//  PositionManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

// PositionManager.swift
// Computes positions based on scene dimensions

import CoreGraphics

enum Anchor {
    case left
    case center
    case right
}

class PositionManager {
    private let sceneSize: CGSize
    private let groundHeight: CGFloat
    private let safeMargin: CGFloat
    
    init(sceneSize: CGSize, groundHeight: CGFloat = 64, safeMargin: CGFloat = 20) {
        self.sceneSize = sceneSize
        self.groundHeight = groundHeight
        self.safeMargin = safeMargin
    }
    
    func ground(anchor: Anchor) -> CGPoint {
        let y = groundHeight / 2
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
        return sceneSize.height - groundHeight
    }
    
    // Optional: relative placement within a layer height
    func position(in layer: RenderLayer, anchor: Anchor) -> CGPoint {
        // This is a placeholder. You can define vertical bounds per layer type if needed.
        return ground(anchor: anchor)
    }
}

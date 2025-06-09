//
//  DebugOverlayManager.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-09.
//

// Central manager for displaying debug information in a SpriteKit game

import SpriteKit

class DebugOverlayManager {
    private let overlayNode = SKNode()
    private var labels: [String: SKLabelNode] = [:]
    
    init() {
        overlayNode.zPosition = RenderLayer.debug.rawValue
    }
    
    func getNode() -> SKNode {
        return overlayNode
    }
    
    func setText(_ text: String, forKey key: String, at position: CGPoint, fontSize: CGFloat = 12, color: SKColor = .magenta) {
        let label: SKLabelNode
        
        if let existing = labels[key] {
            label = existing
        } else {
            label = SKLabelNode(fontNamed: "Menlo")
            label.horizontalAlignmentMode = .left
            label.verticalAlignmentMode = .top
            label.fontSize = fontSize
            label.fontColor = color
            overlayNode.addChild(label)
            labels[key] = label
        }
        
        label.position = position
        label.text = text
    }
    
    func removeText(forKey key: String) {
        if let label = labels[key] {
            label.removeFromParent()
            labels.removeValue(forKey: key)
        }
    }
    
    func clearAll() {
        for label in labels.values {
            label.removeFromParent()
        }
        labels.removeAll()
    }
    
    func setVisible(_ visible: Bool) {
        overlayNode.isHidden = !visible
    }
}

// Example usage in scene:
// debugOverlay.setText("Velocity: (25, -300)", forKey: "velocityInfo", at: CGPoint(x: 20, y: 200))
// debugOverlay.setVisible(true)

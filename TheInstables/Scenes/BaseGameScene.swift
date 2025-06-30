//
//  BaseGameScene.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-08.
//

import SpriteKit

class BaseGameScene: SKScene {
    var layerManager: LayerManager!
    var positionManager: PositionManager!
    var resourceData: ResourceData!
    var theme: ThemeTextureProvider!
    var themeName: String = "Default"

    //MARK: - Weapon Rack
    var weaponRack: WeaponRack!
    var isRackOpen = false

    override func didMove(to view: SKView) {
        print("didMove in BaseGameScene")
        backgroundColor = .cyan // Placeholder background
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        setupResourceData()
    }

    func configure(with layerManager: LayerManager, positionManager: PositionManager) {
        self.layerManager = layerManager
        self.positionManager = positionManager
    }
    
    func setupResourceData() {
        fatalError("setupResourceData not overridden")
    }
    
    func loadSceneContent() {
        print("ENTER: load scene content")
        setupCamera()
        setupGround()
        setupInitialObjects()
        setupWeaponRack()
        print("EXIT: loadSceneContent")
//         fatalError("onConfigureDone not overridden")
    }
    
    
    private func setupCamera() {
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        print("cameranode \(cameraNode)")
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        cameraNode.setScale(2) // Adjust zoom level as needed
    }
    
    
    private func setupGround() {
        print("Setting up ground")
        let groundTile = SKSpriteNode(texture: theme.ground(index: 0))
        groundTile.name = "ground"
        print("groundTile size \(groundTile.size)")
        groundTile.position = positionManager.ground(anchor: .center)
        groundTile.physicsBody = SKPhysicsBody(rectangleOf: groundTile.size)
        groundTile.physicsBody?.isDynamic = false
        print("Before adding to layerManager")
        layerManager.add(groundTile, to: .terrain)
        
        
        
        //        let tileSize = CGSize(width: 64, height: 64)
        //        let tileCount = Int(size.width / tileSize.width) + 1
        //
        //        for i in 0..<tileCount {
        //            let tile = SKSpriteNode(texture: theme.ground(index: 1))
        //
        //            tile.size = tileSize
        //            tile.position = CGPoint(x: CGFloat(i) * tileSize.width + tileSize.width / 2,
        //                                    y: tileSize.height / 2)
        //            tile.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
        //            tile.physicsBody?.isDynamic = false
        //            addChild(tile)
        //        }
        
        
    }
    
    func setupInitialObjects() {
        // Future: gnomes, boxes, bombs
    }
    
    
    
    
    // MARK: - Weapon rack
    func setupWeaponRack() {
        guard let camera = camera else {
            print(" Camera not set up yet")
            return
        }
        print("setupWeaponRack view.size \(size)")
        weaponRack = WeaponRack(theme: theme, viewSize: size)
        camera.addChild(weaponRack.node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            print("node name \(node.name ?? "")")
            if node.name == NodeNames.weaponRackHandle.name {
                weaponRack.toggleWeaponRack()
                return
            } else if node.name?.starts(with: "weapon_") == true {
                // Handle weapon selection
                print("Selected: \(node.name ?? "")")
                weaponRack.toggleWeaponRack()
                return
            }
        }
    }
}








//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else { return }
//    let location = touch.location(in: self)
//    
//    let nodes = self.nodes(at: location)
//    
//    for node in nodes {
//        if node.name == "handle" {
//            toggleWeaponRack()
//            return

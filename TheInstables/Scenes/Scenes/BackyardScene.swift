//
//  BackyardScene.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-04.
//

import SpriteKit

// BackyardScene.swift
// The first playable scene, with the overgrown garden theme
class BackyardScene: BaseGameScene {
//    var layerManager: LayerManager!
//    var positionManager: PositionManager!
    private let cameraNode = SKCameraNode()
    
    private let theme: ThemeTextureProvider = ThemeTextureProvider(themeName: "BackyardMayhem")
    
    override func didMove(to view: SKView) {
        backgroundColor = .cyan // Placeholder background
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    override func loadSceneContent() {
        setupCamera()
        setupGround()
        setupInitialObjects()
    }
    
//    func configure(with layerManager: LayerManager, positionManager: PositionManager) {
//        self.layerManager = layerManager
//        self.positionManager = positionManager
//        
//    }
    
    private func setupPositionManager() {
        
    }
    
    private func setupCamera() {
        addChild(cameraNode)
        print("cameranode \(cameraNode)")
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        cameraNode.setScale(1) // Adjust zoom level as needed
    }

    
    private func setupGround() {
        print("Setting up ground")
        let groundTile = SKSpriteNode(texture: theme.ground(index: 0))
        print("groundTile size \(groundTile.size)")
        groundTile.position = positionManager.ground(anchor: .right)
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
    
    private func setupInitialObjects() {
        // Future: gnomes, boxes, bombs
    }
}



//import SpriteKit
//
//class BackyardScene: SKScene {
//    private weak var gameManager: GameManager?
//    private let cameraNode = SKCameraNode()
//    private let theme: ThemeTextureProvider = ThemeTextureProvider(themeName: "BackyardMayhem")
//    private var startPoint: CGPoint!
//    private var groundLevel : CGFloat = 0
//    
//    init(size: CGSize, gameManager: GameManager) {
//        self.gameManager = gameManager
//        print("BackyardScene init size \(size)")
//        super.init(size: size)
//        self.scaleMode = .resizeFill
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func didMove(to view: SKView) {
//        setupCamera()
//        setupBackground()
//        setupGround()
//        setupObjects()
//        setupHUD()
//    }
//    
//    private func setupCamera() {
//        addChild(cameraNode)
//        camera = cameraNode
//        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        cameraNode.setScale(1) // Adjust zoom level as needed
//    }
//    
//    private func setupBackground() {
//        let bg = SKSpriteNode(color: .green, size: size)
//        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        bg.zPosition = -10
//        addChild(bg)
//    }
//    
//    private func setupGround() {
//        // Example ground sprite
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
//    }
//    
//    private func setupObjects() {
//        // Add crates, destructibles, gnomes, etc. here
//    }
//    
//    private func setupHUD() {
//        gameManager?.updateScore(to: 0)
//        // Other HUD-related setup if needed
//    }
//    
//    // Example touch handling
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: cameraNode)
//        gameManager?.hudManager.handleTouch(at: location)
//    }
//}


//import SpriteKit
//import GameplayKit
//
//class BackyardScene: SKScene {
//    private var theme: ThemeTextureProvider!
//    private var playerBomb: SKSpriteNode!
//    private var cameraNode: SKCameraNode!
//    private var hudManager: HUDManager!
//    private var gameManager: GameManager
//    
//    
//    override func didMove(to view: SKView) {
//        // MARK: - Theme - setup
//        theme = ThemeTextureProvider(themeName: "BackyardMayhem")
//        theme.preload { [weak self] in
//            self?.setupScene()
//        }
//    }
//    
//    private func setupScene() {
//        backgroundColor = .cyan // placeholder sky color
//        
//        setupCamera()
//        setupHUD()
//        setupGround()
//        setupClouds()
//        setupPlayerBomb()
//    }
//    
//    private func setupCamera() {
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//        
//        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        cameraNode.setScale(2.0) // Zoom out to view a larger area
//    }
//    
//    private func setupHUD() {
//        self.hudManager = HUDManager(sceneSize: size)
//        let hud = self.hudManager.getNode()
//        hud.zPosition = 1000
//        cameraNode.addChild(hud)
//    }
//    
//    private func setupGround() {
//        let tileSize = CGSize(width: 64, height: 64)
//        let tileCount = Int(size.width / tileSize.width) + 1
//        print("before loop tileCount = \(tileCount)")
//        
//        for i in 0..<tileCount {
//            print("in loop")
//            let tile = SKSpriteNode(texture: theme.ground(index: 1))
//            print("tile.texture.size: \(tile.texture!.size())")
//            print("tile = \(tile)")
//            
//            tile.size = tileSize
//            print("tile size = \(tileSize)")
////            tile.position = CGPoint(x: CGFloat(i) * tileSize.width + tileSize.width / 2,
////                                    y: tileSize.height / 2)
//            tile.position = CGPoint(x: CGFloat(i) * tileSize.width + tileSize.width / 2,
//                                    y: tileSize.height / 2)
//            tile.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
//            tile.physicsBody?.isDynamic = false
//            print("before add child tile = \(tile)")
//            addChild(tile)
//        }
//    }
//    
//    private func setupClouds() {
//        for _ in 0..<5 {
//            let cloud = SKSpriteNode(texture: theme.randomCloud(cloudCount: 3))
//            cloud.position = CGPoint(x: CGFloat.random(in: 0...size.width),
//                                     y: CGFloat.random(in: size.height * 0.7...size.height * 0.95))
//            cloud.zPosition = -1
//            cloud.alpha = 0.85
//            addChild(cloud)
//        }
//    }
//    
//    private func setupPlayerBomb() {
//        let texture = theme.texture(named: "bomb_idle")
//        playerBomb = SKSpriteNode(texture: texture)
//        playerBomb.position = CGPoint(x: size.width * 0.2, y: size.height * 0.3)
//        playerBomb.size = CGSize(width: 128, height: 128)
//        playerBomb.physicsBody = SKPhysicsBody(circleOfRadius: 64)
//        playerBomb.physicsBody?.allowsRotation = true
//        playerBomb.name = "playerBomb"
//        addChild(playerBomb)
//    }
//}
//
//extension BackyardScene: PlayerSpawnProvider {
//    var playerSpawnPoint: CGPoint {
//        return CGPoint(x: 100, y: 100)
//    }
//    
//}
//
//
//

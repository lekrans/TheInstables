//
//  WeaponRack.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-29.
//

import SpriteKit



final class HandleNode: SKSpriteNode {
    var toggleHandler: (() -> Void)?
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize)  {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleHandler?()
    }
}

final class WeaponRackItem: SKSpriteNode {
    var selectHandler: ((Int) -> Void)?
    var id: Int = -1
    var shadowNode: SKSpriteNode!
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize)  {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyShadow() {
        shadowNode = SKSpriteNode(texture: self.texture, color: .black, size: self.size)
        shadowNode.colorBlendFactor = 1
        shadowNode.alpha = 0.4
        
        shadowNode.zPosition = 5
        print("self.zPosition: \(self.zPosition)")
        shadowNode.position = CGPoint(x: 5, y: -10)
        shadowNode.zRotation = self.zRotation
        shadowNode.xScale = self.xScale
        shadowNode.yScale = self.yScale
        shadowNode.isHidden  = false

//        let blurNode = SKEffectNode()
//        blurNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":3])
//        blurNode.addChild(shadowNode)
        self.addChild(shadowNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectHandler?(id)
    }
}

public class WeaponRack {
    private var background: SKSpriteNode! // rack background
    private var handle: HandleNode!
    private var weaponGrid: SKNode!
    private var sizeFactor: CGFloat = 1.0
    private var closedRackVisibleWidth: CGFloat = 20
    private var closedPos : CGPoint!
    private var openedPos : CGPoint!
    private var theme: ThemeTextureProvider!
    
    public var node = SKNode()
    
    var weaponIcons: [WeaponRackItem] = []
    var unlockedWeapons = 2

    
    var isRackOpen: Bool = false
    
    
    //MARK: - init
    init(theme: ThemeTextureProvider, viewSize: CGSize) {
        self.theme = theme
        setup(with: theme)
        configure(for: viewSize)
        updateWeaponGrid()
    }

    
    private func setup(with theme: ThemeTextureProvider) {
        node.name = NodeNames.weaponRack.name
        
        
        background = SKSpriteNode(texture: theme.weaponRack())
        background.name = NodeNames.weaponRackBG.name
        background.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        node.addChild(background)
        
        weaponGrid = SKNode()
        background.addChild(weaponGrid)
        weaponGrid.position = CGPoint(
            x: -(weaponGrid.parent as! SKSpriteNode).size.width * (weaponGrid.parent as! SKSpriteNode).anchorPoint.x,
            y: -(weaponGrid.parent as! SKSpriteNode).size.height * (weaponGrid.parent as! SKSpriteNode).anchorPoint.y
        )
        print("WeaponGrid position \(weaponGrid.position)")
        
        handle = HandleNode(texture: theme.weaponRackHandle())
        handle.toggleHandler = { [weak self] in self?.toggleWeaponRack() }
        handle.name = NodeNames.weaponRackHandle.name
        handle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        handle.position = CGPoint(x: closedRackVisibleWidth, y: 0)
        background.addChild(handle)
    }
    
    private func configure(for viewSize: CGSize) {
        let scaleFactor = viewSize.height / self.node.calculateAccumulatedFrame().height
        self.node.xScale = scaleFactor
        self.node.yScale = scaleFactor
        
        
        closedPos = CGPoint(x: -viewSize.width/2 + (closedRackVisibleWidth * self.node.xScale), y: 0)
        openedPos = CGPoint(x: closedPos.x + (self.background.size.width - closedRackVisibleWidth) * self.node.xScale , y: 0)

        self.node.position = isRackOpen ? openedPos : closedPos
        
        // TODO: - change this to be handled by the layerManager
        self.node.zPosition = 100
    }

    
    // MARK: - toggleWeaponRack
    func toggleWeaponRack(wait: TimeInterval = 0) {
        isRackOpen.toggle()
        let targetX: CGFloat = isRackOpen ? openedPos.x : closedPos.x
        
        let action: SKAction = isRackOpen ? OpenWeaponRackAction(x: targetX) : CloseWeaponRackAction(x: targetX)
        let seq = SKAction.sequence([SKAction.wait(forDuration: wait), action])
        self.node.run(seq)
    }

    // MARK: - updateWeaponGrid
    func updateWeaponGrid() {
        // Remove old icons
        weaponIcons.forEach { $0.removeFromParent() }
        weaponIcons.removeAll()
        
        
        
        
        // Decide layout
        let columns = unlockedWeapons >= 10 ? 4 : 3
        let parentWidth = weaponGrid.parent!.frame.width
        let frameOffset = CGPoint(x: 180, y: 165)
        let spacing: CGFloat = (parentWidth - (frameOffset.x * 2)) / CGFloat(columns - 1)
        let ySpacing: CGFloat = spacing * 0.92
        print("spacing  \(spacing)")
        let startX: CGFloat = frameOffset.x
        let startY: CGFloat =  weaponGrid.parent!.frame.height - frameOffset.y

        for i in 0..<9 {
            var icon: SKSpriteNode? = nil
            if i >= unlockedWeapons {
                print("creating iconContainer")
                icon = SKSpriteNode(texture: theme.weaponRackItemLock(), size: CGSize(width: 75, height: 75))
            } else {
                icon = WeaponRackItem(texture: theme.weaponRackItem(at: i), size: CGSize(width: 150, height: 150))
                icon!.name = "weapon_\(i)"
                (icon as! WeaponRackItem).id = i
                weaponIcons.append(icon as! WeaponRackItem)
                (icon as! WeaponRackItem).selectHandler = self.weaponIconSelected
            }
                        
            guard let icon = icon else { continue }
            
            icon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            icon.zPosition = 200
            let row = i / columns
            let col = i % columns
            print("col = \(col)")
            icon.position = CGPoint(
                x: startX + CGFloat(col) * spacing,
                y: startY - CGFloat(row) * ySpacing
            )
//            icon.position = points[i]
            print("icon.position \(icon.position)")
            print("icon size \(icon.size)")
            print("weaponRackBG size \(background.size)")
            let shadowNode = SKSpriteNode(texture: theme.weaponRackItem(at: i), size: CGSize(width: 150, height: 150))
            shadowNode.color = .black
            shadowNode.colorBlendFactor = 1.0
            shadowNode.alpha = 0.3
            
            shadowNode.zPosition = 150
            print("self.zPosition: \(icon.zPosition)")
            shadowNode.position = CGPoint(x: icon.position.x + 5, y: icon.position.y - 10)
            shadowNode.zRotation = icon.zRotation
            shadowNode.xScale = icon.xScale
            shadowNode.yScale = icon.yScale
            shadowNode.isHidden  = false
            
//            let blurNode = SKEffectNode()
//            blurNode.filter =  CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 3])
//            blurNode.addChild(shadowNode)
//            weaponGrid.addChild(blurNode)


//            icon.applyShadow()

            weaponGrid.addChild(icon)
            weaponGrid.addChild(shadowNode)
           
        }
    }
    
    func weaponIconSelected(at index: Int) {
        print("Weapon \(index) selected")
        weaponIcons[index].run(MLButtonPressAction(duration: 0.1))
        toggleWeaponRack(wait: 0.2)
    }
    
    // MARK: - unlockNewWeapon
    func unlockNewWeapon() {
        self.unlockedWeapons += 1
        self.updateWeaponGrid()
    }


}

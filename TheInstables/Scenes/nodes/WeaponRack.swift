//
//  WeaponRack.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-29.
//

import SpriteKit

let WEAPON_LAYER = 300

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

enum WeaponRackItemState {
    case unselected
    case selected
    case locked
    case unknown
}

final class WeaponRackItem: SKSpriteNode {
    var origSize: CGSize!
    var selectHandler: ((Int) -> Void)?
    var unlockHandler: ((Int) -> Void)?
    var id: Int = -1
    var shadowNode: SKSpriteNode!
    var unselectedTexture: SKTexture!
    var selectedTexture: SKTexture!
    var unknownTexture: SKTexture!
    var lockTexture: SKTexture!
    var _state: WeaponRackItemState = .locked
    var state: WeaponRackItemState {
        set {
            _state = newValue
           switch state {
            case .unselected:
               self.texture = unselectedTexture
            case .selected:
               self.texture = selectedTexture
            case .locked:
               self.texture = lockTexture
               self.size = CGSize(width: origSize.width/2, height: origSize.height/2)
               self.shadowNode.colorBlendFactor = 0.5
            case .unknown:
               self.texture = .none
               self.shadowNode.texture = unselectedTexture
            }
        }
        get {
            return _state
        }
    }
    
    convenience init(theme: ThemeTextureProvider, size: CGSize, id: Int, state: WeaponRackItemState = .locked) {
        self.init(texture: theme.weaponRackItem(at: id), color: .clear, size: size)
        
        self.origSize = size
        self.unselectedTexture = self.texture
        self.selectedTexture = theme.weaponRackSelectedItem(at: id)
        self.unknownTexture = theme.weaponRackUnknownItem()
        self.lockTexture = theme.weaponRackItemLock()
        
        self.id = id
        
        setup()
        applyShadow()
        self.state = state
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize)  {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.zPosition = CGFloat(WEAPON_LAYER)
    }
    
    func applyShadow() {
        shadowNode = SKSpriteNode(texture: self.texture, color: .black, size: self.size)
        shadowNode.colorBlendFactor = 1
        shadowNode.alpha = 0.4
        
        shadowNode.zPosition = -5
        print("self.zPosition: \(self.zPosition)")
        shadowNode.position = CGPoint(x: 5, y: -10)
        shadowNode.zRotation = self.zRotation
        shadowNode.xScale = self.xScale
        shadowNode.yScale = self.yScale
        shadowNode.isHidden  = false

        self.addChild(shadowNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .locked {
            unlockHandler?(id)
        } else if state == .unknown {
            
        } else {
            print("Weapon \(index) selected")
            self.state = .selected
            self.run(SKAction.sequence([SelectWeaponAction(), SKAction.run({ [self] in selectHandler?(id) }) ]))
        }
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
    var totalNoOfWeapons = WR_totalNoOfWeapons_DEFAULT
    var discoveredWeapons = WR_discoveredWeapons_DEFAULT
    var unlockedWeapons = WR_unlockedWeapons_DEFAULT

    
    var isRackOpen: Bool = false
    
    
    //MARK: - init
    init(theme: ThemeTextureProvider, viewSize: CGSize) {
        self.theme = theme
        print("viewSize in WeaponRack \(viewSize)")
        setup(with: theme)
        configure(for: viewSize)
        updateWeaponGrid()
        print("self.size \(self.node.calculateAccumulatedFrame().size)")
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
        let horizontalHeight = min(viewSize.height, viewSize.width)
        let scaleFactor = horizontalHeight / self.background.size.height
        print( " ------------------- ")
        print(" horizontalHeight: \(horizontalHeight)")
        print(" background.size.height: \(self.background.size.height)")
        print("scaleFactor: \(scaleFactor)")
        
        self.node.xScale = scaleFactor
        self.node.yScale = scaleFactor
        print("newScale: \(self.node.xScale) \(self.node.yScale)")
        
        
        closedPos = CGPoint(x: -viewSize.width/2 + (closedRackVisibleWidth * self.node.xScale), y: 0)
        openedPos = CGPoint(x: closedPos.x + (self.background.size.width - closedRackVisibleWidth) * self.node.xScale , y: 0)

        self.node.position = isRackOpen ? openedPos : closedPos
        
        // TODO: - change this to be handled by the layerManager
        self.node.zPosition = 100
    }

    
    private func getWeaponState(index: Int) -> WeaponRackItemState {
        if index < unlockedWeapons
            { return .unselected}
        else if index >= discoveredWeapons {
            return .unknown
        } else {
            return .locked
        }
    }
    
    private func getPosition(for index: Int) -> CGPoint {
        let columns = unlockedWeapons >= 10 ? 4 : 3
        let parentWidth = weaponGrid.parent!.frame.width
        let frameOffset = CGPoint(x: 180, y: 165)
        let spacing: CGFloat = (parentWidth - (frameOffset.x * 2)) / CGFloat(columns - 1)
        let ySpacing: CGFloat = spacing * 0.92
        let startX: CGFloat = frameOffset.x
        let startY: CGFloat =  weaponGrid.parent!.frame.height - frameOffset.y
        
        let row = index / columns
        let col = index % columns
        let pos = CGPoint(
            x: startX + CGFloat(col) * spacing,
            y: startY - CGFloat(row) * ySpacing
        )
        return pos

    }
    
    
    
    // MARK: - toggleWeaponRack
    func toggleWeaponRack(wait: TimeInterval = 0) {
        isRackOpen.toggle()
        if isRackOpen {
            updateWeaponGrid()
        }
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
        weaponGrid.removeAllChildren()
        
        // Decide layout

        for i in 0..<totalNoOfWeapons {
            
            var size = CGSize(width: 150, height: 150)
            let state = getWeaponState(index: i)
            if i == 4  {
                size = CGSize(width: 180, height: 180)
            }
            let icon = WeaponRackItem(theme: theme, size: size, id: i, state: state)
            


            icon.selectHandler = self.weaponIconSelected
            icon.unlockHandler = self.unlockWeapon
            
            
            icon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            icon.position = getPosition(for: i)

            weaponGrid.addChild(icon)
            weaponIcons.append(icon)
           
        }
    }
    
    func weaponIconSelected(at index: Int) {
        toggleWeaponRack(wait: 0)
    }
    
    func unlockWeapon(at index: Int) {
        print("Unlock weapon? ")
    }
    
    // MARK: - unlockNewWeapon
    func unlockNewWeapon() {
        self.unlockedWeapons += 1
        self.updateWeaponGrid()
    }


}

//
//  NodeNames.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-06-30.
//

enum NodeNames: String {
    case box
    case gnome
    case weaponRack
    case weaponRackBG
    case weaponRackHandle
    case bomb
    case ground
    case HUDNode
    case gameHUDNode
    case settingsHUDNode
}

extension NodeNames {
    var textureName: String {
        rawValue
    }
    var name: String {
        rawValue
    }
}

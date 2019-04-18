//
//  Settings.swift
//  Jump
//
//  Created by Michelle Ho on 4/10/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

enum LayoutProperties {
    static let backgroundColor: UIColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
}

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1 << 1       // 01
    static let barCategory: UInt32 = 0x1 << 2  // 10
}

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
        ]
}


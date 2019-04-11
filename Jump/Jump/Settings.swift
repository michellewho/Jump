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
    static let ballCategory: UInt32 = 0x1         // 01
    static let barCategory: UInt32 = 0x1 << 1  // 10
}


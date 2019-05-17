//
//  File.swift
//  Jump
//
//  Created by Michelle Ho on 4/18/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class Disk {
    var spritenode: SKSpriteNode!
    
    init(position: CGPoint) {
        spritenode = SKSpriteNode(texture: SKTexture(imageNamed: "disk"), size: CGSize(width: 30.0, height: 30.0))
        spritenode.physicsBody = SKPhysicsBody(circleOfRadius: spritenode.size.width / 2)
        spritenode.name = "Disk"
        spritenode.position = position
        spritenode.physicsBody?.isDynamic = false
    }
    
}


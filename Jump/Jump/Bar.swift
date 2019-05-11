//
//  File.swift
//  Jump
//
//  Created by Michelle Ho on 4/18/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class Bar {
    var spritenode: SKSpriteNode!
    
    init(color: UIColor, position: CGPoint) {
        spritenode = SKSpriteNode(texture: SKTexture(imageNamed: "bar"), size: CGSize(width: 100.0, height: 30.0))
        spritenode.colorBlendFactor = 1
        spritenode.color = color
        
        spritenode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100.0, height: 30.0))
        spritenode.physicsBody?.categoryBitMask = PhysicsCategories.barCategory
        spritenode.physicsBody?.contactTestBitMask = PhysicsCategories.ballCategory
        spritenode.physicsBody?.collisionBitMask = 0
        
        spritenode.name = "Bar"
        spritenode.position = position
        spritenode.zPosition = 3
//        spritenode.physicsBody?.friction = 0
//        spritenode.physicsBody?.restitution = 1.0
        spritenode.physicsBody?.isDynamic = false
//        spritenode.physicsBody?.affectedByGravity = false
    }

}


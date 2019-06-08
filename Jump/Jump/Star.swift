//
//  Star.swift
//  Jump
//
//  Created by Michelle Ho on 6/6/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class Star {
    var spritenode: SKSpriteNode!
    
    init(position: CGPoint) {
        spritenode = SKSpriteNode(texture: SKTexture(imageNamed: "star"), size: CGSize(width: 70.0, height: 70.0))
        
        spritenode.physicsBody = SKPhysicsBody(circleOfRadius: spritenode.size.width / 2)
        spritenode.physicsBody?.categoryBitMask = PhysicsCategories.starCategory
//        spritenode.physicsBody?.contactTestBitMask = PhysicsCategories.ballCategory
        spritenode.physicsBody?.collisionBitMask = 0
        spritenode.physicsBody?.usesPreciseCollisionDetection = true
        
        spritenode.name = "Bar"
        spritenode.position = position
        spritenode.zPosition = 3
        //        spritenode.physicsBody?.friction = 0
        //        spritenode.physicsBody?.restitution = 151.0
        spritenode.physicsBody?.isDynamic = false
        //        spritenode.physicsBody?.affectedByGravity = false
    }
    
}


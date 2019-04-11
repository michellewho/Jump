//
//  GameScene.swift
//  Jump
//
//  Created by Michelle Ho on 4/10/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        layoutScene()

    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        addPlatforms()
        spawnBall()
    }
    
    func addPlatforms() {
        let bar = SKSpriteNode(texture: SKTexture(imageNamed: "bar"), size: CGSize(width: 100.0, height: 30.0))
        bar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100.0, height: 30.0))
        bar.name = "Bar"
        bar.position = CGPoint(x: frame.midX, y: frame.maxY / 4)
        bar.physicsBody?.isDynamic = false
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.friction = 0
        addChild(bar)
    }
    
    func spawnBall() {
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), size: CGSize(width: 30.0, height: 30.0))
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY * 3/4)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        addChild(ball)
    }
    
    
}

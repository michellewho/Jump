//
//  GameScene.swift
//  Jump
//
//  Created by Michelle Ho on 4/10/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var currentColorIndex: Int?
    var startGame: Bool = false
    
    override func didMove(to view: SKView) {
        print("start game")
        layoutScene()

    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        physicsWorld.contactDelegate = self
        addPlatforms()
        addRandomPlatforms()
        spawnBall()
    }
    
    func addRandomPlatforms() {
//        let num = arc4random_uniform(UInt32(1..4))
//        for i in 1...num {
//            let newBar = SKSpriteNode(texture: SKTexture(imageNamed: "bar"), size: CGSize(width: 100.0, height: 30.0))
//
//        }
        

    }
    
    func addPlatforms() {
        let bar = SKSpriteNode(texture: SKTexture(imageNamed: "bar"), size: CGSize(width: 100.0, height: 30.0))
        bar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100.0, height: 30.0))
        bar.physicsBody?.categoryBitMask = PhysicsCategories.barCategory
        bar.physicsBody?.contactTestBitMask = PhysicsCategories.ballCategory
        bar.name = "Bar"
        bar.position = CGPoint(x: frame.midX, y: frame.maxY / 4)
        bar.zPosition = 3
        bar.physicsBody?.friction = 0
        bar.physicsBody?.restitution = 1.0
        bar.physicsBody?.isDynamic = false
        bar.physicsBody?.affectedByGravity = false
       
        addChild(bar)
    }
    
    func spawnBall() {
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), size: CGSize(width: 30.0, height: 30.0))
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY * 3/4)
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.barCategory
//        ball.physicsBody?.collisionBitMask = PhysicsCategories.barCategory
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0.3
        ball.physicsBody?.linearDamping = 0.01
        ball.physicsBody?.angularDamping = 0
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyB.categoryBitMask | contact.bodyA.categoryBitMask
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.barCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                changeBallColor(ball: ball)
            }
        }
    }
    
    func changeBallColor(ball: SKSpriteNode) {
        ball.color = UIColor.red
    }
    
//    func shift() {
//
//    }

    
    func detectColorMatch(ball: SKSpriteNode) {
        
    }
    
    func gameOver() {
        print("game over")
        let menuScene = MenuScene(size: self.view!.bounds.size)
        self.view!.presentScene(menuScene)
    }
    
    
    
}

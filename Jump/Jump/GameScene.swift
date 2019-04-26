//
//  GameScene.swift
//  Jump
//
//  Created by Michelle Ho on 4/10/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    
    var currentColorIndex: Int?
    var isWhite: Bool = false
    
    let motionManager = CMMotionManager()
    var destX: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        print("start game")
        layoutScene()

    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        physicsWorld.contactDelegate = self
        addRandomPlatforms()
        addStartingPlatform()
        spawnBall()
    }
    
    func addRandomPlatforms() {
        addMidLevelPlatforms()
        let num = Int.random(in: 2 ... 5)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let y = CGFloat.random(in: frame.minY ... frame.maxY)
            let color = PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)]
            let newBar = Bar(color: color, position: CGPoint(x: x, y: y))
            addChild(newBar.spritenode)
        }
    }
    
    func addMidLevelPlatforms() {
        let num = Int.random(in: 1 ... 3)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let y = CGFloat.random(in: frame.maxY * 1/4 ... frame.maxY * 3/4)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
            addChild(newBar.spritenode)
        }
    }
    
    func addStartingPlatform() {
        let bar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: frame.midX, y: frame.maxY / 4))
        addChild(bar.spritenode)
    }
    
    func spawnBall() {
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), size: CGSize(width: 30.0, height: 30.0))
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY * 3/4)
        ball.colorBlendFactor = 1
        ball.color = PlayColors.colors[0]
        isWhite = true
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
                let bar = contact.bodyB.node == ball ? contact.bodyA.node : contact.bodyB.node
                changeBallColor(ball: ball, bar: bar as! SKSpriteNode)
            }
        }
    }
    
    func changeBallColor(ball: SKSpriteNode, bar: SKSpriteNode) {
        if isWhite {
            ball.color = bar.color
            isWhite = false
        }
        if (!ball.color.isEqual(bar.color)) {
            gameOver()
        }
    }
    
    func detectColorMatch(ball: SKSpriteNode) {
        
    }
    
    func gameOver() {
        print("game over")
        
        let wait = SKAction.wait(forDuration: 1)
        let runBlock = SKAction.run {
            print(" HELLO ! RUN BLOCK AREA ")
            let menuScene = MenuScene(size: self.view!.bounds.size)
            self.view!.presentScene(menuScene)
        }
        let seq = SKAction.sequence( [ wait , runBlock ] )
        self.run( seq , withKey: "scale_me_please")
        
        
    }
    
//    override func didSimulatePhysics() {
//        <#code#>
//    }
    
    
    
}

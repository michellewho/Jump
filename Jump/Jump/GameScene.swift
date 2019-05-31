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
    
//    var score = 0
    var scoreLabel: ScoreLabel!
    var score = 0
    
    
    var currentColorIndex: Int?
    var isWhite: Bool = false
    
    let motionManager = CMMotionManager()
    var destX: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        print("start game")
        layoutScene()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        motionManager.startAccelerometerUpdates()
//        setScoreLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        processUserMotion(forUpdate: currentTime)
        enumerateChildNodes(withName: "Bar") {bar,_ in
            if !self.intersects(bar) {
                bar.removeFromParent()
            }
        }
        
        let ball = childNode(withName: "Ball")
        if Int(ball!.position.y) < Int(self.frame.maxY - 800) {
            gameOver()
        }
    }
    
    func setScoreLabel() {
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 20.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.size.width - 30, y: self.size.height - 60)
        addChild(scoreLabel)
    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        physicsWorld.contactDelegate = self
        scoreLabel = ScoreLabel(frame: frame)
        addChild(scoreLabel.node)
        layoutPlatforms()
        spawnBall()
    }
    
    func layoutPlatforms() {
        addStartingPlatform()
        addLowPlatforms()
        addMidPlatforms()
        addHighPlatforms()
    }
    
    func addHighPlatforms() {
        var platforms = [SKSpriteNode]()
        let num = Int.random(in: 1 ... 2)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let y = CGFloat.random(in: frame.maxY * 2/3 ... frame.maxY)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
            for node in platforms {
                if newBar.spritenode.intersects(node) {
                    print("intersect")
                    platforms.append(newBar.spritenode)
                    addChild(newBar.spritenode)
                    break
                }
            }
            addChild(newBar.spritenode)
        }
    }
    
    func addMidPlatforms() {
        let num = Int.random(in: 1 ... 2)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let y = CGFloat.random(in: frame.maxY * 1/3 ... frame.maxY * 2/3)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
            addChild(newBar.spritenode)
        }
    }
    
    func addLowPlatforms() {
        let num = Int.random(in: 1 ... 3)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let y = CGFloat.random(in: frame.minY ... frame.maxY * 2/3)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
            addChild(newBar.spritenode)
        }
    }
 
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if let ball = childNode(withName: "Ball") as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.2 {
                    ball.physicsBody!.applyForce(CGVector(dx: 100 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
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
    
    func addNewPlatforms() {
        let num = Int.random(in: 1 ... 2)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX ... frame.maxX)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: self.frame.maxY + 10.0))
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
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -20.0))
        
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.barCategory
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.angularDamping = 0.0
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyB.categoryBitMask | contact.bodyA.categoryBitMask
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.barCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                let bar = contact.bodyB.node == ball ? contact.bodyA.node : contact.bodyB.node
                bounceEffect()
                if let body = ball.physicsBody {
                    let dy = body.velocity.dy
                    if dy > 0 { // going up
                        body.collisionBitMask &= ~PhysicsCategories.barCategory
                    }
                    else { // falling
                        body.collisionBitMask |= PhysicsCategories.barCategory
                        body.velocity = CGVector(dx: body.velocity.dx , dy: 800.0)
                    }
                }
                changeBallColor(ball: ball, bar: bar as! SKSpriteNode)
                addNewPlatforms()
                shiftY()
            }
        }
    }
    
    func bounceEffect() {
        let bounceSound = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
        if (SoundProperties.soundOn == true) {
            run(bounceSound)
        }
    }
    
    func shiftY() {
        enumerateChildNodes(withName: "Bar") {node,_ in
            node.run(SKAction.moveBy(x: 0, y: -200, duration: 0.2))
        }
        updateScore()
    }
    
    func updateScore() {
        score += 200
        scoreLabel.updateScore(score: score)
    }
    
    func changeBallColor(ball: SKSpriteNode, bar: SKSpriteNode) {
//        if isWhite  {
//            ball.color = bar.color
//            isWhite = false
//        }
        ball.color = bar.color
    }
    
    func gameOver() {
        print("game over")
    
        let reveal = SKTransition.fade(withDuration: 1)
        let endGameScene = GameOver(size: self.view!.bounds.size)
        self.view!.presentScene(endGameScene, transition: reveal)
        
    }

    
    
}

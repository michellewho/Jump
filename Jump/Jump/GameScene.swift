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
    
    var ball = SKSpriteNode()
    
    var scoreLabel: ScoreLabel!
    var score = 0
    var bounceHeight: CGFloat = 0.0
    
    var currentPlatformY: CGFloat = 0.0
    
    var currentColorIndex: Int?
    var isWhite: Bool = false
    
    let motionManager = CMMotionManager()
    var destX: CGFloat = 0.0
    
    var touchLocation = CGPoint(x: 0, y: 0)
    
    private var currentNode: SKNode?
    
    override func didMove(to view: SKView) {
        print("start game")
        layoutScene()
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        motionManager.startAccelerometerUpdates()
//        setScoreLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
//        processUserMotion(forUpdate: currentTime)
        enumerateChildNodes(withName: "Bar") {bar,_ in
            if !self.intersects(bar) {
                bar.removeFromParent()
            }
        }
        if Int(ball.position.y) < Int(-1 * self.frame.maxY) {
            gameOver()
        }
        
        if (abs(frame.maxY / 4 - (ball.position.y)) > bounceHeight) {
            bounceHeight = abs(frame.maxY / 4 - (ball.position.y))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchLocation = touch.location(in: self)
            ball.position.x = (touchLocation.x)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchLocation = touch.location(in: self)
            ball.position.x = (touchLocation.x)
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
        currentPlatformY = self.frame.maxY * -1.0
        scoreLabel = ScoreLabel(frame: frame)
        addChild(scoreLabel.node)
        layoutPlatforms()
        spawnBall()
        
    }
    
    func layoutPlatforms() {
        addStartingLayout()
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
        if let data = motionManager.accelerometerData {
            if fabs(data.acceleration.x) > 0.2 {
                ball.physicsBody!.applyForce(CGVector(dx: 50 * CGFloat(data.acceleration.x), dy: 0))
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
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: self.frame.maxY * 1.25))
            addChild(newBar.spritenode)
        }
    }
    
    func addStartingLayout() {
        let bar1 = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: frame.midX, y: frame.maxY / 4))
        
        let bar2 = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: frame.maxX * 1/4, y: frame.midY))
        
        let bar3 = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: frame.maxX * 3/4, y: frame.midY + 20.0))
        
        addChild(bar1.spritenode)
        addChild(bar2.spritenode)
        addChild(bar3.spritenode)
        
        let star1 = Star(position: CGPoint(x: bar1.spritenode.position.x, y: bar1.spritenode.position.y + 40.0))
        let star2 = Star(position: CGPoint(x: bar3.spritenode.position.x, y: bar3.spritenode.position.y + 40.0))
        
        addChild(star1.spritenode)
        addChild(star2.spritenode)
        
    }
    
    func spawnBall() {
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), size: CGSize(width: 30.0, height: 30.0))
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY * 3/4)
        ball.colorBlendFactor = 1
        ball.color = PlayColors.colors[0]
        isWhite = true
        ball.zPosition = 1
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -50.0))
        ball.physicsBody?.mass = 0.2
        
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.barCategory | PhysicsCategories.starCategory
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.angularDamping = 0.0
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyB.categoryBitMask | contact.bodyA.categoryBitMask
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.barCategory {
            if let contactBall = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                let bar = contact.bodyB.node == contactBall ? contact.bodyA.node : contact.bodyB.node
                soundEffect(sound: "bounce")
                if let body = contactBall.physicsBody {
                    let dy = body.velocity.dy
                    if (dy > 0) || (body.node!.intersects(bar!)) && (body.node!.position.y - 15.0 < bar!.position.y + 15.0) {
                        body.collisionBitMask &= ~PhysicsCategories.barCategory
                    } else {
                        // Allow collisions if the hero is falling
                        body.collisionBitMask |= PhysicsCategories.barCategory
                    }
                }
                changeBallColor(ball: contactBall, bar: bar as! SKSpriteNode)
                addNewPlatforms()
                
            }
        }
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.starCategory {
            if let contactBall = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                let star = contact.bodyB.node == contactBall ? contact.bodyA.node : contact.bodyB.node
                soundEffect(sound: "bling")
                updateScore()
                star?.removeFromParent()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyB.categoryBitMask | contact.bodyA.categoryBitMask
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.barCategory {
            if let contactBall = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                let bar = contact.bodyB.node == contactBall ? contact.bodyA.node : contact.bodyB.node
                soundEffect(sound: "bounce")
                if let body = contactBall.physicsBody {
                    let dy = body.velocity.dy
                    if (dy > 0) || (body.node!.intersects(bar!)) && (body.node!.position.y - 15.0 < bar!.position.y + 15.0) {
                        body.collisionBitMask &= ~PhysicsCategories.barCategory
                    } else {
                        // Allow collisions if the hero is falling
                        body.collisionBitMask |= PhysicsCategories.barCategory
                    }
                }
                changeBallColor(ball: contactBall, bar: bar as! SKSpriteNode)
                addNewPlatforms()
            }
        }
    }
    
    func soundEffect(sound: String) {
        switch sound {
        case "bounce":
            let bounceSound = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
            if (SoundProperties.soundOn == true) {
                run(bounceSound)
            }
            print("bounce")
        case "bling":
            print("bling")
            let blingSound = SKAction.playSoundFileNamed("bling.wav", waitForCompletion: false)
            if (SoundProperties.soundOn == true) {
                run(blingSound)
            }
        default:
            print("no sound specified")
        }
    }
    
    func shiftY() {
        enumerateChildNodes(withName: "Bar") {node,_ in
            node.run(SKAction.moveBy(x: 0, y: -500, duration: 0.2))
        }
    }
    
    func updateScore() {
        score += 1
        scoreLabel.updateScore(score: score)
    }
    
    func changeBallColor(ball: SKSpriteNode, bar: SKSpriteNode) {
        ball.color = bar.color
    }
    
    func gameOver() {
        print("game over")
    
        let reveal = SKTransition.fade(withDuration: 1)
        let endGameScene = GameOver(size: self.view!.bounds.size)
        self.view!.presentScene(endGameScene, transition: reveal)
        
    }
    
}

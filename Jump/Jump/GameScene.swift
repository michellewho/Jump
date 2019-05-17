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
        print(self.frame.maxY)
        print("start game")
        layoutScene()
//        addDisks()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        motionManager.startAccelerometerUpdates()
//        setSco reLabel()
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
    
    func addDisks() {
//        let wait = SKAction.wait(forDuration: 3, withRange: 2)
//        let spawn = SKAction.run {
//            let disk = Disk(position: CGPoint(x: self.frame.midX, y: self.frame.maxY / 4))
//            self.addChild(disk.spritenode)
//
//        }
//
//        let sequence = SKAction.sequence([wait, spawn])
//        self.run(SKAction.repeatForever(sequence))
        
        let disk = Disk(position: CGPoint(x: 160, y: 220))
        self.addChild(disk.spritenode)
    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        physicsWorld.contactDelegate = self
//        getPlatformPlist()
//        addPlatforms()
        scoreLabel = ScoreLabel(frame: frame)
        addChild(scoreLabel.node)
        addRandomPlatforms()
        addStartingPlatform()
        spawnBall()
    }
    
    func getPlatformPlist() {
        let levelPlist = Bundle.main.path(forResource: "Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!

        // Height at which the player ends the level
//        endLevelY = (levelData["EndY"]! as AnyObject).integerValue!
        
        addPlatforms(levelData: levelData)
    }
    
    func addPlatforms(levelData: NSDictionary) {
        // Add the platforms
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let patternX = (platformPosition["x"] as AnyObject).floatValue
            let patternY = (platformPosition["y"] as AnyObject).floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            // Look up the pattern
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let x = (platformPoint["x"] as AnyObject).floatValue
                let y = (platformPoint["y"] as AnyObject).floatValue
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: positionX, y: positionY))
                addChild(platformNode.spritenode)
            }
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
    
    func addHigher() {
        let num = Int.random(in: 1 ... 3)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX + 10 ... frame.maxX - 10)
            let y = CGFloat.random(in: frame.maxY * 2/3 ... frame.maxY)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
            addChild(newBar.spritenode)
        }
    }
    
    func addLower() {
        let num = Int.random(in: 1 ... 3)
        for _ in 1...num {
            let x = CGFloat.random(in: frame.minX + 10 ... frame.maxX - 10)
            let y = CGFloat.random(in: frame.minY ... frame.maxY * 2/3)
            let newBar = Bar(color: PlayColors.colors[Int.random(in: 1 ... PlayColors.colors.count - 1)], position: CGPoint(x: x, y: y))
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
            bounceEffect()
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                let bar = contact.bodyB.node == ball ? contact.bodyA.node : contact.bodyB.node
                
                if let body = ball.physicsBody {
                    let dy = body.velocity.dy
                    if dy > 0 { // going up
                        body.collisionBitMask &= ~PhysicsCategories.barCategory
                    }
                    else { // falling
                        body.collisionBitMask |= PhysicsCategories.barCategory
                        body.velocity = CGVector(dx: body.velocity.dx, dy: 800.0)
                    }
                }
                changeBallColor(ball: ball, bar: bar as! SKSpriteNode)
                shiftY()
                
            }
        }
    }
    
    func bounceEffect() {
        let bounceSound = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
        run(bounceSound)
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
        if isWhite  {
            ball.color = bar.color
            isWhite = false
        }
    }
    
    func gameOver() {
        print("game over")
    
        let reveal = SKTransition.fade(withDuration: 1)
        let endGameScene = GameOver(size: self.view!.bounds.size)
        self.view!.presentScene(endGameScene, transition: reveal)
        
    }

    
    
}

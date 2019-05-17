//
//  GameOver.swift
//  Jump
//
//  Created by Michelle Ho on 5/16/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        addLabels()
    }
    
    func addLabels() {
        let titleLabel = SKLabelNode(text: "GAME OVER")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 50.0
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.size.height * 3/5)
        addChild(titleLabel)
        
        let playLabel = SKLabelNode(text: "Play Again?")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 30.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
    }
    
    func animate(label: SKLabelNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
}

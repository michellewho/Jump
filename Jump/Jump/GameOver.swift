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
        addSoundOnOff()
    }
    
    func addSoundOnOff() {
        let sound = SKSpriteNode(imageNamed: "soundon")
        if SoundProperties.soundOn == false {
            let sound = SKSpriteNode(imageNamed: "soundoff")
        }
        sound.size = CGSize(width: frame.size.width / 8, height: frame.size.width / 8)
        sound.position = CGPoint(x: frame.size.width - 40, y: self.size.height - 60)
        sound.name = "sound"
        sound.isUserInteractionEnabled = false
        addChild(sound)
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
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene) as? SKSpriteNode
        if let name = touchedNode?.name {
            if name == "sound" {
                SoundProperties.soundOn = !SoundProperties.soundOn
                if (SoundProperties.soundOn == true) {
                    touchedNode?.texture = SKTexture.init(imageNamed: "soundon")
                } else {
                    touchedNode?.texture = SKTexture.init(imageNamed: "soundoff")
                }
            }
        } else {
            let gameScene = GameScene(size: view!.bounds.size)
            view!.presentScene(gameScene)
        }
    }
    
}

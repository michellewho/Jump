//
//  MenuScene.swift
//  Jump
//
//  Created by Michelle Ho on 4/10/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        addLogo()
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
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
    }
    
    func addLabels() {
        let titleLabel = SKLabelNode(text: "ColorJump")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 60.0
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.size.height * 2/3)
        addChild(titleLabel)
        
        let playLabel = SKLabelNode(text: "Tap to play!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 40.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.size.height / 4)
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

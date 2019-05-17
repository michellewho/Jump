//
//  ScoreLabel.swift
//  Jump
//
//  Created by Michelle Ho on 5/17/19.
//  Copyright © 2019 Michelle Ho. All rights reserved.
//

import SpriteKit

class ScoreLabel {
    var node = SKLabelNode(text: "Score: 0")
    
    init(frame: CGRect) {
        node.fontName = "AvenirNext-Bold"
        node.fontSize = 20.0
        node.fontColor = UIColor.white
        node.horizontalAlignmentMode = .right
        node.position = CGPoint(x: frame.size.width - 30, y: frame.size.height - 60)
    }
    
    func updateScore(score: Int) {
        print(score)
        node.text = "Score: \(score)"
    }
}

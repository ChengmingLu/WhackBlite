//
//  GameHint3.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-07-09.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameHint3: SKScene {
    
    //var hintTitle: eCATextLayer = eCATextLayer()
    var hint: eCATextLayer = eCATextLayer()
    var hintImage: CALayer = CALayer()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        let hinteSize = CGSize(width: UIScreen.main.bounds.width * 3 / 4, height: UIScreen.main.bounds.height * 1.5)
        let hintOrigin = CGPoint(x: UIScreen.main.bounds.width / 2 - hinteSize.width / 2, y: UIScreen.main.bounds.height / 2 - hinteSize.height / 1.4)
        
        hint.frame = CGRect(origin: hintOrigin, size: hinteSize)
        
        hint.opacity = 1
        hint.contentsScale = UIScreen.main.scale
        hint.alignmentMode = kCAAlignmentCenter
        hint.foregroundColor = UIColor.white.cgColor
        //font
        let systemFont = UIFont.systemFont(ofSize: 0.0)
        let fontStringRef = systemFont.fontName as CFString
        hint.font = fontStringRef
        hint.fontSize = UIScreen.main.bounds.width / 20
        hint.string = NSLocalizedString("gameHint", comment: "")
        hint.isWrapped = true
        self.view?.layer.addSublayer(hint)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print("test ball at \(testBall.layer.frame)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hint.removeFromSuperlayer()
        //hintTitle.removeFromSuperlayer()
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let nextScene = GameHint4(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

//
//  Ball.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-06-10.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class Ball {
    enum type: UInt32 {
        case Black
        case White
        private static let count: type.RawValue = {
            var maxValue: UInt32 = 0
            while let _ = type(rawValue: maxValue) {
                maxValue += 1
            }
            return maxValue
        }()
        
        static func randomType() -> type {
            let rand = arc4random_uniform(count)
            return type(rawValue: rand)!
        }
    }
    var score: Int
    var scoreLabel: CATextLayer
    var ballType: type
    var layer: CALayer
    var colour: CGColor
    var diameter: CGFloat
    
    
    init(initRect: CGRect, ofType: type) {
        score = 0
        ballType = ofType
        colour = ballType == type.Black ? UIColor.black.cgColor : UIColor.white.cgColor
        layer = CALayer()
        layer.frame = initRect
        layer.backgroundColor = colour
        diameter = layer.frame.size.width
        layer.cornerRadius = diameter / 2 // dis makes a circle, kind of
        scoreLabel = CATextLayer()
        scoreLabel.frame = initRect
        resetScore()
        scoreLabel.contentsScale = UIScreen.main.scale
        scoreLabel.alignmentMode = kCAAlignmentCenter
        scoreLabel.foregroundColor = ballType == type.Black ? UIColor.white.cgColor : UIColor.black.cgColor
        //setting font
        let systemFont = UIFont.systemFont(ofSize: 0.0) //size is unimportant here
        let fontStringRef = systemFont.fontName as CFString
        print("fontStringRef is \(fontStringRef)")
        scoreLabel.font = fontStringRef
        scoreLabel.fontSize = 18.0
        
    }
    
    // update score Label as the score is changed
    func updateScoreLabel() {
        scoreLabel.string = "\(score)"
    }
    
    //add 1 to score and update its label
    func incScore() {
        score += 1
        updateScoreLabel()
    }
    
    //set score to 0 and update its label
    func resetScore() {
        score = 0
        updateScoreLabel()
    }
    
    //manage movement of the ball
    func move() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            
            
        }
        layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
        CATransaction.commit()
    }
}

















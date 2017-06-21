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
    
    //test
    var initialPos: CGPoint
    
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
        initialPos = initRect.origin
        resetScore()
        scoreLabel.contentsScale = UIScreen.main.scale
        scoreLabel.alignmentMode = kCAAlignmentCenter
        scoreLabel.foregroundColor = ballType == type.Black ? UIColor.white.cgColor : UIColor.black.cgColor
        //setting font
        let systemFont = UIFont.systemFont(ofSize: 0.0) //size is unimportant here
        let fontStringRef = systemFont.fontName as CFString
        scoreLabel.font = fontStringRef
        scoreLabel.fontSize =  initRect.size.width //needs to be tested
        //layer.addSublayer(scoreLabel)
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
        //if outside the grid: return score and self destruction
        //test move
        let lengthToMove: CGFloat = Grid.blockSize / 2 - layer.frame.size.width / 2
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            print("Ball: mom I moved, now I am at \(self.layer.frame.origin)")
            self.move()
        }
        layer.transform = CATransform3DTranslate(layer.transform, lengthToMove, lengthToMove,  0)
        scoreLabel.transform = layer.transform
        CATransaction.commit()
    }
    
    func test_resetPosition() {
        layer.frame.origin = initialPos
        scoreLabel.frame.origin = initialPos
    }
}

















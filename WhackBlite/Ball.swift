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
    
    enum direction: UInt32 {
        case Top
        case Bottom
        case Left
        case Right
        private static let count: direction.RawValue = {
            var maxValue: UInt32 = 0
            while let _ = direction(rawValue: maxValue) {
                maxValue += 1
            }
            return maxValue
        }()
        
        static func randomDirection() -> direction {
            let rand = arc4random_uniform(count)
            return direction(rawValue: rand)!
        }
    }
    let lengthToMove: CGFloat = Grid.blockSize / 2
    var score: Int
    var scoreLabel: CATextLayer
    var ballType: type
    var layer: CALayer
    var colour: CGColor
    var diameter: CGFloat
    var nextBlockToAccess: Block
    var directionToBlock: direction
    //test
    //var initialPos: CGPoint
    
    init(initRect: CGRect, ofType: type, toBlock: Block, fromDirection: direction) {
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
        //initialPos = initRect.origin
        nextBlockToAccess = toBlock
        directionToBlock = fromDirection
        
        //indirect initialization
        resetScore()
        scoreLabel.contentsScale = UIScreen.main.scale
        scoreLabel.alignmentMode = kCAAlignmentCenter
        scoreLabel.foregroundColor = ballType == type.Black ? UIColor.white.cgColor : UIColor.black.cgColor
        //setting font
        let systemFont = UIFont.systemFont(ofSize: 0.0) //size is unimportant here
        let fontStringRef = systemFont.fontName as CFString
        scoreLabel.font = fontStringRef
        scoreLabel.fontSize =  initRect.size.width * 0.76 //needs to be tested
        //layer.addSublayer(scoreLabel)
        
    }
    
    func addLayersToView(toView: UIView) {
        toView.layer.addSublayer(layer)
        toView.layer.addSublayer(scoreLabel)
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
        var xToMove: CGFloat = 0
        var yToMove: CGFloat = 0
        switch directionToBlock {
        case direction.Top:
            switch nextBlockToAccess.blockType {
            case Block.type.WBL:
                switch ballType {
                case type.Black:
                    xToMove = lengthToMove
                    yToMove = lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WBR:
                switch ballType {
                case type.Black:
                    xToMove = -lengthToMove
                    yToMove = lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WTL:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = -lengthToMove
                    yToMove = lengthToMove
                }
            case Block.type.WTR:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = lengthToMove
                    yToMove = lengthToMove
                }
            }
        case direction.Bottom:
            switch nextBlockToAccess.blockType {
            case Block.type.WBL:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = -lengthToMove
                    yToMove = -lengthToMove
                }
            case Block.type.WBR:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = lengthToMove
                    yToMove = -lengthToMove
                }
            case Block.type.WTL:
                switch ballType {
                case type.Black:
                    xToMove = lengthToMove
                    yToMove = -lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WTR:
                switch ballType {
                case type.Black:
                    xToMove = -lengthToMove
                    yToMove = -lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            }
        case direction.Left:
            switch nextBlockToAccess.blockType {
            case Block.type.WBL:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = lengthToMove
                    yToMove = lengthToMove
                }
            case Block.type.WBR:
                switch ballType {
                case type.Black:
                    xToMove = lengthToMove
                    yToMove = -lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WTL:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = lengthToMove
                    yToMove = -lengthToMove
                }
            case Block.type.WTR:
                switch ballType {
                case type.Black:
                    xToMove = lengthToMove
                    yToMove = lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            }
        case direction.Right:
            switch nextBlockToAccess.blockType {
            case Block.type.WBL:
                switch ballType {
                case type.Black:
                    xToMove = -lengthToMove
                    yToMove = -lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WBR:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = -lengthToMove
                    yToMove = lengthToMove
                }
            case Block.type.WTL:
                switch ballType {
                case type.Black:
                    xToMove = -lengthToMove
                    yToMove = lengthToMove
                case type.White:
                    print("Not accessible")
                    retire()
                    return
                }
            case Block.type.WTR:
                switch ballType {
                case type.Black:
                    print("Not accessible")
                    retire()
                    return
                case type.White:
                    xToMove = -lengthToMove
                    yToMove = -lengthToMove
                }
            }
        }
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WhatIsNextBlock"), object: self, userInfo: ["currentBlock":self.nextBlockToAccess, "direction":self.directionToBlock])
            self.incScore()
            self.move()
        }
        layer.transform = CATransform3DTranslate(layer.transform, xToMove, yToMove, 0)
        scoreLabel.transform = layer.transform
        CATransaction.commit()
    }
    
    
    
    //suicide
    func retire() {
        
    }
}

















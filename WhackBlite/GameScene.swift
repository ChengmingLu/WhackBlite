//
//  GameScene.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-06-04.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mainGrid: Grid = Grid.init(withNumberOfRows: 4, withNumberOfColumns: 4, withBlockSize: UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? (UIScreen.main.bounds.size.width - 40) / 4 : (UIScreen.main.bounds.size.height - 40) / 4)
    var totalScoreLabel: CATextLayer = CATextLayer()
    var totalScore: Int = 0
    
    var testBall: Ball = Ball.init(initRect: CGRect.zero, ofType: Ball.type.randomType(), toBlock: Block.init(initRect: CGRect.zero, typeOfBlock: Block.type.randomType(), x:0, y:0), fromDirection: Ball.direction.randomDirection())
    
    override func didMove(to view: SKView) {

        //init total score label
        totalScoreLabel.frame = CGRect(x: mainGrid.blocks[0][0].layer.frame.origin.x, y: mainGrid.blocks[0][0].layer.frame.origin.y - Grid.blockSize / 2, width: mainGrid.blocks[0][0].layer.frame.size.width / 3, height: mainGrid.blocks[0][0].layer.frame.size.height)
        resetTotalScore()
        totalScoreLabel.contentsScale = UIScreen.main.scale
        totalScoreLabel.alignmentMode = kCAAlignmentCenter
        totalScoreLabel.foregroundColor = UIColor.white.cgColor
        //font
        let systemFont = UIFont.systemFont(ofSize: 0.0)
        let fontStringRef = systemFont.fontName as CFString
        totalScoreLabel.font = fontStringRef
        totalScoreLabel.fontSize = 20
        self.view?.layer.addSublayer(totalScoreLabel)
        
        //add grid to view
        mainGrid.addGridToView(toView: self.view!)
        
        
        
        
        //testing
        let ballDiameter = Grid.blockSize / 3
        testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: Ball.type.randomType(), toBlock: mainGrid.blocks[0][0], fromDirection: Ball.direction.Top)
        
        testBall.addLayersToView(toView: self.view!)
        NotificationCenter.default.addObserver(self, selector: #selector(getNextBlockWithCurrentBlockIndex(note:)), name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: testBall)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //NSLog("GS: touched began")
        //incTotalScore()
        
        for r in 0..<4 {
            for c in 0..<4 {
                if mainGrid.blocks[r][c].layer.frame.contains((touches.first?.location(in: self.view))!) {
                    //NSLog("GS: touched at row %d, coloum %d, rotating", r, c)
                    if mainGrid.blocks[r][c].canRotate {
                        mainGrid.blocks[r][c].rotateClockwise90()
                        //testBall.test_resetPosition()
                    }
                    return
                }
            }
        }
        
        testBall.move()
        
        //add a ball whenever we touch somewhere else
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print("test ball at \(testBall.layer.frame)")


    }
    
    func updateTotalScore() {
        totalScoreLabel.string = "\(totalScore)"
    }
    
    func resetTotalScore() {
        totalScore = 0
        updateTotalScore()
    }
    
    func incTotalScore(amount: Int) {
        totalScore += amount
        updateTotalScore()
    }
    
    func getNextBlockWithCurrentBlockIndex(note: Notification) {
        print("I will change your shoes")
        let userInformation = note.userInfo as NSDictionary?
        let direction = userInformation?.object(forKey: "direction") as! Ball.direction
        let currentblock = userInformation?.object(forKey: "currentBlock") as! Block
        let theBall = note.object as! Ball
        switch direction {
        case Ball.direction.Top:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        testBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        testBall.directionToBlock = Ball.direction.Right
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        testBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        testBall.directionToBlock = Ball.direction.Left
                    }
                }
            }
        case Ball.direction.Bottom:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        testBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        testBall.directionToBlock = Ball.direction.Left
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        testBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        testBall.directionToBlock = Ball.direction.Right
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            }
        case Ball.direction.Left:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Bottom
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.xIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Bottom
                    }
                }

            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Top
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            }
        case Ball.direction.Right:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Bottom
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Top
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.xIndex == 0) {
                        print("Exiting")
                        incTotalScore(amount: theBall.score)
                        testBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                    } else {
                        testBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        testBall.directionToBlock = Ball.direction.Bottom
                    }
                }
            }
        }
    }
}

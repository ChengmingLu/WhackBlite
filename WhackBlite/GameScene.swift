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
    
    struct spawn {
        var rowIndex:Int
        var colIndex:Int
        var fromDirection:Ball.direction
    }
    
    enum possibleSpawns:UInt32 {
        case TopFirst
        case TopSecond
        case TopThird
        case TopFourth
        case BottomFirst
        case BottomSecond
        case BottomThird
        case BottomFourth
        case LeftFirst
        case LeftSecond
        case LeftThird
        case LeftFourth
        case RightFirst
        case RightSecond
        case RightThird
        case RightFourth
        private static let count: possibleSpawns.RawValue = {
            var maxValue: UInt32 = 0
            while let _ = possibleSpawns(rawValue: maxValue) {
                maxValue += 1
            }
            return maxValue
        }()
        
        static func randomSpawn() -> possibleSpawns {
            let rand = arc4random_uniform(count)
            return possibleSpawns(rawValue: rand)!
        }
    }
    
    var mainGrid: Grid = Grid.init(withNumberOfRows: 4, withNumberOfColumns: 4, withBlockSize: UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? (UIScreen.main.bounds.size.width - 40) / 4 : (UIScreen.main.bounds.size.height - 40) / 4)
    var totalScoreLabel: CATextLayer = CATextLayer()
    var totalScore: Int = 0
    var canSpawnBall: Bool = true
    //var testBall: Ball = Ball.init(initRect: CGRect.zero, ofType: Ball.type.randomType(), toBlock: Block.init(initRect: CGRect.zero, typeOfBlock: Block.type.randomType(), x:0, y:0), fromDirection: Ball.direction.randomDirection())
    
    override func didMove(to view: SKView) {

        //init total score label
        totalScoreLabel.frame = CGRect(x: mainGrid.blocks[0][0].layer.frame.origin.x, y: mainGrid.blocks[0][0].layer.frame.origin.y - Grid.blockSize / 2, width: mainGrid.blocks[0][0].layer.frame.size.width / 2, height: mainGrid.blocks[0][0].layer.frame.size.height)
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
        
        
        //testball
        //testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2 - Grid.blockSize / 2 / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y - Grid.blockSize / 2 / 2, width:Grid.blockSize / 2, height:Grid.blockSize / 2), ofType: Ball.type.randomType(), toBlock: mainGrid.blocks[0][0], fromDirection: Ball.direction.Top)
        
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
        
        //testBall.move()
        if canSpawnBall {
            spawnAndStartBall()
            canSpawnBall = false
        }
        //add a ball whenever we touch somewhere else
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canSpawnBall = true
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
    
    func spawnAndStartBall() {
        //testing
        var testBall: Ball = Ball.init(initRect: CGRect.zero, ofType: Ball.type.randomType(), toBlock: Block.init(initRect: CGRect.zero, typeOfBlock: Block.type.randomType(), x:0, y:0), fromDirection: Ball.direction.randomDirection())
        let ballDiameter = Grid.blockSize / 3 //did not use radius since height and width need whole diameter
        let positionToSpawn = possibleSpawns.randomSpawn()
        var directionToSpawn: Ball.direction
        var ballTypeToSpawn: Ball.type
        switch positionToSpawn {
        case possibleSpawns.TopFirst:
            if (mainGrid.blocks[0][0].blockType == Block.type.WBL || mainGrid.blocks[0][0].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][0], fromDirection: directionToSpawn)
        case possibleSpawns.TopSecond:
            if (mainGrid.blocks[0][1].blockType == Block.type.WBL || mainGrid.blocks[0][1].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][1].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][1].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][1], fromDirection: directionToSpawn)
        case possibleSpawns.TopThird:
            if (mainGrid.blocks[0][2].blockType == Block.type.WBL || mainGrid.blocks[0][2].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][2].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][2].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][2], fromDirection: directionToSpawn)
        case possibleSpawns.TopFourth:
            if (mainGrid.blocks[0][3].blockType == Block.type.WBL || mainGrid.blocks[0][3].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][3].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][3].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][3], fromDirection: directionToSpawn)
        case possibleSpawns.LeftFirst:
            if (mainGrid.blocks[0][0].blockType == Block.type.WBR || mainGrid.blocks[0][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x - ballDiameter / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][0], fromDirection: directionToSpawn)
        case possibleSpawns.LeftSecond:
            if (mainGrid.blocks[1][0].blockType == Block.type.WBR || mainGrid.blocks[1][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[1][0].layer.frame.origin.x - ballDiameter / 2, y:mainGrid.blocks[1][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[1][0], fromDirection: directionToSpawn)
        case possibleSpawns.LeftThird:
            if (mainGrid.blocks[2][0].blockType == Block.type.WBR || mainGrid.blocks[2][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[2][0].layer.frame.origin.x - ballDiameter / 2, y:mainGrid.blocks[2][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[2][0], fromDirection: directionToSpawn)
        case possibleSpawns.LeftFourth:
            if (mainGrid.blocks[3][0].blockType == Block.type.WBR || mainGrid.blocks[3][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][0].layer.frame.origin.x - ballDiameter / 2, y:mainGrid.blocks[3][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][0], fromDirection: directionToSpawn)
        case possibleSpawns.BottomFirst:
            if (mainGrid.blocks[3][0].blockType == Block.type.WTL || mainGrid.blocks[3][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[3][0].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][0], fromDirection: directionToSpawn)
        case possibleSpawns.BottomSecond:
            if (mainGrid.blocks[3][1].blockType == Block.type.WTL || mainGrid.blocks[3][1].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][1].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[3][1].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][1], fromDirection: directionToSpawn)
        case possibleSpawns.BottomThird:
            if (mainGrid.blocks[3][2].blockType == Block.type.WTL || mainGrid.blocks[3][2].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][2].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[3][2].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][2], fromDirection: directionToSpawn)
        case possibleSpawns.BottomFourth:
            if (mainGrid.blocks[3][3].blockType == Block.type.WTL || mainGrid.blocks[3][3].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][3].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[3][3].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][3], fromDirection: directionToSpawn)
        case possibleSpawns.RightFirst:
            if (mainGrid.blocks[0][3].blockType == Block.type.WTL || mainGrid.blocks[0][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:mainGrid.blocks[0][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[0][3], fromDirection: directionToSpawn)
        case possibleSpawns.RightSecond:
            if (mainGrid.blocks[1][3].blockType == Block.type.WTL || mainGrid.blocks[1][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[1][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:mainGrid.blocks[1][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[1][3], fromDirection: directionToSpawn)
        case possibleSpawns.RightThird:
            if (mainGrid.blocks[2][3].blockType == Block.type.WTL || mainGrid.blocks[2][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[2][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:mainGrid.blocks[2][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[2][3], fromDirection: directionToSpawn)
        case possibleSpawns.RightFourth:
            if (mainGrid.blocks[3][3].blockType == Block.type.WTL || mainGrid.blocks[3][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[3][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:mainGrid.blocks[3][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: mainGrid.blocks[3][3], fromDirection: directionToSpawn)
        }
        
        //testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: mainGrid.blocks[0][0].blockType == Block.type.WBL || mainGrid.blocks[0][0].blockType == Block.type.WBR ? Ball.type.Black : Ball.type.White, toBlock: mainGrid.blocks[0][0], fromDirection: Ball.direction.Top)
        
        testBall.addLayersToView(toView: self.view!)
        NotificationCenter.default.addObserver(self, selector: #selector(getNextBlockWithCurrentBlockIndex(note:)), name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: testBall)
        //NotificationCenter
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { 
            testBall.move()
        }
    }
        
    func getNextBlockWithCurrentBlockIndex(note: Notification) {
        print("received note in getNextBlockWithCurrentBlockIndex")
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
                        print("Exiting TOP WBL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        print("Exiting TOP WBR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
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
                        print("Exiting TOP WTL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting TOP WTR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
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
                        print("Exiting BOT WBL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    print("Collission with block of opposite colour")
                case Ball.type.White:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting BOT WBR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == mainGrid.numberOfColumns - 1) {
                        print("Exiting BOT WTL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    print("Collission with block of opposite colour")
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        print("Exiting BOT WTR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
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
                        print("Exiting LEF WBL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == 0) {
                        print("Exiting LEF WBR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
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
                        print("Exiting LEF WTL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                }

            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting LEF WTR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
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
                        print("Exiting RIG WBL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
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
                        print("Exiting RIG WBR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == mainGrid.numberOfRows - 1) {
                        print("Exiting RIG WTL, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
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
                        print("Exiting RIG WTR, the ball had score \(theBall.score)")
                        incTotalScore(amount: theBall.score)
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        theBall.nextBlockToAccess = mainGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                }
            }
        }
    }
}

//
//  GameHint.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-07-09.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameHint: SKScene {
    var hintTapCounter = 4
    //var hintTitle: eCATextLayer = eCATextLayer()
    var hint: eCATextLayer = eCATextLayer()
    var hintImage: CALayer = CALayer()
    var demoGrid: Grid = Grid.init(withBlockSize: (UIScreen.main.bounds.size.width - 80) / 4)
    var gridInteractionEnabled = true
    var secondHintBallSpawned = false
    var totalScoreLabel = CATextLayer()
    var totalScore = 0
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        demoGrid.addGridToView(toView: self.view!)
        
        
        let hinteSize = CGSize(width: UIScreen.main.bounds.width * 3 / 4, height: UIScreen.main.bounds.height * 1.5)
        var hintOrigin = CGPoint(x: UIScreen.main.bounds.width / 2 - hinteSize.width / 2, y: (UIScreen.main.bounds.height - 6 * Grid.blockSize) / 2)
        
        //print(NSStringFromCGPoint(hintOrigin))
        demoGrid.grid.frame = CGRect(x: demoGrid.grid.frame.origin.x, y: hintOrigin.y + 2 * Grid.blockSize, width: demoGrid.grid.frame.width, height: demoGrid.grid.frame.height)
        
        hintOrigin = CGPoint(x: UIScreen.main.bounds.width / 2 - hinteSize.width / 2, y:  -6 * Grid.blockSize)
        
        hint.frame = CGRect(origin: hintOrigin, size: hinteSize)
        print("grid frame is \(NSStringFromCGRect(demoGrid.grid.frame))")
        print("hint frame is \(NSStringFromCGRect(hint.frame))")
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
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        totalScoreLabel.frame = CGRect(x: demoGrid.grid.frame.origin.x - Grid.blockSize / 4, y: demoGrid.grid.frame.origin.y - Grid.blockSize / 2, width: Grid.blockSize * 2.5, height: Grid.blockSize / 2)
        CATransaction.commit()
        resetTotalScore()
        //CATransaction.setDisableActions(true)
        totalScoreLabel.opacity = 1
        totalScoreLabel.contentsScale = UIScreen.main.scale
        totalScoreLabel.alignmentMode = kCAAlignmentCenter
        totalScoreLabel.foregroundColor = UIColor.white.cgColor
        //font
        totalScoreLabel.font = fontStringRef
        totalScoreLabel.fontSize = Grid.blockSize * 0.3
        self.view?.layer.addSublayer(totalScoreLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print("test ball at \(testBall.layer.frame)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self.view)
        let xTouchLoc = touchLocation?.x
        let yTouchLoc = touchLocation?.y
        
        
        for r in 0..<demoGrid.numberOfRows {
            for c in 0..<demoGrid.numberOfColumns {
                if demoGrid.blocks[r][c].layer.frame.contains(CGPoint(x: xTouchLoc! - demoGrid.grid.frame.origin.x, y: yTouchLoc! - demoGrid.grid.frame.origin.y)) {//to calibrate location due to difference introduced by demoGrid's grid layer
                    if gridInteractionEnabled {
                        demoGrid.blocks[r][c].rotateClockwise90()
                    }
                    return
                }
            }
        }
        
        
        
        if hintTapCounter <= 1 {
            hint.removeFromSuperlayer()
            totalScoreLabel.removeFromSuperlayer()
            demoGrid.grid.removeFromSuperlayer()
            //hintTitle.removeFromSuperlayer()
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let nextScene = GameScene(size: scene!.size)
            nextScene.scaleMode = .aspectFill
            scene?.view?.presentScene(nextScene, transition: transition)
        } else if hintTapCounter == 4 {
            gridInteractionEnabled = false
            demoGrid.blocks[3][1].rotateToAndSetType(toType: .WTL)
            demoGrid.blocks[3][2].rotateToAndSetType(toType: .WBR)
            demoGrid.blocks[2][2].rotateToAndSetType(toType: .WTR)
            demoGrid.blocks[2][1].rotateToAndSetType(toType: .WBL)
            demoGrid.blocks[1][1].rotateToAndSetType(toType: .WTR)
            demoGrid.blocks[1][0].rotateToAndSetType(toType: .WBL)
            demoGrid.blocks[0][0].rotateToAndSetType(toType: .WTR)
            hint.string = NSLocalizedString("gameHint2", comment: "")
            if !secondHintBallSpawned {
                hintTapCounter += 1
                secondHintBallSpawned = true
            } else {
                _ = spawnAndStartBall(spawn: GameScene.possibleSpawns.BottomSecond)
            }
        } else if hintTapCounter == 3 {
            if totalScore < 6 { // wow hardcode here, reported
                hintTapCounter += 1
            }
            hint.string = NSLocalizedString("gameHint2-1", comment: "")
        } else if hintTapCounter == 2 {
            hint.string = NSLocalizedString("gameHint3", comment: "")
        }
        hintTapCounter -= 1
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    func spawnAndStartBall(spawn: GameScene.possibleSpawns = GameScene.possibleSpawns.randomSpawn()) -> Bool {
        //testing
        var testBall: Ball
        let ballDiameter = Grid.blockSize / 3 //did not use radius since height and width need whole diameter
        let positionToSpawn = spawn
        var directionToSpawn: Ball.direction
        var ballTypeToSpawn: Ball.type
        switch positionToSpawn {
        case GameScene.possibleSpawns.TopFirst:
            /*if (demoGrid.blocks[0][0].blockType == Block.type.WBL || demoGrid.blocks[0][0].blockType == Block.type.WBR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[0][0].blockType {
            case Block.type.WBL:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WBR:
                return false
            case Block.type.WTL:
                return false
            case Block.type.WTR:
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[0][0].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.TopSecond:
            if (demoGrid.blocks[0][1].blockType == Block.type.WBL || demoGrid.blocks[0][1].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][1].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[0][1].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][1], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.TopThird:
            if (demoGrid.blocks[0][2].blockType == Block.type.WBL || demoGrid.blocks[0][2].blockType == Block.type.WBR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][2].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[0][2].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][2], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.TopFourth:
            /*if (demoGrid.blocks[0][3].blockType == Block.type.WBL || demoGrid.blocks[0][3].blockType == Block.type.WBR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[0][3].blockType {
            case Block.type.WBL:
                return false
            case Block.type.WBR:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WTL:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WTR:
                return false
            }
            directionToSpawn = Ball.direction.Top
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][3].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[0][3].layer.frame.origin.y - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][3], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.LeftFirst:
            /*if (demoGrid.blocks[0][0].blockType == Block.type.WBR || demoGrid.blocks[0][0].blockType == Block.type.WTR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[0][0].blockType {
            case Block.type.WBL:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WBR:
                return false
            case Block.type.WTL:
                return false
            case Block.type.WTR:
                ballTypeToSpawn = Ball.type.Black
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][0].layer.frame.origin.x - ballDiameter / 2, y:demoGrid.blocks[0][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.LeftSecond:
            if (demoGrid.blocks[1][0].blockType == Block.type.WBR || demoGrid.blocks[1][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[1][0].layer.frame.origin.x - ballDiameter / 2, y:demoGrid.blocks[1][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[1][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.LeftThird:
            if (demoGrid.blocks[2][0].blockType == Block.type.WBR || demoGrid.blocks[2][0].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[2][0].layer.frame.origin.x - ballDiameter / 2, y:demoGrid.blocks[2][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[2][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.LeftFourth:
            /*if (demoGrid.blocks[3][0].blockType == Block.type.WBR || demoGrid.blocks[3][0].blockType == Block.type.WTR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[3][0].blockType {
            case Block.type.WBL:
                return false
            case Block.type.WBR:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WTL:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WTR:
                return false
            }
            directionToSpawn = Ball.direction.Left
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][0].layer.frame.origin.x - ballDiameter / 2, y:demoGrid.blocks[3][0].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.BottomFirst:
            /*if (demoGrid.blocks[3][0].blockType == Block.type.WTL || demoGrid.blocks[3][0].blockType == Block.type.WTR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[3][0].blockType {
            case Block.type.WBL:
                return false
            case Block.type.WBR:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WTL:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WTR:
                return false
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][0].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[3][0].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][0], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.BottomSecond:
            if (demoGrid.blocks[3][1].blockType == Block.type.WTL || demoGrid.blocks[3][1].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][1].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[3][1].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][1], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.BottomThird:
            if (demoGrid.blocks[3][2].blockType == Block.type.WTL || demoGrid.blocks[3][2].blockType == Block.type.WTR) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][2].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[3][2].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][2], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.BottomFourth:
            /*if (demoGrid.blocks[3][3].blockType == Block.type.WTL || demoGrid.blocks[3][3].blockType == Block.type.WTR) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[3][3].blockType {
            case Block.type.WBL:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WBR:
                return false
            case Block.type.WTL:
                return false
            case Block.type.WTR:
                ballTypeToSpawn = Ball.type.Black
            }
            directionToSpawn = Ball.direction.Bottom
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][3].layer.frame.origin.x + Grid.blockSize / 2 - ballDiameter / 2, y:demoGrid.blocks[3][3].layer.frame.origin.y + Grid.blockSize - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][3], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.RightFirst:
            /*if (demoGrid.blocks[0][3].blockType == Block.type.WTL || demoGrid.blocks[0][3].blockType == Block.type.WBL) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[0][3].blockType {
            case Block.type.WBL:
                return false
            case Block.type.WBR:
                ballTypeToSpawn = Ball.type.White
            case Block.type.WTL:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WTR:
                return false
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[0][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:demoGrid.blocks[0][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[0][3], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.RightSecond:
            if (demoGrid.blocks[1][3].blockType == Block.type.WTL || demoGrid.blocks[1][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[1][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:demoGrid.blocks[1][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[1][3], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.RightThird:
            if (demoGrid.blocks[2][3].blockType == Block.type.WTL || demoGrid.blocks[2][3].blockType == Block.type.WBL) {
                ballTypeToSpawn = Ball.type.Black
            } else {
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[2][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:demoGrid.blocks[2][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[2][3], fromDirection: directionToSpawn)
        case GameScene.possibleSpawns.RightFourth:
            /*if (demoGrid.blocks[3][3].blockType == Block.type.WTL || demoGrid.blocks[3][3].blockType == Block.type.WBL) {
             ballTypeToSpawn = Ball.type.Black
             } else {
             ballTypeToSpawn = Ball.type.White
             }*/
            //we replace if with switch only for blocks that sit at the corner because in some cases scoring is not possible
            switch demoGrid.blocks[3][3].blockType {
            case Block.type.WBL:
                ballTypeToSpawn = Ball.type.Black
            case Block.type.WBR:
                return false
            case Block.type.WTL:
                return false
            case Block.type.WTR:
                ballTypeToSpawn = Ball.type.White
            }
            directionToSpawn = Ball.direction.Right
            testBall = Ball.init(initRect: CGRect(x:demoGrid.blocks[3][3].layer.frame.origin.x + Grid.blockSize - ballDiameter / 2, y:demoGrid.blocks[3][3].layer.frame.origin.y + Grid.blockSize / 2 - ballDiameter / 2, width:ballDiameter, height:ballDiameter), ofType: ballTypeToSpawn, toBlock: demoGrid.blocks[3][3], fromDirection: directionToSpawn)
        }
        
        testBall.addLayersToLayer(toLayer: demoGrid.grid)
        NotificationCenter.default.addObserver(self, selector: #selector(getNextBlockWithCurrentBlockIndex(note:)), name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: testBall)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            testBall.move()
        }
        return true
    }
    
    
    func updateTotalScore() {
        totalScoreLabel.string = "\(totalScore) <-- total score"
        
    }
    
    func resetTotalScore() {
        totalScore = 0
        updateTotalScore()
    }
    
    func incTotalScore(amount: Int) {
        totalScore += amount
        totalScore = totalScore < 0 ? 0 : totalScore //prevent totalScore from being negative
        updateTotalScore()
    }

    @objc func getNextBlockWithCurrentBlockIndex(note: Notification) {
        let userInformation = note.userInfo as NSDictionary?
        let direction = userInformation?.object(forKey: "direction") as! Ball.direction
        let currentblock = userInformation?.object(forKey: "currentBlock") as! Block
        let theBall = note.object as! Ball
        //print("received note in getNextBlockWithCurrentBlockIndex, current ball score \(theBall.score)")
        switch direction {
        case Ball.direction.Top:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == demoGrid.numberOfColumns - 1) {
                        //print("Exiting TOP WBL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) ||  demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        //print("Exiting TOP WBR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            //theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.yIndex == 0) {
                        //print("Exiting TOP WTL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.yIndex == demoGrid.numberOfColumns - 1) {
                        //print("Exiting TOP WTR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                }
            }
        case Ball.direction.Bottom:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.yIndex == 0) {
                        //print("Exiting BOT WBL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.yIndex == demoGrid.numberOfColumns - 1) {
                        //print("Exiting BOT WBR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == demoGrid.numberOfColumns - 1) {
                        //print("Exiting BOT WTL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex + 1]
                        theBall.directionToBlock = Ball.direction.Left
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.yIndex == 0) {
                        //print("Exiting BOT WTR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "penalizeScore"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            //theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex][currentblock.yIndex - 1]
                        theBall.directionToBlock = Ball.direction.Right
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            }
        case Ball.direction.Left:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.xIndex == demoGrid.numberOfRows - 1) {
                        //print("Exiting LEF WBL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            //theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == 0) {
                        //print("Exiting LEF WBR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            //theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.xIndex == 0) {
                        //print("Exiting LEF WTL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                }
                
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == demoGrid.numberOfRows - 1) {
                        //print("Exiting LEF WTR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            }
        case Ball.direction.Right:
            switch currentblock.blockType {
            case Block.type.WBL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == 0) {
                        //print("Exiting RIG WBL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WBR:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.xIndex == demoGrid.numberOfRows - 1) {
                        //print("Exiting RIG WBR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                }
            case Block.type.WTL:
                switch theBall.ballType {
                case Ball.type.Black:
                    if (currentblock.xIndex == demoGrid.numberOfRows - 1) {
                        //print("Exiting RIG WTL, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex + 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Top
                    }
                case Ball.type.White:
                    //print("Collission with block of opposite colour")
                    break
                }
            case Block.type.WTR:
                switch theBall.ballType {
                case Ball.type.Black:
                    //print("Collission with block of opposite colour")
                    break
                case Ball.type.White:
                    if (currentblock.xIndex == 0) {
                        //print("Exiting RIG WTR, the ball had score \(theBall.score)")
                        if theBall.needToSumbitScore {
                            incTotalScore(amount: theBall.score)
                        }
                        theBall.nextBlockToAccess = Block.init(initRect: CGRect.zero, typeOfBlock: Block.type(rawValue: (currentblock.blockType.rawValue + 2) % Block.type.count)!, x: 0, y: 0) // this basically makes a dummy ball with flipped orientation which blocks the ball from going on further, ideally
                        //now we should remove observer I guess
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "WhatIsNextBlock"), object: theBall)
                    } else {
                        //                        if theBall.score < maxBallScoreAllowed && (demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 1) % Block.type.count) || demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex].blockType == Block.type(rawValue: (theBall.nextBlockToAccess.blockType.rawValue + 3) % Block.type.count)) {
                        //                            theBall.incScore() //we detected a turn
                        //                        }
                        theBall.nextBlockToAccess = demoGrid.blocks[currentblock.xIndex - 1][currentblock.yIndex]
                        theBall.directionToBlock = Ball.direction.Bottom
                    }
                }
            }
        }
    }
}

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
    var testBall: Ball = Ball.init(initRect: CGRect.zero, ofType: Ball.type.randomType())
    override func didMove(to view: SKView) {
        //init total score label
        totalScoreLabel.frame = CGRect(x: mainGrid.blocks[0][0].layer.frame.origin.x, y: mainGrid.blocks[0][0].layer.frame.origin.y - Grid.blockSize / 3, width: mainGrid.blocks[0][0].layer.frame.size.width / 3, height: mainGrid.blocks[0][0].layer.frame.size.height)
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
        
        testBall = Ball.init(initRect: CGRect(x:mainGrid.blocks[0][0].layer.frame.origin.x + Grid.blockSize / 2, y:mainGrid.blocks[0][0].layer.frame.origin.y, width:Grid.blockSize / 3, height:Grid.blockSize / 3), ofType: Ball.type.Black)
        
        self.view?.layer.addSublayer(testBall.layer)
        self.view?.layer.addSublayer(testBall.scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //NSLog("GS: touched began")
        //incTotalScore()
        
        for c in 0..<4 {
            for r in 0..<4 {
                if mainGrid.blocks[r][c].layer.frame.contains((touches.first?.location(in: self.view))!) {
                    //NSLog("GS: touched at row %d, coloum %d, rotating", r, c)
                    if mainGrid.blocks[r][c].canRotate {
                        mainGrid.blocks[r][c].rotateClockwise90()
                        testBall.test_resetPosition()
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
        for c in 0..<4 {
            for r in 0..<4 {
                if mainGrid.blocks[r][c].layer.frame.contains(mainGrid.blocks[r][c].layer.frame) {

                }
            }
        }

    }
    
    func updateTotalScore() {
        totalScoreLabel.string = "\(totalScore)"
    }
    
    func resetTotalScore() {
        totalScore = 0
        updateTotalScore()
    }
    
    func incTotalScore() {
        totalScore += 1
        updateTotalScore()
    }
}

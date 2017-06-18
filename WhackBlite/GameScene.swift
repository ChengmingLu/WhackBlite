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
    var testGrid: Grid = Grid.init(withNumberOfRows: 4, withNumberOfColumns: 4, withBlockSize: UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? (UIScreen.main.bounds.size.width - 40) / 4 : (UIScreen.main.bounds.size.height - 40) / 4)
    override func didMove(to view: SKView) {
        let testBall = Ball.init(initRect: CGRect(x:testGrid.blocks[0][0].layer.frame.origin.x, y:testGrid.blocks[0][0].layer.frame.origin.y, width:testGrid.blockSize / 3, height:testGrid.blockSize / 3), ofType: Ball.type.Black)
        testGrid.addGridToView(toView: self.view!)
        self.view?.layer.addSublayer(testBall.layer)
        self.view?.layer.addSublayer(testBall.scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //NSLog("GS: touched began")
        for c in 0..<4 {
            for r in 0..<4 {
                if testGrid.blocks[r][c].layer.frame.contains((touches.first?.location(in: self.view))!) {
                    //NSLog("GS: touched at row %d, coloum %d, rotating", r, c)
                    if testGrid.blocks[r][c].canRotate {
                        testGrid.blocks[r][c].rotateClockwise90()
                    }
                    return
                }
            }
        }
        //add a ball whenever we touch somewhere else
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

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
    var testGrid = Grid.init(withNumberOfRows: 4, withNumberOfColumns: 4, withBlockSize: UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? (UIScreen.main.bounds.size.width - 40) / 4 : (UIScreen.main.bounds.size.height - 40) / 4)
    
    override func didMove(to view: SKView) {
        //var testBlock: Block
        //testBlock = Block.init(initRect: CGRect(x: 50, y: 50, width: 100, height: 100), typeOfBlock: Block.type.randomType())
        //self.view?.layer.addSublayer(testBlock.layer)
        
        testGrid.addGridToView(toView: self.view!)
        //testgrid.blocks[0][0].shrinkBlockAndSurroundings()
        //testgrid.blocks[0][1].shrinkBlockAndSurroundings()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        NSLog("GS: touched down")

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("GS: touched began")
        for c in 0..<4 {
            for r in 0..<4 {
                if testGrid.blocks[r][c].layer.frame.contains((touches.first?.location(in: self.view))!) {
                    NSLog("GS: touched at row %d, coloum %d, rotating", r, c)
                    testGrid.blocks[r][c].rotateClockwise90()
                }
            }
        }
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

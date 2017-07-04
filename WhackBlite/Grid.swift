//
//  Grid.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-06-04.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Grid {
    var screenRect: CGRect
    var grid: CALayer
    var blocks = [[Block]]()
    let numberOfRows: Int = 4
    let numberOfColumns: Int = 4
    static var blockSize: CGFloat = 0
    var count: Int
    init(withBlockSize: CGFloat) {
        //numberOfRows = withNumberOfRows
        //numberOfColumns = withNumberOfColumns
        Grid.blockSize = withBlockSize
        screenRect = UIScreen.main.bounds
        let rawHalfColumnPosition: CGFloat = screenRect.size.width / 2 - Grid.blockSize * CGFloat(numberOfColumns) / 2
        let rawHalfRowPosition: CGFloat = screenRect.size.height / 2 - Grid.blockSize * CGFloat(numberOfRows) / 2
        let columnStartPosition: CGFloat = rawHalfColumnPosition
        let rowStartPosition: CGFloat = rawHalfRowPosition
        count = numberOfRows * numberOfColumns
        grid = CALayer()
        blocks = Array(repeating: Array(repeating: Block.init(initRect: CGRect(x: 0, y: 0, width: Grid.blockSize, height: Grid.blockSize), typeOfBlock: Block.type.randomType(), x:0, y:0), count: numberOfColumns), count: numberOfRows)
        for r in 0..<numberOfRows {
            for c in 0..<numberOfColumns {
                blocks[r][c] = Block(initRect: CGRect(x: /*columnStartPosition + */CGFloat(c) * Grid.blockSize, y: /*rowStartPosition + */CGFloat(r) * Grid.blockSize, width: Grid.blockSize, height: Grid.blockSize), typeOfBlock: Block.type.randomType(), x:r, y:c)
            }
        }
        grid.frame = CGRect(origin: CGPoint(x: columnStartPosition, y: rowStartPosition), size: CGSize(width: Grid.blockSize * 4, height: Grid.blockSize * 4))
    }
    
    //Add grid to specified view's layer as a sublayer
    func addGridToView(toView: UIView) {
        for r in 0..<numberOfRows {
            for c in 0..<numberOfColumns {
                grid.addSublayer(blocks[r][c].layer)
                blocks[r][c].setTypeAndRedraw(typeToSet: Block.type.randomType())
            }
        }
        toView.layer.addSublayer(grid)
    }
    
    // Convert given index to array index
    func indexToArray(index: Int) -> (r: Int, c: Int) {
        //var
        return (r: (index - 1) / numberOfColumns, c: (index - 1) % numberOfColumns)
    }
    
    // Convert given array to index
    func arrayToIndex(array: (r: Int, c: Int)) -> Int {
        return array.r * numberOfColumns + array.c + 1
    }
    
    //this is hardcoded to assume the grid is 4X4
    func setBlocksToResultScreen() {
        blocks[0][0].rotateToType(toType: Block.type.WBR)
        blocks[0][1].rotateToType(toType: Block.type.WBL)
        blocks[0][2].rotateToType(toType: Block.type.WBR)
        blocks[0][3].rotateToType(toType: Block.type.WBL)
        
        blocks[1][0].rotateToType(toType: Block.type.WTR)
        blocks[1][1].rotateToType(toType: Block.type.WTL)
        blocks[1][2].rotateToType(toType: Block.type.WTR)
        blocks[1][3].rotateToType(toType: Block.type.WTL)
        
        blocks[2][0].rotateToType(toType: Block.type.WBR)
        blocks[2][1].rotateToType(toType: Block.type.WBL)
        blocks[2][2].rotateToType(toType: Block.type.WBR)
        blocks[2][3].rotateToType(toType: Block.type.WBL)
        
        blocks[3][0].rotateToType(toType: Block.type.WTR)
        blocks[3][1].rotateToType(toType: Block.type.WTL)
        blocks[3][2].rotateToType(toType: Block.type.WTR)
        blocks[3][3].rotateToType(toType: Block.type.WTL)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { 
            
        }
        //print("block0 has frame origin of \(blocks[0][0].layer.frame.origin)with superlayer \(blocks[0][0].layer.superlayer)")
        //grid.transform = CATransform3DMakeTranslation(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2, 0)
        //grid.transform = CATransform3DTranslate(grid.transform, Grid.blockSize * 4 / (sqrt(2)), 0, 0)
        grid.transform = CATransform3DRotate(grid.transform, CGFloat(Double.pi / 4), 0, 0, 1)
        //grid.transform = CATransform3DTranslate(grid.transform, Grid.blockSize * 4, 0, 0)
        CATransaction.commit()
    }
}

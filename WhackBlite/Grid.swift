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
    var numberOfRows: Int
    var numberOfColumns: Int
    static var blockSize: CGFloat = 0
    var count: Int
    init(withNumberOfRows: Int, withNumberOfColumns: Int, withBlockSize: CGFloat) {
        numberOfRows = withNumberOfRows
        numberOfColumns = withNumberOfColumns
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
                blocks[r][c] = Block(initRect: CGRect(x: columnStartPosition + CGFloat(c) * Grid.blockSize, y: rowStartPosition + CGFloat(r) * Grid.blockSize, width: Grid.blockSize, height: Grid.blockSize), typeOfBlock: Block.type.randomType(), x:r, y:c)
            }
        }
    }
    
    //Add grid to specified view's layer as a sublayer
    func addGridToView(toView: UIView) {
        for r in 0..<numberOfRows {
            for c in 0..<numberOfColumns {
                toView.layer.addSublayer(blocks[r][c].layer)
                blocks[r][c].setTypeAndRedraw(typeToSet: Block.type.randomType())
            }
        }
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
}

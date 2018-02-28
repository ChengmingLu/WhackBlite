//
//  Blocks.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-06-04.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
//import CoreGraphics

class Block {
    enum type: UInt32 {
        case WTL
        case WTR
        case WBR
        case WBL
        static let count: type.RawValue = {
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
    
    var screenScale: CGRect
    var layer: CALayer
    var blockType: type
    var cornerRadiusSetting: CGFloat = 0
    var size: CGFloat
    private var canRotate: Bool //used only for rotation interval control, not by other class
    var shapeLayer: CAShapeLayer
    var ballAccessCount: Int
    let xIndex: Int
    let yIndex: Int

    init(initRect: CGRect, typeOfBlock: type, x: Int, y: Int) {
        ballAccessCount = 0
        screenScale = UIScreen.main.bounds
        layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = cornerRadiusSetting
        layer.frame = initRect
        layer.masksToBounds = true
        blockType = typeOfBlock
        size = initRect.size.width
        canRotate = true
        xIndex = x
        yIndex = y
        shapeLayer = CAShapeLayer()
        layer.addSublayer(shapeLayer)
    }
    
    //this function is only used by Grid for initialization since it has no animation
    func setTypeAndRedraw(typeToSet: type) {
        blockType = typeToSet
        let TLPoint: CGPoint = layer.bounds.origin
        let BRPoint: CGPoint = CGPoint(x: layer.bounds.origin.x + size, y: layer.bounds.origin.y + size)
        let TRPoint: CGPoint = CGPoint(x: layer.bounds.origin.x + size, y: layer.bounds.origin.y)
        let BLPoint: CGPoint = CGPoint(x: layer.bounds.origin.x, y: layer.bounds.origin.y + size)
        let path: UIBezierPath = UIBezierPath.init()
        
        switch typeToSet {
        case Block.type.WBL:
            path.move(to: TRPoint)
            path.addLine(to: TLPoint)
            path.addLine(to: BRPoint)
            path.addLine(to: TRPoint)
            
        case Block.type.WBR:
            path.move(to: TLPoint)
            path.addLine(to: TRPoint)
            path.addLine(to: BLPoint)
            path.addLine(to: TLPoint)
            
        case Block.type.WTL:
            path.move(to: BRPoint)
            path.addLine(to: BLPoint)
            path.addLine(to: TRPoint)
            path.addLine(to: BRPoint)
        
        case Block.type.WTR:
            path.move(to: BLPoint)
            path.addLine(to: BRPoint)
            path.addLine(to: TLPoint)
            path.addLine(to: BLPoint)
        }
        shapeLayer.removeFromSuperlayer()
        shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.frame.origin = layer.bounds.origin
        layer.addSublayer(shapeLayer)
        
    }
    
    func shrinkBlockAndSurroundings() {
        //layer.transform = CATransform3DMakeScale(0.6, 0.6, 1)
    }
    
    //rotate the block 90 degrees CW and change its type upon completion
    func rotateClockwise90() {
        if canRotate {
            self.blockType = Block.type(rawValue: (self.blockType.rawValue + 1) % type.count)!
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.canRotate = true
            }
            layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
            CATransaction.commit()
        }
        canRotate = false
    }
    
    //this function is used by the grid to rotate its blocks to form a result screen
    func rotateToAndSetType(toType: type) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.blockType = toType
        }
        switch blockType {
        case type.WBL:
            switch toType {
            case type.WBL:
                break
            case type.WBR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(-Double.pi / 2), 0, 0, 1)
            case type.WTL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
            case type.WTR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi), 0, 0, 1)
            }
        case type.WBR:
            switch toType {
            case type.WBL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
            case type.WBR:
                break
            case type.WTL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi), 0, 0, 1)
            case type.WTR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(-Double.pi / 2), 0, 0, 1)
            }
        case type.WTL:
            switch toType {
            case type.WBL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(-Double.pi / 2), 0, 0, 1)
            case type.WBR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi), 0, 0, 1)
            case type.WTL:
                break
            case type.WTR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
            }
        case type.WTR:
            switch toType {
            case type.WBL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi), 0, 0, 1)
            case type.WBR:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(Double.pi / 2), 0, 0, 1)
            case type.WTL:
                layer.transform = CATransform3DRotate(layer.transform, CGFloat(-Double.pi / 2), 0, 0, 1)
            case type.WTR:
                break
            }
        }
        CATransaction.commit()
    }
}

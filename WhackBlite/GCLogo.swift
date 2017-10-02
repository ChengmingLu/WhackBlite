//
//  GCLogo.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-07-29.
//  Copyright © 2017 Fumlar. All rights reserved.
//

import Foundation
import UIKit

class GCLogo: CALayer {
    let squareLengthReference = (UIScreen.main.bounds.size.width - 40) / 4 * sqrt(2)
    var firstCircleLayer = CALayer()
    var secondCircleLayer = Ball.init(initRect: CGRect.zero, ofType: Ball.type.White, toBlock: Block.init(initRect: CGRect.zero, typeOfBlock: Block.type.randomType(), x: 0, y: 0), fromDirection: Ball.direction.randomDirection(), initialScore: 0,  registerObserver: false)
    var thirdCicleLayer = Ball.init(initRect: CGRect.zero, ofType: Ball.type.White, toBlock: Block.init(initRect: CGRect.zero, typeOfBlock: Block.type.randomType(), x: 0, y: 0), fromDirection: Ball.direction.randomDirection(), initialScore: 0,  registerObserver: false)
    var fourthCircleLayer = CALayer()
    override init() {
        super.init()
        self.frame = CGRect.init(x: 0, y: 0, width: squareLengthReference, height: squareLengthReference)
        
        firstCircleLayer.frame = CGRect.init(x: 0 + 0.1 * squareLengthReference, y: 0 + 0.1 * squareLengthReference, width: squareLengthReference / 1.7, height: squareLengthReference / 1.7)
        firstCircleLayer.backgroundColor = UIColor.black.cgColor
        firstCircleLayer.cornerRadius = squareLengthReference / 3.4
        firstCircleLayer.masksToBounds = true
        
        //secondCircleLayer.layer.frame = CGRect.init(x: squareLengthReference / 2, y: 0, width: squareLengthReference / 2, height: squareLengthReference / 2)
        //secondCircleLayer.backgroundColor = UIColor.white.cgColor
        //secondCircleLayer.cornerRadius = squareLengthReference / 4
        //secondCircleLayer.masksToBounds = true
        secondCircleLayer = Ball.init(initRect: CGRect.init(x: squareLengthReference / 2, y: 0 + 0.1 * squareLengthReference, width: squareLengthReference / 2.5, height: squareLengthReference / 2.5), ofType: Ball.type.White, toBlock: Block.init(initRect: .zero, typeOfBlock: Block.type.randomType(), x: 0, y: 0), fromDirection: Ball.direction.randomDirection(), initialScore: 0, registerObserver: false)
        
        //thirdCicleLayer.frame = CGRect.init(x: 0, y: squareLengthReference / 2, width: squareLengthReference / 2, height: squareLengthReference / 2)
        //thirdCicleLayer.backgroundColor = UIColor.white.cgColor
        //thirdCicleLayer.cornerRadius = squareLengthReference / 4
        //thirdCicleLayer.masksToBounds = true
        thirdCicleLayer = Ball.init(initRect: CGRect.init(x: 0 + 0.25 * squareLengthReference, y: squareLengthReference / 2, width: squareLengthReference / 2.8, height: squareLengthReference / 2.8), ofType: Ball.type.White, toBlock: Block.init(initRect: .zero, typeOfBlock: Block.type.randomType(), x: 0, y: 0), fromDirection: Ball.direction.randomDirection(), initialScore: 0, registerObserver: false)
        
        fourthCircleLayer.frame = CGRect.init(x: squareLengthReference / 2 - 0.05 * squareLengthReference, y: squareLengthReference / 2 - 0.1 * squareLengthReference, width: squareLengthReference / 2.3, height: squareLengthReference / 2.3)
        fourthCircleLayer.backgroundColor = UIColor.black.cgColor
        fourthCircleLayer.cornerRadius = squareLengthReference / 4.6
        fourthCircleLayer.masksToBounds = true
        
        
        secondCircleLayer.addLayersToLayer(toLayer: self, addScore: false)
        thirdCicleLayer.addLayersToLayer(toLayer: self, addScore: false)
        self.addSublayer(firstCircleLayer)
        self.addSublayer(fourthCircleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

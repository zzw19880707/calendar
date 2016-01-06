//
//  TopBgView.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/27.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//  顶部裁剪的背景图

import UIKit

class TopBgView: UIView {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.draw()
    }
    
    
    func draw() {
        let finalSize = self.bounds.size
        let layerHeight = 25.0 as CGFloat
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.moveToPoint(CGPointMake(0, finalSize.height - layerHeight))
        bezier.addLineToPoint(CGPointMake(0, finalSize.height ))
        bezier.addLineToPoint(CGPointMake(finalSize.width, finalSize.height ))
        bezier.addLineToPoint(CGPointMake(finalSize.width, finalSize.height - layerHeight))
        bezier.addQuadCurveToPoint(CGPointMake(0,finalSize.height - layerHeight),
            controlPoint: CGPointMake(finalSize.width / 2, (finalSize.height - layerHeight) - 30))
        layer.path = bezier.CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        self.layer.insertSublayer(layer, atIndex: 0)
    }

}

//
//  BucketView.swift
//  drag
//
//  Created by cnsyl066 on 16/4/21.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class BucketView: UIView {

    var bodyView = UIImageView(image: UIImage(named: "BucketBodyTemplate"))
    var headerView = UIImageView(image: UIImage(named: "BucketLidTemplate"))

    var viewWidth : CGFloat = 0
    init(x : CGFloat , y : CGFloat , width : CGFloat) {
        super.init(frame : CGRect (x: x , y: y , width: width, height: width))
        viewWidth = width
        self.layer.cornerRadius = width / 2
        self.layer.masksToBounds = true
        bodyView.frame = CGRect(x: width / 2 - width * 18 / 100, y: width * 0.3, width: width * 36 / 100 , height: width / 2 )
        self.addSubview(bodyView)
        headerView.frame = CGRect(x: width / 2 - width * 18 / 100 , y: width * 0.3 - width * 8 / 100 , width: width * 36 / 100, height: width * 8 / 100)
        self.setViewFixedAnchorPoint(CGPoint(x :0 , y :1), view: headerView)
        self.addSubview(headerView)
    }
    
    
    func setViewFixedAnchorPoint(anchorPoint : CGPoint , view : UIView) -> Void {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
        var  oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
        
        var position = view.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var viewScale : CGFloat = 1.0
    var viewMoveX : CGFloat = 1.0
    var viewRotation : CGFloat = 0
//    回复到原状
    func recovery() -> Void {
        viewScale = 1
        self.transform = CGAffineTransformMakeScale( 1 , 1 );
        viewRotation = 0 
        headerView.transform = CGAffineTransformMakeRotation(0)
        endShake(bodyView.layer)
    }
    
    func startToMove(realityExtent realityExtent : CGFloat , maxExtent :CGFloat) -> Void {
        
//        整体缩放
        let scale = 0.9 * maxExtent - realityExtent
        if scale > 0  && viewScale <= 1.5 {
            if viewScale <= 1.4 {
                benginShake(bodyView.layer)

                viewScale += 0.1
            }else {
                viewScale = 1.5

            }
            self.transform = CGAffineTransformMakeScale( viewScale , viewScale );
            
        }
        else if scale < 0 && viewScale >= 1.0{
            if viewScale >= 1.1  {
                viewScale -= 0.1
            }else {
                viewScale = 1
                endShake(bodyView.layer)

            }
            self.transform = CGAffineTransformMakeScale( viewScale , viewScale );
        }
        

//        桶盖旋转
        let rotation = 0.6 * maxExtent - realityExtent
        let angle =  -CGFloat(M_PI_2) * 0.6
        if rotation > 0  && viewRotation >= angle{
            if viewRotation >= angle * 0.95  {
                viewRotation += angle * 0.05
            }else {
                viewRotation = angle
            }
            headerView.transform = CGAffineTransformMakeRotation(viewRotation)
        }
        else if rotation < 0  && viewRotation <= 0{
            if viewRotation <= angle * 0.05 {
                viewRotation -=  angle * 0.05
            }else {
                viewRotation = 0
            }
            headerView.transform = CGAffineTransformMakeRotation(viewRotation)

        }
        //超过一半， 则显示全部效果
        if 0.5 * maxExtent - realityExtent  > 0 {
            viewScale = 1.5
            self.transform = CGAffineTransformMakeScale( viewScale , viewScale );
            viewRotation = angle
            headerView.transform = CGAffineTransformMakeRotation(viewRotation)
        }
    }
    func benginShake( layer : CALayer){
        //            抖动动画
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "transform.rotation.z"
        shakeAnimation.values = [ -0.15 ,0.15]
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount =   Float(INT32_MAX)
        guard let _ = layer.animationKeys()?.contains("shake") else {
            layer.addAnimation(shakeAnimation, forKey: "shake")
            return
        }
        
    }
    func endShake(layer : CALayer) {
        layer.removeAnimationForKey("shake")
    }

}

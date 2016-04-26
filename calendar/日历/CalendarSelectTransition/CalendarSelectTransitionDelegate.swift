//
//  CalendarSelectTransitionDelegate.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/8.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarSelectTransitionDelegate:NSObject ,  UIViewControllerAnimatedTransitioning {

    let isPresenting :Bool
    let duration :NSTimeInterval = 0.75
    
    
    let height : CGFloat = {
        //        获取当前key的个数
        let arr = CalendarData.getAllKeys()
        var height :CGFloat = 0
        if  let array = arr {
            height += CGFloat( array.count * 55) + 40  + 20 * CGFloat(array.count) + 120
        }
        return height
    }()
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
        
        //      config
        _displayLink = CADisplayLink(target: self, selector: #selector(showLayer))
        _displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        _displayLink.paused = true
        
        
        let arr = CalendarData.getAllKeys()
        var height :CGFloat = 0
        if  let array = arr {
            height += CGFloat( array.count * 55) + 40
            if isPresenting {
                curveY =  min(20 * CGFloat(array.count) + 120 , 180 )
            }else{
                curveY =  20 * CGFloat(array.count) + 120
            }
        }
        
        
        _curveView.frame = CGRect(x: SRC_WINDOW_WIDTH / 2 - 3  , y: 50 , width: 6, height: 6)
//        _curveView.backgroundColor = UIColor.yellowColor()
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return duration
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }else {
            animateDismissalWithTransitionContext(transitionContext)
            
        }
    }
    
    // ---- Helper methods
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()!
        
        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
        
        containerView.addSubview(presentedControllerView)
        
        presentedControllerView.center.y += self.height

        
        presentedControllerView.addSubview(_curveView)
        presentedControllerView.layer.addSublayer(_shapeLayer)
        
        
        _curveView.frame = CGRect(x: SRC_WINDOW_WIDTH / 2 - 3  , y: 50 , width: 6, height: 6)

        self._displayLink.paused = false
        
        UIView.animateWithDuration(self.duration / 2, delay: self.duration / 3 , options: .CurveEaseOut, animations: {
            self._curveView.frame.origin.y = self.curveY
        }) { (finish) in
            if finish {
                UIView.animateWithDuration(self.duration * 2   , delay: 0 , usingSpringWithDamping:0.3, initialSpringVelocity: 0, options: .CurveEaseIn , animations: {
                    
                    self._curveView.frame.origin.y = -1
                }) { (finished) in
                    if finished {
                        self._displayLink.paused = true
                    }
                }
            }
            
        }
        
        // Animate the presented view to it's final position
        UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            presentedControllerView.center.y -= self.height
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()!
        containerView.addSubview(presentedControllerView)

        presentedControllerView.addSubview(_curveView)
        presentedControllerView.layer.addSublayer(_shapeLayer)
        
        _curveView.frame = CGRect(x: SRC_WINDOW_WIDTH / 2 - 3  , y: -3 , width: 6, height: 6)
        _displayLink.paused = false
        UIView.animateWithDuration(self.duration  , delay: 0 , options: .CurveEaseOut, animations: {
            self._curveView.frame.origin.y =  -self.curveY * 3 / 5
        }) { (finish) in
            if finish {
                self._displayLink.paused = true
            }
        }
        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            presentedControllerView.center.y += self.height
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }

    
    
    let SRC_WINDOW_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SRC_WINDOW_HEIGHT = UIScreen.mainScreen().bounds.size.height
    var _displayLink =  CADisplayLink()
    var _curveView = UIView()
    var _shapeLayer :CAShapeLayer = {
            var  shaperLayer = CAShapeLayer()
            shaperLayer.fillColor = UIColor.whiteColor().CGColor
            return shaperLayer
        }()

    
    func showLayer() -> Void {
        let layer = _curveView.layer.presentationLayer()
        curveY = layer!.position.y
        if  abs(curveY) > 0.05  {
            self.updateShapeLayerPath()
        }
    }
    
    
    
    var curveY :CGFloat = 0
    func updateShapeLayerPath() -> Void {
        let bezierPath = UIBezierPath()
        
        bezierPath.moveToPoint(CGPoint(x: 0, y: -90))
        bezierPath.addQuadCurveToPoint(CGPoint(x: SRC_WINDOW_WIDTH ,y: 0  - 90) , controlPoint: CGPoint(x: SRC_WINDOW_WIDTH / 2, y: curveY - 90))
        
        bezierPath.addLineToPoint(CGPoint(x: SRC_WINDOW_WIDTH, y: 0 ))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.closePath()
        
        _shapeLayer.path = bezierPath.CGPath
        _shapeLayer.fillColor = UIColor.whiteColor().CGColor
//        _shapeLayer.strokeColor = UIColor.redColor().CGColor
    }
    
    
    
}

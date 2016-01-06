//
//  MoviewDetailAnimatedTransitioning.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/12.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
public class MovieDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 1

    
    var center : CGPoint
    
    init(center : CGPoint ) {
        self.center = center
        super.init()
    }

    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return self.duration
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
//        containerView.addSubview(toView)
        toView.alpha = 0
        let view = fromView.snapshotViewAfterScreenUpdates(false)
        view.frame = containerView.frame
        containerView.addSubview(view)
        
        view.addSubview(toView)
        view.animateCircularWithDuration(self.duration, center: center , animations: { () -> Void in
            toView.alpha = 1

            }) { (finished :Bool) -> Void in
                if finished {
                    view.removeFromSuperview()
                    containerView.addSubview(toView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
        }

    }
    
    public func animationEnded(transitionCompleted: Bool){
        
    }

    
}
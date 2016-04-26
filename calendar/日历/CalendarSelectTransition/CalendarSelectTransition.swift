//
//  CalendarSelectTransition.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/6.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarSelectTransition: UIPresentationController {
    
    
    override func presentationTransitionWillBegin(){
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
//        blurView.frame = self.containerView!.frame
        blurView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//        blurView.backgroundColor = UIColor.redColor()
        
        
        let contentView = UIVisualEffectView()
        contentView.effect = UIBlurEffect(style: .Light)
        contentView.frame =  self.containerView!.bounds
        contentView.alpha = 0.4
        self.containerView!.addSubview(contentView)
        self.containerView!.addGestureRecognizer(tapG)
        

    }
    
    override func presentationTransitionDidEnd(completed: Bool){
        
    }
    override func dismissalTransitionWillBegin() {
        
    }
    override func dismissalTransitionDidEnd(completed: Bool){
        
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        let windowH = UIScreen.mainScreen().bounds.size.height
        let windowW = UIScreen.mainScreen().bounds.size.width
        let arr = CalendarData.getAllKeys()
        self.presentedView()?.backgroundColor = UIColor.whiteColor()

        var height :CGFloat = 0
        if  let array = arr {
            height += CGFloat( array.count * 55) + 40
        }
        
        self.presentedView()?.frame = CGRect(x: 0, y: windowH - height , width: windowW, height: height)

    }
    
    //MARK : - Action 
    func tapAction() -> Void {
        self.presentingViewController .dismissViewControllerAnimated(true, completion: nil)
    }
}

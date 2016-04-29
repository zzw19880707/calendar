//
//  CalendarListPresentationController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/26.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarListPresentationController: UIPresentationController {

    
    
    override func presentationTransitionWillBegin(){
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
        //半模糊背景
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
        self.presentedView()?.backgroundColor = UIColor.clearColor()
        

        self.presentedView()?.frame = CGRect(x: 0, y: windowH - listViewHeight , width: windowW, height: listViewHeight)
    }
    
    //MARK : - Action
    func tapAction() -> Void {
        self.presentingViewController .dismissViewControllerAnimated(true, completion: nil)
    }
}

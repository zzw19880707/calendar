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
        
        

        //半模糊背景
        let contentView = UIVisualEffectView()
        contentView.effect = UIBlurEffect(style: .Dark)
        contentView.frame =  self.containerView!.bounds
        contentView.alpha = 0.4
        self.containerView!.addSubview(contentView)
        
        let view = UIView()
        view.frame = CGRect(origin: self.containerView!.bounds.origin, size: CGSize(width: UIScreen.mainScreen().bounds.size.width , height:UIScreen.mainScreen().bounds.size.height - listViewHeight ))
        self.containerView!.addSubview(view)
        view.addGestureRecognizer(tapG)
        
        
        
    }
    
    override func presentationTransitionDidEnd(completed: Bool){
        
    }
    override func dismissalTransitionWillBegin() {
        for view  in self.containerView!.subviews {
            view.removeFromSuperview()
        }
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

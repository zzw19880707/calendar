//
//  CalendarPopViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/8.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarPopViewController: CalendarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgView = UIImageView(image: UIImage(named: "calendar_bg"))
        imgView.frame = self.view.bounds
        self.view.addSubview(imgView)
        self.view.sendSubviewToBack(imgView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon_Settings") , style: .Done , target: self, action:  #selector(itemAction))
        
        self.navigationItem.rightBarButtonItem = nil
        if self.key == UD_DATA {
            self.title = "我"
        }else{
            self.title = self.key
        }
        
    }

    func itemAction() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
//
//extension CalendarPopViewController : UIViewControllerTransitioningDelegate {
//    override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
//        return nil
//    }
//    
//    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//        return nil
//    }
//    
//    override func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//        return CalendarPopTransitionDelegate(isPresenting: true)
//    }
//    
//}
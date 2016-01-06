//
//  SettingNavViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/5.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class SettingNavViewController: UINavigationController,UIViewControllerTransitioningDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(17),NSForegroundColorAttributeName : UIColor.blackColor()]
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return SettingDataPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return SettingDataPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return SettingDataPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CalendarSelectViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/7.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarSelectViewController: UIViewController {

    
    let height : CGFloat = {
        //        获取当前key的个数
        let arr = CalendarData.getAllKeys()
        var height :CGFloat = 0
        if  let array = arr {
            height += CGFloat( array.count * 55) + 40
        }
        return height
    }()
    
    var dataKey = UD_DATA
    override func viewDidLoad() {
        super.viewDidLoad()
        let windowW = UIScreen.mainScreen().bounds.size.width

//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: windowW, height: 50)
//        self.view.addSubview(view)
        
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: height - 30 , width: windowW, height: 30)
        label.text = "请选择需要查看的日历，支持3D-Touch预览"
        label.textAlignment = .Center
        self.view.addSubview(label)
        
        let arr = CalendarData.getAllKeys()
//        依次添加按钮
        if  let array = arr {
            for (index ,key) in array.enumerate() {
                let btn = ProfileButton()
                
                btn.frame = CGRect(x: 40 , y: (height - 40 - 45 * CGFloat(index + 1 )) , width:windowW - 40 * 2 , height: 35)
                if  key == UD_DATA {
                    btn.setTitle("我", forState: .Normal)
                }else {
                    btn.setTitle(key, forState: .Normal)
                }
                btn.layer.cornerRadius = 35 / 2
                btn.layer.borderColor = UIColor.yellowColor().CGColor
                btn.layer.borderWidth = 1
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: .TouchUpInside)
                self.view.addSubview(btn)
                if traitCollection.forceTouchCapability == .Available {
                    self.registerForPreviewingWithDelegate(self, sourceView: btn)
                }
            }
        }
        
        
        
    }
    
    // MARK : - Action
    func btnClick(btn : ProfileButton) -> Void {
        
        
        btn.animateTouchUpInside{
            let key = btn.currentTitle
            if key == "我" {
            } else {
                self.dataKey = key!
            }
            let vc = CalendarPopViewController()
            vc.key = self.dataKey
            let nav = UINavigationController(rootViewController: vc)
            nav.transitioningDelegate = self
            nav.modalPresentationStyle = .Custom
            
            self.presentViewController(nav, animated: true, completion: nil)
            

        }

    }

    
}
extension CalendarSelectViewController : UIViewControllerTransitioningDelegate{
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return SettingDataPresentationAnimationController(isPresenting: false)
    }
}

extension CalendarSelectViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?{
        let btn = previewingContext.sourceView as! UIButton
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarPeekViewController") as! CalendarPeekViewController
        let key = btn.currentTitle
        if key == "我" {
            
        } else {
            dataKey = key!
        }
        vc.key = dataKey
        return vc
        
    }
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController){
        let vc = CalendarPopViewController()
        vc.key = dataKey

        let nav = UINavigationController(rootViewController: vc)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .Custom

        self.presentViewController(nav, animated: true, completion: nil)
    }
}
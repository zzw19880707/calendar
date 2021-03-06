//
//  MainViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/9/30.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
class MainViewController: UIViewController,UIScrollViewDelegate {
    
    ///底层的背景滚动视图
    @IBOutlet weak var bgScrollView: UIScrollView!
    ///左侧菜单视图
    @IBOutlet weak var menuView: UIView!
    
    
    @IBOutlet weak var containerView:UIView!
    
    var currentItem : menuItem = menuItem(name: "首页", imageName: "menu", color: UIColor.redColor(), index: 0){
        
        didSet{
            let index = currentItem.index
            transitionWithViewController(viewControllersArr[index])
            bgScrollView.subviews[0].backgroundColor = currentItem.color

            
            hideOrShowMenu(false, animated: true )
        }
    }

    var menuTableViewController : MenuTableViewController?
    
    ///是一个UINavigationController容器,能切换视图
    var contentViewController: UINavigationController?
    

    var showingMenu = false
    
    
    var viewControllersArr : Array< BaseViewController> = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        bgScrollView.decelerationRate = 0
    }

    ///初始化对应的各个视图
    func initViewController() {
        var nameArr = Array.init(count: 4, repeatedValue: "BaseViewController")
        nameArr[0] = "CalendarViewController"
        nameArr[1] = "WeatherViewController"
        nameArr[2] = "SportViewController"
        let baseNavigation = storyboard?.instantiateViewControllerWithIdentifier("Detail") as! UINavigationController
        let detailStoryboard = baseNavigation.topViewController?.storyboard
        for index in 0...3 {
            let identifier = nameArr[index]
            let viewcontroller = detailStoryboard?.instantiateViewControllerWithIdentifier(identifier) as! BaseViewController
            viewControllersArr.append(viewcontroller)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDeafults = NSUserDefaults.standardUserDefaults()
        
        if let data = userDeafults.valueForKey("UD_DATA") {
            print(data)
        } else{
            presentSettingDataViewController()
       }
    }
//    设置页面
    func presentSettingDataViewController(){
//        let settingStoryBoard = UIStoryboard(name: "SettingData", bundle: nil)
//        
//        let settingVC = settingStoryBoard.instantiateViewControllerWithIdentifier("SettingNavViewController")
//        presentViewController(settingVC, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarAddViewController") as! UINavigationController
        let v = vc.viewControllers[0] as! CalendarAddViewController
        //跟key 有顺序，先设置是否是编辑，在设置key
        v.isAddVC = false
        v.key = UD_DATA
        
        self.presentViewController(vc, animated: true, completion: nil)


    }
    
    @IBAction func dissmiss(unwindSegue: UIStoryboardSegue){
        let currentVC = contentViewController?.viewControllers[0] as! BaseViewController
        currentVC.needReloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        hideOrShowMenu(showingMenu, animated: false )
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//    不自动转屏
    override func shouldAutorotate() -> Bool {
        return false
    }
    // MARK : - Animate
    func transformForFraction(fraction:CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0;
        let angle = Double(1.0 - fraction) * -M_PI_2
        let xOffset = CGRectGetWidth(menuView.bounds) * 0.5
        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
        let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
        return CATransform3DConcat(rotateTransform, translateTransform)
    }
    
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {

        ///根据偏移量 做动画效果
        let multiplier = 1.0 / CGRectGetWidth(menuView.bounds)
        let offset = scrollView.contentOffset.x * multiplier
        let fraction = 1.0 - offset

        menuView.layer.transform = transformForFraction(fraction)
        menuView.alpha = fraction
        
        ///根据偏移量 做菜单按钮动画效果
        if let contentViewController = contentViewController {
            if let rotatingView = (contentViewController.topViewController as! BaseViewController).hamburgerView {
                rotatingView.rotate(fraction)
            }
        }
//        scrollView.pagingEnabled = true
//        scrollView.pagingEnabled = scrollView.contentOffset.x  < (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))
        let menuOffset = CGRectGetWidth(menuView.bounds)
        showingMenu = !CGPointEqualToPoint(CGPoint(x: menuOffset, y: 0), scrollView.contentOffset)
       
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            zzw_scrollViewDidEndDecelerating(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        zzw_scrollViewDidEndDecelerating(scrollView)
    }
    
    func zzw_scrollViewDidEndDecelerating(scrollView: UIScrollView) -> Void{
        let contentOff_X = scrollView.contentOffset.x
        if contentOff_X < 3  {
            self.hideOrShowMenu(true, animated: true)
        }else if contentOff_X >= 3 && contentOff_X < 80 {
            var index = currentItem.index
            if index == 4{
                index = 0
            }else {
                index += 1
            }
            menuTableViewController?.showController(index)
        }else {
            self.hideOrShowMenu(false , animated: true)
        }
    }
    
    
    // MARK: - Method
    
    // MARK: ContainerViewController
    func hideOrShowMenu(show: Bool, animated: Bool ) {
        let menuOffset = CGRectGetWidth(menuView.bounds)
        bgScrollView.setContentOffset(show ? CGPointZero : CGPoint(x: menuOffset, y: 0), animated: animated)
    // 设置是否显示菜单
        showingMenu = show
    }
    // MARK: - Navigationbefore navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailViewSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            contentViewController = navigationController
            //插入首页视图
            let rootVC = navigationController.topViewController as! BaseViewController
            rootVC.title = "首页"
            rootVC.view.backgroundColor = currentItem.color
            bgScrollView.subviews[0].backgroundColor = currentItem.color
            viewControllersArr.insert(rootVC, atIndex: 0)
        } else if segue.identifier == "MenuViewSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            menuTableViewController = navigationController.topViewController as? MenuTableViewController
        }
    }

    
    
    /// 根据标示符切换视图
    func transitionWithViewController(viewController:BaseViewController){
        
        viewController.title = currentItem.name
        viewController.view.backgroundColor = currentItem.color
        
        contentViewController?.viewControllers = [viewController]
    
    }
    

}

//
//  BaseViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/29.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var hamburgerView: HamburgerView?
    var hamburgerViewNeedVertical = false
    
    ///抽象类，需要重新刷新数据
    func needReloadData() -> Void {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加一个按钮
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hamburgerViewTapped))
        hamburgerView = HamburgerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hamburgerView!.addGestureRecognizer(tapGestureRecognizer)
        if hamburgerViewNeedVertical {
            hamburgerView?.rotate(1)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hamburgerView!)

        
        //设置透明导航栏
        navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

    }
    
    // MARK: - Action
    ///给菜单按钮添加关闭左侧菜单的事件
    func hamburgerViewTapped() {
        let mainViewController = self.navigationController?.parentViewController as! MainViewController
        mainViewController.hideOrShowMenu(!mainViewController.showingMenu, animated: true )
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(NSStringFromClass(self.classForCoder))
        MobClick.beginLogPageView(NSStringFromClass(self.classForCoder))
    }
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView
//    {
//    UIColor * color =  DEF_COLOR_SS_BACKGROUND;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//    CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
//    
//    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    } else {
//    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
//    }
//    }
}


    // MARK: - Action
extension BaseViewController {
    func alertMessage(string : String ){
        let alertController = UIAlertController.init(title: "提示", message: string, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        
    }

}


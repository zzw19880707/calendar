//
//  MovieDetailTableViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/12.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
import MJRefresh

class MovieDetailTableViewController: UITableViewController {
    @IBOutlet weak var imgView: UIImageView!
    ///标签
    @IBOutlet weak var tagsLabel: UILabel!
    ///产地
    @IBOutlet weak var nationLabel: UILabel!
    ///2D&&3D
    @IBOutlet weak var typeLabel: UILabel!
    ///时长
    @IBOutlet weak var lengthLabel: UILabel!
    ///上映日期
    @IBOutlet weak var releaseDateLaebl: UILabel!
    ///导演
    @IBOutlet weak var directorLabel: UILabel!
    ///主演
    @IBOutlet weak var starringLabel: UILabel!
    
    var data : HomePageTopData?{
        didSet {
            let bgView = UIImageView(frame: self.view.bounds)
            bgView.sd_setImageWithURL(NSURL(string: (data?.picture)!))
            
            let effeView = UIVisualEffectView(effect: UIBlurEffect.init(style: .Light) )
            effeView.frame = self.view.bounds
            
            let backgroundView = UIView(frame: self.view.bounds)
            backgroundView.addSubview(bgView)
            backgroundView.addSubview(effeView)
            backgroundView.backgroundColor = UIColor.redColor()
            self.tableView.backgroundView = backgroundView
            
            self.title = data?.name
            self.tagsLabel.text = data?.tags
            self.nationLabel.text = data?.nation
            self.typeLabel.text = data?.type
            self.lengthLabel.text = data?.length
            self.releaseDateLaebl.text = data?.releaseDate
            self.directorLabel.text = data?.director
            self.starringLabel.text = data?.starring
            imgView.sd_setImageWithURL(NSURL(string: (data?.picture)!))

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let mj = FJJRefreshFooter { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        mj.setTitle("上拉关闭当前页", forState: MJRefreshState.Idle)
        mj.setTitle("释放关闭当前页", forState: MJRefreshState.Pulling)
        
        self.tableView.mj_footer = mj
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17),NSForegroundColorAttributeName : UIColor.blackColor()]
    }
    
}


extension MovieDetailTableViewController {

}
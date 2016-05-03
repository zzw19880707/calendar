//
//  MenuTableViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/9/30.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
struct menuItem {
    var name : String
    var imageName : String
    var color : UIColor
    var index : Int
}
class MenuTableViewController: UITableViewController {
    
    
    var dataArr : [menuItem] = [
        menuItem(name: "首页", imageName: "menu", color: UIColor.redColor(), index: 0),
        menuItem(name: "日历", imageName: "menu", color: UIColor.yellowColor(), index: 1),
        menuItem(name: "天气", imageName: "menu", color: UIColor.blueColor(), index: 2),
        menuItem(name: "运动", imageName: "menu", color: UIColor.greenColor(), index: 3),
//        menuItem(name: "aaxx", imageName: "menu", color: UIColor.cyanColor(), index: 4),
//        menuItem(name: "aaxx", imageName: "menu", color: UIColor.orangeColor(), index: 5),
        menuItem(name: "设置", imageName: "menu", color: UIColor.brownColor(), index: 4),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.barTintColor = dataArr[0].color

        
        let height = ( UIScreen.mainScreen().bounds.size.height - 64 ) / CGFloat(dataArr.count)
        tableView.rowHeight = height
        tableView.estimatedRowHeight = height
        tableView.separatorStyle = .None
        view.backgroundColor = UIColor.redColor()
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)

        cell.textLabel!.text = dataArr[indexPath.row].name
        cell.backgroundColor = dataArr[indexPath.row].color
        cell.selectionStyle = .None
        
        return cell
    }
    // Mark: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        showController(indexPath.row)
    }
    
    func showController(index : NSInteger){
        let menuItem = dataArr[index]
        let mainVC = navigationController!.parentViewController as! MainViewController
        mainVC.currentItem = menuItem

        navigationController?.navigationBar.barTintColor = menuItem.color
    }
    

}

//
//  SettingDataViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/21.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class SettingDataViewController: UIViewController {

    
    var data = ["type":["白","白","白","夜","下","休"],"date": NSDate()]

    // MARK: - Action
    @IBAction func datePickerValueChange(sender: UIDatePicker) {
        data["date"] = sender.date
        print(data)
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingSort" {
            let settingDataVC = segue.destinationViewController as! SettingSortCollectionViewController
            settingDataVC.dataArr = data["type"] as! Array<String>
            
        } else  if segue.identifier == "showDetail" {
            let detailVC = segue.destinationViewController as! SettingDetailViewController
            detailVC.dataArr = data["type"] as! Array<String>
        }

    }
    
    

}

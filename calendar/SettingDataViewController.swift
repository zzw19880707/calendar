//
//  SettingDataViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/21.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class SettingDataViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker! 
    
    var date : NSDate{
        get {
            return CalendarData.getDate()
        }
        set {
            CalendarData.setDataByDate(newValue)
        }
    }
    //转场时初始化
    var collectionView : SettingSortCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = date
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        
    }
    // MARK: - Action
    @IBAction func datePickerValueChange(sender: UIDatePicker) {
        date = sender.date
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingSort" {
            collectionView = ( segue.destinationViewController as! UICollectionViewController ).collectionView as? SettingSortCollectionView
        }

    }
}

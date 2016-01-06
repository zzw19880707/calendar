//
//  CalendarViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/4.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit



class CalendarViewController: BaseViewController {
    
    var calendarView : FSCalendar?
    let tableView = UITableView()
    var tableData = [String]()
    @IBOutlet weak var headerView: FSCalendarHeader!
    
    let appWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    ///用于存放没个班次的类型
    var types : [String] = []{
        didSet{
//            移除所有视图
//            for view in topBgView.subviews {
//                view.removeFromSuperview()
//            }
            
//            for (index,value) in types.enumerate() {
//
//                let w = CGFloat(index) * appWidth
//                let count = CGFloat(types.count)
//                let label = UILabel(frame: CGRect(x: w / count, y: 0 , width: appWidth / count, height: topBgView.frame.size.height ) )
//                label.text = value
//                label.textAlignment = .Center
//                topBgView.addSubview(label)
//            }
            
        }
    }
    ///存放初始日期
    var beginDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightBtn .setImage(UIImage.init(named: "Icon_Settings"), forState: .Normal )
        rightBtn.addTarget(self, action: Selector("showSettingDataViewController"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
//        初始化表视图。用于显示底部信息
        initTableView()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDeafults = NSUserDefaults.standardUserDefaults() 
        
        if let data = userDeafults.valueForKey(UD_DATA) as? [String:AnyObject] {
            if let type = data["newType"] as? [String] {
                beginDate = data["date"] as? NSDate
                if type != types {
                    types = type
                    self.initCalendarView()
                }
            }else{
                showSettingDataViewController()
            }
        }else {
            showSettingDataViewController()
        }
    }
    
    // MARK: - Action
    func showSettingDataViewController() {
        let mainVC = navigationController?.parentViewController as! MainViewController
        mainVC.presentSettingDataViewController()
    }
    
    
    
}

extension CalendarViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if #available(iOS 8.0 , *){
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
        }
        cell.separatorInset = UIEdgeInsetsZero
    }
    
}

extension CalendarViewController : UITableViewDataSource  {

    func initTableView() {
        self.updateTableData(NSDate())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 384, width: self.view.frame.size.width, height: self.view.frame.size.height - 384)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.separatorInset = UIEdgeInsetsZero
//        guard只有满足条件下才进行下一步 不满足则直接跳出程序
//        if self.respondsToSelector(<#T##aSelector: Selector##Selector#>)
//        if #available(iOS 8.0 , * ) {
//            
//        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = tableData[indexPath.row]
        cell?.selectionStyle = .None
        return cell!
    }
}

extension CalendarViewController : FSCalendarDataSource {
    
    func initCalendarView() {
        if let _ = calendarView {
            calendarView!.removeFromSuperview()
        }

        calendarView = FSCalendar(frame: CGRect(x: 0, y: 104, width: self.view.frame.size.width, height: 280), rowNum: types.count , beginDate: beginDate!)
        self.view.addSubview(calendarView!)
        calendarView?.header = headerView
        calendarView?.weekSymbols = types
        calendarView?.flow = .Vertical
        calendarView?.dataSource = self
        calendarView?.delegate = self
        
    }
    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
        return SSLunarDate.init(date: date).dayString()
    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        //        农历信息
        let lunarMonth = SSLunarDate.init(date: date).monthString()
        let lunarDay = SSLunarDate.init(date: date).dayString()
        //        获取节日信息
        let lunarCalendar = LunarCalendar.getChineseHoliday(lunarMonth, day: lunarDay)
        if lunarCalendar != "无" {
            return true
        }
        //        获取世界节日
        let worldHoliday = LunarCalendar.getWorldHoliday(date)
        if worldHoliday != "无" {
            return true
        }
        return false
    }
//    更新表格信息
    func updateTableData(date : NSDate!){
        tableData = [String]()
//        天干地支 年的信息
        let dateFormate = NSDateFormatter()
        dateFormate.dateFormat = "yyyy"
        let year = dateFormate.stringFromDate(date) as NSString
        tableData.append(LunarCalendar.getYear(year.integerValue))
//        农历信息
        let lunarMonth = SSLunarDate.init(date: date).monthString()
        let lunarDay = SSLunarDate.init(date: date).dayString()
//        星座
        let constellation = LunarCalendar.Constellation(date)
//        第几周
        let calendar = NSCalendar.currentCalendar()
        let com = calendar.components(NSCalendarUnit.WeekOfYear, fromDate: date)
        let week = String("第" + String(com.weekOfYear)  + "周")
        tableData.append(week + "  " + constellation )
        
//        获取节日信息
        let lunarCalendar = LunarCalendar.getChineseHoliday(lunarMonth, day: lunarDay)
        if lunarCalendar != "无" {
            //        获取农历信息
            let firstStr = String("农历" + lunarMonth + " " + lunarDay + " " + lunarCalendar )
            tableData.append(firstStr)
        }else {
            let firstStr = String("农历" + lunarMonth + " " + lunarDay )
            tableData.append(firstStr)
        }
        
//        获取世界节日
        let worldHoliday = LunarCalendar.getWorldHoliday(date)
        if worldHoliday != "无" {
            tableData.append(worldHoliday)
        }
    }
}

extension CalendarViewController : FSCalendarDelegate {
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        self.updateTableData(date)
        tableView.reloadData()
        
    }
}

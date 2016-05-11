//
//  CalendarViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/4.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController {
    
    
    var key : String = UD_DATA
    
    var transition : LHCustomModalTransition?
    var calendarView : FSCalendar?
    let tableView = UITableView()
    var tableData = [String]()
    lazy var headerView = FSCalendarHeader(frame: CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.size.width, height: 40 ))
    
    let appWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    ///用于存放每个班次的类型
    var types : [String] = []
    ///存放初始日期
    var beginDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightBtn .setImage(UIImage(named: "Icon_Settings"), forState: .Normal )
        rightBtn.addTarget(self, action: #selector(showSettingDataViewController), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.view.addSubview(headerView)
        //        初始化表视图。用于显示底部信息
        initTableView()

        if self.isMemberOfClass(CalendarViewController.self){
            initMenu()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.needReloadData()
    }
    ///重新刷新数据
    override func needReloadData() {
        let data = CalendarData.getDataByKey(key)
        types = data[calDNewType] as! [String]
        beginDate = data[calDDate] as? NSDate
        self.initCalendarView()
        self.updateTableData(NSDate())
        tableView.reloadData()
    }
    // MARK: - Action
    func showSettingDataViewController() {
//        let mainVC = navigationController?.parentViewController as! MainViewController
//        mainVC.presentSettingDataViewController()
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarAddViewController") as! UINavigationController
        let v = vc.viewControllers[0] as! CalendarAddViewController
        //跟key 有顺序，先设置是否是编辑，在设置key
        v.isAddVC = false
        v.key = UD_DATA
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

extension CalendarViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
//        if #available(iOS 8.0 , *){
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
//        }
        cell.separatorInset = UIEdgeInsetsZero
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !self.isMemberOfClass(CalendarViewController.self){
            if scrollView.contentOffset.y > 45 || scrollView.contentOffset.y < -45 {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

extension CalendarViewController : UITableViewDataSource  {

    func initTableView() {
        self.updateTableData(NSDate())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 104, width: self.view.frame.size.width, height: self.view.frame.size.height - 104)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()

        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell" ,forIndexPath: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}

extension CalendarViewController : FSCalendarDataSource {
    
    func initCalendarView() {
        if let _ = calendarView {
            calendarView!.removeFromSuperview()
        }

        calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 280), rowNum: types.count , beginDate: beginDate!)
        self.view.addSubview(calendarView!)
        self.view.bringSubviewToFront(self.headerView)
        calendarView?.header = headerView
        calendarView?.weekSymbols = types
        calendarView?.flow = .Vertical
        calendarView?.dataSource = self
        calendarView?.delegate = self
        tableView.tableHeaderView = calendarView
        
    }
    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
        return SSLunarDate(date: date).dayString()
    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        //        农历信息
        let lunarMonth = SSLunarDate(date: date).monthString()
        let lunarDay = SSLunarDate(date: date).dayString()
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
        let lunarMonth = SSLunarDate(date: date).monthString()
        let lunarDay = SSLunarDate(date: date).dayString()
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
        
        
        let allKeyArr = CalendarData.getAllKeys()
        for key in allKeyArr! {
            if key == UD_DATA {
                continue
            }
            let type = CalendarData.getTypeByKey(key)
            let date1 = CalendarData.getDateByKey(key)
            
            let index = date.getTodayTypebyCurrentDate(date1, num: type.count)
            tableData.append("\(key) : \(type[index])")
        }

    }
}

extension CalendarViewController : FSCalendarDelegate {
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        self.updateTableData(date)
        tableView.reloadData()
        
    }
}



//弹出的按钮
extension CalendarViewController : MenuDidSelectedDelegate {
    func  initMenu()  {
        let gooeyMenu = KYGooeyMenu(origin: CGPoint(x: self.view.frame.size.width - 10 - 50  , y: self.view.frame.size.height - 120 ), andDiameter: 50 , andDelegate: self, themeColor: UIColor.redColor())
        gooeyMenu.menuDelegate = self;
        gooeyMenu.radius = 50 / 3//大圆的1/4
        gooeyMenu.extraDistance = 30
        gooeyMenu.MenuCount = 2
        gooeyMenu.imgNameArr = ["calendar_sub","calendar_add"]
    }
    
    func menuDidSelected(index: CalendarMenu) {
        print(index.rawValue)
        switch index {
        case .Add :
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CalendarAddViewController")
//            self.transition = LHCustomModalTransition(modalViewController: vc)
//            self.transition?.dragable = true
//            vc!.transitioningDelegate = self.transition
//            vc!.modalPresentationStyle = .Custom
            self.presentViewController(vc!, animated: true, completion: nil)
        case .Look:
            var vc : UIViewController
            if CalendarData.getAllKeys()?.count > 1 {
                vc = (self.storyboard?.instantiateViewControllerWithIdentifier("CalendarListViewController"))!
            }else {
                vc = CalendarSelectViewController()
            }
            vc.modalPresentationStyle = .Custom
            vc.transitioningDelegate = self
            self.presentViewController(vc, animated: true, completion: nil)            
        }
    }
}

extension CalendarViewController : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        if presented.isMemberOfClass(CalendarSelectViewController.classForCoder()) {
            return CalendarSelectTransition(presentedViewController: presented, presentingViewController: presenting)
        }
        return CalendarListPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        if presented.isMemberOfClass(CalendarSelectViewController.classForCoder()) {
            return CalendarSelectTransitionDelegate(isPresenting: true)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        if dismissed.isMemberOfClass(CalendarSelectViewController.classForCoder()) {
            return CalendarSelectTransitionDelegate(isPresenting: false)
        }else if dismissed.isMemberOfClass(CalendarListViewController.classForCoder()){
            self.needReloadData()
        }
        return nil
    }
}

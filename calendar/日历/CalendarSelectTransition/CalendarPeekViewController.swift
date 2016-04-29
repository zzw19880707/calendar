//
//  CalendarPeekViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/8.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarPeekViewController: BaseViewController {

    var calendarView : FSCalendar?
    
    
    var hasDelete : ((key : String) -> Void)?
    
    var hasEdit : ((key : String )-> Void )?
    ///用于存放每个班次的类型
    var types : [String] = []
    ///存放初始日期
    var beginDate : NSDate?

    var data  = [String : AnyObject](){
        didSet {
            types = data[calDNewType] as! [String]
            beginDate = data[calDDate] as? NSDate

        }
    }
    
    var key = UD_DATA {
        didSet {
            self.data = CalendarData.getDataByKey(key)
        }
    }
    
    @IBOutlet weak var headView: FSCalendarHeader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imgView = UIImageView(image: UIImage(named: "calendar_bg"))
        imgView.frame = self.view.bounds
        self.view.addSubview(imgView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initCalendarView()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension CalendarPeekViewController  {
    override func previewActionItems() -> [UIPreviewActionItem] {
        var arr = [UIPreviewActionItem]()
        
        
        
        let editItem = UIPreviewAction(title: "编辑", style: .Default ) { (action, viewController) in
            self.hasEdit?(key: self.key)
        }
        arr.append(editItem)
        
        if key != UD_DATA {
            let deleItem = UIPreviewAction(title: "删除", style: .Destructive ) { (action, viewController) in
                self.hasDelete?(key: self.key)
            }
            arr.append(deleItem)
        }
        return arr
    }
}



extension CalendarPeekViewController : FSCalendarDataSource {
    
    func initCalendarView() {
        if let _ = calendarView {
            calendarView!.removeFromSuperview()
        }
        
        calendarView = FSCalendar(frame: CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: 280), rowNum: types.count , beginDate: beginDate!)
        self.view.addSubview(calendarView!)
        self.view.bringSubviewToFront(headView)
        calendarView?.header = headView
        calendarView?.weekSymbols = types
        calendarView?.flow = .Vertical
        calendarView?.dataSource = self
        
    }
    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
        return SSLunarDate.init(date: date).dayString()
    }
}
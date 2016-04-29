//
//  CalendarData.swift
//  calendar
//
//  Created by cnsyl066 on 16/3/25.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import Foundation
public let UD_DATA = "ud_data_by_zzw__8877@126.com"

public let calDType = "type"
public let calDDate = "date"
public let calDNewType = "newType"
class  CalendarData {
    
    class func getAllKeys() -> [String]? {
        let userDeafults = NSUserDefaults.standardUserDefaults()
        let data = userDeafults.valueForKey("UD_DATA") as? NSDictionary
        if  let d = data {
            return d.allKeys as? [String]
        }
        return nil
    }
    class func getDataByKey ( key : String?)  -> [String:AnyObject]{
        let userDeafults = NSUserDefaults.standardUserDefaults()
        var dataKey :String;
        if let k = key  {
            dataKey = k
        }else{
            dataKey = UD_DATA
        }
        
        if let data = userDeafults.valueForKey("UD_DATA") as? [String : AnyObject]{
            if let d = data[dataKey] as! [String : AnyObject]? {
                return d
            }else {
                return [calDType:["白","白","白","夜","下","休"],calDDate: NSDate(),calDNewType:["白","白","白","夜","下","休"]]
            }
        } else{
            let data = [UD_DATA : [calDType:["白","白","白","夜","下","休"],calDDate: NSDate(),calDNewType:["白","白","白","夜","下","休"]]]
            userDeafults.setValue(data, forKey: "UD_DATA")
            userDeafults.synchronize()
            return [calDType:["白","白","白","夜","下","休"],calDDate: NSDate(),calDNewType:["白","白","白","夜","下","休"]]

        }
    }
    
    class func getData()->[String:AnyObject] {
        return self.getDataByKey(UD_DATA)
    }
    
    class func getTypeByKey(key : String) ->  [String] {
        let data = self.getDataByKey(key)
        return data[calDType] as! [String]
    }
    
    class func getType() ->  [String] {
        return self.getTypeByKey(UD_DATA)
    }
    
    class func getDateByKey(key : String) ->  NSDate {
        let data = self.getDataByKey(key)
        return data[calDDate] as! NSDate
    }
    
    class func getDate() ->  NSDate {
        return self.getDateByKey(UD_DATA)
    }
    

    //MARK: -
    
    class func setDataByKey(key : String , type : [String] , date : NSDate) {
        var dataArr = [String]()
        switch type.count {
        case 2 :
            for _ in 1...4 {
                dataArr += type
            }
        case 3 :
            for _ in 1...3 {
                dataArr += type
            }
        case 4 :
            for _ in 1...2 {
                dataArr += type
            }
        default :
            dataArr += type
        }
        
        let data = [calDType : type , calDDate : date , calDNewType : dataArr]
        
        let userDeafults = NSUserDefaults.standardUserDefaults()
        var d = userDeafults.valueForKey("UD_DATA") as! [String : AnyObject]
        d[key] = data
        userDeafults.setValue(d, forKey: "UD_DATA")
        userDeafults.synchronize()
    }
    
    class func setData(type : [String] , date : NSDate) {
        self.setDataByKey(UD_DATA, type: type, date: date)
    }
    
    class func setDataByTypeAndKey(key : String , type : [String]) {
        let data = self.getDataByKey(key)
        let date = data[calDDate] as! NSDate
        self.setData(type, date: date)
    }
    
    class func setDataByType(type : [String]) {
        self.setDataByTypeAndKey(UD_DATA, type: type)
    }
    
    class func setDataByDateAndKey(key : String ,  date : NSDate) {
        let data = self.getDataByKey(key)
        let type = data[calDType] as! [String]
        self.setData(type, date: date)
    }
    
    class func setDataByDate( date : NSDate) {
        self.setDataByDateAndKey(UD_DATA, date: date)
    }
    
    class func removeDataByKey (key : String){
        let userDeafults = NSUserDefaults.standardUserDefaults()
        var d = userDeafults.valueForKey("UD_DATA") as! [String : AnyObject]
        if let _ = d[key] {
            d.removeValueForKey(key)
        }
        userDeafults.setValue(d, forKey: "UD_DATA")
        userDeafults.synchronize()
    }
}


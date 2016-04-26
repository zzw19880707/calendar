//
//  WeatherData.swift
//  calendar
//
//  Created by cnsyl066 on 16/1/7.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import Foundation
///预报未来时段
struct  HourForCast{
    ///时间段  //    "hour": "20时-23时 ",
    var hour : String
    ///温度   //    "hour": "20时-23时 ",
    var temperature : String
    ///天气   //    "weather": "晴",
    var weather : String
    ///天气图片 //    "weather_pic": "http://app1.showapi.com/weather/icon/night/00.png",
    var weather_pic : String
    ///风向   //    "wind_direction": "无持续风向",
    var wind_direction : String
    ///风力   //    "wind_power": "微风"
    var wind_power : String
}
///警告
struct Alarm {
    ///预报未来时段   "city": "",
    var city : String
    ///问题内容         "issueContent": "大风蓝色预警:预计23日23时到24日08时:大连、锦州、营口、盘锦、葫芦岛地区陆地偏北风6级,阵风7级;渤海、渤海海峡、黄海北部偏北风7级,阵风8级。大连、丹东、锦州、营口、盘锦、葫芦岛附近海域和航线将受影响,请注意防范。省气象灾害预警中心10月23日16时35分发布",
    var issueContent : String
    ///问题时间             "issueTime": "2015-10-23 16:40:00",
    var issueTime : String
    ///省                  "province": "辽宁省",
    var province : String
    ///信号级别                 "signalLevel": "蓝色",
    var signalLevel : String
    ///信号类别                 "signalType": "大风"
    var signalType : String

}
///某一天的天气
struct DayWearther {
    ///预报未来时段
    var hourForcast : [HourForCast]
    ///气压
    var air_press : String
    ///预警列表
    var alarmList : [Alarm]
    ///日期   "day": "20160107",
    var day : String
    ///空气温度                "day_air_temperature": "2",
    var day_air_temperature : String
    ///天气
    var day_weather : String
    ///天气温度
    var day_weather_code : String
    ///天气图片
    var day_weather_pic : String
    ///风向
    var day_wind_direction : String
    ///风力
    var day_wind_power : String
    ///指数
    var index : [String:[String:String]]
    ///降水概率             "jiangshui": "0%",
    var jiangshui : String
    ///夜晚空气温度
    var night_air_temperature : String
    ///夜晚天气
    var night_weather : String
    ///夜晚温度
    var night_weather_code : String
    ///夜晚温度图片
    var night_weather_pic : String
    ///夜晚风向
    var night_wind_direction : String
    ///夜晚风力
    var night_wind_power : String
    ///日出日落时间               "sun_begin_end": "07:36|17:04",
    var sun_begin_end : String
    ///星期
    var weekday : String
    ///紫外线
    var ziwaixian : String

    
}

///当前温度
class NowWeather : NSObject , DictModelProtocol{
    ///空气指数
    var aqi : Int?
    ///湿度       "sd": "29%",
    var sd : String?
    ///温度
    var temperature : String?
    ///温度发布时间
    var temperature_time : String?
    ///天气
    var weather : String?
    ///温度
    var weather_code : String?
    ///图片
    var weather_pic : String?
    ///风向
    var wind_direction : String?
    ///风力
    var wind_power : String?

    ///详细空气指数
//    var aqiDetail : AqiDetail?

    static func customClassMapping() -> [String : String]? {
        return ["aqiDetail" : "\(AqiDetail.self)" ]
    }
}

class  AqiDetail : NSObject {
    ///aqi    "aqi": 65,
    var aqi : Int?
    ///地区 "area": "沈阳",
    var area : String?
    ///area_code    "area_code": "shenyang",
    var area_code : String?
    ///co     "co": 0.753,
    var co : Int?
    
    ///no2     "no2": 36,
    var no2 : Int?
    ///        "o3": 39,
    var o3 : Int?
    
    ///8小时内o3 "o3_8h": 19,
    var o3_8h : Int?
    ///pm10  "pm10": 76,
    var pm10 : Int?
    ///pm2.5    "pm2_5": 46,
    var pm2_5 : Int?
    
    ///主要污染物    "primary_pollutant": "颗粒物(PM2.5)",
    var primary_pollutant : String?
    ///空气指数    "quality": "良",
    var quality : String?
    /// so2 "so2": 80
    var so2 : Int?
}
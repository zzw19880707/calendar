//
//  HttpRequest.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/6.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest  {
    class func getWeatherData( callBack : ( [DayWearther]? , NowWeather? ,String?) ->Void ,city : String)  {
        var weartherData : [DayWearther]?
        var nowWearther : NowWeather?

        let parameters = ["area":city , "needMoreDay" : "1" , "needIndex": "1" , "needAlarm" : "1" , "need3HourForcast" : "1" ]
//
        Alamofire.request(.GET , HTTP_GET_WEATHER_DATA , parameters: parameters , encoding: .URL , headers: ["apikey" : "7ef693d2c822db59f28e1b43c2977c11"]  ).responseJSON { (response) -> Void in
            if let json = response.result.value {
                let data = JSON(json)
                let status = data["showapi_res_code"]
                if status.int == 0 {
                    let body = data["showapi_res_body"]
                    let now = body["now"]
                    

                    let modelTool = DictModelManager.sharedManager
                    nowWearther = modelTool.objectWithDictionary(now.dictionaryObject! , cls: NowWeather.self) as? NowWeather
                    print(nowWearther!)
                    
                    
                }else{
                    callBack(nil,nil,data["showapi_res_error"].string)
                }
            }else{
                callBack(nil,nil,"出错了")
            }
        }
        
    }
    
    
    class func getHomePageTopData(callBack :[HomePageTopData]? -> Void  ) -> Void {
        var homeData : [HomePageTopData]?
        
        Alamofire.request(.GET, HTTP_GET_MOVIE_DATA , parameters:nil , encoding: .JSON , headers: ["apikey":"7ef693d2c822db59f28e1b43c2977c11"] ).responseJSON { (response) -> Void in
            if let json = response.result.value {
                let data = JSON(json)
                let status = data["status"]
                if  status == "Success"{
                    var list = data["result"]
                    let moveList = list[0]["movies"]
                    homeData = []
                    for (_,subJson):(String, JSON) in moveList {
                        let movie_name = subJson["movie_name"].stringValue
                        let movie_type = subJson["movie_type"].stringValue
                        let movie_nation = subJson["movie_nation"].stringValue
                        let movie_director = subJson["movie_director"].stringValue
                        let movie_starring = subJson["movie_starring"].stringValue
                        let movie_release_date = subJson["movie_release_date"].stringValue
                        let movie_picture = subJson["movie_picture"].stringValue
                        let movie_length = subJson["movie_length"].stringValue
                        let movie_description = subJson["movie_description"].stringValue
                        let movie_score = subJson["movie_score"].stringValue
                        let movie_message = subJson["movie_message"].stringValue
                        let movie_tags = subJson["movie_tags"].stringValue
                        
                        let home = HomePageTopData(name:movie_name ,type: movie_type ,nation: movie_nation , director: movie_director,starring:  movie_starring , releaseDate: movie_release_date ,picture:  movie_picture,length: movie_length ,description:  movie_description ,score:  movie_score ,message:  movie_message ,tags:  movie_tags)
                        homeData?.append(home)
                    }
                    callBack(homeData)
                    
                }else{
                    callBack(nil)
                }
            }else{
                callBack(nil)
            }
            
            //            response.result.error
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
        }
//        Alamofire.request(.GET, HTTP_GET_MOVIE_DATA , parameters:nil , encoding: .JSON , headers: ["apikey":"7ef693d2c822db59f28e1b43c2977c11"] ).response { (_, _, json, error ) -> Void in
//            
//            if error == nil && json != nil {
//                var data = JSON(json!)
//                let status = data["status"]
//                print(data)
//                if  status == "Success"{
//                    var list = data["result"]
//                    let moveList = list[0]["movies"]
//                    homeData = []
//                    for (key,subJson):(String, JSON) in moveList {
//                        print(key)
//                        let movie_name = subJson["movie_name"].stringValue
//                        let movie_type = subJson["movie_type"].stringValue
//                        let movie_nation = subJson["movie_nation"].stringValue
//                        let movie_director = subJson["movie_director"].stringValue
//                        let movie_starring = subJson["movie_starring"].stringValue
//                        let movie_release_date = subJson["movie_release_date"].stringValue
//                        let movie_picture = subJson["movie_picture"].stringValue
//                        let movie_length = subJson["movie_length"].stringValue
//                        let movie_description = subJson["movie_description"].stringValue
//                        let movie_score = subJson["movie_score"].stringValue
//                        let movie_message = subJson["movie_message"].stringValue
//                        let movie_tags = subJson["movie_tags"].stringValue
//
//                        let home = HomePageTopData(name:movie_name ,type: movie_type ,nation: movie_nation , director: movie_director,starring:  movie_starring , releaseDate: movie_release_date ,picture:  movie_picture,length: movie_length ,description:  movie_description ,score:  movie_score ,message:  movie_message ,tags:  movie_tags)
//                        homeData?.append(home)
//                    }
//                    callBack(homeData)
//                    
//                }else{
//                    callBack(nil)
//                }
//
//            }else{
//                callBack(nil)
//            }
//        }
    }
    
}
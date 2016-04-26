//
//  WeatherViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/1/6.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class WeatherViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HttpRequest.getWeatherData({ (_, _, _) -> Void in
            
            }, city: "沈阳")
    }

}

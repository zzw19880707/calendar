//
//  AppDelegate.swift
//  calendar
//
//  Created by cnsyl066 on 15/9/30.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate  {

    var window: UIWindow?

    var locationManager = CLLocationManager.init()
    
    let UD_LOCATION = "location"
    ///初始化第三方
    func initThrid() {
        MobClick.startWithAppkey("568a0ac1e0f55ae989000a0c", reportPolicy: BATCH, channelId: "thrid")
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        initThrid()
        locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        //使用程序其间允许访问位置数据（iOS8定位需要）
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
//        所有返回按钮的文字上移100像素
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -100), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor() ]
        return true
    }
    
    /// MARK : - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let currLocation = locations.last
        print(currLocation?.coordinate.latitude)
        print(currLocation?.coordinate.longitude)
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currLocation!) { (placemarks, error) -> Void in
            let userDeafults = NSUserDefaults.standardUserDefaults()

            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
                userDeafults.setObject("沈阳市", forKey: self.UD_LOCATION)
                userDeafults.synchronize()
                return
            }
        
            if placemarks!.count > 0 {
                let placemark   = placemarks![0] 
                userDeafults.setObject(placemark.name!, forKey: self.UD_LOCATION)
                userDeafults.synchronize()

                self.locationManager.stopUpdatingLocation()

            }

        }
        

        
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        let userDeafults = NSUserDefaults.standardUserDefaults()
        userDeafults.setObject("沈阳市", forKey: UD_LOCATION)
        userDeafults.synchronize()
        
        locationManager.stopUpdatingLocation()
        
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


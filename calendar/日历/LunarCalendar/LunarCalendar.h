//
//  LunarCalendar.h
//  calendar
//
//  Created by cnsyl066 on 15/12/16.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunarCalendar : NSObject


//计算星座
+(NSString *)Constellation : (NSDate *) date;
///世界节日获取节日
+(NSString *)getWorldHoliday:(NSDate *)date;
///获取中国节日
+(NSString *)getChineseHoliday:(NSString *)aMonth day:(NSString *)aDay;
///获取年的信息
+(NSString *)getYear:(NSInteger )aYear;
@end

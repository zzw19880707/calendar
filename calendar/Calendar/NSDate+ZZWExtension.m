//
//  NSDate+ZZWExtension.m
//  fs
//
//  Created by cnsyl066 on 15/12/8.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

#import "NSDate+ZZWExtension.h"

@implementation NSDate (ZZWExtension)


/**
 *  返回今日是什么班
 *
 *  @param nowDate 今天的日期
 *  @param currentDate 设置的日期
 *  @param num 一共有多少个班次
 *
 *  @return 上班的类型
 */
-(int)getTodayTypebyCurrentDate:(NSDate *)currentDate num:(int)num{
    //    时间差（天）
    NSTimeInterval t = [[self beginingOfDay] timeIntervalSinceDate:[currentDate beginingOfDay]]/(60 * 60 *24 );
    int count = t / num ;
    if(t < 0){
        t = ( -count + 1) * num + t;
    }else{
        t = t - count * num;
    }
    if (t == num) {
        t = 0;
    }
    /**
     *  设置最近一次中心时间
     */
//    NSDate *newDate = [[NSDate alloc]initWithTimeInterval:count *6 *60 *60 *24 sinceDate:[currentDate beginingOfDay]];
//    [self setCurrentDate:newDate];
    return (int)t;
}

/******************************************
 *@Description:获取当天的起始时间（00:00:00）
 *@Params:nil
 *@Return:当天的起始时间
 ******************************************/
- (NSDate *)beginingOfDay
{
    [[self componentsOfDay] setHour:0];
    [[self componentsOfDay] setMinute:0];
    [[self componentsOfDay] setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}


/**********************************************************
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 ***********************************************************/
- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    
    return dateComponents;
}

@end

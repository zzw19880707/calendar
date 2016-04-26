//
//  NSDate+ZZWExtension.h
//  fs
//
//  Created by cnsyl066 on 15/12/8.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZZWExtension)



/**
 *  返回今日是什么班
 *
 *  @param nowDate 今天的日期
 *  @param currentDate 设置的日期
 *  @param num 一共有多少个班次
 *
 *  @return 上班的类型
 */
-(NSInteger)getTodayTypebyCurrentDate:(NSDate *)currentDate num:(NSInteger )num;
@end

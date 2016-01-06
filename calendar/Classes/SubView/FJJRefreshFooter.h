//
//  FJJRefreshFooter.h
//  calendar
//
//  Created by cnsyl066 on 15/11/26.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface FJJRefreshFooter : MJRefreshBackFooter
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(MJRefreshState)state;
@end

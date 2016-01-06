//
//  FSCalendarViewPage.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendarPage.h"
#import "FSCalendarUnit.h"
#import "NSDate+FSExtension.h"
#import "UIView+FSExtension.h"
#import "FSCalendar.h"
#import "NSDate+ZZWExtension.h"
@interface FSCalendarPage ()
{
    int _maxDate;
    NSDate *_beginDate;
}
@property (readonly, nonatomic) FSCalendar *calendarView;

@end

@implementation FSCalendarPage

#pragma mark - ZZW
-(instancetype)initWithFrame:(CGRect)frame rowNum:(NSInteger ) rowNum  beginDate : (NSDate *)beginDate{
    self = [super initWithFrame:frame];
    if (self) {
        if ( rowNum == 4 ||rowNum == 5 ||rowNum == 8){
            _maxDate = 40 ;
        }else {
            _maxDate = 42 ;
        }
        self.rowNum = rowNum;
        for (int i = 0; i < _maxDate; i++) {
            FSCalendarUnit *unit = [[FSCalendarUnit alloc] initWithFrame:CGRectZero];
            [self addSubview:unit];
        }
        self.backgroundColor = [UIColor clearColor];
        _beginDate = beginDate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 42; i++) {
            FSCalendarUnit *unit = [[FSCalendarUnit alloc] initWithFrame:CGRectZero];
            [self addSubview:unit];
        }
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    if (![_date isEqualToDate:date]) {
        _date = [date copy];
    }
    [self updateDateForUnits];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset = self.fs_height * 0.1 / (_rowNum + 1);
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / _rowNum;
        CGFloat width = self.fs_width/_rowNum;
        CGFloat height = (self.fs_height-inset*2)/ (self.subviews.count / _rowNum );
        CGFloat top = inset+row * height;
        CGFloat left = (idx % _rowNum)*width;
        [obj setFrame:CGRectMake(left, top, width, height)];
    }];
}

- (void)updateDateForUnits
{
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:_maxDate];
    for (int i = 0; i < _date.numberOfDaysInMonth; i++) {
        [dates addObject:[NSDate fs_dateWithYear:_date.fs_year month:_date.fs_month day:i+1]];
    }
    NSInteger numberOfPlaceholders = _maxDate - dates.count;
    
    int type = [dates[0] getTodayTypebyCurrentDate:_beginDate num:_rowNum];
    NSInteger numberOfPlaceholdersForPrev = type ?  : _rowNum;
    
    for (int i = 0; i < numberOfPlaceholdersForPrev; i++) {
        [dates insertObject:[dates[0] fs_dateBySubtractingDays:1] atIndex:0];
    }
    for (int i = 0; i < numberOfPlaceholders-numberOfPlaceholdersForPrev; i++) {
        [dates addObject:[dates.lastObject fs_dateByAddingDays:1]];
    }
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDate *date = dates[idx];
        [obj setDate: date];
        [obj setTag: date.fs_year*10000 + date.fs_month*100 + date.fs_day*100];
    }];
}

- (FSCalendarUnit *)unitForDate:(NSDate *)date
{
    NSInteger tag = date.fs_year*10000 + date.fs_month*100 + date.fs_day*100;
    return (FSCalendarUnit *)[self viewWithTag:tag];
}

- (FSCalendar *)calendarView
{
    return (FSCalendar *)self.superview.superview;
}


@end

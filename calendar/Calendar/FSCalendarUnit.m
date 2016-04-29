//
//  FSCalendarViewUnit.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendarUnit.h"
#import "FSCalendarPage.h"
#import "NSDate+FSExtension.h"
#import "UIView+FSExtension.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration 0.12

#define kTitleHeight self.fs_height*5.0/6.0
#define kDiameter MIN(self.fs_height*5.0/6.0,self.fs_width)

@interface FSCalendarUnit ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;



@property (strong, nonatomic) CAShapeLayer *animLayer;
@property (strong, nonatomic) CAShapeLayer *eventLayer;

- (void)handleTap:(FSCalendarUnit *)unit;
#pragma mark - ZZW
@property (strong, nonatomic) UILabel *weekLabel;
@end

@implementation FSCalendarUnit

@synthesize titleFont = _titleFont;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        日期
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
//        农历
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_subtitleLabel];
        
#pragma mark - ZZW
        _weekLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
        _weekLabel.font = [UIFont systemFontOfSize:8];
        _weekLabel.textColor = [UIColor redColor];
        [self addSubview:_weekLabel];

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.cancelsTouchesInView = NO;
        tapGesture.delaysTouchesBegan = NO;
        [self addGestureRecognizer:tapGesture];
        
        _animation = FSCalendarUnitAnimationScale;
        
        _eventLayer = [CAShapeLayer layer];
        _eventLayer.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
        [self.layer addSublayer:_eventLayer];
        
        _animLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:_animLayer below:_titleLabel.layer];
        _style = FSCalendarUnitStyleCircle;
        
        self.clipsToBounds  = NO;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    if (layer == self.layer) {
        
        CGFloat diameter = kDiameter ;
        _animLayer.frame = CGRectMake((self.fs_width-diameter)/2, (kTitleHeight-diameter)/2, diameter, diameter);
        
        switch (self.style) {
            case FSCalendarUnitStyleCircle:
                _animLayer.path = [UIBezierPath bezierPathWithOvalInRect:_animLayer.bounds].CGPath;
                break;
            case FSCalendarUnitStyleRectangle:
                _animLayer.path = [UIBezierPath bezierPathWithRect:_animLayer.bounds].CGPath;
                break;
            default:
                break;
        }
        _animLayer.fillColor = [self.dataSource unitColorForUnit:self].CGColor;
        
        CGFloat eventSize = _animLayer.frame.size.height/6.0;
        _eventLayer.frame = CGRectMake((_animLayer.frame.size.width-eventSize)/2+_animLayer.frame.origin.x, CGRectGetMaxY(_animLayer.frame)+eventSize*0.2, eventSize*0.8, eventSize*0.8);
        _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
        _eventLayer.hidden = ![self.dataSource hasEventForUnit:self];
        
        if ([self isSelected]) {
            [self showAnimation];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_date) {
        // set attribute title
        NSString *subtitle = [_dataSource subtitleForUnit:self];
        UIColor *titleColor = [self.dataSource titleColorForUnit:self];
        NSString *title = [NSString stringWithFormat:@"%@", @(_date.fs_day)];
        _titleLabel.text = title;
        _titleLabel.textColor = titleColor;
        CGFloat titleHeight = [title sizeWithAttributes:@{NSFontAttributeName:self.titleFont}].height;
        if (subtitle) {
            _subtitleLabel.hidden = NO;
            _subtitleLabel.text = subtitle;
            CGFloat subtitleHeight = [subtitle sizeWithAttributes:@{NSFontAttributeName:self.subtitleFont}].height;
            
            CGFloat height = titleHeight + subtitleHeight;
            _titleLabel.frame = CGRectMake(0,
                                           (kTitleHeight-height)*0.5,
                                           self.fs_width,
                                           titleHeight);
            
            _subtitleLabel.frame = CGRectMake(0,
                                              kTitleHeight-subtitleHeight,
                                              self.fs_width,
                                              subtitleHeight);
            _subtitleLabel.textColor = [self.dataSource subtitleColorForUnit:self];
        } else {
            _titleLabel.frame = CGRectMake(0, 0, self.fs_width, floor(kTitleHeight));
            _subtitleLabel.hidden = YES;
        }
#pragma mark - ZZW
        _weekLabel.frame = CGRectMake( self.fs_width - 10 , 0 , 12 , 12 );
        NSString *weekText = [NSString string];
        switch (self.date.fs_weekday) {
            case 1:
                weekText = @"日";
                break;
            case 2:
                weekText = @"一";
                break;
            case 3:
                weekText = @"二";
                break;
            case 4:
                weekText = @"三";
                break;
            case 5:
                weekText = @"四";
                break;
            case 6:
                weekText = @"五";
                break;
            case 7:
                weekText = @"六";
                break;
            default:
                break;
        }
        _weekLabel.text = weekText;
    }
}

#pragma mark - Public

- (void)setDate:(NSDate *)date
{
    if (![_date isEqualToDate:date]) {
        _date = [date copy];
    }
    [self setNeedsLayout];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleLabel.font != titleFont) {
        _titleLabel.font = titleFont;
    }
}

- (UIFont *)titleFont
{
    return _titleLabel.font;
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    if (_subtitleLabel.font != subtitleFont) {
        _subtitleLabel.font = subtitleFont;
    }
}

- (UIFont *)subtitleFont
{
    return _subtitleLabel.font;
}

- (void)setEventColor:(UIColor *)eventColor
{
    _eventLayer.fillColor = eventColor.CGColor;
}

- (UIColor *)eventColor
{
    return [UIColor colorWithCGColor:_eventLayer.fillColor];
}

- (void)setStyle:(FSCalendarUnitStyle)style
{
    if (_style != style) {
        _style = style;
        [self setNeedsLayout];
    }
}

#pragma mark - Target Action

- (void)handleTap:(id)sender
{
    [self.delegate handleUnitTap:self];
}

#pragma mark - Private

- (BOOL)isSelected
{
    return [self.dataSource unitIsSelected:self];
}

- (BOOL)isPlaceholder
{
    return [_dataSource unitIsPlaceholder:self];
}

- (BOOL)isToday
{
    return [_dataSource unitIsToday:self];
}

- (BOOL)isWeekend
{
    return self.date.fs_weekday == 1 || self.date.fs_weekday == 7;
}

- (void)showAnimation
{
    if (_animation == FSCalendarUnitAnimationNone) {
        return;
    }
    if (_animation == FSCalendarUnitAnimationScale) {
        CAAnimationGroup *group = [CAAnimationGroup animation];
        CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomOut.fromValue = @0.3;
        zoomOut.toValue = @1.2;
        zoomOut.duration = kAnimationDuration/4*3;
        CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomIn.fromValue = @1.2;
        zoomIn.toValue = @1.0;
        zoomIn.beginTime = kAnimationDuration/4*3;
        zoomIn.duration = kAnimationDuration/4;
        group.duration = kAnimationDuration;
        group.animations = @[zoomOut, zoomIn];
        [_animLayer addAnimation:group forKey:@"bounce"];
        
    } else if (_animation == FSCalendarUnitAnimationShade) {
        [UIView transitionWithView:self duration:kAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setNeedsLayout];
        } completion:nil];
    }
    
}

- (FSCalendarUnitState)absoluteState
{
    if (self.isSelected) {
        return FSCalendarUnitStateSelected;
    }
    if (self.isToday) {
        return FSCalendarUnitStateToday;
    }
    if (self.isPlaceholder) {
        return FSCalendarUnitStatePlaceholder;
    }
    if (self.isWeekend) {
        return FSCalendarUnitStateWeekend;
    }
    return FSCalendarUnitStateNormal;
}


@end



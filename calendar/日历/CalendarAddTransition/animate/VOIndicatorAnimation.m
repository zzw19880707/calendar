//
//  VOLayerAnimation.m
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-30.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOIndicatorAnimation.h"

@implementation VOIndicatorAnimation

+ (void)opacityMoveIndicator:(CALayer *)indicator toPosition:(CGPoint)toPos duration:(CGFloat)duration{
    
    
    
    CGSize size = indicator.bounds.size;
    
    CABasicAnimation *animate = [CABasicAnimation animation];
    animate.keyPath = @"opacity";
    animate.fromValue = @0;
    animate.toValue = @1;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animate.removedOnCompletion = NO;
    animate.duration = duration;
    indicator.position = toPos;
    [indicator addAnimation:animate forKey:nil];
    
    NSMutableArray *values = [NSMutableArray array];
    CGFloat maxWidth = size.width * 3 ;
    CGFloat firstDamp = 1.0 - size.width / maxWidth;
    CGFloat damp = 0.75;
    CGFloat drift = size.width * firstDamp * -1.0;
    for (NSInteger i = 0; i < duration / 0.15; i ++) {
        [values addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, size.width + drift, size.height)]];
        drift = drift * -damp;
    }
    // 最后状态
    [values addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, size.width, size.height)]];
    CAKeyframeAnimation *keyanim = [CAKeyframeAnimation animation];
    keyanim.keyPath = @"bounds";
    keyanim.values = values;
    keyanim.removedOnCompletion = NO;
    keyanim.fillMode = kCAFillModeForwards;
    keyanim.duration = duration;
    keyanim.beginTime = [indicator convertTime:CACurrentMediaTime() fromLayer:nil] + duration * 0.25;
    keyanim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [indicator addAnimation:keyanim forKey:nil];

}

+ (void)bounceMoveIndicator: (CALayer *)indicator fromPostion: (CGPoint)fromPos toPosition: (CGPoint)toPos duration: (CGFloat)duration{
    CGSize size = indicator.bounds.size;
    CGFloat bounceDuration, moveDuration;
    if (CGPointEqualToPoint(fromPos, toPos)) {
        moveDuration   = 0.0;
        bounceDuration = duration;
    }
    else{
        moveDuration   = duration * 0.25;
        bounceDuration = duration * 0.75;
    }
    CABasicAnimation *moveAnim = [CABasicAnimation animation];
    moveAnim.keyPath = @"position";
    moveAnim.fromValue = [NSValue valueWithCGPoint:fromPos];
    moveAnim.toValue = [NSValue valueWithCGPoint:toPos];
    moveAnim.duration = moveDuration;
    moveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveAnim.removedOnCompletion = NO;
    moveAnim.fillMode = kCAFillModeForwards;
    [indicator addAnimation:moveAnim forKey:nil];
    
    NSMutableArray *values = [NSMutableArray array];
    CGFloat maxWidth;
    if (toPos.x - fromPos.x == 0 ) {
        maxWidth = size.width + ABS(toPos.y - fromPos.y);
    }else{
        maxWidth = size.width + ABS(toPos.x - fromPos.x);
    }
    CGFloat firstDamp = 1.0 - size.width / maxWidth;
    CGFloat damp = 0.75;
    CGFloat drift = size.width * firstDamp * -1.0;
    for (NSInteger i = 0; i < bounceDuration / 0.15; i ++) {
        [values addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, size.width + drift, size.height)]];
        drift = drift * -damp;
    }
    // 最后状态
    [values addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, size.width, size.height)]];

    
    CAKeyframeAnimation *keyanim = [CAKeyframeAnimation animation];
    keyanim.keyPath = @"bounds";
    keyanim.values = values;
    keyanim.removedOnCompletion = NO;
    keyanim.fillMode = kCAFillModeForwards;
    keyanim.duration = bounceDuration;
    keyanim.beginTime = [indicator convertTime:CACurrentMediaTime() fromLayer:nil] + duration * 0.25;
    keyanim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [indicator addAnimation:keyanim forKey:nil];
}

+ (void)smoothMoveIndicator: (CALayer *)indicator fromPostion: (CGPoint)fromPos toPosition: (CGPoint)toPos duration: (CGFloat)duration{
    if (CGPointEqualToPoint(fromPos, toPos)) {
        return;
    }
    CABasicAnimation *moveAnim = [CABasicAnimation animation];
    moveAnim.keyPath = @"position";
    moveAnim.fromValue = [NSValue valueWithCGPoint:fromPos];
    moveAnim.toValue = [NSValue valueWithCGPoint:toPos];
    moveAnim.duration = duration;
    moveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnim.removedOnCompletion = NO;
    moveAnim.fillMode = kCAFillModeForwards;
    [indicator addAnimation:moveAnim forKey:nil];
}

@end

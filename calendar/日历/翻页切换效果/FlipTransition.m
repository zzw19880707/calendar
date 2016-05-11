//
//  FlipTransition.m
//  MMPaperPanFlip
//
//  Created by mukesh mandora on 18/12/14.
//  Copyright (c) 2014 madaboutapps. All rights reserved.
//

#import "FlipTransition.h"
#import "calendar-Swift.h"
@implementation FlipTransition


-(instancetype)initWithPresenting:(BOOL)isPresenting{
    if (self = [super init]) {
        _isPresenting = isPresenting;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_isPresenting) {
        [self present:transitionContext];
    }else {
        [self dismiss:transitionContext];
    }
}

-(void)present:(id <UIViewControllerContextTransitioning>)transitionContext{
    CalendarListViewController *fromVC = (CalendarListViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];


    UIView *selectCellView = [fromVC.collection cellForItemAtIndexPath:fromVC.selectCellIndexPath] ;
    ///cell
    UIView *fromView = [selectCellView snapshotViewAfterScreenUpdates:YES];
    selectCellView.hidden = YES;
    UIView *toView = toVC.view;

    UIView* containerView = [transitionContext containerView];
    
    UIView * bgView = [ [UIApplication sharedApplication] .keyWindow  snapshotViewAfterScreenUpdates:YES];
    [containerView addSubview:bgView];

    CGRect initialFrame = toVC.view.frame;

    CGFloat listViewHeight  = [UIScreen mainScreen].bounds.size.width * 300 / 375 + 64;
    CGRect frame = fromVC.selectCellFrame;
    frame.origin.y += listViewHeight;
    
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
//    [containerView addSubview:fromVC.view];

    
    
    //返回的顺序是 上\下、
    NSArray* toViewSnapshots = [self createSnapshots:toView ];

    
    
    fromView.frame = frame;
    [containerView addSubview:fromView];

    frame.origin.y = initialFrame.size.height / 2;


    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];

    
    UIView *topView = toViewSnapshots[0];
    UIView *bottomView = toViewSnapshots[1];
    frame.origin.x = (initialFrame.size.width - frame.size.width) / 2;

    bottomView.frame = frame;
    bottomView.alpha = 0;
    topView.frame = CGRectMake(frame.origin.x , initialFrame.size.height / 2 - frame.size.height, frame.size.width, frame.size.height);
    
    [self updateAnchorPointAndOffset:CGPointMake(0.5, 0) view:fromView];
    [self updateAnchorPointAndOffset:CGPointMake(0.5, 1) view:topView];
    
    topView.layer.transform = [self rotate: -M_PI_2];

    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];


    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                   options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                   animations:^{
                                       [UIView addKeyframeWithRelativeStartTime:0.0
                                                               relativeDuration:0.25 animations:^{

                                                                   fromView.frame = frame;
                                                               }];
                                       [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.01 animations:^{
                                           bottomView.alpha = 1 ;
                                           
                                       }];
                                       [UIView addKeyframeWithRelativeStartTime:0.25
                                                               relativeDuration:0.25 animations:^{
                                                                   fromView.layer.transform = [self rotate: M_PI_2];
                                                               }];
                                       [UIView addKeyframeWithRelativeStartTime:0.5
                                                               relativeDuration:0.5 animations:^{
                                                                   topView.layer.transform = [self rotate:0];
                                                                   topView.frame = CGRectMake(0, 0, initialFrame.size.width, initialFrame.size.height / 2) ;
                                                                   bottomView.frame = CGRectMake(0, initialFrame.size.height / 2,  initialFrame.size.width, initialFrame.size.height / 2);
                                       }];
                                    } completion:^(BOOL finished) {
                                        [containerView bringSubviewToFront:toView];
                                        selectCellView.hidden = NO;
                                        [topView removeFromSuperview];
                                        [bottomView removeFromSuperview];
                                        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                                    }];
    
    

}
-(void)dismiss:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CalendarListViewController *toVC = (CalendarListViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *selectCellView = [toVC.collection cellForItemAtIndexPath:toVC.selectCellIndexPath] ;
    UIView *toView = [selectCellView snapshotViewAfterScreenUpdates:true];
    selectCellView.hidden = YES;
    UIView *fromView = fromVC.childViewControllers[0].view;
    
    CGFloat listViewHeight  = [UIScreen mainScreen].bounds.size.width * 300 / 375 + 64;
    CGRect frame = toVC.selectCellFrame;
    frame.origin.y += listViewHeight;
    
    UIView* containerView = [transitionContext containerView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
//    toView.frame = frame;
    fromView.frame =  initialFrame;
    
    // customise
    [containerView addSubview:toView];
    
    // create two-part snapshots of both the from- and to- views
    UIView* cell = toView;
    //返回的顺序是 下、上
    NSArray* fromViewSnapshots = [self createSnapshots:fromView afterScreenUpdates:NO];
    CGFloat cell_X = (initialFrame.size.width - frame.size.width) / 2;

    ///上视图
    UIView* flippedSectionOfFromView = (UIView * )fromViewSnapshots[1];
    cell.frame = CGRectMake(cell_X, fromVC.view.frame.size.height / 2, frame.size.width, frame.size.height);

    // change the anchor point so that the view rotate around the correct edge
    [self updateAnchorPointAndOffset:CGPointMake(0.5,1) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffset:CGPointMake(0.5,0) view:cell];
    
    // rotate the to- view by 90 degrees, hiding it
    cell.layer.transform = [self rotate: M_PI_2 ];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from- view to 90 degrees
                                                                    flippedSectionOfFromView.layer.transform = [self rotate: -M_PI_2];
//                                                                        //下
                                                                    ((UIView *)fromViewSnapshots[0]).frame=CGRectMake(cell_X, fromVC.view.center.y , frame.size.width, frame.size.height);
//                                                                    //上
                                                                    flippedSectionOfFromView.frame=CGRectMake(cell_X, fromVC.view.center.y  - frame.size.height  + 7, frame.size.width,  frame.size.height );
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.25
                                                                animations:^{
                                                                    cell.layer.transform = [self rotate: 0 ];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.65 relativeDuration:0.01 animations:^{
                                      flippedSectionOfFromView.alpha = 0;
                                      ((UIView *)fromViewSnapshots[0]).alpha = 0;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.75
                                                          relativeDuration:0.25
                                                                animations:^{
                                                                    cell.frame = frame;
                                                                }];
                                  
                              } completion:^(BOOL finished) {
                                  
                                  [((UIView *)fromViewSnapshots[0]) removeFromSuperview];
                                  [flippedSectionOfFromView removeFromSuperview];

                                  if (finished) {
                                      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                                  }
                                  selectCellView.hidden = NO;
                                  toVC.selectCellIndexPath = nil;
                              }];
    
}

- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0);
}

- (NSArray*)createSnapshots:(UIView*)view{
    UIView* containerView = view.superview;
    // snapshot the left-hand side of the view
    
    //issue in iPhone 6
    UIView *leftHandView = [view resizableSnapshotViewFromRect:CGRectMake(0,view.frame.size.height/2,view.frame.size.width,view.frame.size.height/2)  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    [containerView addSubview:leftHandView];
    
    UIView *rightHandView = [view resizableSnapshotViewFromRect:CGRectMake(0, 0,view.frame.size.width,view.frame.size.height/2)  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    [containerView addSubview:rightHandView];
    
    //上下
    return @[rightHandView, leftHandView];
}
/// creates a pair of snapshots from the given view   返回的顺序是 下、上
- (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    CGRect snapshotRegion;
    // snapshot the left-hand side of the view
    snapshotRegion = CGRectMake(0,view.center.y,view.frame.size.width , view.frame.size.height/2);
    
    //issue in iPhone 6
    UIView *leftHandView = [view resizableSnapshotViewFromRect:CGRectMake(0,view.frame.size.height/2,view.frame.size.width,view.frame.size.height/2)  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    snapshotRegion = CGRectMake(0,0,view.frame.size.width , view.frame.size.height/2);
    
    UIView *rightHandView = [view resizableSnapshotViewFromRect:CGRectMake(0, 0,view.frame.size.width,view.frame.size.height/2)  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    
    [view removeFromSuperview];
    return @[leftHandView, rightHandView];
}

// updates the anchor point for the given view, offseting the frame to compensate for the resulting movement
- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.y - 0.5;
    view.frame = CGRectOffset(view.frame, 0, xOffset * view.frame.size.height);
}



@end

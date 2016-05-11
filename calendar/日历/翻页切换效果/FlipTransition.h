//
//  FlipTransition.h
//  MMPaperPanFlip
//
//  Created by mukesh mandora on 18/12/14.
//  Copyright (c) 2014 madaboutapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FlipTransition : NSObject<UIViewControllerAnimatedTransitioning>
{
    BOOL _isPresenting;
   
}
-(instancetype)initWithPresenting:(BOOL)isPresenting;

@end

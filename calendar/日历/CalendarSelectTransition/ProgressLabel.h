//
//  ProgressLabel.h
//  LEffectLabel
//
//  Created by cnsyl066 on 16/4/27.
//  Copyright © 2016年 Luka Gabric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressLabel : UIView
{
    UILabel *_effectLabel;
    CGImageRef _alphaImage;
    CALayer *_textLayer;
    
    CALayer *_colorLayer;
}


@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *text;
@property (assign , nonatomic) CGFloat progress;

@end
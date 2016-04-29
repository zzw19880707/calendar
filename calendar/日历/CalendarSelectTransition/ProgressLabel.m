//
//  ProgressLabel.m
//  LEffectLabel
//
//  Created by cnsyl066 on 16/4/27.
//  Copyright © 2016年 Luka Gabric. All rights reserved.
//

#import "ProgressLabel.h"


@interface UIImage (LEffectLabelAdditions)


+ (UIImage *)imageWithView:(UIView *)view;


@end


@implementation ProgressLabel


#pragma mark - Init


- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    _textColor = [UIColor whiteColor];
    
    _effectLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _effectLabel.textAlignment = NSTextAlignmentLeft;
    _effectLabel.numberOfLines = 1;
    _effectLabel.text = @"113123123";
    _effectLabel.backgroundColor = [UIColor clearColor];
    
    self.progress = 0;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    _colorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_colorLayer];
    
}


#pragma mark - layoutSubviews


- (void)layoutSubviews
{
    _textLayer.frame = self.bounds;
}



#pragma mark - Setters


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _effectLabel.frame = frame;
}


- (void)setFont:(UIFont *)font
{
    _font = font;
    _effectLabel.font = _font;
    
    [self updateLabel];
}


- (void)setText:(NSString *)text
{
    _text = text;
    _effectLabel.text = _text;
    
    [self updateLabel];
}


- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _effectLabel.textColor = _textColor;
    
    [self updateLabel];
}


#pragma mark - Update UI


- (void)updateLabel
{
    
    [_effectLabel sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _effectLabel.frame.size.width, _effectLabel.frame.size.height);
    
    _alphaImage = [[UIImage imageWithView:_effectLabel] CGImage];
    
    _textLayer = [CALayer layer];
    _textLayer.contents = (__bridge id)_alphaImage;
    
    [self.layer setMask:_textLayer];
    
    [self setNeedsLayout];
}
-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    CGRect frame = _colorLayer.frame;
    frame.size.width = self.bounds.size.width * progress;
    _colorLayer.frame = frame;
}


@end


@implementation UIImage (LEffectLabelAdditions)


+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
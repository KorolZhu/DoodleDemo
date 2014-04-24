//
//  HTCroperMaskView.m
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import "HTCroperMaskView.h"

@interface HTCroperMaskView ()
{
    CGRect _croperRect;
}

@end

@implementation HTCroperMaskView

- (void)setCropsize:(CGSize)cropsize{
    _cropsize = cropsize;
    
    CGFloat x = (CGRectGetWidth(self.bounds) - cropsize.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - cropsize.height) / 2;
    _croperRect = CGRectMake(x, y, cropsize.width, cropsize.height);
    
    [self setNeedsDisplay];
}

- (CGRect)cropRect{
    return _croperRect;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, .4);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRectWithWidth(ctx, _croperRect, 1.0f);
    CGContextClearRect(ctx, _croperRect);
    
    UIGraphicsPopContext();
}

@end

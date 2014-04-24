//
//  HTLightnessSlider.m
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-13.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import "HTAlphaSlider.h"

@interface HTAlphaSlider ()
{
    CAGradientLayer *gradientLayer;
}

@end

@implementation HTAlphaSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.bounds = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
        gradientLayer.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
		if ([self respondsToSelector:@selector(contentScaleFactor)])
			self.contentScaleFactor = [[UIScreen mainScreen] scale];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
		gradientLayer.cornerRadius = 18.0f;
        [self.layer insertSublayer:gradientLayer atIndex:1];
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	gradientLayer.colors =  [NSArray arrayWithObjects:
							 (id)[tintColor colorWithAlphaComponent:0.0].CGColor,
							 (id)tintColor.CGColor,
							 nil];
	[CATransaction commit];
}

@end

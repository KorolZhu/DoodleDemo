//
//  HTSaturationSlider.m
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-13.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import "HTBrightnessSlider.h"

@interface HTBrightnessSlider ()
{
    CAGradientLayer *gradientLayer;
}

@end

@implementation HTBrightnessSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.cornerRadius = 15.0f;
        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.bounds = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
        gradientLayer.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
		self.layer.cornerRadius = 18.0f;
		gradientLayer.cornerRadius = 18.0f;
		if ([self respondsToSelector:@selector(contentScaleFactor)])
			self.contentScaleFactor = [[UIScreen mainScreen] scale];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	gradientLayer.colors =  [NSArray arrayWithObjects:
							 (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.000].CGColor,
							 (id)tintColor.CGColor,
							 nil];
	[CATransaction commit];
}

@end

//
//  HTHuePickerView.m
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-13.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import "HTHuePickerView.h"

@interface HTHuePickerView ()
{
    UIImageView *colorDiscView;
    UIImageView *whiteLoopView;
}

@end

@implementation HTHuePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        colorDiscView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_set_color_colordisc"]];
        colorDiscView.frame = CGRectMake(0.0f, 0.0f, 152.0f, 152.0f);
        colorDiscView.contentMode = UIViewContentModeTopLeft;
        whiteLoopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_set_color_loop"]];
        [self addSubview:colorDiscView];
        [self addSubview:whiteLoopView];
        
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void)setHSV:(HSVType)HSV {
    _HSV = HSV;
	_HSV.v = 1.0;
	double angle = _HSV.h * 2.0 * M_PI;
	CGPoint center = colorDiscView.center;
	double radius = colorDiscView.bounds.size.width * 0.5 - 3.0f;
	radius *= _HSV.s;
	
	CGFloat x = center.x + cosf(angle) * radius;
	CGFloat y = center.y - sinf(angle) * radius;
	
	x = roundf(x - whiteLoopView.bounds.size.width * 0.5) + whiteLoopView.bounds.size.width * 0.5;
	y = roundf(y - whiteLoopView.bounds.size.height * 0.5) + whiteLoopView.bounds.size.height * 0.5;
	whiteLoopView.center = CGPointMake(x + colorDiscView.frame.origin.x, y + colorDiscView.frame.origin.y);
}

- (void) mapPointToColor:(CGPoint) point
{
	CGPoint center = colorDiscView.center;
    double radius = self.frame.size.width / 2.0f;
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
	if (isnan(angle))
		angle = 0.0;
	
    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist/radius, 1.0);
	
	if (dist < 1)
        saturation = 0; // snap to center
	
    if (point.x < center.x)
        angle = M_PI - angle;
	
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
	
	self.HSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint beginPoint = [touch locationInView:self];
	if (!CGRectContainsPoint(colorDiscView.frame, beginPoint))
		return NO;
	
	[self mapPointToColor:[touch locationInView:colorDiscView]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToColor:[touch locationInView:colorDiscView]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self continueTrackingWithTouch:touch withEvent:event];
}

@end

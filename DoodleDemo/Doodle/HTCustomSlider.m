//
//  CustomSlider.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-11.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "HTCustomSlider.h"

@interface HTCustomSlider ()
{
	UIImageView *trackImageView;
	UIImageView *thumbImageView;
}

@end

@implementation HTCustomSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:trackImageView];
		[self addSubview:thumbImageView];
		
		self.minimumValue = 0.0f;
		self.maximumValue = 100.0f;
		self.value = 50.0f;
    }
    return self;
}

- (CGFloat)frameRange {
	return self.frame.size.width - thumbImageView.frame.size.width;
}

- (CGFloat)valueRange {
	return _maximumValue - _minimumValue;
}

- (void)layoutSubviews {
	CGRect frame;
	frame.origin = CGPointZero;
	frame.size = _trackImage.size;
	trackImageView.frame = frame;
	trackImageView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
	
	frame.origin.x = ((_value - _minimumValue) / [self valueRange]) * [self frameRange];
	frame.origin.y = (self.frame.size.height - _thumbImage.size.height) / 2.0f;
	frame.size = _thumbImage.size;
	if (frame.origin.x < 0) {
		frame.origin.x = 0;
	} else if (frame.origin.x + frame.size.width > self.frame.size.width){
		frame.origin.x = self.frame.size.width - frame.size.width;
	}
	thumbImageView.frame = frame;
}

- (void)setValue:(float)value {
	_value = value;
	[self setNeedsLayout];
}

- (void)setTrackImage:(UIImage *)trackImage {
	_trackImage = trackImage;
	[trackImageView setImage:trackImage];
	[self setNeedsLayout];
}

- (void)setThumbImage:(UIImage *)thumbImage {
	_thumbImage = thumbImage;
	[thumbImageView setImage:thumbImage];
	[self setNeedsLayout];
}

- (void)valueChangedWithPoint:(CGPoint)point {
	thumbImageView.center = CGPointMake(point.x, self.frame.size.height / 2.0f);
	CGRect frame = thumbImageView.frame;
	if (frame.origin.x < 0) {
		frame.origin.x = 0;
		thumbImageView.frame = frame;
	} else if (frame.origin.x + frame.size.width > self.frame.size.width){
		frame.origin.x = self.frame.size.width - frame.size.width;
		thumbImageView.frame = frame;
	}
	
	_value = _minimumValue + (frame.origin.x / [self frameRange]) * [self valueRange];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint beginPoint = [touches.anyObject locationInView:self];
    [self valueChangedWithPoint:beginPoint];
	[self sendActionsForControlEvents:UIControlEventEditingDidBegin];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	[super touchesBegan:touches withEvent:event];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[super beginTrackingWithTouch:touch withEvent:event];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint currentPoint = [touch locationInView:self];
	[self valueChangedWithPoint:currentPoint];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[super endTrackingWithTouch:touch withEvent:event];
	[self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

@end

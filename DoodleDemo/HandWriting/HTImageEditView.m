//
//  UIImageEditView.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-28.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "HTImageEditView.h"

#define KWIDTH (self.width / 5.0f)
#define KHEIGHT (self.height / 5.0f)

@interface HTImageEditView ()
{
	NSMutableArray *images;
	
	CGPoint lastDrawPoint;
//	UIView *cursor;
	UIImageView *cursor;
}

@end

@implementation HTImageEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		images = [NSMutableArray array];
//		cursor = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2.0f, KHEIGHT - 4.0f)];
//		cursor.backgroundColor = [UIColor blueColor];
//		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//		[animation setToValue:@0.0f];
//		[animation setDuration:0.8f];
//		[animation setTimingFunction:[CAMediaTimingFunction
//									  functionWithName:kCAMediaTimingFunctionDefault]];
//		[animation setAutoreverses:YES];
//		[animation setRepeatCount:20000];
//		[cursor.layer addAnimation:animation forKey:@"opacity"];
//		[self addSubview:cursor];
		cursor = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2.0f, KHEIGHT - 4.0f)];
		cursor.animationImages = @[[UIImage imageNamed:@"cursor1"], [UIImage imageNamed:@"cursor2"]];
		cursor.animationDuration = 1.0f;
		[cursor startAnimating];
        [self addSubview:cursor];
    }
    return self;
}

- (CGPoint)validateDrawPoint:(CGPoint)point {
	if (point.x + KWIDTH > self.width) {
		point.x = 0.0f;
		point.y += KHEIGHT;
	}
	return point;
}

- (void)drawRect:(CGRect)rect {
	cursor.hidden = YES;
	CGPoint point = CGPointZero;
	for (UIImage *image in images) {
		point = [self validateDrawPoint:point];
		if (point.y + KHEIGHT > self.height) {
			break;
		}
		if ([image isKindOfClass:[UIImage class]]) {
			[image drawAtPoint:point];
		}
		point.x += KWIDTH;
		point = [self validateDrawPoint:point];
	}
	
	lastDrawPoint = point;
	
	CGRect frame = cursor.frame;
	frame.origin.x = lastDrawPoint.x + 5.0f;
	frame.origin.y = lastDrawPoint.y - 2.0f;
	cursor.frame = frame;
	cursor.hidden = NO;
}

- (void)addImage:(UIImage *)image {
	image = [image imageByScalingProportionallyToSize:CGSizeMake(KWIDTH, KHEIGHT)];
	[images addObject:image];
	[self setNeedsDisplay];
}

- (void)newline {
	if (lastDrawPoint.y + KHEIGHT <= self.height) {
		for (int i = 0; i < floorf((self.width - lastDrawPoint.x) / KWIDTH) ; i++) {
			[images addObject:[NSNull null]];
		}
	}
	
	[self setNeedsDisplay];
}

- (void)backspace {
	[images removeLastObject];
	
	__block NSRange range = NSMakeRange(0, 0);
	[images enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[NSNull class]] && (idx + 1) % 5 != 0) {
			range.location = idx;
			range.length += 1;
		} else {
			*stop = YES;
		}
	}];
	
	[images removeObjectsInRange:range];
	
	[self setNeedsDisplay];
}

- (UIImage *)done {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
	return viewImage;
}

- (void)clearDrawing {
	[images removeAllObjects];
	[self setNeedsDisplay];
}

@end

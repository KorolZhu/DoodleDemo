//
//  DrawView.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-4.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "HTDoodleDrawView.h"

@interface HTDoodleDrawView ()<HTDoodleDrawViewDelegate>
{
	UIImageView *backgroudImageView;
}

@end

@implementation HTDoodleDrawView

@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_drawview = [[_HTDoodleDrawView alloc] initWithFrame:frame];
		_drawview.delegate = self;
		_drawview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backgroudImageView = [[UIImageView alloc] initWithFrame:frame];
		backgroudImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backgroudImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self addSubview:backgroudImageView];
		[self addSubview:_drawview];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)image {
	backgroudImageView.image = image;
	_drawview.empty = NO;
}

- (CGFloat)lineWidth {
    return [_drawview lineWidth];
}

- (void)setLineWidth:(CGFloat)lineWidth {
	_lineWidth = lineWidth;
	[_drawview setLineWidth:lineWidth];
}

- (UIColor *)lineColor {
    return [_drawview lineColor];
}

- (void)setLineColor:(UIColor *)lineColor {
	_lineColor = lineColor;
	[_drawview setLineColor:lineColor];
}

- (BOOL)isEmpty {
	return _drawview.isEmpty;
}

- (void)clearDrawing {
	backgroudImageView.image = nil;
	[_drawview clearDrawing];
}

- (void)undo {
	[_drawview undo];
}

- (void)redo {
	[_drawview redo];
}

- (UIImage *)done {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
	return viewImage;
}

- (BOOL)doodleDrawViewWillStartDraw:(_HTDoodleDrawView *)drawView {
	return [self.delegate doodleDrawViewWillStartDraw:drawView];
}

- (void)doodleDrawViewDidStartDraw:(_HTDoodleDrawView *)drawView {
	[self.delegate doodleDrawViewDidStartDraw:drawView];
}

@end

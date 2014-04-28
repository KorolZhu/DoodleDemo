//
//  HTHandWritingView.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-28.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "HTHandWritingView.h"
#import "_HTDoodleDrawView.h"
#import "HTImageEditView.h"

@interface HTHandWritingView ()<HTDoodleDrawViewDelegate>
{
	HTImageEditView *_imageEditView;
	
	NSTimer *timer;
}

@end

@implementation HTHandWritingView

@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		_imageEditView = [[HTImageEditView alloc] initWithFrame:frame];
		_imageEditView.backgroundColor = RGB(243, 243, 243);
		[self addSubview:_imageEditView];
		
		_drawview = [[_HTDoodleDrawView alloc] initWithFrame:frame];
		_drawview.delegate = self;
		_drawview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_drawview];
    }
    return self;
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
	return _imageEditView.isEmpty;
}

- (void)clearDrawing {
	[_drawview clearDrawing];
}

- (void)newline {
	[_imageEditView newline];
}

- (void)backspace {
	[_imageEditView backspace];
}

- (UIImage *)done {
	return [_imageEditView done];
}

- (void)didWrite {
	UIImage *image = [_drawview done];
	[_drawview clearDrawing];
	[_imageEditView addImage:image];
}

- (BOOL)doodleDrawViewWillStartDraw:(_HTDoodleDrawView *)drawView {
	return [self.delegate doodleDrawViewWillStartDraw:drawView];
}

- (void)doodleDrawViewDidStartDraw:(_HTDoodleDrawView *)drawView {
	[self.delegate doodleDrawViewDidStartDraw:drawView];
	
	[timer invalidate];
}

- (void)doodleDrawViewDidEndDraw:(_HTDoodleDrawView *)drawView {
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(didWrite) userInfo:nil repeats:NO];
}

@end

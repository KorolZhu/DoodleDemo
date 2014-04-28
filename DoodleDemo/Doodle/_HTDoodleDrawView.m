//
//  DrawView.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-3.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "_HTDoodleDrawView.h"
#import "HTBezierPath.h"

@interface _HTDoodleDrawView ()
{
	CGPoint _lastPoint;
    CGPoint _prePreviousPoint;
    CGPoint _previousPoint;
    HTBezierPath *_drawingPath;
    
    BOOL isUndo;
}

@end

@implementation _HTDoodleDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = YES;

    // defaults
	self.empty = YES;
    _lineWidth = 5.0f;
    _lineColor = [UIColor blackColor];
	
	_pathArray = [NSMutableArray array];
	_bufferArray = [NSMutableArray array];
    
    _drawingPath = [[HTBezierPath alloc] init];
    [_drawingPath setLineWidth:_lineWidth];
	[_drawingPath setLineColor:_lineColor];
    [_drawingPath setLineCapStyle:kCGLineCapRound];
}

- (void)setLineColor:(UIColor *)lineColor {
	_lineColor = lineColor;
//    [self cacheCurrentDrawing];
//    [self flushDrawingPath];
	_drawingPath.lineColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
//    [self cacheCurrentDrawing];
//    [self flushDrawingPath];
    _drawingPath.lineWidth = lineWidth;
}

- (void)clearDrawing {
    self.backgroundColor = [UIColor clearColor];
	[self willChangeValueForKey:@"pathArray"];
	[self willChangeValueForKey:@"bufferArray"];
	[_pathArray removeAllObjects];
	[_bufferArray removeAllObjects];
	[self didChangeValueForKey:@"pathArray"];
	[self didChangeValueForKey:@"bufferArray"];
    [_drawingPath removeAllPoints];
    isUndo = NO;
    [self setNeedsDisplay];
	self.empty = YES;
}

- (void)undo {
	if (_pathArray.count > 0) {
        isUndo = YES;
        
		UIBezierPath *path = [_pathArray lastObject];
		[self willChangeValueForKey:@"pathArray"];
		[self willChangeValueForKey:@"bufferArray"];
		[_pathArray removeLastObject];
		[_bufferArray addObject:path];
		[self didChangeValueForKey:@"pathArray"];
		[self didChangeValueForKey:@"bufferArray"];
		[self setNeedsDisplay];
		
	}
}

- (void)redo {
	if ([_bufferArray count] > 0) {
		UIBezierPath *path = [_bufferArray lastObject];
		[self willChangeValueForKey:@"pathArray"];
		[self willChangeValueForKey:@"bufferArray"];
		[_bufferArray removeLastObject];
		[_pathArray addObject:path];
		[self didChangeValueForKey:@"pathArray"];
		[self didChangeValueForKey:@"bufferArray"];
		[self setNeedsDisplay];
	}
}

- (UIImage *)done {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
	return viewImage;
}

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}

- (void)cacheCurrentDrawing {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:viewImage];
    UIGraphicsEndImageContext();
}

- (void)flushDrawingPath {
    [_drawingPath removeAllPoints];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    if (isUndo) {
        self.backgroundColor = [UIColor clearColor];
		CGContextClearRect(context, self.bounds);
        for (HTBezierPath *path in _pathArray) {
			if ([path.lineColor isEqual:[UIColor clearColor]]) {
				[path.lineColor setStroke];
				[path strokeWithBlendMode:kCGBlendModeClear alpha:1.0f];
			} else {
				[path.lineColor setStroke];
				[path strokeWithBlendMode:kCGBlendModeNormal alpha:CGColorGetAlpha(path.lineColor.CGColor)];
			}
        }
    } else {
		if ([_drawingPath.lineColor isEqual:[UIColor clearColor]]) {
			[_drawingPath.lineColor setStroke];
			[_drawingPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0f];
		} else {
			[_drawingPath.lineColor setStroke];
			[_drawingPath strokeWithBlendMode:kCGBlendModeNormal alpha:CGColorGetAlpha(_drawingPath.lineColor.CGColor)];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isUndo) {
		[self cacheCurrentDrawing];
		isUndo = NO;
	}

    UITouch *touch = [touches anyObject];
    _previousPoint = [touch locationInView:self];
	
	if ([self.delegate respondsToSelector:@selector(doodleDrawViewDidStartDraw:)]) {
		[self.delegate doodleDrawViewDidStartDraw:self];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.empty) {
		self.empty = NO;
	}

    UITouch *touch = [touches anyObject];
    
    _prePreviousPoint = _previousPoint;
    _previousPoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGPoint mid1 = [self calculateMidPointForPoint:_previousPoint andPoint:_prePreviousPoint];
    CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:_previousPoint];
    
    [_drawingPath moveToPoint:mid1];
    [_drawingPath addQuadCurveToPoint:mid2 controlPoint:_previousPoint];
    
    _lastPoint = mid2;
    
    [self setNeedsDisplayInRect:CGRectMake(MIN(_prePreviousPoint.x, currentPoint.x) - 30.0f,
										   MIN(_prePreviousPoint.y, currentPoint.y) - 30.0f,
										   fabs(_prePreviousPoint.x - currentPoint.x) + 60.0f,
										   fabs(_prePreviousPoint.y - currentPoint.y) + 60.0f)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (_drawingPath.isEmpty) {
		if ([self.delegate respondsToSelector:@selector(doodleDrawViewWillStartDraw:)] && [self.delegate doodleDrawViewWillStartDraw:self]) {
			
			if (self.empty) {
				self.empty = NO;
			}

			[_drawingPath addArcWithCenter:_previousPoint radius:0.5f startAngle:0.0f endAngle:M_PI * 2  clockwise:YES];
			[self setNeedsDisplayInRect:CGRectMake(_previousPoint.x - self.lineWidth,
												   _previousPoint.y - self.lineWidth,
												   self.lineWidth * 2,
												   self.lineWidth * 2)];
		}
	}
	
	if ([self.delegate respondsToSelector:@selector(doodleDrawViewDidEndDraw:)]) {
		[self.delegate doodleDrawViewDidEndDraw:self];
	}
		
	if (!_drawingPath.isEmpty) {
		HTBezierPath *path = nil;
		if (!IOS7) {
			path = [[HTBezierPath alloc] init];
			path.CGPath = _drawingPath.CGPath;
			path.lineWidth = _drawingPath.lineWidth;
			[path setLineCapStyle:kCGLineCapRound];
		} else {
			path = [_drawingPath copy];
		}
		
		path.lineColor = [_drawingPath.lineColor copy];
		
		[self willChangeValueForKey:@"pathArray"];
		[_pathArray addObject:path];
		[self didChangeValueForKey:@"pathArray"];
		
		[self cacheCurrentDrawing];
		[self flushDrawingPath];
		
		if ([_bufferArray count] > 0) {
			[self willChangeValueForKey:@"bufferArray"];
			[_bufferArray removeAllObjects];
			[self didChangeValueForKey:@"bufferArray"];
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self touchesEnded:touches withEvent:event];
}

@end

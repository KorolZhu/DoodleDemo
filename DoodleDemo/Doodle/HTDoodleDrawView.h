//
//  DrawView.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-4.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_HTDoodleDrawView.h"

@interface HTDoodleDrawView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly, getter = isEmpty) BOOL empty;
@property (nonatomic, strong) _HTDoodleDrawView *drawview;
@property (nonatomic, weak)id<HTDoodleDrawViewDelegate> delegate;

- (void)setBackgroundImage:(UIImage *)image;
- (void)clearDrawing;
- (void)undo;
- (void)redo;
- (UIImage *)done;

@end

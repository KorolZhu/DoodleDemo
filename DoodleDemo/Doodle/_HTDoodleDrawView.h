//
//  DrawView.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-3.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol HTDoodleDrawViewDelegate;

@interface _HTDoodleDrawView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, getter = isEmpty) BOOL empty;
@property (nonatomic, strong)NSMutableArray *pathArray;
@property (nonatomic, strong)NSMutableArray *bufferArray;
@property (nonatomic, weak)id<HTDoodleDrawViewDelegate> delegate;

- (void)clearDrawing;
- (void)undo;
- (void)redo;

@end

@protocol HTDoodleDrawViewDelegate <NSObject>

- (BOOL)doodleDrawViewWillStartDraw:(_HTDoodleDrawView *)drawView;
- (void)doodleDrawViewDidStartDraw:(_HTDoodleDrawView *)drawView;

@end
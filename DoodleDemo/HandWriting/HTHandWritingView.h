//
//  HTHandWritingView.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-28.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTImageEditView.h"

@protocol HTDoodleDrawViewDelegate;

@interface HTHandWritingView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly, getter = isEmpty) BOOL empty;
@property (nonatomic, strong) HTImageEditView *imageEditView;
;
@property (nonatomic, weak)id<HTDoodleDrawViewDelegate> delegate;

- (void)clearDrawing;
- (void)newline;
- (void)backspace;
- (UIImage *)done;

@end

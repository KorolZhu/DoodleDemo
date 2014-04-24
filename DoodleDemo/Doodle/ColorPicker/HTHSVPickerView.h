//
//  HTColorPickerView.h
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-13.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"

@protocol HTHSVPickerViewDelegate <NSObject>

- (void)HSVPickerViewDidCancel;
- (void)HSVPickerViewDidFinished:(UIColor *)color;

@end

@interface HTHSVPickerView : UIView

@property (nonatomic, weak)id<HTHSVPickerViewDelegate> delegate;
@property (nonatomic) UIColor *color;
@property (nonatomic) UIColor *defaultColor;

@end

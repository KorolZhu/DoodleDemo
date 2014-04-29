//
//  UIImageEditView.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-28.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImageEditView : UIView

@property (nonatomic, getter = isEmpty) BOOL empty;
@property (nonatomic, getter=isEditable) BOOL editable;

- (void)addImage:(UIImage *)image;
- (void)newline;
- (void)backspace;
- (UIImage *)done;
- (void)clearDrawing;

@end

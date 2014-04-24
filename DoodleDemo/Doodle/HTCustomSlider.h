//
//  CustomSlider.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-11.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCustomSlider : UIControl

@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property (nonatomic, strong)UIImage *trackImage;
@property (nonatomic, strong)UIImage *thumbImage;

@end

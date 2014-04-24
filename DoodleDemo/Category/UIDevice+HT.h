//
//  UIDevice+HT.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IOS7 [[UIDevice currentDevice] isIOS7]

@interface UIDevice (HT)

- (NSInteger)majorVersion;

- (BOOL)isIOS7;
- (BOOL)isPad;

@end

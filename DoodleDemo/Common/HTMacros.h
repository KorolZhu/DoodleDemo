//
//  HTMacros.h
//  HelloTalk_Binary
//
//  Created by 任健生 on 13-7-18.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#ifndef HelloTalk_Binary_HTMacros_h
#define HelloTalk_Binary_HTMacros_h

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 1136.0f), [[UIScreen mainScreen] currentMode].size) : NO)

//动态获取设备高度
#define IPHONE_STATUSBAR_WIDTH          [UIApplication sharedApplication].statusBarFrame.size.width
#define IPHONE_STATUSBAR_HEIGHT         [UIApplication sharedApplication].statusBarFrame.size.height
#define IPHONE_HEIGHT                   [UIScreen mainScreen].bounds.size.height
#define IPHONE_HEIGHT_WITHOUTSTATUSBAR  [UIScreen mainScreen].bounds.size.height - IPHONE_STATUSBAR_HEIGHT
#define IPHONE_HEIGHT_WITHOUTTOPBAR     [UIScreen mainScreen].bounds.size.height - 44 - IPHONE_STATUSBAR_HEIGHT
#define IPHONE_WIDTH                    [UIScreen mainScreen].bounds.size.width

#define IPHONE_WIDTHDIFF                IPHONE_WIDTH - 320.0f
#define IPHONE_HEIGHTDIFF               IPHONE_HEIGHT - 480.0f
#define IPHONE_WIDTHDIFF_HALF           (IPHONE_WIDTH - 320.0f) / 2.0f
#define IPHONE_HEIGHTDIFF_HALF          (IPHONE_HEIGHT - 480.0f) / 2.0f

#endif

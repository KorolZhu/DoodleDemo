//
//  HTActionSheet.h
//  HelloTalk_Binary
//
//  Created by 任健生 on 13-7-20.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTActionSheetBlock)(NSInteger);

@interface HTActionSheet : UIActionSheet <UIActionSheetDelegate>

@property(nonatomic,copy) HTActionSheetBlock block;

@end

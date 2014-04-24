//
//  HTActionSheet.m
//  HelloTalk_Binary
//
//  Created by 任健生 on 13-7-20.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import "HTActionSheet.h"

@interface HTActionSheet ()

@property(nonatomic,copy) HTActionSheetBlock actionBlock;

@end

@implementation HTActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBlock:(HTActionSheetBlock)block {
    self.delegate = self;
    self.actionBlock = block;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (self.actionBlock) {
        
        if ([NSThread isMainThread]) {
            self.actionBlock(buttonIndex);
            self.actionBlock = nil;
        } else {
            __block __weak typeof (self) weakSelf = self;
            [self performBlockOnMainThread: ^{
                weakSelf.actionBlock(buttonIndex);
                weakSelf.actionBlock = nil;
            }];
        }
        
    }
}



@end

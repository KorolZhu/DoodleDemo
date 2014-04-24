//
//  UIDevice+HT.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "UIDevice+HT.h"

@implementation UIDevice (HT)

- (NSInteger)majorVersion {
    static NSInteger result = -1;
    if (result == -1) {
        NSNumber *majorVersion = [[self.systemVersion componentsSeparatedByString:@"."] objectAtIndex:0];
        result = majorVersion.integerValue;
    }
    return result;
}

- (BOOL)isIOS7 {
    
    static int initIsIOS7 = -1;
    static BOOL isIOS7;
    
    if (initIsIOS7 == -1) {
        isIOS7 = ([self majorVersion] >= 7);
        initIsIOS7 = 1;
    }
    
    return isIOS7;
}

- (BOOL)isPad {
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end

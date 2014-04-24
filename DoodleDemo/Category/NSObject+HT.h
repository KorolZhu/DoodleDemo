//
//  NSObject+HT.h
//  HelloTalk_Binary
//
//  Created by 任健生 on 13-6-19.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HT)

- (void)addNotificationWithName:(NSString *)name selector:(SEL)selector;
- (void)removeObserverWithNotificationName:(NSString *)name;

- (void)performBlockInBackground:(dispatch_block_t)block;
- (void)performBlockOnMainThread:(dispatch_block_t)block;
- (void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay;

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay;
- (void)customPerformSelectorOnMainThread:(SEL)selector withObject:(id)object waitUntilDone:(BOOL)wait;



@end

//
//  NSObject+HT.m
//  HelloTalk_Binary
//
//  Created by 任健生 on 13-6-19.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import "NSObject+HT.h"

@implementation NSObject (HT)

static NSOperationQueue *backgroundQueue;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundQueue = [[NSOperationQueue alloc] init];
        backgroundQueue.maxConcurrentOperationCount = 6;
    });
}

- (void)addNotificationWithName:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void)removeObserverWithNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)performBlockInBackground:(dispatch_block_t)block {
    [backgroundQueue addOperationWithBlock:block];
}

- (void)performBlockOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(),block);
    }
    
}

- (void)performBlock:(dispatch_block_t)block afterDelay:(double)delay {
    [self performSelector:@selector(performDelayBlock:) withObject:block afterDelay:delay];
}

- (void)performDelayBlock:(dispatch_block_t)block {
    block();
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self performSelector:selector withObject:object afterDelay:delay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:selector withObject:object afterDelay:delay];
        });
    }
}

- (void)customPerformSelectorOnMainThread:(SEL)selector withObject:(id)object waitUntilDone:(BOOL)wait{
    if ([self respondsToSelector:selector]) {
        [self performSelectorOnMainThread:selector withObject:object waitUntilDone:wait];
    }
}

@end

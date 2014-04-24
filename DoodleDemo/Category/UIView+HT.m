//
//  UIView+HT.m
//  helloTalk
//
//  Created by 任健生 on 13-3-4.
//
//

#import "UIView+HT.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIView (HT)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    return curve << 16;
}

+ (UIViewAnimationOptions)keyboardAnimationOptions {
    return IOS7 ? 7 << 16 : 0;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (BOOL)containSubviewWithClass:(Class)clazz {
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return YES;
        } else {
            if ([subView containSubviewWithClass:clazz]) {
                return YES;
            }
        }
    }
    
    return NO;
}


@end

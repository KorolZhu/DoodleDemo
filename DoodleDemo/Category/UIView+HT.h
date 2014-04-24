//
//  UIView+HT.h
//  helloTalk
//
//  Created by 任健生 on 13-3-4.
//
//

#import <UIKit/UIKit.h>

@interface UIView (HT)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
+ (UIViewAnimationOptions)keyboardAnimationOptions;

- (BOOL)containSubviewWithClass:(Class)clazz;
//- (UIView *)subviewWithClass:(Class)clazz;

@end

@interface UIView (Private)

- (NSString *)recursiveDescription;

@end

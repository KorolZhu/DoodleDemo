//
//  UIColor+HT.m
//  helloTalk
//
//  Created by 任健生 on 13-4-4.
//
//

#import "UIColor+HT.h"

@implementation UIColor (HT)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue {
    return [UIColor rgbColorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end

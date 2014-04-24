//
//  UIColor+HT.h
//  helloTalk
//
//  Created by 任健生 on 13-4-4.
//
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor rgbColorWithRed:r green:g blue:b]
#define RGBA(r,g,b,a) [UIColor rgbColorWithRed:r green:g blue:b alpha:a]

@interface UIColor (HT)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue;
+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end

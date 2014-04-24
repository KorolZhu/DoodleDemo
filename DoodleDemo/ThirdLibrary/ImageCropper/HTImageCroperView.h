//
//  HTImageCroperView.h
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImageCroperView : UIView

- (id)initWithFrame:(CGRect)frame croperSize:(CGSize)size image:(UIImage *)image;

- (void)rotateLeftAnimated;
- (UIImage *)crop;

@end

//
//  HTImageCroperViewController.h
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTImageCroperDelegate;

@interface HTImageCroperViewController : UIViewController

@property(nonatomic,weak)id<HTImageCroperDelegate> delegate;

- (id)initWithCroperSize:(CGSize)size image:(UIImage *)image;

@end

@protocol HTImageCroperDelegate <NSObject>

- (void)imageCropper:(HTImageCroperViewController *)cropper didFinished:(UIImage *)image;
- (void)imageCropperDidCancel:(HTImageCroperViewController *)cropper;

@end

//
//  HTDoodleViewController.h
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-11.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTDoodleViewControllerDelegate;

@interface HTDoodleViewController : UIViewController

@property (nonatomic, weak)id<HTDoodleViewControllerDelegate> delegate;

@end

@protocol HTDoodleViewControllerDelegate <NSObject>

- (void)doodleViewControllerDidCancel:(HTDoodleViewController *)doodleViewController;
- (void)doodleViewController:(HTDoodleViewController *)doodleViewController didFinished:(UIImage *)image ;

@end

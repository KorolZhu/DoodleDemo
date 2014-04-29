//
//  HTWhiteBoradViewController.h
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-29.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTWhiteBoradViewControllerDelegate;

@interface HTWhiteBoradViewController : UIViewController

@property (nonatomic, weak)id<HTWhiteBoradViewControllerDelegate> delegate;

@end

@protocol HTWhiteBoradViewControllerDelegate <NSObject>

- (void)doodleViewControllerDidCancel:(HTWhiteBoradViewController *)doodleViewController;
- (void)doodleViewController:(HTWhiteBoradViewController *)doodleViewController didFinished:(UIImage *)image ;

@end

//
//  HTCroperMaskView.h
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCroperMaskView : UIView

@property(nonatomic)CGSize cropsize;
@property(nonatomic,readonly)CGRect cropRect;

@end

//
//  HTImageCroperViewController.m
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import "HTImageCroperViewController.h"
#import "HTImageCroperView.h"
#import "HTCroperMaskView.h"

@interface HTImageCroperViewController ()
{
    HTImageCroperView       *_croperView;
	
	BOOL                    _leaveStatusBarAlone;
	BOOL                    _previousStatusBarHidden;
	BOOL                    _previousNavBarHidden;
    UIBarStyle              _previousNavBarStyle;
	UIImage                 *_previousNavigationBarBackgroundImageDefault;
	UIStatusBarStyle         _previousStatusBarStyle;
}

@end

@implementation HTImageCroperViewController

- (id)initWithCroperSize:(CGSize)size image:(UIImage *)image{
    self = [super init];
    if (self) {
        if (IOS7) {
            self.edgesForExtendedLayout = UIRectEdgeAll;
            self.extendedLayoutIncludesOpaqueBars = YES;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        else
//            self.wantsFullScreenLayout = YES;
        CGRect frame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            frame = CGRectMake(0.0f, 0.0f, 320.0f, 443.0f);
        else
            frame = [[UIScreen mainScreen] bounds];
        _croperView = [[HTImageCroperView alloc] initWithFrame:frame croperSize:size image:image];
        _croperView.backgroundColor = [UIColor blackColor];
        _croperView.clipsToBounds = YES;
    }
    return self;
}

- (void)loadView{
    self.view = _croperView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([[UIDevice currentDevice] isPad]) {
        CGSize size = CGSizeMake(320, 480);
        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
            [self setPreferredContentSize:size];
        }
        else
            self.contentSizeForViewInPopover = size;
    }
    [super viewWillAppear:animated];
    [self storePreviousNavBarAppearance];
	[self setNavBarAppearance:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
	[self restorePreviousNavBarAppearance:YES];
}

- (void)setUpUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)];

    CGRect frame;
    if ([[UIDevice currentDevice] isPad])
        frame = CGRectMake(0, 443.0f - 44.0f, 320.0f, 44.0f);
    else
        frame = CGRectMake(0, self.view.frame.size.height - 44.0f, 320.0f, 44.0f);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setTranslucent:YES];
    
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSString *text = NSLocalizedString(@"Move and Scale", @"");
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:20.f]];
    UILabel *moveAndScaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    moveAndScaleLabel.backgroundColor = [UIColor clearColor];
    moveAndScaleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    moveAndScaleLabel.text = text;
    moveAndScaleLabel.textColor = [UIColor whiteColor];
    moveAndScaleLabel.shadowOffset = CGSizeMake(0, 1);
    UIBarButtonItem *moveAndScaleItem = [[UIBarButtonItem alloc] initWithCustomView:moveAndScaleLabel];
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btn_rotationRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture_rotation_left"] style:UIBarButtonItemStylePlain target:self.view action:@selector(rotateLeftAnimated)];
    [toolbar setItems:[NSArray arrayWithObjects:flexItem1,moveAndScaleItem,flexItem2,btn_rotationRight, nil]];
    [self.view addSubview:toolbar];
}

- (void)finishCropping{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropper:didFinished:)]) {
        [self.delegate imageCropper:self didFinished:[_croperView crop]];
    }
}

#pragma mark - Nav Bar Appearance

- (void)setNavBarAppearance:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
	navBar.barStyle = UIBarStyleBlackTranslucent;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

- (void)storePreviousNavBarAppearance {
    _previousStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
	_previousNavBarHidden = self.navigationController.isNavigationBarHidden;
	if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
	_previousNavBarStyle = self.navigationController.navigationBar.barStyle;
	_previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
	if (self.navigationController.topViewController != self) {
		[[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHidden withAnimation:UIStatusBarAnimationFade];
		[self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
		UINavigationBar *navBar = self.navigationController.navigationBar;
		if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
			[navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
		}
		navBar.barStyle = _previousNavBarStyle;
		[[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
	} else {
		
		[[UIApplication sharedApplication] setStatusBarHidden:[self presentingViewControllerPrefersStatusBarHidden] withAnimation:UIStatusBarAnimationFade];
	}
    
}

- (BOOL)presentingViewControllerPrefersStatusBarHidden {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        if ([presenting isKindOfClass:[UINavigationController class]]) {
            presenting = [(UINavigationController *)presenting topViewController];
        }
    } else {
        // We're in a navigation controller so get previous one!
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
            presenting = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        }
    }
    if (presenting && [presenting respondsToSelector:@selector(prefersStatusBarHidden)]) {
		return [presenting prefersStatusBarHidden];
    } else {
        return NO;
    }
}

@end

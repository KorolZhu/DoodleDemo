//
//  HTImagePickerController.m
//  helloTalk
//
//  Created by tcj on 12-12-4.
//
//

#import "HTImagePickerController.h"


@implementation HTImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)prefersStatusBarHidden
{
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        return YES;
    }
    return NO;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}


@end

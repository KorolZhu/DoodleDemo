//
//  HTWhiteBoradViewController.m
//  DoodleDemo
//
//  Created by zhuzhi on 14-4-29.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "HTWhiteBoradViewController.h"
#import "HTDoodleDrawView.h"
#import "HTHandWritingView.h"
#import "HTImagePickerController.h"
#import "HTCustomSlider.h"
#import "HTHSVPickerView.h"
#import "HTImageCroperViewController.h"
#import "MBProgressHUD.h"
#import "HTActionSheet.h"

typedef enum {
	HTDrawTypeHandWriting,
	HTDrawTypeDoodle,
}HTDrawType;

typedef enum {
	HTDrawBarButtonItemPen,
	HTDrawBarButtonItemErase,
	HTDrawBarButtonItemColor,
	HTDrawBarButtonItemUndo,
	HTDrawBarButtonItemRedo,
	HTDrawBarButtonItemPhoto,
	HTDrawBarButtonItemNewLine,
	HTDrawBarButtonItemBackSpace,
	HTDrawBarButtonItemClear,
}HTDrawBarButtonItem;

@interface HTWhiteBoradViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HTHSVPickerViewDelegate,UIActionSheetDelegate,HTImageCroperDelegate,HTDoodleDrawViewDelegate>
{
	UISegmentedControl *segmentControl;
	
	UIView *toolBar;

	HTDoodleDrawView *drawView;
	UIButton *penButtonItem;
	UIButton *eraseButtonItem;
	UIButton *colorButtonItem;
	UIButton *undoButtonItem;
    UIButton *redoButtonItem;
	UIButton *photoButtonItem;
	UIButton *clearButtonItem;

	HTHandWritingView *handwritingView;
	UIButton *newlineButtonItem;
	UIButton *backspaceButtonItem;
	
	HTCustomSlider *penSizeSlider;
	UIImageView *penTriangleImageView;
	UIView *penSliderPanelView;
	UIView *sizeCircleView;
	
	HTCustomSlider *eraseSizeSlider;
	UIImageView *eraseTriangleImageView;
	UIView *eraseSliderPanelView;
	
    CALayer *colorButtonItemBacklayer;
	UIImageView *colorTriangleImageView;
	UIView *colorPanelView;
    UIButton *lastColorSelectedButton;
    HTHSVPickerView *hsvPickerView;
	UIButton *customColorButton;
	CALayer *customColorButtonLayer;
	
	UIPopoverController *imagePopoverContr;
}

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIColor *drawColor;
@property (nonatomic, assign) BOOL hasPanelViewShowed;

@end

@implementation HTWhiteBoradViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self setupUI];
	
	[drawView.drawview addObserver:self forKeyPath:@"empty" options:NSKeyValueObservingOptionNew context:NULL];
	[drawView.drawview addObserver:self forKeyPath:@"pathArray" options:NSKeyValueObservingOptionNew context:NULL];
	[drawView.drawview addObserver:self forKeyPath:@"bufferArray" options:NSKeyValueObservingOptionNew context:NULL];
	
	[handwritingView.imageEditView addObserver:self forKeyPath:@"empty" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	self.view.backgroundColor = RGB(243, 243, 243);
	
	if (!IOS7) {
		UIImage *navBtnBg = [[UIImage imageNamed:@"nav_btn"] stretchableImageWithLeftCapWidth:5 topCapHeight:30];
        UIImage *navBtnBgPressed = [[UIImage imageNamed:@"nav_btn_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:30];
		
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"Send Button") style:UIBarButtonItemStyleDone target:self action:@selector(send)];
        [rightBarItem setBackgroundImage:navBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [rightBarItem setBackgroundImage:navBtnBgPressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = rightBarItem;
		
		UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
        [leftBarItem setBackgroundImage:navBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [leftBarItem setBackgroundImage:navBtnBgPressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = leftBarItem;
		
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	}
	
	segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"HandWriting", nil), NSLocalizedString(@"Doodle", nil)]];
	[segmentControl setSelectedSegmentIndex:HTDrawTypeDoodle];
	[segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmentControl;
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	// draw view
	drawView = [[HTDoodleDrawView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f)];
	drawView.delegate = self;
	drawView.backgroundColor = RGB(243, 243, 243);
	drawView.lineWidth = 5.0f;
	
	//	NSData *data = [[HTUserCache sharedCache] objectForKey:HT_DoodleColorSelected];
	//	if (data.length > 0) {
	//		UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	//		drawView.lineColor = color;
	//		self.drawColor = color;
	//	} else {
	drawView.lineColor = RGB(23, 137, 229);
	self.drawColor = RGB(23, 137, 229);
	//	}
	[self.view addSubview:drawView];
	
	// handwriting view
	handwritingView = [[HTHandWritingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f)];
	handwritingView.delegate = self;
	handwritingView.backgroundColor = RGB(243, 243, 243);
	handwritingView.lineWidth = drawView.lineWidth;
	handwritingView.lineColor = drawView.lineColor;
	[self.view addSubview:handwritingView];
	handwritingView.hidden = YES;
    
    // Tool Bar
	toolBar = [[UIView alloc] initWithFrame:CGRectMake(-1.0f, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f , IPHONE_WIDTH + 2.0f, 52.0f)];
	toolBar.backgroundColor = RGB(229, 229, 229);
	toolBar.layer.borderColor = RGB(204, 204, 204).CGColor;
	toolBar.layer.borderWidth = 1.0f;
	
	
	NSArray *itemImages = @[@"doodle_pan", @"doodle_eraser", @"doodle_transparency", @"doodle_undo", @"doodle_redo", @"doodle_photo", @"setp_back_mark", @"emoji_delete", @"doodle_del"];
	for (int i = 0; i < itemImages.count; i ++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0.0f, 0.0f, 52.0f, 50.0f);
		button.tag = i;
		[button setImage:[UIImage imageNamed:[itemImages objectAtIndex:i]] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
		if (i == 0) {
			penButtonItem = button;
		} else if (i == 1) {
			eraseButtonItem = button;
		} else if (i == 2) {
			colorButtonItem = button;
		} else if (i == 3) {
			undoButtonItem = button;
		} else if (i == 4) {
			redoButtonItem = button;
		} else if (i == 5) {
			photoButtonItem = button;
		} else if (i == 6) {
			newlineButtonItem = button;
		} else if (i == 7) {
			backspaceButtonItem = button;
		} else if (i == 8) {
			clearButtonItem = button;
		}
	}
	
	colorButtonItem.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
	colorButtonItem.layer.cornerRadius = 12.0f;
	colorButtonItem.layer.masksToBounds = YES;
	colorButtonItemBacklayer = [[CALayer alloc] init];
	colorButtonItemBacklayer.backgroundColor = [[drawView lineColor] CGColor];
	colorButtonItemBacklayer.frame = colorButtonItem.bounds;
	[colorButtonItem.layer addSublayer:colorButtonItemBacklayer];
	
	undoButtonItem.enabled = NO;
	redoButtonItem.enabled = NO;
	clearButtonItem.enabled = NO;
			
	// Pen Slider
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 50.0f)];
	topView.backgroundColor = RGB(84, 84, 84);
	
	penTriangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_pop_up_triangle"]];
	
	UIImageView *frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_pan_size_frame"]];
	frameImageView.userInteractionEnabled = YES;
	frameImageView.frame = CGRectMake(9.0f, 8.0f, 302.0f, 34.0f);
	
	penSliderPanelView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 60.0f)];
	penSliderPanelView.backgroundColor = [UIColor clearColor];
	penSliderPanelView.userInteractionEnabled = YES;
	CGRect frame = penSliderPanelView.frame;
	frame.origin.y = IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f;
	penSliderPanelView.frame = frame;
	penSliderPanelView.hidden = YES;
	[penSliderPanelView addSubview:topView];
	[penSliderPanelView addSubview:penTriangleImageView];
	[penSliderPanelView addSubview:frameImageView];
	
	penSizeSlider = [[HTCustomSlider alloc] initWithFrame:CGRectMake(9.0f, 8.0f, 302.0f, 34.0f)];
	penSizeSlider.backgroundColor = [UIColor clearColor];
	[penSizeSlider setTrackImage:[UIImage imageNamed:@"doodle_pan_size_trend"]];
	[penSizeSlider setThumbImage:[UIImage imageNamed:@"doodle_pan_size_handle"]];
	penSizeSlider.minimumValue = 2.0f;
	penSizeSlider.maximumValue = 32.f;
	penSizeSlider.value = 5.0f;
	[penSizeSlider addTarget:self action:@selector(sliderDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
	[penSizeSlider addTarget:self action:@selector(sliderDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
	[penSizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[penSliderPanelView addSubview:penSizeSlider];
	
	[self.view addSubview:penSliderPanelView];
	
	// Erase Slider
	
	topView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 50.0f)];
	topView.backgroundColor = RGB(84, 84, 84);
	
	eraseTriangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_pop_up_triangle"]];
	
	frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_pan_size_frame"]];
	frameImageView.userInteractionEnabled = YES;
	frameImageView.frame = CGRectMake(9.0f, 8.0f, 302.0f, 34.0f);
	
	eraseSliderPanelView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 60.0f)];
	eraseSliderPanelView.backgroundColor = [UIColor clearColor];
	eraseSliderPanelView.userInteractionEnabled = YES;
	frame = eraseSliderPanelView.frame;
	frame.origin.y = IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f;
	eraseSliderPanelView.frame = frame;
	eraseSliderPanelView.hidden = YES;
	[eraseSliderPanelView addSubview:topView];
	[eraseSliderPanelView addSubview:eraseTriangleImageView];
	[eraseSliderPanelView addSubview:frameImageView];
	
	eraseSizeSlider = [[HTCustomSlider alloc] initWithFrame:CGRectMake(9.0f, 8.0f, 302.0f, 34.0f)];
	eraseSizeSlider.backgroundColor = [UIColor clearColor];
	[eraseSizeSlider setTrackImage:[UIImage imageNamed:@"doodle_pan_size_trend"]];
	[eraseSizeSlider setThumbImage:[UIImage imageNamed:@"doodle_pan_size_handle"]];
	eraseSizeSlider.minimumValue = 2.0f;
	eraseSizeSlider.maximumValue = 32.f;
	eraseSizeSlider.value = 5.0f;
	[eraseSizeSlider addTarget:self action:@selector(sliderDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
	[eraseSizeSlider addTarget:self action:@selector(sliderDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
	[eraseSizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[eraseSliderPanelView addSubview:eraseSizeSlider];
	[self.view addSubview:eraseSliderPanelView];
	
    // Color Picker
	
    colorPanelView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f, IPHONE_WIDTH, 130.0f)];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 120.0f)];
	topView.backgroundColor = RGB(84, 84, 84);
    
    colorTriangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_pop_up_triangle"]];
    
    [colorPanelView addSubview:topView];
    [colorPanelView addSubview:colorTriangleImageView];
    
    NSArray *colors = @[[UIColor clearColor], RGB(23, 137, 229), [UIColor whiteColor], RGB(150, 108, 217), RGB(255, 221, 128), RGB(16, 185, 4), RGB(23, 137, 229), [UIColor blackColor], RGB(255, 38, 0), RGB(255, 140, 0)];
	
    BOOL colorMatched = NO;
	
    for (int i = 0; i < colors.count / 5; i++) {
        for (int j = 0; j < 5; j++) {
            int index = i * 5 + j;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = index;
			button.layer.cornerRadius = 5.0f;
            button.frame = CGRectMake(23 + 59 * j, 16 + 52 * i, 36.0f, 36.0f);
            [button addTarget:self action:@selector(colorSelect:) forControlEvents:UIControlEventTouchUpInside];
            [colorPanelView addSubview:button];
			
            if (index == 0) {
                [button setImage:[UIImage imageNamed:@"doodle_color_colordisc"] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
            } else {
				[button setBackgroundColor:colors[index]];
				
				if (index == 1) {
					button.backgroundColor = [UIColor clearColor];
					[button setImage:[UIImage imageNamed:@"doodle_color_transparency"] forState:UIControlStateNormal];
					[button setImage:[UIImage imageNamed:@"doodle_color_transparency"] forState:UIControlStateHighlighted];
					customColorButton = button;
					customColorButtonLayer = [[CALayer alloc] init];
					customColorButtonLayer.cornerRadius = 4.5f;
					customColorButtonLayer.backgroundColor = [colors[index] CGColor];
					customColorButtonLayer.frame = customColorButton.bounds;
					[customColorButton.layer addSublayer:customColorButtonLayer];
				}
				
				if (!colorMatched && [button.backgroundColor isEqual:self.drawColor]) {
					colorMatched = YES;
					[self colorSelect:button];
				}
				
            }
			
        }
    }
	
	if (!colorMatched) {
		customColorButtonLayer.backgroundColor = [self.drawColor CGColor];
		[self colorSelect:customColorButton];
	}
    
    [self.view addSubview:colorPanelView];
    colorPanelView.hidden = YES;
	
	[self.view addSubview:toolBar];
	
	[self setDoodleMode];
	
}

- (void)setupToolBarWithItems:(NSArray *)items {
	for (UIView *view in toolBar.subviews) {
		[view removeFromSuperview];
	}
	
	for (int i = 0; i < items.count; i++) {
		UIView *view = items[i];
		CGPoint center = CGPointZero;
		center.x = toolBar.width / (items.count + 1) * (i + 1);
		center.y = 26.0f;
		view.center = center;
		
		[toolBar addSubview:view];
	}
	
	CGRect frame = penTriangleImageView.frame;
	frame.origin = CGPointMake(penButtonItem.center.x - 9.0f, 50.0f);
	penTriangleImageView.frame = frame;
	
	frame = eraseTriangleImageView.frame;
	frame.origin = CGPointMake(eraseButtonItem.center.x - 9.0f, 50.0f);
	eraseTriangleImageView.frame = frame;
	
	frame = colorTriangleImageView.frame;
	frame.origin = CGPointMake(colorButtonItem.center.x - 9.0f, 120.0f);
	colorTriangleImageView.frame = frame;
}

- (BOOL)swipeBackGestureRecognizerShouldBegin {
	return NO;
}

//- (void)saveDrawColorToDisk {
//	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.drawColor];
//	[[HTUserCache sharedCache] setObject:data forKey:HT_DoodleColorSelected];
//	[[HTUserCache sharedCache] synchronize];
//}

- (void)showPenSliderAnimated:(BOOL)animate {
	penSliderPanelView.hidden = NO;
	penSliderPanelView.frame = CGRectMake(0.0f, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f, IPHONE_WIDTH, 60.0f);
	[UIView animateWithDuration:animate ? 0.3f : 0.0f animations:^{
		CGRect frame = penSliderPanelView.frame;
		frame.origin.y -= 60.0f;
		penSliderPanelView.frame = frame;
	}];
}

- (void)hidePenSliderAnimated:(BOOL)animate {
	[UIView animateWithDuration:animate ? 0.3f : 0.0f animations:^{
		CGRect frame = penSliderPanelView.frame;
		frame.origin.y += 60.0f;
		penSliderPanelView.frame = frame;
	} completion:^(BOOL finished) {
		penSliderPanelView.hidden = YES;
	}];
}

- (void)showEraseSliderAnimated:(BOOL)animate {
	eraseSliderPanelView.hidden = NO;
	eraseSliderPanelView.frame = CGRectMake(0.0f, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f, IPHONE_WIDTH, 60.0f);
	[UIView animateWithDuration:animate ? 0.2f : 0.0f animations:^{
		CGRect frame = eraseSliderPanelView.frame;
		frame.origin.y -= 60.0f;
		eraseSliderPanelView.frame = frame;
	}];
}

- (void)hideEraseSliderAnimated:(BOOL)animate {
	[UIView animateWithDuration:animate ? 0.2f : 0.0f animations:^{
		CGRect frame = eraseSliderPanelView.frame;
		frame.origin.y += 60.0f;
		eraseSliderPanelView.frame = frame;
	} completion:^(BOOL finished) {
		eraseSliderPanelView.hidden = YES;
	}];
}

- (void)showColorPickerAnimated:(BOOL)animate {
	colorPanelView.hidden = NO;
	colorPanelView.frame = CGRectMake(0.0f, IPHONE_HEIGHT_WITHOUTTOPBAR - 51.0f, IPHONE_WIDTH, 130.0f);
	[UIView animateWithDuration:animate ? 0.2f : 0.0f animations:^{
		CGRect frame = colorPanelView.frame;
		frame.origin.y -= 130.0f;
		colorPanelView.frame = frame;
	}];
}

- (void)hideColorPickerAnimated:(BOOL)animate {
	[UIView animateWithDuration:animate ? 0.2f : 0.0f animations:^{
		CGRect frame = colorPanelView.frame;
		frame.origin.y += colorPanelView.frame.size.height;
		colorPanelView.frame = frame;
	} completion:^(BOOL finished) {
		colorPanelView.hidden = YES;
	}];
}

- (BOOL)hasPanelViewShowed {
	if (!penSliderPanelView.hidden || !eraseSliderPanelView.hidden || !colorPanelView.hidden) {
		return YES;
	}
	
	return NO;
}

- (void)hideAllPanelView {
	if (!penSliderPanelView.hidden) {
		[self hidePenSliderAnimated:YES];
	}
	
	if (!eraseSliderPanelView.hidden) {
		[self hideEraseSliderAnimated:YES];
	}
	
	if (!colorPanelView.hidden) {
		[self hideColorPickerAnimated:YES];
	}
}

#pragma mark - Action

- (void)send {
	if (segmentControl.selectedSegmentIndex == HTDrawTypeDoodle) {
		[self.delegate doodleViewController:self didFinished:[drawView done]];
	} else {
		[self.delegate doodleViewController:self didFinished:[handwritingView done]];
	}
}

- (void)cancel {
	if ((segmentControl.selectedSegmentIndex == HTDrawTypeDoodle && drawView.isEmpty) ||
		(segmentControl.selectedSegmentIndex == HTDrawTypeHandWriting && handwritingView.isEmpty)) {
		HTActionSheet *actionSheet = [[HTActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@?", NSLocalizedString(@"Cancel", @"Cancel")] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		actionSheet.block = ^(NSInteger index) {
			if (index == 0) {
				//				[self saveDrawColorToDisk];
				[self dismissViewControllerAnimated:YES completion:NULL];
			}
		};
		[actionSheet showInView:self.view];
		return;
	}
	
	//	[self saveDrawColorToDisk];
	[self.delegate doodleViewControllerDidCancel:self];
}

- (void)presentImagePickerController:(NSString *)title {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel button text")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Camera",@"Camera button text"),
                                  NSLocalizedString(@"Choose from Album",@"Button text"),nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.navigationController.view];
}

- (void)itemClick:(UIButton *)button {
	switch (button.tag) {
		case HTDrawBarButtonItemPen:
			[self setDrawMode];
			
			if (!eraseSliderPanelView.hidden) {
				[self hideEraseSliderAnimated:NO];
			}
            if (!colorPanelView.hidden) {
				[self hideColorPickerAnimated:NO];
			}
			if (penSliderPanelView.hidden) {
				[self showPenSliderAnimated:YES];
			} else {
				[self hidePenSliderAnimated:YES];
			}
			break;
		case HTDrawBarButtonItemErase:
			[self setEraseMode];
			
			if (!penSliderPanelView.hidden) {
				[self hidePenSliderAnimated:NO];
			}
            
            if (!colorPanelView.hidden) {
				[self hideColorPickerAnimated:NO];
			}
			
			if (eraseSliderPanelView.hidden) {
				[self showEraseSliderAnimated:YES];
			} else {
				[self hideEraseSliderAnimated:YES];
			}
			break;
		case HTDrawBarButtonItemColor:
			[self setDrawMode];
			
			if (!penSliderPanelView.hidden) {
				[self hidePenSliderAnimated:NO];
			}
            
            if (!eraseSliderPanelView.hidden) {
				[self hideEraseSliderAnimated:NO];
			}
			
			if (colorPanelView.hidden) {
				[self showColorPickerAnimated:YES];
			} else {
				[self hideColorPickerAnimated:YES];
			}
			break;
		case HTDrawBarButtonItemUndo:
			[drawView undo];
			break;
		case HTDrawBarButtonItemRedo:
			[drawView redo];
			break;
		case HTDrawBarButtonItemPhoto:
			if (!drawView.isEmpty) {
				HTActionSheet *sheet = [[HTActionSheet alloc] initWithTitle:NSLocalizedString(@"Clear Doodle content and insert photo?", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles: nil];
				sheet.block = ^(NSInteger index) {
					if (index == 0) {
						[drawView clearDrawing];
						[self presentImagePickerController:NSLocalizedString(@"Insert image as background", nil)];
					}
				};
				[sheet showInView:self.view];
			} else {
				[self presentImagePickerController:NSLocalizedString(@"Insert image as background", nil)];
			}
			break;
		case HTDrawBarButtonItemClear: {
			if (!drawView.isEmpty) {
				HTActionSheet *sheet = [[HTActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Clear content", nil) otherButtonTitles: nil];
				sheet.block = ^(NSInteger index) {
					if (index == 0) {
						if (segmentControl.selectedSegmentIndex == HTDrawTypeDoodle) {
							[drawView clearDrawing];
						} else {
							[handwritingView clearDrawing];
						}
					}
				};
				[sheet showInView:self.view];
			}
		}
			break;
		case HTDrawBarButtonItemNewLine:
			[handwritingView newline];
			break;
		case HTDrawBarButtonItemBackSpace:
			[handwritingView backspace];
			break;
		default:
			break;
	}
}

- (void)colorSelect:(UIButton *)button {
    if (button.tag == 0) {
        //HSV Color
        if (!hsvPickerView) {
            hsvPickerView = [[HTHSVPickerView alloc] initWithFrame:self.navigationController.view.bounds];
			hsvPickerView.delegate = self;
			[self.navigationController.view addSubview:hsvPickerView];
        }
		
		hsvPickerView.defaultColor = self.drawColor;
		hsvPickerView.hidden = NO;
        
        return;
    }
    
    if (button == lastColorSelectedButton) {
        return;
    }
	
	UIView *selectView = [lastColorSelectedButton viewWithTag:999];
    if (!selectView) {
        selectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_color_select"]];
        CGRect frame = selectView.frame;
        frame.origin = CGPointMake(28.0f, 28.0f);
        selectView.frame = frame;
        selectView.tag = 999;
    }
    
    [selectView removeFromSuperview];
    [button addSubview:selectView];
	lastColorSelectedButton = button;
	
	if (button.tag == 1) {
		self.drawColor = [UIColor colorWithCGColor:customColorButtonLayer.backgroundColor];
	} else {
		self.drawColor = [button.backgroundColor copy];
	}
	[self setDrawMode];
}

- (void)segmentValueChanged:(UISegmentedControl *)control {
	if ([self hasPanelViewShowed]) {
		[self hideAllPanelView];
	}
	
	if (control.selectedSegmentIndex == HTDrawTypeDoodle) {
		[self setDoodleMode];
	} else {
		[self setHandWritingMode];
	}
}

#pragma mark - Draw setting

- (void)setHandWritingMode {
	drawView.hidden = YES;
	handwritingView.hidden = NO;
	[self setupToolBarWithItems:@[penButtonItem, colorButtonItem, newlineButtonItem, backspaceButtonItem, clearButtonItem]];
	if ([handwritingView isEmpty]) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
		clearButtonItem.enabled = NO;
		backspaceButtonItem.enabled = NO;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		clearButtonItem.enabled = YES;
		backspaceButtonItem.enabled = YES;
	}
}

- (void)setDoodleMode {
	drawView.hidden = NO;
	handwritingView.hidden = YES;
	[self setupToolBarWithItems:@[penButtonItem, eraseButtonItem, colorButtonItem, undoButtonItem, redoButtonItem, photoButtonItem, clearButtonItem]];
	if ([drawView isEmpty]) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
		clearButtonItem.enabled = NO;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		clearButtonItem.enabled = YES;
	}
}

- (void)setEraseMode {
	[drawView setLineColor:[UIColor clearColor]];
	[drawView setLineWidth:eraseSizeSlider.value];
}

- (void)setDrawMode {
	[drawView setLineColor:self.drawColor];
	[drawView setLineWidth:penSizeSlider.value];
    [colorButtonItemBacklayer setBackgroundColor:self.drawColor.CGColor];
	
	[handwritingView setLineColor:self.drawColor];
	[handwritingView setLineWidth:penSizeSlider.value];
}

#pragma mark - HTDoodleDrawViewDelegate

- (BOOL)doodleDrawViewWillStartDraw:(_HTDoodleDrawView *)drawView {
	if ([self hasPanelViewShowed]) {
		return NO;
	}
	
	return YES;
}

- (void)doodleDrawViewDidStartDraw:(_HTDoodleDrawView *)drawView {
	[self hideAllPanelView];
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"empty"]) {
		if ([change boolForKey:NSKeyValueChangeNewKey]) {
			self.navigationItem.rightBarButtonItem.enabled = NO;
			clearButtonItem.enabled = NO;
			if (object != drawView.drawview) {
				backspaceButtonItem.enabled = NO;
			}
		} else {
			self.navigationItem.rightBarButtonItem.enabled = YES;
			clearButtonItem.enabled = YES;
			if (object != drawView.drawview) {
				backspaceButtonItem.enabled = YES;
			}
		}
	} else if ([keyPath isEqualToString:@"pathArray"]) {
		NSArray *pathArray = [change arrayForKey:NSKeyValueChangeNewKey];
		if (pathArray.count > 0) {
			undoButtonItem.enabled = YES;
		} else {
			undoButtonItem.enabled = NO;
		}
	} else if ([keyPath isEqualToString:@"bufferArray"]) {
		NSArray *bufferArray = [change arrayForKey:NSKeyValueChangeNewKey];
		if (bufferArray.count > 0) {
			redoButtonItem.enabled = YES;
		} else {
			redoButtonItem.enabled = NO;
		}
	}
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            HTImagePickerController *imagePicker = [[HTImagePickerController alloc] init];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
	}
	if (buttonIndex == 1){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            HTImagePickerController *m_imagePicker = [[HTImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary])
            {
                m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                m_imagePicker.delegate = self;
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:m_imagePicker];
                if (IOS7) {
                    popover.backgroundColor = [UIColor rgbColorWithRed:24.0f green:116.0f blue:205.0f];
                }
                imagePopoverContr = popover;
                [imagePopoverContr presentPopoverFromRect:self.navigationItem.titleView.frame inView:self.navigationController.navigationBar permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
        }
        else {
            HTImagePickerController *imagePicker = [[HTImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
	}
	if (buttonIndex == 2) {
		
	}
}

#pragma mark - hsvPickerViewDelegate

- (void)HSVPickerViewDidCancel {
	hsvPickerView.hidden = YES;
}

- (void)HSVPickerViewDidFinished:(UIColor *)color {
	hsvPickerView.hidden = YES;
	self.drawColor = [color copy];
	customColorButtonLayer.backgroundColor = [self.drawColor CGColor];
	[self setDrawMode];
    [self colorSelect:customColorButton];
}

#pragma mark - Slide Delegate

- (void)sliderDidBegin:(HTCustomSlider *)slider {
	if (!sizeCircleView) {
		UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
		customView.backgroundColor = [UIColor clearColor];
		[[self HUD] setCustomView:customView];
		
		sizeCircleView = [[UIView alloc] initWithFrame:CGRectZero];
		sizeCircleView.backgroundColor = [UIColor whiteColor];
		[customView addSubview:sizeCircleView];
	}
	sizeCircleView.frame = CGRectMake((50.0f - slider.value) / 2.0f, (50.0f - slider.value) / 2.0f, slider.value, slider.value);
	sizeCircleView.layer.cornerRadius = slider.value / 2.0f;
	[self showHUD:YES];
}

- (void)sliderDidEnd:(HTCustomSlider *)slider {
	[self hideHUD:YES];
}

- (void)sliderValueChanged:(HTCustomSlider *)slider {
	sizeCircleView.frame = CGRectMake((50.0f - slider.value) / 2.0f, (50.0f - slider.value) / 2.0f, slider.value, slider.value);
	sizeCircleView.layer.cornerRadius = slider.value / 2.0f;
	[drawView setLineWidth:slider.value];
	[handwritingView setLineWidth:slider.value];
}

#pragma mark - MBProgressHUD

- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        _HUD.minSize = CGSizeMake(100.0f, 100.0f);
        _HUD.mode = MBProgressHUDModeCustomView;
        [self.navigationController.view addSubview:_HUD];
    }
    return _HUD;
}

- (void)showHUD:(BOOL)animated{
    [self.HUD show:animated];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)hideHUD:(BOOL)animated {
    [self.HUD hide:animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (IOS7 && [navigationController isKindOfClass:[HTImagePickerController class]]) {
		//		HTImagePickerController *imagePickerController = (HTImagePickerController *)navigationController;
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
		//		if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
		//			if ([navigationController.viewControllers.lastObject isKindOfClass:[HTImageCroperViewController class]]) {
		//				[[UIApplication sharedApplication] setStatusBarHidden:NO];
		//				[navigationController setNavigationBarHidden:NO];
		//			} else {
		//				[[UIApplication sharedApplication] setStatusBarHidden:YES];
		//				[navigationController setNavigationBarHidden:YES];
		//			}
		//		}
		
	}
}

#pragma mark - HTImageCroperDelegate

- (void)imageCropper:(HTImageCroperViewController *)cropper didFinished:(UIImage *)image {
	[drawView setBackgroundImage:image];
	if ([[UIDevice currentDevice] isPad] && imagePopoverContr) {
        [imagePopoverContr dismissPopoverAnimated:YES];
        imagePopoverContr = nil;
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(HTImageCroperViewController *)cropper {
	[self imageCropperDidCancel:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	HTImageCroperViewController *_imgCropperViewController = [[HTImageCroperViewController alloc] initWithCroperSize:CGSizeMake(drawView.width - 20, drawView.height * (drawView.width - 20) / drawView.width) image:originalImage];
	_imgCropperViewController.delegate = self;
	
	[picker pushViewController:_imgCropperViewController animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	if ([[UIDevice currentDevice] isPad] && imagePopoverContr) {
        [imagePopoverContr dismissPopoverAnimated:YES];
        imagePopoverContr = nil;
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end

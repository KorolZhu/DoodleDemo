//
//  HTColorPickerView.m
//  HelloTalk_Binary
//
//  Created by zhuzhi on 14-4-13.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import "HTHSVPickerView.h"
#import "HTHuePickerView.h"
#import "HTBrightnessSlider.h"
#import "HTAlphaSlider.h"

@interface HTHSVPickerView ()
{
    UIImageView *panelView;
    HTHuePickerView *_huePickerView;
    HTBrightnessSlider *_brightnessSlider;
    HTAlphaSlider *_alphaSlider;
    
    UIImageView *colorPreviewView;
    CALayer *colorPreviewBackLayer;
    
    UIButton *cancelButton;
    UIButton *saveButton;
}

@end

@implementation HTHSVPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.60f];
        panelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_set_color_bg"]];
        panelView.frame = CGRectMake(20.0f, (frame.size.height - 328.0f) / 2.0f, 280.0f, 328.0f);
        panelView.userInteractionEnabled = YES;
        
        _huePickerView = [[HTHuePickerView alloc] initWithFrame:CGRectMake(64.0f, 16.0f, 152.0f, 152.0f)];
        [_huePickerView addTarget:self action:@selector(huePickerViewValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _brightnessSlider = [[HTBrightnessSlider alloc] initWithFrame:CGRectMake(20.0f, 181.0f, 240.0f, 36.0f)];
        _brightnessSlider.backgroundColor = [UIColor clearColor];
        [_brightnessSlider setThumbImage:[UIImage imageNamed:@"doodle_set_color_loop"]];
        _brightnessSlider.minimumValue = 0.0f;
        _brightnessSlider.maximumValue = 1.0f;
        _brightnessSlider.value = 1.0f;
        [_brightnessSlider addTarget:self action:@selector(brightnessValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _alphaSlider = [[HTAlphaSlider alloc] initWithFrame:CGRectMake(20.0f, 228.0f, 240.0f, 36.0f)];
        _alphaSlider.backgroundColor = [UIColor clearColor];
        [_alphaSlider setTrackImage:[UIImage imageNamed:@"doodle_set_color_transparency"]];
        [_alphaSlider setThumbImage:[UIImage imageNamed:@"doodle_set_color_loop"]];
        _alphaSlider.minimumValue = 0.0f;
        _alphaSlider.maximumValue = 1.0f;
        _alphaSlider.value = 1.0f;
        [_alphaSlider addTarget:self action:@selector(alphaValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        colorPreviewView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle_set_color_transparency_loop"]];
        colorPreviewView.layer.cornerRadius = 22.0f;
        colorPreviewView.layer.masksToBounds = YES;
        colorPreviewView.frame = CGRectMake(19.0f, 18.0f, 44.0f, 44.0f);
        
        colorPreviewBackLayer = [[CALayer alloc] init];
        colorPreviewBackLayer.frame = colorPreviewView.bounds;
        colorPreviewBackLayer.backgroundColor = [self.color CGColor];
        [colorPreviewView.layer addSublayer:colorPreviewBackLayer];
		
		cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(10.0f, 278.0f, 118.0f, 40.0f);
		[cancelButton setBackgroundImage:[UIImage imageNamed:@"common_white_btn"] forState:UIControlStateNormal];
		[cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
		[cancelButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
		[cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
		
		saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
		saveButton.frame = CGRectMake(152.0f, 278.0f, 118.0f, 40.0f);
		[saveButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
		[saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[saveButton setBackgroundImage:[UIImage imageNamed:@"common_blue_btn"] forState:UIControlStateNormal];
		[saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
		
        [panelView addSubview:_huePickerView];
        [panelView addSubview:_brightnessSlider];
        [panelView addSubview:_alphaSlider];
        [panelView addSubview:colorPreviewView];
		[panelView addSubview:cancelButton];
		[panelView addSubview:saveButton];
        [self addSubview:panelView];
        
    }
    return self;
}

- (RGBType)rgbWithUIColor:(UIColor *)color {
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	CGFloat r,g,b;
	
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)))
	{
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			break;
		default:	// We don't know how to handle this model
			return RGBTypeMake(0, 0, 0);
	}
	
	return RGBTypeMake(r, g, b);
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    _color = defaultColor;
	
	RGBType rgb = [self rgbWithUIColor:defaultColor];
	HSVType hsv = RGB_to_HSV(rgb);
	
	_huePickerView.HSV = hsv;
    _brightnessSlider.value = hsv.v;
    _alphaSlider.value = CGColorGetAlpha(defaultColor.CGColor);
    colorPreviewBackLayer.backgroundColor = [defaultColor CGColor];
	
	UIColor *tintColor = [UIColor colorWithHue:hsv.h
                                   saturation:hsv.s
                                   brightness:1.0
                                        alpha:1.0];
	[_brightnessSlider setTintColor:tintColor];
	tintColor = [UIColor colorWithHue:hsv.h
						   saturation:hsv.s
						   brightness:hsv.v
								alpha:1.0];
	[_alphaSlider setTintColor:tintColor];
}

- (void)cancelClick {
	[self.delegate HSVPickerViewDidCancel];
}

- (void)saveClick {
	[self.delegate HSVPickerViewDidFinished:self.color];
}

- (void)huePickerViewValueChanged:(HTHuePickerView *)huePickerView {
    HSVType hsv = huePickerView.HSV;
	self.color = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:_brightnessSlider.value
										 alpha:_alphaSlider.value];
	colorPreviewBackLayer.backgroundColor = [self.color CGColor];
	
	UIColor *tintColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:1.0
										 alpha:1.0];
	[_brightnessSlider setTintColor:tintColor];
	
	tintColor = [UIColor colorWithHue:hsv.h
						   saturation:hsv.s
						   brightness:hsv.v
								alpha:1.0];
	[_alphaSlider setTintColor:tintColor];
}

- (void)brightnessValueChanged:(HTBrightnessSlider *)brightnessSlider {
    HSVType hsv = _huePickerView.HSV;
	self.color = [UIColor colorWithHue:hsv.h
                            saturation:hsv.s
                            brightness:_brightnessSlider.value
                                 alpha:_alphaSlider.value];
	colorPreviewBackLayer.backgroundColor = [self.color CGColor];
}

- (void)alphaValueChanged:(HTAlphaSlider *)alphaSlider {
    HSVType hsv = _huePickerView.HSV;
	self.color = [UIColor colorWithHue:hsv.h
                            saturation:hsv.s
                            brightness:_brightnessSlider.value
                                 alpha:_alphaSlider.value];
	colorPreviewBackLayer.backgroundColor = [self.color CGColor];
}

@end

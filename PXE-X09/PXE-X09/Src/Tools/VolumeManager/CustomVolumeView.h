//
//  CustomVolumeView.h
//  VolumeCustom
//
//  Created by 王广威 on 2017/11/26.
//  Copyright © 2017年 王广威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIApplication+VolumeControl.h"

/**
 音量指示器的样式
 
 - Plain: 默认
 - Rounded: 圆角
 - Dashes: 虚线
 - Dots: 点
 */
typedef enum : NSUInteger {
	VolumeStylePlain,
	VolumeStyleRounded,
	VolumeStyleDashes,
	VolumeStyleDots,
} CustomVolumeStyle;

/**
 音量发生变化时，本控件改变的动画方式
 
 - None: 没有任何特效
 - SlideDown: 下落加渐显
 - FadeIn: 渐显
 */
typedef enum : NSUInteger {
	VolumeAnimationNone,
	VolumeAnimationSlideDown,
	VolumeAnimationFadeIn,
} CustomVolumeAnimation;

@interface CustomVolumeView : UIView

/**
 动画效果
 */
@property (nonatomic, assign) CustomVolumeAnimation volumeAnimation;
/**
 音量条的样式
 */
@property (nonatomic, assign) CustomVolumeStyle volumeStyle;

/**
 音量条颜色
 */
- (void)setBarTintColor:(UIColor *)barTintColor;

@end

//
//  MasterVolView.h
//  JH-DBP4106-newMusic
//
//  Created by chs on 2017/11/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface MasterVolView : UIView
{
    int count;
    
}
/**
 动画效果
 */
@property (nonatomic, assign) CustomVolumeAnimation volumeAnimation;
@property (weak, nonatomic) IBOutlet UISlider *VolSlider;
@property (nonatomic,strong)NSTimer *showTime;
-(void)setSliderValue:(int) value;
@end

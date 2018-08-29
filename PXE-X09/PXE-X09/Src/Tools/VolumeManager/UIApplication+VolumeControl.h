//
//  UIApplication+VolumeControl.h
//  VolumeCustom
//
//  Created by 王广威 on 2017/11/26.
//  Copyright © 2017年 王广威. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIApplication *SharedApplication(void) {
	return [UIApplication sharedApplication];
}

#define VMSharedApplication (SharedApplication())

// 封装好的有两种方式监听系统音量改变，一是通知，监听 AVAudioSessionVolumeChanged。
// 二是添加代理，遵循 VolumeDelegate 协议

// 监听音量变化的字符串标识 key
UIKIT_EXTERN NSNotificationName const AVAudioSessionVolumeChanged;

@protocol VolumeDelegate <NSObject>

/**
 The volume did change
 
 - parameter value: The value of the volume (between 0 an 1.0)
 */
- (void)systemVolumeDidChange:(CGFloat)value;

@end

@interface UIApplication (VolumeControl) <VolumeDelegate>

/**
 是否隐藏系统音量指示器，默认为 YES
 */
@property (nonatomic, assign) BOOL hideSystemVolumeIndicator;

/**
 音量大小
 */
@property (nonatomic, assign) CGFloat volumeLevel;

/**
 添加一个音量变化观察者

 @param observer observer
 */
- (void)addVolumeChangeObserver:(id<VolumeDelegate>)observer;

/**
 移除一个音量变化观察者

 @param observer observer
 */
- (void)removeVolumeChangeObserver:(id<VolumeDelegate>)observer;

@end

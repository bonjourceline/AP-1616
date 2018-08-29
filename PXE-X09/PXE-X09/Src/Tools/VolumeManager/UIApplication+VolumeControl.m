//
//  UIApplication+VolumeControl.m
//  VolumeCustom
//
//  Created by 王广威 on 2017/11/26.
//  Copyright © 2017年 王广威. All rights reserved.
//

#import "UIApplication+VolumeControl.h"

#import "AppDelegate.h"
#import <objc/runtime.h>

#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

static NSString *AVAudioSessionOutputVolumeKey = @"outputVolume";
const NSNotificationName AVAudioSessionVolumeChanged = @"AVAudioSessionVolumeChanged";

@interface UIApplication ()

@property (nonatomic, strong, readonly) MPVolumeView *systemVolumeView;
@property (nonatomic, strong, readonly) UISlider *systemVolumeSlider;

@property (nonatomic, strong, readonly) NSHashTable<id<VolumeDelegate>> *volumeObservers;

@end

@implementation UIApplication (VolumeControl)

// 不需要对象，封装为类方法了，每次应用进入前台需要调用
+ (void)activeAudioSession {
	NSError *initialError = nil;
	[[AVAudioSession sharedInstance] setActive:YES error:&initialError];
	if (initialError) {
		NSLog(@"%@", initialError);
	}
}

- (void)setupVolumeControl {
	// 两种监听方式，一个是 KVO 监听 AVAudioSession 的 outputVolume 属性
	// 另一种是给系统音量指示器添加 target action
//	[[AVAudioSession sharedInstance] addObserver:self forKeyPath:AVAudioSessionOutputVolumeKey options:NSKeyValueObservingOptionNew context:nil];
//	self.volumeLevel = [AVAudioSession sharedInstance].outputVolume;
	UISlider *systemVolumeSlider = self.systemVolumeSlider;
	[systemVolumeSlider addTarget:self action:@selector(volumeSliderDidChange:) forControlEvents:UIControlEventValueChanged];
	self.hideSystemVolumeIndicator = YES;
}

// 下面的懒得写注释了，自己将就看吧
- (void)refreshCurrentVolume {
//    [UIApplication activeAudioSession];
	UISlider *systemVolumeSlider = self.systemVolumeSlider;
//    self.volumeLevel = systemVolumeSlider.value;
}

- (void)refreshSystemVolumeIndicator {
	[self.keyWindow addSubview:self.systemVolumeView];
	BOOL hideSystemVolumeIndicator = self.hideSystemVolumeIndicator;
	self.systemVolumeView.hidden = !hideSystemVolumeIndicator;
}

#pragma mark - get & set
- (MPVolumeView *)systemVolumeView {
	MPVolumeView *systemVolumeView = objc_getAssociatedObject(self, _cmd);
	if (!systemVolumeView) {
		systemVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
		[systemVolumeView setVolumeThumbImage:[UIImage new] forState:UIControlStateNormal];
		[systemVolumeView setUserInteractionEnabled:NO];
		[systemVolumeView setAlpha:0.0001];
		[systemVolumeView setShowsRouteButton:NO];
//		[systemVolumeView setShowsVolumeSlider:NO];
		objc_setAssociatedObject(self, _cmd, systemVolumeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return systemVolumeView;
}

- (UISlider *)systemVolumeSlider {
	__block UISlider *systemVolumeSlider = nil;
	[[self.systemVolumeView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[UISlider class]]) {
			systemVolumeSlider = (UISlider *)obj;
			*stop = YES;
		}
	}];

	if (systemVolumeSlider) {
		
	}else {
		// can not change volume
	}
	return systemVolumeSlider;
}

- (CGFloat)volumeLevel {
	NSNumber *volumeLevel = objc_getAssociatedObject(self, _cmd);
	return [volumeLevel floatValue];
}

- (void)setVolumeLevel:(CGFloat)volumeLevel {
	CGFloat targetVolumeLevel = MAX(0, MIN(1, volumeLevel));
	CGFloat oldVolumeLevel = self.volumeLevel;
    if (targetVolumeLevel != oldVolumeLevel ||targetVolumeLevel == 0 || targetVolumeLevel == 1) {
		objc_setAssociatedObject(self, @selector(volumeLevel), @(targetVolumeLevel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		self.systemVolumeSlider.value = volumeLevel;
		[self notifiObserverVolumeLevelChanged];
    }
}

- (BOOL)hideSystemVolumeIndicator {
	NSNumber *hideSystemVolumeIndicator = objc_getAssociatedObject(self, _cmd);
	// 首次访问，还没设置，需要设置默认值
	if (hideSystemVolumeIndicator == nil) {
		hideSystemVolumeIndicator = @(YES);
		objc_setAssociatedObject(self, _cmd, hideSystemVolumeIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return [hideSystemVolumeIndicator boolValue];
}

- (void)setHideSystemVolumeIndicator:(BOOL)hideSystemVolumeIndicator {
	BOOL oldSystemVolumeStatus = self.hideSystemVolumeIndicator;
	if (oldSystemVolumeStatus != hideSystemVolumeIndicator) {
		objc_setAssociatedObject(self, @selector(hideSystemVolumeIndicator), @(hideSystemVolumeIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[self refreshSystemVolumeIndicator];
	}
}

- (NSHashTable<id<VolumeDelegate>> *)volumeObservers {
	NSHashTable<id<VolumeDelegate>> *volumeObservers = objc_getAssociatedObject(self, _cmd);
	if (!volumeObservers) {
		volumeObservers = [NSHashTable weakObjectsHashTable];
		objc_setAssociatedObject(self, _cmd, volumeObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return volumeObservers;
}

#pragma mark - notifi observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:AVAudioSessionOutputVolumeKey]) {
		CGFloat newVolumeLevel = [change[NSKeyValueChangeNewKey] floatValue];
		[self systemVolumeDidChange:newVolumeLevel];
	}
}

- (void)volumeSliderDidChange:(UISlider *)systemVolumeSlider {
	[self systemVolumeDidChange:systemVolumeSlider.value];
}

- (void)systemVolumeDidChange:(CGFloat)value {
	NSLog(@"%s, %f", __func__, value);
    self.volumeLevel = value;
}

- (void)addVolumeChangeObserver:(id<VolumeDelegate>)observer {
	if ([self.volumeObservers containsObject:observer] == NO) {
		[self.volumeObservers addObject:observer];
		
		// when add a new observer
		[observer systemVolumeDidChange:self.volumeLevel];
	}
}

- (void)removeVolumeChangeObserver:(id<VolumeDelegate>)observer {
	[self.volumeObservers removeObject:observer];
}

- (void)notifiObserverVolumeLevelChanged {
	NSArray<id<VolumeDelegate>> *volumeObservers = [self.volumeObservers allObjects];
	CGFloat currentVolumeLevel = self.volumeLevel;
	for (id<VolumeDelegate> volumeObserver in volumeObservers) {
		[volumeObserver systemVolumeDidChange:currentVolumeLevel];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:AVAudioSessionVolumeChanged object:@(currentVolumeLevel)];
}

@end


@implementation AppDelegate (VolumeControl)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
	Method originalMethod = class_getInstanceMethod(self, originalSel);
	Method newMethod = class_getInstanceMethod(self, newSel);
	if (!originalMethod || !newMethod) return NO;
	
	class_addMethod(self,
					originalSel,
					class_getMethodImplementation(self, originalSel),
					method_getTypeEncoding(originalMethod));
	class_addMethod(self,
					newSel,
					class_getMethodImplementation(self, newSel),
					method_getTypeEncoding(newMethod));
	
	method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
								   class_getInstanceMethod(self, newSel));
	return YES;
}

//+ (void)load {
//    [AppDelegate swizzleInstanceMethod:@selector(applicationDidBecomeActive:) with:@selector(volumeControl_applicationDidBecomeActive:)];
//    [AppDelegate swizzleInstanceMethod:@selector(application:didFinishLaunchingWithOptions:) with:@selector(volumeControl_application:didFinishLaunchingWithOptions:)];
//}
//
//- (BOOL)volumeControl_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    BOOL finished = [self volumeControl_application:application didFinishLaunchingWithOptions:launchOptions];
//    [VMSharedApplication setupVolumeControl];
//    return finished;
//}
//
//- (void)volumeControl_applicationDidBecomeActive:(UIApplication *)application {
//    [self volumeControl_applicationDidBecomeActive:application];
//    [VMSharedApplication refreshSystemVolumeIndicator];
//    [VMSharedApplication refreshCurrentVolume];
//}

@end


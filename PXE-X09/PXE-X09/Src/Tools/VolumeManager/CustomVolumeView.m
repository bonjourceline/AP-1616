//
//  CustomVolumeView.m
//  VolumeCustom
//
//  Created by 王广威 on 2017/11/26.
//  Copyright © 2017年 王广威. All rights reserved.
//

#import "CustomVolumeView.h"

@interface CustomVolumeView () <VolumeDelegate>

@property (nonatomic, weak) CALayer *overlay;

@end

@implementation CustomVolumeView

#pragma mark - over load super method
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupDefaultApperance];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setupDefaultApperance];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.overlay.frame = CGRectMake(0, 0, self.frame.size.width * [UIApplication sharedApplication].volumeLevel, self.frame.size.height);
}

- (void)dealloc {
	[VMSharedApplication removeVolumeChangeObserver:self];
}

#pragma mark - apperance
- (void)setupDefaultApperance {
	self.backgroundColor = [UIColor clearColor];
	self.overlay.backgroundColor = [UIColor blackColor].CGColor;
	[VMSharedApplication addVolumeChangeObserver:self];
}

- (CALayer *)overlay {
	if (!_overlay) {
		CALayer *overlay = [CALayer layer];
		[self.layer addSublayer:overlay];
		_overlay = overlay;
	}
	return _overlay;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
	self.overlay.backgroundColor = barTintColor.CGColor;
}

- (void)setVolumeStyle:(CustomVolumeStyle)volumeStyle {
	_volumeStyle = volumeStyle;
	switch (volumeStyle) {
		case VolumeStylePlain:
			self.overlay.cornerRadius = 0.0f;
			self.layer.cornerRadius = 0.0f;
			break;
		case VolumeStyleRounded:
			self.overlay.cornerRadius = self.overlay.frame.size.height / 2.0f;
			self.overlay.masksToBounds = YES;
			self.layer.cornerRadius = self.frame.size.height / 2.0f;
			self.layer.masksToBounds = YES;
			break;
		case VolumeStyleDashes:
			break;
		case VolumeStyleDots:
			break;
		default:
			break;
	}
}

#pragma mark - observer and animated change
- (void)systemVolumeDidChange:(CGFloat)value {
	[self updateVolume:value animated:true];
}

- (void)updateVolume:(CGFloat)newVolume animated:(BOOL)animated {
	CGRect originFrame = self.overlay.frame;
	originFrame.size.width = self.frame.size.width * VMSharedApplication.volumeLevel;
	self.overlay.frame = originFrame;
	
	[UIView animateKeyframesWithDuration:animated * 2 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
		[UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
			switch (self.volumeAnimation) {
				case VolumeAnimationFadeIn:
					self.alpha = 1.0f;
					break;
				case VolumeAnimationSlideDown:
					self.alpha = 1.0f;
					self.transform = CGAffineTransformIdentity;
					break;
				default:
					break;
			}
		}];
		
		[UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
			switch (self.volumeAnimation) {
				case VolumeAnimationFadeIn:
					self.alpha = 0.0001;
					break;
				case VolumeAnimationSlideDown:
					self.alpha = 0.0001;
					self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
					break;
				default:
					break;
			}
		}];
	} completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

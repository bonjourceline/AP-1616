//
//  VolSettingViewController.h
//  PXE-X09
//
//  Created by celine on 2018/10/10.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolumeCircleIMLine.h"
typedef NS_ENUM(NSInteger, ChannelType) {
    CH_OUT,
    CH_INPUT,
    
};
NS_ASSUME_NONNULL_BEGIN

@interface VolSettingViewController : UIViewController
@property(nonatomic,strong)VolumeCircleIMLine *sbVol;
@property(nonatomic,strong)UILabel *volLab;
@property(nonatomic,strong)UIButton *polarBtn;
@property(nonatomic,strong)UILabel *chTopLabel;
@property(nonatomic,strong)UILabel *chLabel;
@property(nonatomic,assign)ChannelType chType;
@property(nonatomic,strong)void (^dismissBlock)(void);
@end

NS_ASSUME_NONNULL_END

//
//  OutputPageViewController.h
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EQViewController.h"
#import "XOverOutputViewController.h"
#import "DelayViewController.h"



@interface OutputPageViewController : UIViewController{
    @private
    float frameStartY;
    float frameEndY;
    
}

@property (strong, nonatomic) UIButton *Btn_OutputPage;
@property (strong, nonatomic) UIButton *Btn_EQPage;
@property (strong, nonatomic) UIButton *Btn_DelayPage;
@property (strong, nonatomic) UIImageView *IV_ChannelSwitch;

@property (nonatomic,strong) XOverOutputViewController *mXOverOutputPage;
@property (nonatomic,strong) EQViewController *mEQPage;
@property (nonatomic,strong) DelayViewController *mDelayPage;
@property (nonatomic,strong) UIViewController *mVC_Temp;

- (void)FlashPageUI;


@end

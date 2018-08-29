//
//  MixerViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacDefine.h"

#import "TopBarView.h"

#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"
#import "EQView.h"
#import "EQItem.h"
#import "EQIndex.h"
#import "ChannelBtn.h"
#import "ASValueTrackingSlider.h"
#import "SeekBarChannel.h"
#import "MixerItem.h"
#import "IZValueSelectorView.h"
#import "DelayItem.h"

@interface DelayViewController_FRS : UIViewController
<UIScrollViewDelegate,
MBProgressHUDDelegate>

{
    
    @private
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
    
    NSString *setEnNum;
    int SEFF_SendListTotal;
    
    uint8 mGroup;//点击的用户组
    int mAlertType;//弹出框响应，1：调用，2：删除，3：保存
    BOOL BOOL_GroupClick[16];
    //主音量计数定时器 减
    NSTimer *_pMainVolMinusTimer;
    NSTimer *_pMainVolAddTimer;
    
    NSString *seffName;
    int delayUnit;
}

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

@property (nonatomic,strong) UIImageView *IVDelayCar;
@property (nonatomic,strong) DelayItem *mDelayItem;
@property (nonatomic,strong) DelayItem *CurDelayItem;
@property (nonatomic,strong) NormalButton *BtnDelayUnit;
@property (nonatomic,strong) NormalButton *BtnSave;

@property (nonatomic, strong) UIButton *Btn_CM;
@property (nonatomic, strong) UIButton *Btn_MS;
@property (nonatomic, strong) UIButton *Btn_INCH;
@property (nonatomic, strong) UIImageView *IV_UnitDelaySwitch;


- (void)FlashPageUI;

@end

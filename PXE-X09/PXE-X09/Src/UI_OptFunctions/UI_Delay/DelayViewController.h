//
//  DelayViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView.h"

#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "DataCommunication.h"
#import "ASValueTrackingSlider.h"
#import "rootViewController.h"

#define  MaxSpk 21
#define  TagStart_DelayView   100
#define  TagStart_DelayBtnVal 200
#define  TagStart_DelaySpk    300

@interface DelayViewController : rootViewController
<MBProgressHUDDelegate>
{
    @private
    int delayUnit;
    int spkNum;
    
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
    
    NSString *setEnNum;
    int SEFF_SendListTotal;
}

- (void)FlashPageUI;
//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
//弹出对话框延时
@property (strong, nonatomic) ASValueTrackingSlider *sliderFreq;
@property (strong, nonatomic) UIButton *btnMinus;
@property (strong, nonatomic) UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIImageView *V_SetDelayBg;
//單位切換
@property (weak, nonatomic) IBOutlet UIButton *Btn_CM;
@property (weak, nonatomic) IBOutlet UIButton *Btn_MS;
@property (weak, nonatomic) IBOutlet UIButton *Btn_INCH;
@property (weak, nonatomic) IBOutlet UIImageView *IV_UnitDelaySwitch;

@property (strong, nonatomic) NormalButton *BtnCM;
@property (strong, nonatomic) NormalButton *BtnMS;
@property (strong, nonatomic) NormalButton *BtnINCH;
@property (strong, nonatomic) NormalButton *BtnUnit;


@property (strong, nonatomic) IBOutlet UIView *V_Delay0;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk0;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal0;

@property (strong, nonatomic) IBOutlet UIView *V_Delay1;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk1;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal1;

@property (strong, nonatomic) IBOutlet UIView *V_Delay2;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk2;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal2;

@property (strong, nonatomic) IBOutlet UIView *V_Delay3;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk3;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal3;

@property (strong, nonatomic) IBOutlet UIView *V_Delay4;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk4;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal4;

@property (strong, nonatomic) IBOutlet UIView *V_Delay5;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk5;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal5;

@property (strong, nonatomic) IBOutlet UIView *V_Delay6;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk6;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal6;

@property (strong, nonatomic) IBOutlet UIView *V_Delay7;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk7;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal7;

@property (strong, nonatomic) IBOutlet UIView *V_Delay8;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk8;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal8;

@property (strong, nonatomic) IBOutlet UIView *V_Delay9;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk9;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal9;

@property (strong, nonatomic) IBOutlet UIView *V_Delay10;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk10;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal10;

@property (strong, nonatomic) IBOutlet UIView *V_Delay11;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk11;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal11;

@property (strong, nonatomic) IBOutlet UIView *V_Delay12;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk12;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal12;

@property (strong, nonatomic) IBOutlet UIView *V_Delay13;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk13;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal13;

@property (strong, nonatomic) IBOutlet UIView *V_Delay14;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk14;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal14;

@property (strong, nonatomic) IBOutlet UIView *V_Delay15;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk15;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal15;

@property (strong, nonatomic) IBOutlet UIView *V_Delay16;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk16;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal16;

@property (strong, nonatomic) IBOutlet UIView *V_Delay17;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk17;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal17;

@property (strong, nonatomic) IBOutlet UIView *V_Delay18;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk18;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal18;

@property (strong, nonatomic) IBOutlet UIView *V_Delay19;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk19;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal19;

@property (strong, nonatomic) IBOutlet UIView *V_Delay20;
@property (strong, nonatomic) IBOutlet UIButton *BtnSpk20;
@property (strong, nonatomic) IBOutlet UIButton *BtnVal20;

@property (strong, nonatomic) NormalButton *BtnLinkA;//左右联调

@end

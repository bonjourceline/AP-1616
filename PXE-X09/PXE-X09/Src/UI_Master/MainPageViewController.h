//
//  MainPageViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopBarView.h"
#import "Masonry.h"
#import "MacDefine.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"

#import "NormalButton.h"
#import "DataCommunication.h"
#import "VolumeCircleIMLine.h"

#import "OptFunPage_TBC_VC.h"
#import "SliderButton.h"
//音效文件
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#import "QIZLocalEffectViewController.h"
#import "SEFFFile.h"

@interface MainPageViewController : UIViewController
<//MBProgressHUDDelegate,
UIAlertViewDelegate,
TopBarViewDelegate,
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>
{
    
    uint8 mGroup;//点击的用户组
    int mAlertType;//弹出框响应，1：调用，2：删除，3：保存
    int SEFF_SendListTotal;
    BOOL BOOL_GroupClick[16];
    //主音量计数定时器 减
    NSTimer *_pMainVolMinusTimer;
    NSTimer *_pMainVolAddTimer;

    NSString *seffName;
    NSString *setEnNum;
    
    int MasterVol_buf;
}

- (void)FlashMasterPageUI;

@property (nonatomic,strong) TopBarView *mToolbar;
//声明一个全局变量判断选中的按钮
@property (weak, nonatomic) NormalButton *selectedBtn;

@property (strong, nonatomic) UILabel *Lab_InputSource;
@property (strong, nonatomic) NormalButton *Btn_InputSource;
@property (strong, nonatomic) UIButton *Btn_MasterVolumeAdd;
@property (strong, nonatomic) UIButton *Btn_MasterVolumeSub;
@property (strong, nonatomic) UIButton  *Lab_MasterVolumeText;
@property (strong, nonatomic) UILabel  *Lab_MasterVolume;
@property (strong, nonatomic) UIButton *Btn_MasterMute;
@property (strong, nonatomic) NormalButton *Btn_MasterEncrypt;
@property (strong, nonatomic) UIButton *Btn_AdvanceSettings;


@property (strong, nonatomic) UIButton  *Lab_SEFFText;
@property (strong, nonatomic) NormalButton *Btn_SEFF1;
@property (strong, nonatomic) NormalButton *Btn_SEFF2;
@property (strong, nonatomic) NormalButton *Btn_SEFF3;
@property (strong, nonatomic) NormalButton *Btn_SEFF4;
@property (strong, nonatomic) NormalButton *Btn_SEFF5;
@property (strong, nonatomic) NormalButton *Btn_SEFF6;
@property (weak, nonatomic) UIButton *Btn_SEFF7;
@property (weak, nonatomic) UIButton *Btn_SEFF8;
@property (weak, nonatomic) UIButton *Btn_SEFF9;
@property (weak, nonatomic) UIButton *Btn_SEFF10;

@property (strong, nonatomic) UIButton *Btn_SEFFC;
//@property (strong, nonatomic) UIView *V_SEFF;
//低音音量
@property (strong, nonatomic) UILabel *Lab_SubVol;
@property (strong, nonatomic) UISlider *SB_SubVol;
@property (nonatomic,strong) SliderButton *SB_SubVolume;

//音源音量
@property (strong, nonatomic) UILabel *Lab_InSrcVol;
@property (strong, nonatomic) UILabel *LabInSrcVol;
@property (strong, nonatomic) UISlider *SB_InSrcVol;
//混音音源
@property (strong, nonatomic) UILabel *Lab_MixerInputSource;
@property (strong, nonatomic) NormalButton *Btn_MixerInputSource;

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) VolumeCircleIMLine *SB_MasterVolume;
//@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) OptFunPage_TBC *OptFunPage_VC;

@property (strong, nonatomic) UIButton *BtnHiMode;
//音效文件
@property (nonatomic,strong) UIDocumentInteractionController *doc;

//MasterLogo
@property (strong, nonatomic) UIImageView *IV_MasterLogo;

//EQ增益设置
@property (nonatomic,strong) SliderButton *SB_EQHi;
@property (nonatomic,strong) SliderButton *SB_EQMid;
@property (nonatomic,strong) SliderButton *SB_EQLow;

@end

//
//  MainPageViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//
#import "rootViewController.h"
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

//音效文件
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#import "QIZLocalEffectViewController.h"
#import "SEFFFile.h"

@interface HomePageViewController :rootViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
//TopBarViewDelegate,
UIScrollViewDelegate,
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
    
    BOOL boolMasterSub;
}

- (void)FlashMasterPageUI;

//声明一个全局变量判断选中的按钮
@property (strong, nonatomic) NormalButton *selectedSEFFBtn;

@property (strong, nonatomic) UILabel *Lab_InputSource;
@property (strong, nonatomic) NormalButton *Btn_InputSource;
@property (strong, nonatomic) UIButton *Btn_MasterVolumeAdd;
@property (strong, nonatomic) UIButton *Btn_MasterVolumeSub;
@property (nonatomic,strong) VolumeCircleIMLine *SB_MasterVolume;
//@property (nonatomic,strong) UISlider *SB_MasterVolume;
//@property (strong, nonatomic) UIView *IV_MasterBg;
@property (strong, nonatomic) UILabel  *Lab_MasterVolumeText;
@property (strong, nonatomic) UILabel  *Lab_MasterVolume;
@property (strong, nonatomic) NormalButton *Btn_MasterMute;
@property (strong, nonatomic) NormalButton *Btn_MasterEncrypt;
@property (strong, nonatomic) NormalButton *Btn_AdvanceSettings;

@property (nonatomic, nonatomic) UIScrollView *SVList;
@property (strong, nonatomic) UILabel  *Lab_SEFFText;
@property (strong, nonatomic) NormalButton *Btn_SEFF1;
@property (strong, nonatomic) NormalButton *Btn_SEFF2;
@property (strong, nonatomic) NormalButton *Btn_SEFF3;
@property (strong, nonatomic) NormalButton *Btn_SEFF4;
@property (strong, nonatomic) NormalButton *Btn_SEFF5;
@property (strong, nonatomic) NormalButton *Btn_SEFF6;
@property (strong, nonatomic) UIButton *Btn_SEFF7;
@property (strong, nonatomic) UIButton *Btn_SEFF8;
@property (strong, nonatomic) UIButton *Btn_SEFF9;
@property (strong, nonatomic) UIButton *Btn_SEFF10;

@property (strong, nonatomic) NormalButton *Btn_SEFFC;
//@property (strong, nonatomic) UIView *V_SEFF;
//低音音量
@property (strong, nonatomic) UILabel *Lab_SubVol;
@property (strong, nonatomic) UISlider *SB_SubVol;

@property (strong, nonatomic) UIImageView *MasterSubBg;
@property (strong, nonatomic) UIButton *Btn_CMaster;
@property (strong, nonatomic) UIButton *Btn_CSub;

//音源音量
@property (strong, nonatomic) UILabel *Lab_InSrcVol;
@property (strong, nonatomic) UILabel *LabInSrcVol;
@property (strong, nonatomic) UISlider *SB_InSrcVol;
//混音音源
@property (strong, nonatomic) UILabel *Lab_MixerInputSource;
@property (strong, nonatomic) NormalButton *Btn_MixerInputSource;

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
//@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;

//音效文件
@property (nonatomic,strong) UIDocumentInteractionController *doc;

@end

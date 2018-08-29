//
//  XOverOutputViewController.h
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
#import "IconButton.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"
#import "EQView.h"
#import "EQItem.h"
#import "EQIndex.h"
#import "ChannelBtn.h"
#import "ASValueTrackingSlider.h"
#import "IndexButton.h"
#import "OutNameSet.h"
#import "DataCommunication.h"
#import "VolumeCircleIMLine.h"
#import "IZValueSelectorView.h"
#import "rootViewController.h"
#import "ChannelBar.h"
@interface XOverOutputViewController : rootViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
IZValueSelectorViewDataSource,
IZValueSelectorViewDelegate,
UITextFieldDelegate>
{
    
    @private
    //主音量计数定时器 减
    NSTimer *_pVolFreqMinusTimer;
    NSTimer *_pVolFreqAddTimer;
    
    //主音量计数定时器 减
    NSTimer *_pMainVolMinusTimer;
    NSTimer *_pMainVolAddTimer;

    
    NSString *setEnNum;
    int SEFF_SendListTotal;
    
    NSMutableArray *Filter_List;
    NSMutableArray *Level_List;
    NSMutableArray *LevelH_List;
    NSMutableArray *AllLevel;
    
    Boolean Bool_HL;//True:高通
    NormalButton *B_Buf;
    
    NSMutableArray *CurCH_SPK;
    NSArray *CH0_SPK;
    NSArray *CH1_SPK;
    NSArray *CH2_SPK;
    NSArray *CH3_SPK;
    NSArray *CH4_SPK;
    NSArray *CH5_SPK;
    NSArray *CH6_SPK;
    NSArray *CH7_SPK;
    NSArray *CH8_SPK;
    NSArray *CH9_SPK;

    int OCTArray[16];
}

- (void)FlashPageUI;


//弹出对话框调频率
@property (strong, nonatomic) ASValueTrackingSlider *sliderFreq;
@property (strong, nonatomic) UIButton *btnFreqMinus;
@property (strong, nonatomic) UIButton *btnFreqAdd;


@property (nonatomic, nonatomic) UIScrollView *SVMixer;
//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

//@property (nonatomic,strong) ChannelBtn * channelBtn;
@property (nonatomic,strong)  ChannelBar * channelBar;
//@property (nonatomic,strong)  IZValueSelectorView *selectorHorizontal;
//XOver
@property (nonatomic,strong) UILabel *LabHP_Text;
@property (nonatomic,strong) UILabel *LabXOver_Text;
@property (nonatomic,strong) UILabel *LabLP_Text;

@property (strong, nonatomic) NormalButton  *H_Filter;
@property (strong, nonatomic) NormalButton  *H_Level;
@property (strong, nonatomic) NormalButton  *H_Freq;

@property (strong, nonatomic) NormalButton  *L_Filter;
@property (strong, nonatomic) NormalButton  *L_Level;
@property (strong, nonatomic) NormalButton  *L_Freq;

@property (nonatomic,strong) UILabel *LabFilter_Text;
@property (nonatomic,strong) UILabel *LabLevel_Text;
@property (nonatomic,strong) UILabel *LabFreq_Text;

//Output
@property (strong, nonatomic) NormalButton *OutMute;
@property (strong, nonatomic) NormalButton *OutPolar;
@property (strong, nonatomic) NormalButton *OutName;
@property (nonatomic,strong) UILabel *LabOutVal_Text;
@property (nonatomic,strong) UILabel *LabOutVal;
@property (nonatomic,strong) UISlider *SB_OutVal;

@property (strong, nonatomic) UIButton *Btn_OutputVolumeAdd;
@property (strong, nonatomic) UIButton *Btn_OutputVolumeSub;

//@property (nonatomic,strong) VolumeCircleIMLine *SB_OutVal;
@property (nonatomic,strong) UIView *mIVMid;


@property (strong, nonatomic) NormalButton *Btn_Link;
@property (strong, nonatomic) NormalButton *Btn_Lock;
@property (strong, nonatomic) NormalButton *Btn_Reset;
@property (strong, nonatomic) OutNameSet   *setOutNameDialog;
//联调状态
@property (strong, nonatomic) UIView *mVLink;
@property (strong, nonatomic) UIImageView *mImgLink;
@property (nonatomic,strong) UILabel *LabLeftCh;
@property (nonatomic,strong) UILabel *LabRightCh;


@property (strong, nonatomic) UIView *mVbg1;
@property (strong, nonatomic) UIView *mVbg2;
@property (strong, nonatomic) UIView *mVbg3;


@end

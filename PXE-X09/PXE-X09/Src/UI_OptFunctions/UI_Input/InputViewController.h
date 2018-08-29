//
//  InputViewController.h
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/28.
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
#import "InputChannelSel.h"



@interface InputViewController : UIViewController
<UIScrollViewDelegate,
MBProgressHUDDelegate>
{
    @private
    
    int EQ_MODE;//1:gain 2:BW 3:Freq
    BOOL bool_ByPass;
    //主音量计数定时器 减
    NSTimer *_pVolEQMinusTimer;
    NSTimer *_pVolEQAddTimer;
    NSTimer *_pVolFreqMinusTimer;
    NSTimer *_pVolFreqAddTimer;
    NSString *setEnNum;
    int SEFF_SendListTotal;

    
    NSMutableArray *Filter_List;
    NSMutableArray *Level_List;
    NSMutableArray *LevelH_List;
    NSMutableArray *AllLevel;
    
    Boolean Bool_HL;//True:高通
    NormalButton *B_Buf;
    
}


- (void)FlashPageUI;

//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

//弹出对话框调EQ
@property (strong, nonatomic) ASValueTrackingSlider *sliderEQ;
@property (strong, nonatomic) UIButton *btnEQMinus;
@property (strong, nonatomic) UIButton *btnEQAdd;

@property (nonatomic,strong) EQView  *EQV_INS;
@property (nonatomic,strong) EQIndex *EQindex;
@property (nonatomic,strong) EQItem *CurEQItem;
@property (nonatomic,strong) NormalButton *Btn_EQReset;
@property (nonatomic,strong) NormalButton *Btn_EQByPass;
@property (nonatomic,strong) NormalButton *Btn_EQPG_MD;
@property (nonatomic, nonatomic) UIScrollView *SVEQ;
//@property (nonatomic,strong) ChannelBtn * channelBtn;

//音源
@property (strong, nonatomic) NormalButton *Btn_InputSource;
@property (strong, nonatomic) InputChannelSel *HI_CH;
@property (strong, nonatomic) InputChannelSel *AUX_CH;
//XOver
//弹出对话框调频率
@property (strong, nonatomic) ASValueTrackingSlider *sliderFreq;
@property (strong, nonatomic) UIButton *btnFreqMinus;
@property (strong, nonatomic) UIButton *btnFreqAdd;

@property (nonatomic,strong) UILabel *LabHP_Text;
//@property (nonatomic,strong) UILabel *LabXOver_Text;
@property (nonatomic,strong) UILabel *LabLP_Text;

@property (strong, nonatomic) NormalButton  *H_Filter;
@property (strong, nonatomic) NormalButton  *H_Level;
@property (strong, nonatomic) NormalButton  *H_Freq;

@property (strong, nonatomic) NormalButton  *L_Filter;
@property (strong, nonatomic) NormalButton  *L_Level;
@property (strong, nonatomic) NormalButton  *L_Freq;


@end

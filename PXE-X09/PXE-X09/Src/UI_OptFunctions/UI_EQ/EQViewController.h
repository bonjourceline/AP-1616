//
//  EQViewController.h
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
#import "IZValueSelectorView.h"
#import "ChannelBar.h"
#import "rootViewController.h"

@interface EQViewController : rootViewController
<UIScrollViewDelegate,
IZValueSelectorViewDataSource,
IZValueSelectorViewDelegate,
MBProgressHUDDelegate>
{
    @private
    
    int EQ_MODE;//1:gain 2:BW 3:Freq
    BOOL bool_ByPass;
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

//弹出对话框调EQ
@property (strong, nonatomic) ASValueTrackingSlider *sliderEQ;
@property (strong, nonatomic) UIButton *btnMinus;
@property (strong, nonatomic) UIButton *btnAdd;

@property (nonatomic,strong) EQView  *EQV_INS;
@property (nonatomic,strong) EQIndex *EQindex;
@property (nonatomic,strong) EQItem *CurEQItem;
@property (nonatomic,strong) NormalButton *Btn_EQReset;
@property (nonatomic,strong) NormalButton *Btn_EQByPass;
@property (nonatomic,strong) NormalButton *Btn_EQPG_MD;
@property (nonatomic, nonatomic) UIScrollView *SVEQ;
@property (nonatomic,strong) ChannelBtn * channelBtn;
@property (nonatomic,strong) ChannelBar * channelBar;
//@property (nonatomic,strong)  IZValueSelectorView *selectorHorizontal;

@end

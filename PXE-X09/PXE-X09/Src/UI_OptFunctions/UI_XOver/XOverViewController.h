//
//  XOverViewController.h
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
#import "DataCommunication.h"
#import "XOverItem.h"
#import "ASValueTrackingSlider.h"

#import "OutNameSet.h"

@interface XOverViewController : UIViewController
<MBProgressHUDDelegate>
{
    @private
    NSMutableArray *Filter_List;
    //NSMutableArray *Level_List;
    //NSMutableArray *LevelH_List;
    NSMutableArray *AllLevel;
    int Level_Val[16];
    
    Boolean Bool_HL;//True:高通
    UIButton *B_Buf;
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
    
    XOverItem *LinkXOverItem;
    
    NSString *setEnNum;
    int SEFF_SendListTotal;
    
    int LinkChannel;
    int OldLinkChannel;
    int OldChannelSel;
}


- (void)FlashXOverPageUI;

//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;


@property (strong, nonatomic) XOverItem *CurXOverItem;
//弹出对话框调频率
@property (strong, nonatomic) ASValueTrackingSlider *sliderFreq;
@property (strong, nonatomic) UIButton *btnMinus;
@property (strong, nonatomic) UIButton *btnAdd;

@end

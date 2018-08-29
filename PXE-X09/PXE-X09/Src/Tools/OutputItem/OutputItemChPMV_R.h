//
//  OutputItem.h
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "Define_Dimens.h"
#import "TopBarView.h"

#import "Masonry.h"
#import "MacDefine.h"

#import "PopoverView.h"
#import "NormalButton.h"
#import "DataCommunication.h"
#import "VolumeCircleIMLine.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"



#define TagStart_OutItem_SB_Volume    100
#define TagStart_OutItem_Btn_Volume   200
#define TagStart_OutItem_Btn_Polar    300

#define TagStart_OutItem_Btn_Mute     400
#define TagStart_OutItem_OutName      500
#define TagStart_OutItem_Btn_Channel  600
#define TagStart_OutItem_Self  700
@interface OutputItemChPMV_R : UIControl{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
    
    int DataMax;
    int DataVal;
    UIButton  *BtnSub, *BtnInc;
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
}


@property (strong, nonatomic) NormalButton *Btn_Volume;
@property (strong, nonatomic) UIButton *Btn_Channel;
@property (strong, nonatomic) NormalButton *Btn_Polar;
@property (strong, nonatomic) UIButton *Btn_Mute;


- (void)setOutputItemTag:(int)stag;

@end

//
//  OutputItem.h
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "TopBarView.h"
#import "Masonry.h"
#import "MacDefine.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"

#import "NormalButton.h"
#import "DataCommunication.h"
#import "VolumeCircleIMLine.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "VolumeCircleIMLine.h"


#define TagStart_DelayItem_SB_Volume    100
#define TagStart_DelayItem_Btn_Volume   200
#define TagStart_DelayItem_Btn_Channel  300
#define TagStart_DelayItem_Self         400


#define DelayUnit_CM   1
#define DelayUnit_MS   2
#define DelayUnit_INCH 3


@interface DelayItem : UIControl{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int delayUnit;
    int tag;
    int DataMax;
    int DataVal;
    UIButton  *BtnSub, *BtnInc;
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;

    
}

@property (strong, nonatomic) UISlider *SB_Volume;

@property (strong, nonatomic) UIButton *Btn_Volume;
@property (strong, nonatomic) UIButton *Btn_Channel;

- (void)setDelayItemTag:(int)stag;
- (void)setDelayItemVal:(int)sval;
- (void)setDelayItemMax:(int)sMax;
- (int)getDelayItemVal;
- (void)setDelayItemDelayUnit:(int)sDelayUnit;


@end

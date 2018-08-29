//
//  EQItem.h
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/30.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"
#import "PIMG.h"

#define EQItemTextSize 12

#define TagStartEQItem_Lab_ID   100
#define TagStartEQItem_Btn_Gain 200
#define TagStartEQItem_Btn_BW   300
#define TagStartEQItem_Btn_Freq 400
#define TagStartEQItem_Btn_Reset 500
#define TagStartEQItem_SB_Gain   600
#define TagStartEQItem_Self      700

#define EQItemNoramlColor 1
#define EQItemPressColor 2
#define EQItemLockedlColor 3
#define EQItemNoramlLockColor 4

@interface EQItemFr : UIView{
@private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    //曲线框的边距
    double BtnHeight;
    double SBHeight;
    int    tag;

    
    UIColor* ColorNormal;      //
    UIColor* ColorPress;       //
    UIColor* ColorDisable;     //
    UIColor* ColorSBProgress;  //
    UIColor* ColorSBProgressBg;//

    
}
@property (strong, nonatomic) UILabel  *Lab_ID;
@property (strong, nonatomic) UIButton *Btn_Gain;
@property (strong, nonatomic) UIButton *Btn_BW;
@property (strong, nonatomic) UIButton *Btn_Freq;
@property (strong, nonatomic) UIButton *Btn_Reset;
@property (strong, nonatomic) UISlider *SB_Gain;


//获取控件编号
- (int)getTag;
//设置控件编号
- (void)setEQItemTag:(int)sTag;
//设置控件颜色0：normal，1：press：3：Locked
- (void)setStateColor:(int)State;




@end

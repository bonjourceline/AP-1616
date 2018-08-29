//
//  MixerItem.h
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


#define TagStart_MixerItem_Lab_MixerInput 100
#define TagStart_MixerItem_Lab_Volue  200
#define TagStart_MixerItem_Btn_Switch   300

#define TagStart_MixerItem_SB_Volume 400
#define TagStart_MixerItem_V_Disable  500
#define TagStart_MixerItem_mView  600
#define TagStart_MixerItem_self   700


@interface MixerItem : UIControl{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int32_t ItemColorNormal;   //边框颜色
    int32_t ItemColorPress;    //边框颜色
    UIColor* ItemColorVolue;    //数值文本颜色
    UIColor* ItemColorMixerInput; //音源文本颜色
    UIColor* ItemColorSBProgress;   //边框颜色
    UIColor* ItemColorSBProgressBg;    //边框颜色

    CGColorSpaceRef NormalColorSpace;;
    CGColorRef NormalColorref;
    CGColorSpaceRef PressColorSpace;;
    CGColorRef PressColorref;
    
    
    int tag;
    int DataTemp;
    int DataMax;
    int DataVal;
    int polar;
    UILabel  *Lab_MixerInput;
    UILabel  *Lab_Volue;
    UIButton *Btn_Switch;
    UIButton *Btn_Polar;
//    UISlider *SB_Volume;
    UIView   *V_Disable;
    UIView   *mView;
    
    
    UIButton  *BtnSub, *BtnInc;
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;

}

@property(nonatomic,strong)UISlider *SB_Volume;

- (void)setMixerItemTag:(int)stag;
- (void)setMixerItemDisable:(BOOL)Set;
- (void)setMixerItemPress;
- (void)setMixerItemNormal;
//- (void)setMixerItemBtnSwitchPress;
//- (void)setMixerItemBtnSwitchNormal;
- (void)setDataVal:(int)val;
- (void)setDataMax:(int)val;
- (int)getDataVal;
- (void)setLab_MixerInput:(NSString*)val;
- (void)setPolar:(int)val;
- (int)getPolar;

@end

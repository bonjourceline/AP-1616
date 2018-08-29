//
//  EQView.h
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/29.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
//画曲线相关

#define   FS          96000
#define   pi          3.1415926
#define   Oct_6dB     0
#define   Oct_12dB    1
#define   Oct_18dB    2
#define   Oct_24dB    3
#define   Oct_30dB    4
#define   Oct_36dB    5
#define   Oct_42dB    6
#define   Oct_48dB    7
#define   HL_OFF      8

#define   L_R         0
#define   Bessel      1
#define   ButtWorth   2


@interface EQView : UIView{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;
    //曲线框的边距
    double marginLeft;
    double marginRight;
    double marginTop;
    double marginBottom;
    double frameWidth;
    double frameHeight;

    UIColor* clearColor;   //无色颜色
    UIColor* EQView_Frame_Color;   //EQ边框颜色
    UIColor* EQView_Text_Color;    //EQ文本颜色
    UIColor* EQView_MidLine_Color; //EQ中线颜色
    UIColor* EQView_EQLine_Color;  //EQ曲线颜色
    
    //曲线框的边距
    double LineWidthOf_Frame;
    double LineWidthOf_InFrame;
    double LineWidthOf_MidLine;
    double LineWidthOf_EQLine;
    
    //X轴的划分
    float x3Base;
    float x3Tap;
    
    float xTap1;
    float xTap2;
    float xTap3;
    float xTap4;
    float xTap5;
    float xTap6;
    float xTap7;
    float xTap8;
    float xTap9;
    
    NSArray *TV_Freq0;
    NSArray *TV_Freq1;
    NSArray *TV_Freq2;
    NSArray *TV_DB;
    NSArray *TV_DB0;
    NSArray *TV_DB1;
    
    //保存滤波器图形每点所对应的dB值
    double m_nPoint[241];
    double m_nPointHP[241];//高通各点增益
    double m_nPointLP[241];//低通各点增益
    double m_nPointPEQ[OUT_CH_EQ_MAX][241] ;//31点增益
    //保存31点EQ的频率在241点EQ的索引值
    //int EQPoint[] = new int[DataStruct.OUT_CH_EQ_MAX];
    int EQPointLR[OUT_CH_EQ_MAX][241];
    
    //保存滤波器图形每点所对应的dB值的Y坐标
    double m_nPointY[241];
    double m_nPointX[241];
    
    struct output_Struct EQ_Filter ;
    struct output_Struct ReadEQ ;
    
    
    BOOL INS_OUT;
    int MaxEQ;
}

/*
 * 高通滤波器更新
 *
 */
- (void)SetEQData:(struct output_Struct)SyncEQ;
- (void)SetINSEQData:(struct inputs_Struct)SyncEQ;

@end

//
//  EQIndex.h
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

#define EQindexTextSize 12

@interface EQIndex : UIView{
        
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    //曲线框的边距
    double BtnHeight;
    double SBHeight;

    UIColor* ColorNormal;
}
@property (strong, nonatomic) UILabel *Lab_ID;
@property (strong, nonatomic) UILabel *Lab_Gain;
@property (strong, nonatomic) UILabel *Lab_BW;
@property (strong, nonatomic) UILabel *Lab_Freq;
@property (strong, nonatomic) UILabel *Lab_Reset;
@property (strong, nonatomic) UILabel *Lab_GainMax;
@property (strong, nonatomic) UILabel *Lab_GainMin;
@property (strong, nonatomic) UILabel *Lab_GainZero;

- (void)frame:(CGRect)frame;
@end

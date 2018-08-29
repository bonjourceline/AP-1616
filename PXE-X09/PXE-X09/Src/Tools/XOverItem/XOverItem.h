//
//  XOverItem.h
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"

#import "NormalButton.h"


#define TagStart_XOVER_H_Filter 100
#define TagStart_XOVER_H_Level  200
#define TagStart_XOVER_H_Freq   300

#define TagStart_XOVER_L_Filter 400
#define TagStart_XOVER_L_Level  500
#define TagStart_XOVER_L_Freq   600

#define TagStart_XOVER_Self     700


@interface XOverItem : UIView{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
}

@property (strong, nonatomic) UIButton *Btn_Channel;//NormalButton

@property (strong, nonatomic) UILabel  *H_XOverLab;
@property (strong, nonatomic) UIButton *H_Filter;
@property (strong, nonatomic) UIButton *H_Level;
@property (strong, nonatomic) UIButton *H_Freq;

@property (strong, nonatomic) UILabel  *L_XOverLab;
@property (strong, nonatomic) UIButton *L_Filter;
@property (strong, nonatomic) UIButton *L_Level;
@property (strong, nonatomic) UIButton *L_Freq;



- (void)setXOverItemTag:(int)stag;

@end

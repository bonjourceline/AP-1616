//
//  ChannelBtn.h
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/4/7.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"
#import "NormalButton.h"

#define TagChannelBtnStart 1300

@interface ChannelBar : UIControl{
    
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    double Start_X;           // 第一个按钮的X坐标
    double Start_Y;           // 第一个按钮的Y坐标
    double Width_Space;       // 2个按钮之间的横间距
    double Height_Space;      // 竖间距
    double Button_Height;     // 高
    double Button_Width;      // 宽
    
    int tag;
    int channel;
    
    NormalButton* NB_Btn;
}

//获取当前通道
- (int)getChannel;
- (void)setChannel:(int)ch;
@end

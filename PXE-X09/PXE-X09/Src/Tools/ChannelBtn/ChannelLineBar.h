//
//  X2S_PageTitleBar.h
//  YB-DAP460-X2S
//
//  Created by chsdsp on 2017/4/27.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"
#import "NormalButton.h"
#import "PIMG.h"

//
@interface ChannelLineBar : UIControl{
    
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
    
    UIButton* NB_Btn;    
    UIView *Vlines,*VLine;
    
    
}

//获取当前通道
- (int)getChannel;
- (void)setChannel:(int)sel;
@end

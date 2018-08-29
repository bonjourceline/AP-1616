//
//  InputChannelSel.h
//  KP_DBP410_CF_A10S
//
//  Created by chsdsp on 2017/6/26.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"

#import "NormalButton.h"

#define EVENT_CH    0
#define EVENT_LINKA 1
#define EVENT_LINKB 2


@interface InputChannelSel : UIControl
{
    
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;

    double side;
    BOOL BOOL_LINKA, BOOL_LINKB;
    
    NormalButton *ch1,*ch2,*ch3,*ch4;
    UIButton *LinkA, *LinkB;
    
    int channelStart,CurChannel;
    
    int event;
}


- (void)setChannelStart:(int)val;
- (void)setCurChannel:(int)val;
- (void)setLinkA:(BOOL)val;
- (void)setLinkB:(BOOL)val;

- (int)getCurChannel;
- (BOOL)getLinkA;
- (BOOL)getLinkB;
- (int)getEvent;


@end

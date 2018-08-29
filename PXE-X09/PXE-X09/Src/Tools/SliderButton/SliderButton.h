//
//  GainSBItem.h
//  YBD-DAP460-NDS460
//
//  Created by chsdsp on 2017/6/15.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Slider.h"
#import "Masonry.h"
@interface SliderButton : UIControl
{
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
    
    double btnSize;
    
    int DataVal;
    int DataMax;
    
    Slider *mSBGain;
    UIButton  *BtnSub, *BtnInc;
    UIButton   *mText,*Table;
    UILabel *Min,*Max;
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
    
    BOOL BOOL_DB;
    
}

- (void)setMaxProgress:(int)val;
- (void)setProgress:(int)val;
- (int)GetProgress;
- (void)setMidTextString:(NSString*)st;
- (void)setShowDB:(BOOL)val;
- (void)setVolTextSize:(int)val;
@end

//
//  BottomBar.h
//  HS-DAP812-DSP-8012
//
//  Created by chsdsp on 2017/8/18.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>



#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"

@interface BottomBar : UIControl
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
    
    UIImageView *Bg;
    
    UIView *View1;
    UIView *View2;
    UIView *View3;
    UIView *View4;
    UIView *View5;
    
    UIImageView *IVM1;
    UIImageView *IVM2;
    UIImageView *IVM3;
    UIImageView *IVM4;
    UIImageView *IVM5;
    
    UILabel *Lab1;
    UILabel *Lab2;
    UILabel *Lab3;
    UILabel *Lab4;
    UILabel *Lab5;

    UIButton *Btn1;
    UIButton *Btn2;
    UIButton *Btn3;
    UIButton *Btn4;
    UIButton *Btn5;
    
}
- (void)setDataVal:(int)val;
- (int)getDataVal;

@end

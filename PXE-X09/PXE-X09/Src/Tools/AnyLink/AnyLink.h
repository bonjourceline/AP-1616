//
//  AnyLink.h
//  YDW-DCS480-DSP-408
//
//  Created by chsdsp on 2018/1/31.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalButton.h"
#import "DataStruct.h"
@interface AnyLink : UIView

{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
    NSString *BtnTemp;

    
    double Start_X;           // 第一个按钮的X坐标
    double Start_Y;           // 第一个按钮的Y坐标
    double Width_Space;       // 2个按钮之间的横间距
    double Height_Space;      // 竖间距
    double Button_Height;     // 高
    double Button_Width;      // 宽
    
    int channel,group;
    UIButton *BtnGTemp;
    
    BOOL BOOLHaveGroup[17];
    //int GA[][16];
}
@property (strong, nonatomic) NormalButton *Btn_Cancel;
@property (strong, nonatomic) NormalButton *Btn_Ok;

@property (strong, nonatomic) NormalButton *Btn_Group;
@property (strong, nonatomic) NormalButton *Btn_Join;
@property (strong, nonatomic) NormalButton *Btn_Delete;
@property (strong, nonatomic) NormalButton *Btn_unLink;
@property (nonatomic, strong)void (^clickBlock)(void);
@property (nonatomic, strong)void (^unlinkBlock)(void);

@end

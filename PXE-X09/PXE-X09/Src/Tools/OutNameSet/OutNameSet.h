//
//  OutNameSet.h
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/3.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"

#import "NormalButton.h"
#define OutputSetNameDialog_Height 550
#define OutputSetNameDialog_Width  360
#define OutputSetNameDialogMsg_Height 40
#define EndFlag 0xee


#define OutputSetNameBtn_Height 25
#define OutputSetNameBtn_Width  80
#define OutputSetNameBtnMid     5

#define maxSpkType 24
#define TagStartOutputSetName   1000
@interface OutNameSet : UIView

{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
    
    //通道类型相关变量
    int ChannelNumList[32];
    int CH_Mutex[32][32];
    NSString *OutChName;
    NormalButton *CurBtn;
    int curSpkType;
    
    
    
}
@property (strong, nonatomic) UIImageView *Ibg;

@property (strong, nonatomic) NormalButton *Btn0;
@property (strong, nonatomic) NormalButton *Btn1;
@property (strong, nonatomic) NormalButton *Btn2;
@property (strong, nonatomic) NormalButton *Btn3;
@property (strong, nonatomic) NormalButton *Btn4;
@property (strong, nonatomic) NormalButton *Btn5;
@property (strong, nonatomic) NormalButton *Btn6;
@property (strong, nonatomic) NormalButton *Btn7;
@property (strong, nonatomic) NormalButton *Btn8;
@property (strong, nonatomic) NormalButton *Btn9;
@property (strong, nonatomic) NormalButton *Btn10;
@property (strong, nonatomic) NormalButton *Btn11;
@property (strong, nonatomic) NormalButton *Btn12;
@property (strong, nonatomic) NormalButton *Btn13;
@property (strong, nonatomic) NormalButton *Btn14;
@property (strong, nonatomic) NormalButton *Btn15;
@property (strong, nonatomic) NormalButton *Btn16;
@property (strong, nonatomic) NormalButton *Btn17;
@property (strong, nonatomic) NormalButton *Btn18;
@property (strong, nonatomic) NormalButton *Btn19;
@property (strong, nonatomic) NormalButton *Btn20;
@property (strong, nonatomic) NormalButton *Btn21;
@property (strong, nonatomic) NormalButton *Btn22;
@property (strong, nonatomic) NormalButton *Btn23;
@property (strong, nonatomic) NormalButton *Btn24;



@property (strong, nonatomic) UILabel  *LabMsg;
@property (strong, nonatomic) UIButton *Btn_Cancel;
@property (strong, nonatomic) UIButton *Btn_Ok;

- (NSString*)getOutputChannelTypeName:(int)Channel;
- (NSString*)getOutputTypeName:(int)Name;
- (int)getOutputTypeNum:(NSString*)Name;
- (void)flashOutputType:(int)Name;
- (NSString*)getOutputName;
- (void)flashOutputState:(int) curType;
- (int)getCurSpkType;


@end

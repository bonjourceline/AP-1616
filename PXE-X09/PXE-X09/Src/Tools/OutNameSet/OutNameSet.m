//
//  OutNameSet.m
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/3.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutNameSet.h"


#define OutNameSet_bg (0xff333333) //
#define OutNameSet_MsgColor (0xffffffff) //

//通道設置選擇框选择
#define UI_ChannelNameSet_Btn_Press  (0xFFff1414) //
#define UI_ChannelNameSet_Btn_Normal (0xff000000) //
#define UI_ChannelNameSet_BtnText_Press (0xFFffffff) //
#define UI_ChannelNameSet_BtnText_Normal (0xFF000000) //


@implementation OutNameSet

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = KScreenWidth/2;//frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        [self setup];
    }
    return self;
}

- (void)setup{
    [self initData];
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, [Dimens GDimens:OutputSetNameDialogMsg_Height], [Dimens GDimens:(OutputSetNameDialog_Width)], [Dimens GDimens:OutputSetNameDialog_Height]);
    
    self.LabMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:(OutputSetNameDialog_Width)], [Dimens GDimens:OutputSetNameDialogMsg_Height])];
    self.LabMsg.text = [LANG DPLocalizedString:@"L_Out_Type"];
    self.LabMsg.textColor = SetColor(OutNameSet_MsgColor);
    self.LabMsg.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.LabMsg];
    [self.LabMsg setBackgroundColor:SetColor(OutNameSet_bg)];
    //Btn
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(
        [Dimens GDimens:0],
        [Dimens GDimens:OutputSetNameDialog_Height-OutputSetNameDialogMsg_Height],
        [Dimens GDimens:(OutputSetNameDialog_Width)],
        [Dimens GDimens:OutputSetNameDialogMsg_Height])
    ];
    bg.backgroundColor = SetColor(OutNameSet_bg);
    [self addSubview:bg];
    
    self.Btn_Cancel = [[UIButton alloc]initWithFrame:CGRectMake(
        [Dimens GDimens:0],
        [Dimens GDimens:OutputSetNameDialog_Height-OutputSetNameDialogMsg_Height],
        [Dimens GDimens:(OutputSetNameDialog_Width/2)],
        [Dimens GDimens:OutputSetNameDialogMsg_Height])
    ];
    self.Btn_Cancel.backgroundColor = [UIColor clearColor];
    [self.Btn_Cancel setTitle:[LANG DPLocalizedString:@"L_System_Cancel"] forState:UIControlStateNormal];
    [self addSubview:self.Btn_Cancel];
    
    self.Btn_Ok = [[UIButton alloc]initWithFrame:CGRectMake(
        [Dimens GDimens:OutputSetNameDialog_Width/2],
        [Dimens GDimens:OutputSetNameDialog_Height-OutputSetNameDialogMsg_Height],
        [Dimens GDimens:(OutputSetNameDialog_Width/2)],
        [Dimens GDimens:OutputSetNameDialogMsg_Height])
    ];
    self.Btn_Ok.backgroundColor = [UIColor clearColor];
    [self.Btn_Ok setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    [self addSubview:self.Btn_Ok];
    
    UIView *Mid = [[UIView alloc]initWithFrame:CGRectMake(
        [Dimens GDimens:OutputSetNameDialog_Width/2-1],
        [Dimens GDimens:OutputSetNameDialog_Height-OutputSetNameDialogMsg_Height+2],
        [Dimens GDimens:(2)],
        [Dimens GDimens:OutputSetNameDialogMsg_Height])
    ];
    Mid.backgroundColor = [UIColor whiteColor];
    [self addSubview:Mid];
    ///////////

    
    [self initOutputSetName];
    CurBtn = nil;
    
}
#pragma initOutputSetName

- (void)initOutputSetName{
    self.Ibg = [[UIImageView alloc]init];
    [self addSubview:self.Ibg];
    [self.Ibg setImage:[UIImage imageNamed:@"delaysettings_bg"]];
    [self.Ibg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset([Dimens GDimens:25]);
        make.size.mas_equalTo(CGSizeMake(100, [Dimens GDimens:250]));
    }];

    self.Btn0 = [[NormalButton alloc]init];
    self.Btn1 = [[NormalButton alloc]init];
    self.Btn2 = [[NormalButton alloc]init];
    self.Btn3 = [[NormalButton alloc]init];
    self.Btn4 = [[NormalButton alloc]init];
    self.Btn5 = [[NormalButton alloc]init];
    self.Btn6 = [[NormalButton alloc]init];
    self.Btn7 = [[NormalButton alloc]init];
    self.Btn8 = [[NormalButton alloc]init];
    self.Btn9 = [[NormalButton alloc]init];
    self.Btn10 = [[NormalButton alloc]init];
    self.Btn11 = [[NormalButton alloc]init];
    self.Btn12 = [[NormalButton alloc]init];
    self.Btn13 = [[NormalButton alloc]init];
    self.Btn14 = [[NormalButton alloc]init];
    self.Btn15 = [[NormalButton alloc]init];
    self.Btn16 = [[NormalButton alloc]init];
    self.Btn17 = [[NormalButton alloc]init];
    self.Btn18 = [[NormalButton alloc]init];
    self.Btn19 = [[NormalButton alloc]init];
    self.Btn20 = [[NormalButton alloc]init];
    self.Btn21 = [[NormalButton alloc]init];
    self.Btn22 = [[NormalButton alloc]init];
    self.Btn23 = [[NormalButton alloc]init];
    self.Btn24 = [[NormalButton alloc]init];

    
    [self addSubview:self.Btn0];
    [self addSubview:self.Btn1];
    [self addSubview:self.Btn2];
    [self addSubview:self.Btn3];
    [self addSubview:self.Btn4];
    [self addSubview:self.Btn5];
    [self addSubview:self.Btn6];
    [self addSubview:self.Btn7];
    [self addSubview:self.Btn8];
    [self addSubview:self.Btn9];
    [self addSubview:self.Btn10];
    [self addSubview:self.Btn11];
    [self addSubview:self.Btn12];
    [self addSubview:self.Btn13];
    [self addSubview:self.Btn14];
    [self addSubview:self.Btn15];
    [self addSubview:self.Btn16];
    [self addSubview:self.Btn17];
    [self addSubview:self.Btn18];
    [self addSubview:self.Btn19];
    [self addSubview:self.Btn20];
    [self addSubview:self.Btn21];
    [self addSubview:self.Btn22];
    [self addSubview:self.Btn23];
    [self addSubview:self.Btn24];
    
    [self.Btn0 setTag:0+TagStartOutputSetName];
    [self.Btn0 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn0 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn0.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn0.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn0 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn0 setTitle:[self getOutputTypeName:0] forState:UIControlStateNormal] ;
    
    [self.Btn1 setTag:1+TagStartOutputSetName];
    [self.Btn1 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn1 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn1.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn1.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn1 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn1 setTitle:[self getOutputTypeName:1] forState:UIControlStateNormal] ;
    
    [self.Btn2 setTag:2+TagStartOutputSetName];
    [self.Btn2 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn2 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn2.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn2.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn2 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn2 setTitle:[self getOutputTypeName:2] forState:UIControlStateNormal] ;
    
    [self.Btn3 setTag:3+TagStartOutputSetName];
    [self.Btn3 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn3 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn3.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn3.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn3 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn3 setTitle:[self getOutputTypeName:3] forState:UIControlStateNormal] ;
    
    [self.Btn4 setTag:4+TagStartOutputSetName];
    [self.Btn4 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn4 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn4.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn4.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn4 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn4 setTitle:[self getOutputTypeName:4] forState:UIControlStateNormal] ;
    
    [self.Btn5 setTag:5+TagStartOutputSetName];
    [self.Btn5 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn5 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn5.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn5.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn5 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn5 setTitle:[self getOutputTypeName:5] forState:UIControlStateNormal] ;
    
    [self.Btn6 setTag:6+TagStartOutputSetName];
    [self.Btn6 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn6 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn6.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn6.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn6 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn6 setTitle:[self getOutputTypeName:6] forState:UIControlStateNormal] ;
    
    [self.Btn7 setTag:7+TagStartOutputSetName];
    [self.Btn7 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn7 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn7.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn7.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn7 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn7 setTitle:[self getOutputTypeName:7] forState:UIControlStateNormal] ;
    
    [self.Btn8 setTag:8+TagStartOutputSetName];
    [self.Btn8 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn8 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn8.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn8.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn8 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn8 setTitle:[self getOutputTypeName:8] forState:UIControlStateNormal] ;
    
    [self.Btn9 setTag:9+TagStartOutputSetName];
    [self.Btn9 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn9 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn9.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn9.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn9 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn9 setTitle:[self getOutputTypeName:9] forState:UIControlStateNormal] ;
    
    [self.Btn10 setTag:10+TagStartOutputSetName];
    [self.Btn10 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn10 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn10.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn10.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn10 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn10 setTitle:[self getOutputTypeName:10] forState:UIControlStateNormal] ;
    
    [self.Btn11 setTag:11+TagStartOutputSetName];
    [self.Btn11 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn11 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn11.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn11.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn11 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn11 setTitle:[self getOutputTypeName:11] forState:UIControlStateNormal] ;
    
    [self.Btn12 setTag:12+TagStartOutputSetName];
    [self.Btn12 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn12 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn12.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn12.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn12 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn12 setTitle:[self getOutputTypeName:12] forState:UIControlStateNormal] ;
    
    [self.Btn13 setTag:13+TagStartOutputSetName];
    [self.Btn13 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn13 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn13.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn13.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn13 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn13 setTitle:[self getOutputTypeName:13] forState:UIControlStateNormal] ;
    
    [self.Btn14 setTag:14+TagStartOutputSetName];
    [self.Btn14 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn14 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn14.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn14.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn14 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn14 setTitle:[self getOutputTypeName:14] forState:UIControlStateNormal] ;
    
    [self.Btn15 setTag:15+TagStartOutputSetName];
    [self.Btn15 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn15 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn15.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn15.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn15 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn15 setTitle:[self getOutputTypeName:15] forState:UIControlStateNormal] ;
    
    [self.Btn16 setTag:16+TagStartOutputSetName];
    [self.Btn16 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn16 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn16.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn16.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn16 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn16 setTitle:[self getOutputTypeName:16] forState:UIControlStateNormal] ;
    
    [self.Btn17 setTag:17+TagStartOutputSetName];
    [self.Btn17 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn17 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn17.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn17.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn17 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn17 setTitle:[self getOutputTypeName:17] forState:UIControlStateNormal] ;
    
    [self.Btn18 setTag:18+TagStartOutputSetName];
    [self.Btn18 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn18 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn18.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn18.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn18 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn18 setTitle:[self getOutputTypeName:18] forState:UIControlStateNormal] ;
    
    [self.Btn19 setTag:19+TagStartOutputSetName];
    [self.Btn19 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn19 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn19.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn19.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn19 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn19 setTitle:[self getOutputTypeName:19] forState:UIControlStateNormal] ;
    
    [self.Btn20 setTag:20+TagStartOutputSetName];
    [self.Btn20 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn20 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn20.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn20.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn20 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn20 setTitle:[self getOutputTypeName:20] forState:UIControlStateNormal] ;
    
    [self.Btn21 setTag:21+TagStartOutputSetName];
    [self.Btn21 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn21 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn21.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn21.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn21 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn21 setTitle:[self getOutputTypeName:21] forState:UIControlStateNormal] ;
    
    [self.Btn22 setTag:22+TagStartOutputSetName];
    [self.Btn22 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn22 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn22.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn22.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn22 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn22 setTitle:[self getOutputTypeName:22] forState:UIControlStateNormal] ;
    
    [self.Btn23 setTag:23+TagStartOutputSetName];
    [self.Btn23 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn23 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn23.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn23.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn23 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn23 setTitle:[self getOutputTypeName:23] forState:UIControlStateNormal] ;
    
    [self.Btn24 setTag:24+TagStartOutputSetName];
    [self.Btn24 initView:3 withBorderWidth:1 withNormalColor:UI_ChannelNameSet_Btn_Normal withPressColor:UI_ChannelNameSet_Btn_Press withType:1];
    [self.Btn24 setTextColorWithNormalColor:UI_ChannelNameSet_BtnText_Normal withPressColor:UI_ChannelNameSet_BtnText_Press];
    self.Btn24.titleLabel.font = [UIFont systemFontOfSize:11];
    self.Btn24.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn24 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn24 setTitle:[self getOutputTypeName:24] forState:UIControlStateNormal] ;
    
    //if(i == 0){
    self.Btn0.frame = CGRectMake(
                               [Dimens GDimens:5],
                               [Dimens GDimens:OutputSetNameDialogMsg_Height+5],
                               [Dimens GDimens:OutputSetNameBtn_Width],
                               [Dimens GDimens:OutputSetNameBtn_Height]
                               );
    //}else if(i<=6){
    self.Btn1.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+0*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn2.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+1*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn3.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+2*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn4.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+3*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn5.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+4*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn6.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+5*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );

    //}else if(i<=12){
    self.Btn7.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height*2+0*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn8.frame = CGRectMake(
                                [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameDialogMsg_Height*2+1*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                [Dimens GDimens:OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameBtn_Height]
                                );
    self.Btn9.frame = CGRectMake(
                                [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameDialogMsg_Height*2+2*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                [Dimens GDimens:OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameBtn_Height]
                                );
    self.Btn10.frame = CGRectMake(
                                [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameDialogMsg_Height*2+3*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                [Dimens GDimens:OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameBtn_Height]
                                );
    self.Btn11.frame = CGRectMake(
                                [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameDialogMsg_Height*2+4*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                [Dimens GDimens:OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameBtn_Height]
                                );
    self.Btn12.frame = CGRectMake(
                                [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameDialogMsg_Height*2+5*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                [Dimens GDimens:OutputSetNameBtn_Width],
                                [Dimens GDimens:OutputSetNameBtn_Height]
                                );
    //}else if(i<=15 ){
    self.Btn13.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameBtn_Height],
                           [Dimens GDimens:OutputSetNameDialog_Height*0.6+0*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn14.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameBtn_Height],
                                 [Dimens GDimens:OutputSetNameDialog_Height*0.6+1*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );
    self.Btn15.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameBtn_Height],
                                 [Dimens GDimens:OutputSetNameDialog_Height*0.6+2*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );

    //}else if(i<=18){
    self.Btn16.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameDialog_Height*0.6+0*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn17.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameDialog_Height*0.6+1*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );
    self.Btn18.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameDialog_Width - OutputSetNameBtn_Height-OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameDialog_Height*0.6+2*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );
        
    //}else if(i<=21){
    self.Btn19.frame = CGRectMake(
                           [Dimens GDimens:OutputSetNameDialog_Width/2 - OutputSetNameBtn_Width/2],
                           [Dimens GDimens:OutputSetNameDialogMsg_Height+5+0*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                           [Dimens GDimens:OutputSetNameBtn_Width],
                           [Dimens GDimens:OutputSetNameBtn_Height]
                           );
    self.Btn20.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameDialog_Width/2 - OutputSetNameBtn_Width/2],
                                 [Dimens GDimens:OutputSetNameDialogMsg_Height+5+1*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );
    self.Btn21.frame = CGRectMake(
                                 [Dimens GDimens:OutputSetNameDialog_Width/2 - OutputSetNameBtn_Width/2],
                                 [Dimens GDimens:OutputSetNameDialogMsg_Height+5+2*(OutputSetNameBtn_Height+OutputSetNameBtnMid)],
                                 [Dimens GDimens:OutputSetNameBtn_Width],
                                 [Dimens GDimens:OutputSetNameBtn_Height]
                                 );
    //}else if(i==24){
        self.Btn24.frame = CGRectMake(
                               [Dimens GDimens:OutputSetNameDialog_Width/2 - OutputSetNameBtn_Width/2],
                               [Dimens GDimens:OutputSetNameDialog_Height - 10 - OutputSetNameDialogMsg_Height - OutputSetNameBtn_Height],
                               [Dimens GDimens:OutputSetNameBtn_Width],
                               [Dimens GDimens:OutputSetNameBtn_Height]
                               );
        
    //}else if(i==22){
        self.Btn22.frame = CGRectMake(
                               [Dimens GDimens:OutputSetNameDialog_Width/2 - OutputSetNameBtn_Width*1.8],
                               [Dimens GDimens:OutputSetNameDialog_Height - 10 - OutputSetNameDialogMsg_Height - OutputSetNameBtn_Height],
                               [Dimens GDimens:OutputSetNameBtn_Width],
                               [Dimens GDimens:OutputSetNameBtn_Height]
                               );
        
   // }else if(i==23){
        self.Btn23.frame = CGRectMake(
                               [Dimens GDimens:OutputSetNameDialog_Width/2 + OutputSetNameBtn_Width*0.8],
                               [Dimens GDimens:OutputSetNameDialog_Height - 10 - OutputSetNameDialogMsg_Height - OutputSetNameBtn_Height],
                               [Dimens GDimens:OutputSetNameBtn_Width],
                               [Dimens GDimens:OutputSetNameBtn_Height]
                               );
        
   // }
    
//    [self flashOutputState];
    
}

- (void)setBtnNormalAll{
    [self.Btn0 setNormal];
    [self.Btn1 setNormal];
    [self.Btn2 setNormal];
    [self.Btn3 setNormal];
    [self.Btn4 setNormal];
    [self.Btn5 setNormal];
    [self.Btn6 setNormal];
    [self.Btn7 setNormal];
    [self.Btn8 setNormal];
    [self.Btn9 setNormal];
    [self.Btn10 setNormal];
    [self.Btn11 setNormal];
    [self.Btn12 setNormal];
    [self.Btn13 setNormal];
    [self.Btn14 setNormal];
    [self.Btn15 setNormal];
    [self.Btn16 setNormal];
    [self.Btn17 setNormal];
    [self.Btn18 setNormal];
    [self.Btn19 setNormal];
    [self.Btn20 setNormal];
    [self.Btn21 setNormal];
    [self.Btn22 setNormal];
    [self.Btn23 setNormal];
    [self.Btn24 setNormal];
}

- (void)setBtnDisable:(int)sel{
    switch (sel) {
        case 0: [self.Btn0 setDisable]; break;
        case 1: [self.Btn1 setDisable]; break;
        case 2: [self.Btn2 setDisable]; break;
        case 3: [self.Btn3 setDisable]; break;
        case 4: [self.Btn4 setDisable]; break;
        case 5: [self.Btn5 setDisable]; break;
        case 6: [self.Btn6 setDisable]; break;
        case 7: [self.Btn7 setDisable]; break;
        case 8: [self.Btn8 setDisable]; break;
        case 9: [self.Btn9 setDisable]; break;

        case 10: [self.Btn10 setDisable]; break;
        case 11: [self.Btn11 setDisable]; break;
        case 12: [self.Btn12 setDisable]; break;
        case 13: [self.Btn13 setDisable]; break;
        case 14: [self.Btn14 setDisable]; break;
        case 15: [self.Btn15 setDisable]; break;
        case 16: [self.Btn16 setDisable]; break;
        case 17: [self.Btn17 setDisable]; break;
        case 18: [self.Btn18 setDisable]; break;
        case 19: [self.Btn19 setDisable]; break;
            
        case 20: [self.Btn20 setDisable]; break;
        case 21: [self.Btn21 setDisable]; break;
        case 22: [self.Btn22 setDisable]; break;
        case 23: [self.Btn23 setDisable]; break;
        case 24: [self.Btn24 setDisable]; break;

        default:
            break;
    }
    
}


- (void)setBtnPress:(int)sel{
    switch (sel) {
        case 0: [self.Btn0 setPress]; break;
        case 1: [self.Btn1 setPress]; break;
        case 2: [self.Btn2 setPress]; break;
        case 3: [self.Btn3 setPress]; break;
        case 4: [self.Btn4 setPress]; break;
        case 5: [self.Btn5 setPress]; break;
        case 6: [self.Btn6 setPress]; break;
        case 7: [self.Btn7 setPress]; break;
        case 8: [self.Btn8 setPress]; break;
        case 9: [self.Btn9 setPress]; break;
            
        case 10: [self.Btn10 setPress]; break;
        case 11: [self.Btn11 setPress]; break;
        case 12: [self.Btn12 setPress]; break;
        case 13: [self.Btn13 setPress]; break;
        case 14: [self.Btn14 setPress]; break;
        case 15: [self.Btn15 setPress]; break;
        case 16: [self.Btn16 setPress]; break;
        case 17: [self.Btn17 setPress]; break;
        case 18: [self.Btn18 setPress]; break;
        case 19: [self.Btn19 setPress]; break;
            
        case 20: [self.Btn20 setPress]; break;
        case 21: [self.Btn21 setPress]; break;
        case 22: [self.Btn22 setPress]; break;
        case 23: [self.Btn23 setPress]; break;
        case 24: [self.Btn24 setPress]; break;
            
        default:
            break;
    }
    
}


- (void)btn_click:(NormalButton*)sender{
    int val = (int)sender.tag - TagStartOutputSetName;
    [self CheckChannelNum];
    if(ChannelNumList[val] == EndFlag){
        return;
    }
    curSpkType = val;
    if(CurBtn != nil){
        [CurBtn setNormal];
    }
    CurBtn = sender;
    OutChName = [self getOutputTypeName:curSpkType];
    [sender setPress];
    
}

- (void)flashOutputState:(int) curType{
    curSpkType = curType;
    [self CheckChannelNum];

    [self setBtnNormalAll];
    for(int i=0;i<maxSpkType;i++){
        //NSLog(@"ChannelNumList[%d]=%d",i,ChannelNumList[i]);
        if(ChannelNumList[i] == EndFlag){
            [self setBtnDisable:i];
        }
    }
}
    
#pragma initData

- (void)initData{

    int cml0 = 2;
    int cml1 = 6;
    int cml2 = 8;
    int cml3 = 6;
    int cml4 = 10;
    int cml5 = 10;
    int cml6 = 12;
    int cml7 = 6;
    int cml8 = 8;
    int cml9 = 6;
    int cml10 = 10;
    int cml11 = 10;
    int cml12 = 12;
    int cml13 = 4;
    int cml14 = 4;
    int cml15 = 6;
    int cml16 = 4;
    int cml17 = 4;
    int cml18 = 6;
    int cml19 = 3;
    int cml20 = 3;
    int cml21 = 4;
    int cml22 = 2;
    int cml23 = 2;
    int cml24 = 4;
    
    int CH_Mutex0[]={0, EndFlag};//结束
    int CH_Mutex1[]={1,4,6,10,12,EndFlag};//结束
    int CH_Mutex2[]={2,4,5,6,10,11,12,EndFlag};
    int CH_Mutex3[]={3,5,6,11,12,EndFlag};
    int CH_Mutex4[]={1,2,4,5,6,7,8,11,12,EndFlag};
    int CH_Mutex5[]={2,3,4,5,6,8,9,10,12,EndFlag};
    int CH_Mutex6[]={1,2,3,4,5,6,7,8,9,10,11,EndFlag};
    int CH_Mutex7[]={4,6,7,10,12,EndFlag};
    int CH_Mutex8[]={4,5,6,8,10,11,12,EndFlag};
    int CH_Mutex9[]={5,6,9,11,12,EndFlag};
    int CH_Mutex10[]={1,2,5,6,7,8,10,11,12,EndFlag};
    int CH_Mutex11[]={2,3,4,6,8,9,10,11,12,EndFlag};
    int CH_Mutex12[]={1,2,3,4,5,7,8,9,10,11,12,EndFlag};
    int CH_Mutex13[]={13,15,18,EndFlag};
    int CH_Mutex14[]={14,15,18,EndFlag};
    int CH_Mutex15[]={13,14,15,16,17,EndFlag};
    int CH_Mutex16[]={15,16,18,EndFlag};
    int CH_Mutex17[]={15,17,18,EndFlag};
    int CH_Mutex18[]={13,14,16,17,18,EndFlag};
    int CH_Mutex19[]={19,21,EndFlag};
    int CH_Mutex20[]={20,21,EndFlag};
    int CH_Mutex21[]={19,20,21,EndFlag};
    int CH_Mutex22[]={22,EndFlag};
    int CH_Mutex23[]={23,EndFlag};
    int CH_Mutex24[]={22,23,24,EndFlag};
    
    for(int i=0;i<32;i++){
        for(int j=0;j<32;j++){
            CH_Mutex[i][j]=EndFlag;
        }
    }
    
    
    for(int i=0;i<cml0;i++){
        CH_Mutex[0][i]=CH_Mutex0[i];
    }
    for(int i=0;i<cml1;i++){
        CH_Mutex[1][i]=CH_Mutex1[i];
    }
    for(int i=0;i<cml2;i++){
        CH_Mutex[2][i]=CH_Mutex2[i];
    }
    for(int i=0;i<cml3;i++){
        CH_Mutex[3][i]=CH_Mutex3[i];
    }
    for(int i=0;i<cml4;i++){
        CH_Mutex[4][i]=CH_Mutex4[i];
    }
    for(int i=0;i<cml5;i++){
        CH_Mutex[5][i]=CH_Mutex5[i];
    }
    for(int i=0;i<cml6;i++){
        CH_Mutex[6][i]=CH_Mutex6[i];
    }
    for(int i=0;i<cml7;i++){
        CH_Mutex[7][i]=CH_Mutex7[i];
    }
    for(int i=0;i<cml8;i++){
        CH_Mutex[8][i]=CH_Mutex8[i];
    }
    for(int i=0;i<cml9;i++){
        CH_Mutex[9][i]=CH_Mutex9[i];
    }
    for(int i=0;i<cml10;i++){
        CH_Mutex[10][i]=CH_Mutex10[i];
    }
    for(int i=0;i<cml11;i++){
        CH_Mutex[11][i]=CH_Mutex11[i];
    }
    for(int i=0;i<cml12;i++){
        CH_Mutex[12][i]=CH_Mutex12[i];
    }
    for(int i=0;i<cml13;i++){
        CH_Mutex[13][i]=CH_Mutex13[i];
    }
    for(int i=0;i<cml14;i++){
        CH_Mutex[14][i]=CH_Mutex14[i];
    }
    for(int i=0;i<cml15;i++){
        CH_Mutex[15][i]=CH_Mutex15[i];
    }
    for(int i=0;i<cml16;i++){
        CH_Mutex[16][i]=CH_Mutex16[i];
    }
    for(int i=0;i<cml17;i++){
        CH_Mutex[17][i]=CH_Mutex17[i];
    }
    for(int i=0;i<cml18;i++){
        CH_Mutex[18][i]=CH_Mutex18[i];
    }
    for(int i=0;i<cml19;i++){
        CH_Mutex[19][i]=CH_Mutex19[i];
    }
    for(int i=0;i<cml20;i++){
        CH_Mutex[20][i]=CH_Mutex20[i];
    }
    for(int i=0;i<cml21;i++){
        CH_Mutex[21][i]=CH_Mutex21[i];
    }
    for(int i=0;i<cml22;i++){
        CH_Mutex[22][i]=CH_Mutex22[i];
    }
    for(int i=0;i<cml23;i++){
        CH_Mutex[23][i]=CH_Mutex23[i];
        //NSLog(@"CH_Mutex[23][%d]=%d",i,CH_Mutex[23][i]);
    }
    for(int i=0;i<cml24;i++){
        CH_Mutex[24][i]=CH_Mutex24[i];
    }
    
}

//通过各通道名字编号检索可组成的新列表 MOTINLU TODO
- (void) CheckChannelNum{
    for(int i=0;i<=maxSpkType;i++){
        ChannelNumList[i]=i;
    }
    ChannelNumList[maxSpkType]=EndFlag;//结束 使用1-24
    //NSLog(@"CheckChannelNum.ch=%d",output_channel_sel);
    //更新列表
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((i!=output_channel_sel)&&(ChannelNumBuf[i]>0)){
            for(int j=1;j<maxSpkType;j++){
                for(int k=0;k<maxSpkType;k++){
                    if(CH_Mutex[ChannelNumBuf[i]][k]==EndFlag){
                        continue;
                    }
                    if(ChannelNumList[j]==CH_Mutex[ChannelNumBuf[i]][k]){
                        ChannelNumList[j] = EndFlag;
                    }
                }
            }
        }
    }
}

//根据通道名字获取通道类型
- (int)getOutputTypeNum:(NSString*)Name{
    if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_NULL"]]){
        return 0;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Tweeter"]]){
        return 1;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Midrange"]]){
        return 2;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Woofer"]]){
        return 3;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_M_T"]]){
        return 4;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_M_WF"]]){
        return 5;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Full"]]){
        return 6;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Tweeter"]]){
        return 7;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Midrange"]]){
        return 8;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Woofer"]]){
        return 9;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_M_T"]]){
        return 10;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_M_WF"]]){
        return 11;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Full"]]){
        return 12;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Tweeter"]]){
        return 13;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Woofer"]]){
        return 14;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Full"]]){
        return 15;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Tweeter"]]){
        return 16;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Woofer"]]){
        return 17;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Full"]]){
        return 18;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Tweeter"]]){
        return 19;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Woofer"]]){
        return 20;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Full"]]){
        return 21;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_L_Subweeter"]]){
        return 22;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_R_Subweeter"]]){
        return 23;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_Subweeter"]]){
        return 24;
    }
    return 0;
}

- (NSString*)getOutputChannelTypeName:(int)Channel{
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    
    return [self getOutputTypeName:ChannelNumBuf[Channel]];
}

- (NSString*)getOutputTypeName:(int)Name{
    switch (Name) {
        case 0: return [LANG DPLocalizedString:@"L_Out_NULL"];
        case 1: return [LANG DPLocalizedString:@"L_Out_FL_Tweeter"];
        case 2: return [LANG DPLocalizedString:@"L_Out_FL_Midrange"];
        case 3: return [LANG DPLocalizedString:@"L_Out_FL_Woofer"];
        case 4: return [LANG DPLocalizedString:@"L_Out_FL_M_T"];
        case 5: return [LANG DPLocalizedString:@"L_Out_FL_M_WF"];
        case 6: return [LANG DPLocalizedString:@"L_Out_FL_Full"];
        case 7: return [LANG DPLocalizedString:@"L_Out_FR_Tweeter"];
        case 8: return [LANG DPLocalizedString:@"L_Out_FR_Midrange"];
        case 9: return [LANG DPLocalizedString:@"L_Out_FR_Woofer"];
        case 10: return [LANG DPLocalizedString:@"L_Out_FR_M_T"];
        case 11: return [LANG DPLocalizedString:@"L_Out_FR_M_WF"];
        case 12: return [LANG DPLocalizedString:@"L_Out_FR_Full"];
        case 13: return [LANG DPLocalizedString:@"L_Out_RL_Tweeter"];
        case 14: return [LANG DPLocalizedString:@"L_Out_RL_Woofer"];
        case 15: return [LANG DPLocalizedString:@"L_Out_RL_Full"];
        case 16: return [LANG DPLocalizedString:@"L_Out_RR_Tweeter"];
        case 17: return [LANG DPLocalizedString:@"L_Out_RR_Woofer"];
        case 18: return [LANG DPLocalizedString:@"L_Out_RR_Full"];
        case 19: return [LANG DPLocalizedString:@"L_Out_C_Tweeter"];
        case 20: return [LANG DPLocalizedString:@"L_Out_C_Woofer"];
        case 21: return [LANG DPLocalizedString:@"L_Out_C_Full"];
        case 22: return [LANG DPLocalizedString:@"L_Out_L_Subweeter"];
        case 23: return [LANG DPLocalizedString:@"L_Out_R_Subweeter"];
        case 24: return [LANG DPLocalizedString:@"L_Out_Subweeter"];
        default:
            return [LANG DPLocalizedString:@"L_Out_NULL"];
    }
}

- (void)flashOutputType:(int)Name{

    RecStructData.System.out_spk_type[output_channel_sel]=Name;
       
}
- (NSString*)getOutputName{
    return OutChName;
}
- (int)getCurSpkType{
    return curSpkType;
}
@end

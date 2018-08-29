//
//  BottomBar.m
//  HS-DAP812-DSP-8012
//
//  Created by chsdsp on 2017/8/18.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "BottomBar.h"

@implementation BottomBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        WIND_MIN     = MIN(WIND_Width, WIND_Height);

        //        NSLog(@"WIND_Width = @%f",WIND_Width);
        //        NSLog(@"WIND_Height = @%f",WIND_Height);
        
        [self setup];
    }
    return self;
}


- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:CBottomBarHeight]);
    
    Bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:CBottomBarHeight])];
    [self addSubview:Bg];
    [Bg setImage:[UIImage imageNamed:@"tab_bar_bg"]];
    
    int MaxItem=5;
    int width=KScreenWidth/MaxItem;
    
    View1 = [[UIView alloc]initWithFrame:CGRectMake(width*0, 0, width, [Dimens GDimens:CBottomBarHeight])];
    View2 = [[UIView alloc]initWithFrame:CGRectMake(width*1, 0, width, [Dimens GDimens:CBottomBarHeight])];
    View3 = [[UIView alloc]initWithFrame:CGRectMake(width*2, 0, width, [Dimens GDimens:CBottomBarHeight])];
    View4 = [[UIView alloc]initWithFrame:CGRectMake(width*3, 0, width, [Dimens GDimens:CBottomBarHeight])];
    View5 = [[UIView alloc]initWithFrame:CGRectMake(width*4, 0, width, [Dimens GDimens:CBottomBarHeight])];
    [self addSubview:View1];
    [self addSubview:View2];
    [self addSubview:View3];
    [self addSubview:View4];
    [self addSubview:View5];
    
    Btn1 = [[UIButton alloc]initWithFrame:CGRectMake(width*0, 0, width, [Dimens GDimens:CBottomBarHeight])];
    Btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width*1, 0, width, [Dimens GDimens:CBottomBarHeight])];
    Btn3 = [[UIButton alloc]initWithFrame:CGRectMake(width*2, 0, width, [Dimens GDimens:CBottomBarHeight])];
    Btn4 = [[UIButton alloc]initWithFrame:CGRectMake(width*3, 0, width, [Dimens GDimens:CBottomBarHeight])];
    Btn5 = [[UIButton alloc]initWithFrame:CGRectMake(width*4, 0, width, [Dimens GDimens:CBottomBarHeight])];
    [Btn1 setBackgroundColor:[UIColor clearColor]];
    [Btn2 setBackgroundColor:[UIColor clearColor]];
    [Btn3 setBackgroundColor:[UIColor clearColor]];
    [Btn4 setBackgroundColor:[UIColor clearColor]];
    [Btn5 setBackgroundColor:[UIColor clearColor]];
    [Btn1 setTag:1];
    [Btn2 setTag:2];
    [Btn3 setTag:3];
    [Btn4 setTag:4];
    [Btn5 setTag:5];
    [Btn1 addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Btn2 addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Btn3 addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Btn4 addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Btn5 addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:Btn1];
    [self addSubview:Btn2];
    [self addSubview:Btn3];
    [self addSubview:Btn4];
    [self addSubview:Btn5];

    IVM1 = [[UIImageView alloc]init];
    IVM2 = [[UIImageView alloc]init];
    IVM3 = [[UIImageView alloc]init];
    IVM4 = [[UIImageView alloc]init];
    IVM5 = [[UIImageView alloc]init];
    
    Lab1 = [[UILabel alloc]init];
    Lab2 = [[UILabel alloc]init];
    Lab3 = [[UILabel alloc]init];
    Lab4 = [[UILabel alloc]init];
    Lab5 = [[UILabel alloc]init];
    
    [View1 addSubview:IVM1];
    [View2 addSubview:IVM2];
    [View3 addSubview:IVM3];
    [View4 addSubview:IVM4];
    [View5 addSubview:IVM5];
    
    [View1 addSubview:Lab1];
    [View2 addSubview:Lab2];
    [View3 addSubview:Lab3];
    [View4 addSubview:Lab4];
    [View5 addSubview:Lab5];
    
    [IVM1 setImage:[UIImage imageNamed:@"tab_setdelay_normal"]];
    [IVM2 setImage:[UIImage imageNamed:@"tab_output_normal"]];
    [IVM3 setImage:[UIImage imageNamed:@"tab_home_normal"]];
    [IVM4 setImage:[UIImage imageNamed:@"tab_eq_normal"]];
    [IVM5 setImage:[UIImage imageNamed:@"tab_mixer_normal"]];
    
    Lab1.text = [LANG DPLocalizedString:@"L_TabBar_Delay"];
    Lab2.text = [LANG DPLocalizedString:@"L_TabBar_Output"];
    Lab3.text = [LANG DPLocalizedString:@"L_Master_Master"];
    Lab4.text = [LANG DPLocalizedString:@"L_TabBar_EQ"];
    Lab5.text = [LANG DPLocalizedString:@"L_Mixer_Mixer"];
    
    int textsize=10;
    Lab1.font = [UIFont systemFontOfSize:textsize];
    Lab2.font = [UIFont systemFontOfSize:textsize];
    Lab3.font = [UIFont systemFontOfSize:textsize];
    Lab4.font = [UIFont systemFontOfSize:textsize];
    Lab5.font = [UIFont systemFontOfSize:textsize];
    Lab1.textAlignment = NSTextAlignmentCenter;
    Lab2.textAlignment = NSTextAlignmentCenter;
    Lab3.textAlignment = NSTextAlignmentCenter;
    Lab4.textAlignment = NSTextAlignmentCenter;
    Lab5.textAlignment = NSTextAlignmentCenter;
    
    
    [IVM1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View1.mas_top).offset([Dimens GDimens:CBottomBarImgViewMarginTop]);
        make.centerX.equalTo(View1.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:CBottomBarImgViewSize], [Dimens GDimens:CBottomBarImgViewSize]));
    }];
    [IVM2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View2.mas_top).offset([Dimens GDimens:CBottomBarImgViewMarginTop]);
        make.centerX.equalTo(View2.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:CBottomBarImgViewSize], [Dimens GDimens:CBottomBarImgViewSize]));
    }];
    [IVM3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View3.mas_top).offset([Dimens GDimens:16]);
        make.centerX.equalTo(View3.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:CBottomBarImgViewSize], [Dimens GDimens:CBottomBarImgViewSize]));
    }];
    [IVM4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View4.mas_top).offset([Dimens GDimens:CBottomBarImgViewMarginTop]);
        make.centerX.equalTo(View4.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:CBottomBarImgViewSize], [Dimens GDimens:CBottomBarImgViewSize]));
    }];
    [IVM5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View5.mas_top).offset([Dimens GDimens:CBottomBarImgViewMarginTop]);
        make.centerX.equalTo(View5.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:CBottomBarImgViewSize], [Dimens GDimens:CBottomBarImgViewSize]));
    }];
    
    [Lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IVM1.mas_bottom).offset([Dimens GDimens:CBottomBarTextMarginTopIVM]);
        make.centerX.equalTo(View1.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(width, [Dimens GDimens:CBottomBarTextHeight]));
    }];
    [Lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IVM2.mas_bottom).offset([Dimens GDimens:CBottomBarTextMarginTopIVM]);
        make.centerX.equalTo(View2.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(width, [Dimens GDimens:CBottomBarTextHeight]));
    }];
    [Lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IVM3.mas_bottom).offset([Dimens GDimens:CBottomBarTextMarginTopIVM+6]);
        make.centerX.equalTo(View3.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(width, [Dimens GDimens:CBottomBarTextHeight]));
    }];
    [Lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IVM4.mas_bottom).offset([Dimens GDimens:CBottomBarTextMarginTopIVM]);
        make.centerX.equalTo(View4.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(width, [Dimens GDimens:CBottomBarTextHeight]));
    }];
    [Lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IVM5.mas_bottom).offset([Dimens GDimens:CBottomBarTextMarginTopIVM]);
        make.centerX.equalTo(View5.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(width, [Dimens GDimens:CBottomBarTextHeight]));
    }];

    
    
    
    [self flashItemSel:3];
    
}

- (void)BtnClickEvent:(UIButton*)sender{
    DataVal = (int)sender.tag;
    [self flashItemSel:DataVal];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)flashItemSel:(int)sel{
    [IVM1 setImage:[UIImage imageNamed:@"tab_setdelay_normal"]];
    [IVM2 setImage:[UIImage imageNamed:@"tab_output_normal"]];
    [IVM3 setImage:[UIImage imageNamed:@"tab_home_normal"]];
    [IVM4 setImage:[UIImage imageNamed:@"tab_eq_normal"]];
    [IVM5 setImage:[UIImage imageNamed:@"tab_mixer_normal"]];
    
    [Lab1 setTextColor:SetColor(UI_TabbarTextColorNormal)];
    [Lab2 setTextColor:SetColor(UI_TabbarTextColorNormal)];
    [Lab3 setTextColor:SetColor(UI_TabbarTextColorNormal)];
    [Lab4 setTextColor:SetColor(UI_TabbarTextColorNormal)];
    [Lab5 setTextColor:SetColor(UI_TabbarTextColorNormal)];
    
    switch (sel) {
        case 1:
            [IVM1 setImage:[UIImage imageNamed:@"tab_setdelay_press"]];
            [Lab1 setTextColor:SetColor(UI_TabbarTextColorPress)];
            break;
        case 2:
            [IVM2 setImage:[UIImage imageNamed:@"tab_output_press"]];
            [Lab2 setTextColor:SetColor(UI_TabbarTextColorPress)];
            break;
        case 3:
            [IVM3 setImage:[UIImage imageNamed:@"tab_home_press"]];
            [Lab3 setTextColor:SetColor(UI_TabbarTextColorPress)];
            break;
        case 4:
            [IVM4 setImage:[UIImage imageNamed:@"tab_eq_press"]];
            [Lab4 setTextColor:SetColor(UI_TabbarTextColorPress)];
            break;
        case 5:
            [IVM5 setImage:[UIImage imageNamed:@"tab_mixer_press"]];
            [Lab5 setTextColor:SetColor(UI_TabbarTextColorPress)];
            break;
            
        default:
            break;
    }
    
}


#pragma 接口
- (int)getDataVal{
    return DataVal;
}

- (void)setDataVal:(int)val{
    DataVal=val;
    [self flashItemSel:DataVal];
}


@end

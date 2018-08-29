//
//  XOverItem.m
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "XOverItem.h"

#define XOver_Btn_Height 30
#define XOver_Btn_Width  100
#define XOver_Btn_Ch_Press (0xFF4dc8fb) //
#define XOver_Btn_Ch_Normal (0xFFffffff) //
#define XOver_Btn_ChText_Press (0xFFffffff) //
#define XOver_Btn_ChText_Normal (0xFFffffff) //
#define XOver_Btn_HLPass (0xFFffffff) //

#define XOverMarginLeft 2



@implementation XOverItem

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
    self.backgroundColor = [UIColor clearColor];
    //通道号
    
    /*
    self.Btn_Channel = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Channel];
    [self.Btn_Channel initView:3 withBorderWidth:1 withNormalColor:XOver_Btn_Ch_Normal withPressColor:XOver_Btn_Ch_Press withType:2];
    [self.Btn_Channel  setTextColorWithNormalColor:XOver_Btn_ChText_Normal withPressColor:XOver_Btn_ChText_Press];
    self.Btn_Channel .titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Channel  setTitle:@"CH1" forState:UIControlStateNormal] ;
    */
    self.Btn_Channel = [[UIButton alloc]init];
    [self addSubview:self.Btn_Channel];
    [self.Btn_Channel setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Channel setTitleColor:SetColor(XOver_Btn_Ch_Normal) forState:UIControlStateNormal];
    self.Btn_Channel .titleLabel.font = [UIFont systemFontOfSize:13];
    //[self.Btn_Channel  setTitle:@"CH1" forState:UIControlStateNormal] ;

    [self.Btn_Channel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([Dimens GDimens:XOverMarginLeft]);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Height]*2, [Dimens GDimens:XOver_Btn_Height]));
    }];
    //高通
    self.H_XOverLab = [[UILabel alloc]init];
    [self addSubview:self.H_XOverLab];
    self.H_XOverLab.font=[UIFont systemFontOfSize:20];
    self.H_XOverLab.textColor = SetColor(XOver_Btn_HLPass);
    self.H_XOverLab.adjustsFontSizeToFitWidth = true;
    self.H_XOverLab.font = [UIFont systemFontOfSize:13];
    self.H_XOverLab.textAlignment = NSTextAlignmentCenter;
    self.H_XOverLab.text = [LANG DPLocalizedString:@"L_XOver_HighPass"];
    
    [self.H_XOverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Btn_Channel.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Height]*2, [Dimens GDimens:XOver_Btn_Height]));
    }];
    
    //高通-滤波器
    self.H_Filter = [[UIButton alloc]init];
    [self addSubview:self.H_Filter];
    [self.H_Filter setBackgroundColor:[UIColor clearColor]];
    [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.H_Filter setTitle:@"H_Filter" forState:UIControlStateNormal] ;
    self.H_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    self.H_Filter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.H_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.H_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
    self.H_Filter.hidden = true;
    //高通-斜率
    self.H_Level = [[UIButton alloc]init];
    [self addSubview:self.H_Level];
    [self.H_Level setBackgroundColor:[UIColor clearColor]];
    [self.H_Level setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.H_Level setTitle:@"H_Level" forState:UIControlStateNormal] ;
    self.H_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    self.H_Level.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.H_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.H_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        //make.top.equalTo(self.H_Filter.mas_bottom);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
    //高通-频率
    self.H_Freq = [[UIButton alloc]init];
    [self addSubview:self.H_Freq];
    [self.H_Freq setBackgroundColor:[UIColor clearColor]];
    [self.H_Freq setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.H_Freq setTitle:@"H_Level" forState:UIControlStateNormal] ;
    self.H_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    self.H_Freq.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.H_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.H_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.equalTo(self.H_Level.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
    
    //低通
    self.L_XOverLab = [[UILabel alloc]init];
    [self addSubview:self.L_XOverLab];
    self.L_XOverLab.font=[UIFont systemFontOfSize:20];
    self.L_XOverLab.textColor = SetColor(XOver_Btn_HLPass);
    self.L_XOverLab.adjustsFontSizeToFitWidth = true;
    self.L_XOverLab.font = [UIFont systemFontOfSize:13];
    self.L_XOverLab.textAlignment = NSTextAlignmentCenter;
    self.L_XOverLab.text = [LANG DPLocalizedString:@"L_XOver_LowPass"];
    [self.L_XOverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Btn_Channel.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.equalTo(self.H_Freq.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Height]*2, [Dimens GDimens:XOver_Btn_Height]));
    }];
    
    //低通-滤波器
    self.L_Filter = [[UIButton alloc]init];
    [self addSubview:self.L_Filter];
    [self.L_Filter setBackgroundColor:[UIColor clearColor]];
    [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.L_Filter setTitle:@"L_Filter" forState:UIControlStateNormal] ;
    self.L_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    self.L_Filter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.L_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.L_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.equalTo(self.H_Freq.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
    self.L_Filter.hidden = true;
    //低通-斜率
    self.L_Level = [[UIButton alloc]init];
    [self addSubview:self.L_Level];
    [self.L_Level setBackgroundColor:[UIColor clearColor]];
    [self.L_Level setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.L_Level setTitle:@"L_Level" forState:UIControlStateNormal] ;
    self.L_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    self.L_Level.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.L_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.L_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        //make.top.equalTo(self.L_Filter.mas_bottom);
        make.top.equalTo(self.H_Freq.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
    //低通-频率
    self.L_Freq = [[UIButton alloc]init];
    [self addSubview:self.L_Freq];
    [self.L_Freq setBackgroundColor:[UIColor clearColor]];
    [self.L_Freq setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.L_Freq setTitle:@"L_Freq" forState:UIControlStateNormal] ;
    self.L_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    self.L_Freq.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.L_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.L_XOverLab.mas_right).offset([Dimens GDimens:XOverMarginLeft]);
        make.top.equalTo(self.L_Level.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:XOver_Btn_Width], [Dimens GDimens:XOver_Btn_Height]));
    }];
}

- (void)setXOverItemTag:(int)stag{
    tag = stag;
    [self.H_Filter setTag:TagStart_XOVER_H_Filter+stag];
    [self.H_Level  setTag:TagStart_XOVER_H_Level+stag];
    [self.H_Freq   setTag:TagStart_XOVER_H_Freq+stag];
    
    [self.L_Filter setTag:TagStart_XOVER_L_Filter+stag];
    [self.L_Level  setTag:TagStart_XOVER_L_Level+stag];
    [self.L_Freq   setTag:TagStart_XOVER_L_Freq+stag];
    [self setTag:TagStart_XOVER_Self+stag];
}

@end

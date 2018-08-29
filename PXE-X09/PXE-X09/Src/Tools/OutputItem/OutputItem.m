//
//  OutputItem.m
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutputItem.h"


#define SB_Volume_Size 95
#define OutputItemBtnHeight 25
#define OutputItemBtnWidth 80

#define OutputItem_Btn_Ch_Press (0xff1eac4b) //
#define OutputItem_Btn_Ch_Normal (0xff1eac4b) //
#define OutputItem_Btn_ChText_Press (0xffffffff) //
#define OutputItem_Btn_ChText_Normal (0xff000000) //
#define OutputItem_Btn_ChTextVal (0xff1eac4b) //
@implementation OutputItem

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
    
    self.SB_Volume = [[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:SB_Volume_Size], [Dimens GDimens:SB_Volume_Size])];
    [self addSubview:self.SB_Volume];
    [self.SB_Volume setMaxProgress:Output_Volume_MAX/Output_Volume_Step];
    [self.SB_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.topMargin.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:SB_Volume_Size], [Dimens GDimens:SB_Volume_Size]));
    }];
    
    //音量值
    self.Btn_Volume = [[UIButton alloc]init];
    [self addSubview:self.Btn_Volume];
    [self.Btn_Volume setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Volume setTitleColor:SetColor(OutputItem_Btn_ChTextVal) forState:UIControlStateNormal];
    //[self.Btn_Volume setTitle:@"60" forState:UIControlStateNormal] ;
    self.Btn_Volume.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Volume.titleLabel.font = [UIFont systemFontOfSize:30];
    self.Btn_Volume.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.SB_Volume.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight*1.5]));
    }];
    //通道号
    self.Btn_Channel = [[UIButton alloc]init];
    [self addSubview:self.Btn_Channel];
    [self.Btn_Channel setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Channel setTitleColor:SetColor(OutputItem_Btn_ChText_Normal) forState:UIControlStateNormal];
    //[self.Btn_Channel setTitle:@"CH1" forState:UIControlStateNormal] ;
    self.Btn_Channel.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Channel.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Channel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Channel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.Btn_Volume.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight*2]));
    }];
    //
    self.V_Mid = [[UIView alloc]init];
    [self addSubview:self.V_Mid];
    [self.V_Mid setBackgroundColor:SetColor(OutputItem_Btn_ChText_Normal)];
    [self.V_Mid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.SB_Volume.mas_bottom).offset([Dimens GDimens:OutputItemBtnHeight/2]);
        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputItemBtnHeight/2]));
    }];

    //正反相
    self.Btn_Polar = [[UIButton alloc]init];
    [self addSubview:self.Btn_Polar];
    [self.Btn_Polar setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Polar setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    self.Btn_Polar.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Polar.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Polar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Polar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.V_Mid.mas_left);
        make.top.equalTo(self.SB_Volume.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight]));
    }];

    //静音
    self.Btn_Mute = [[UIButton alloc]init];
    [self addSubview:self.Btn_Mute];
    //[self.self.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    [self.Btn_Mute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.V_Mid.mas_right);
        make.top.equalTo(self.SB_Volume.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight]));
    }];
    
    //Btn_Name
    self.Btn_Name = [[UIButton alloc]init];
    [self addSubview:self.Btn_Name];
    [self.Btn_Name setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Name setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    //[self.Btn_Name setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
    self.Btn_Name.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Name.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.V_Mid.mas_bottom).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth*2], [Dimens GDimens:OutputItemBtnHeight]));
    }];
    
}



- (void)setOutputItemTag:(int)stag{
    tag = stag;
    [self.SB_Volume setTag:stag+TagStart_OutItem_SB_Volume];
    [self.Btn_Volume setTag:stag+TagStart_OutItem_Btn_Volume];
    [self.Btn_Polar setTag:stag+TagStart_OutItem_Btn_Polar];
    
    [self.Btn_Mute setTag:stag+TagStart_OutItem_Btn_Mute];
    [self.Btn_Name setTag:stag+TagStart_OutItem_OutName];
    [self.Btn_Channel setTag:stag+TagStart_OutItem_Btn_Channel];
    [self setTag:stag+TagStart_OutItem_Self];

}



@end

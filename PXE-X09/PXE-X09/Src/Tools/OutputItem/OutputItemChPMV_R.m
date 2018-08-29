//
//  OutputItem.m
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutputItemChPMV_R.h"


#define SB_Volume_Size 95
#define OutputItemBtnHeight 20
#define OutputItemBtnWidth 50
#define OutputItemMuteSize 50

#define OutputItem_Btn_Ch_Press (0xFFfce802) //
#define OutputItem_Btn_Ch_Normal (0xFFfce802) //
#define OutputItem_Btn_ChText_Press (0xFFfce802) //
#define OutputItem_Btn_ChText_Normal (0xffffffff) //
#define OutputItem_Btn_ChTextVal (0xFFfce802) //
#define OutputItem_Btn_BG (0x30ffffff) //
@implementation OutputItemChPMV_R

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        
        [self setup];
    }
    return self;
}

- (void)setup{

    [self setBackgroundColor:[UIColor clearColor]];
    //通道号
    self.Btn_Channel = [[UIButton alloc]init];
    [self addSubview:self.Btn_Channel];
    [self.Btn_Channel setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Channel setTitleColor:SetColor(OutputItem_Btn_ChText_Normal) forState:UIControlStateNormal];
    //[self.Btn_Channel setTitle:@"CH1" forState:UIControlStateNormal] ;
    self.Btn_Channel.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Channel.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Channel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    self.Btn_Channel.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:0],
        .bottom = 0,
        .right  = WIND_Width - [Dimens GDimens:OutputItemBtnHeight],
    };
    [self.Btn_Channel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:OutputItemBtnHeight]);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, [Dimens GDimens:OutputItemBtnHeight]));
    }];
    
    //正反相
    self.Btn_Polar = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Polar];
    [self.Btn_Polar setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Polar initView:3 withBorderWidth:1 withNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press withType:0];
    [self.Btn_Polar setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    //[self.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    self.Btn_Polar.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Polar.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Polar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Polar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset([Dimens GDimens:0]);
        make.centerY.equalTo(self.mas_centerY).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight]));
    }];
    
    //音量值
    self.Btn_Volume = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Volume];
    [self.Btn_Volume setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Volume initView:3 withBorderWidth:1 withNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press withType:0];
    [self.Btn_Volume setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    //[self.Btn_Volume setTitle:@"60" forState:UIControlStateNormal] ;
    self.Btn_Volume.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Volume.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Volume.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemBtnWidth], [Dimens GDimens:OutputItemBtnHeight]));
    }];

    //静音
    self.Btn_Mute = [[UIButton alloc]init];
    [self addSubview:self.Btn_Mute];
    [self.Btn_Mute setBackgroundColor:[UIColor clearColor]];
    //[self.self.Btn_Mute setImage:[UIImage imageNamed:@"chs_output_mute_left_normal"] forState:UIControlStateNormal];
    [self.Btn_Mute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_Polar.mas_bottom).offset([Dimens GDimens:5]);
        make.right.equalTo(self.Btn_Polar.mas_left).offset(-[Dimens GDimens:3]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputItemMuteSize], [Dimens GDimens:OutputItemMuteSize]));
    }];
    
 
}

#pragma 接口


- (void)setOutputItemTag:(int)stag{
    tag = stag;
    [self.Btn_Volume setTag:stag+TagStart_OutItem_Btn_Volume];
    [self.Btn_Polar setTag:stag+TagStart_OutItem_Btn_Polar];
    
    [self.Btn_Mute setTag:stag+TagStart_OutItem_Btn_Mute];
    [self.Btn_Channel setTag:stag+TagStart_OutItem_Btn_Channel];
    [self setTag:stag+TagStart_OutItem_Self];

}



@end

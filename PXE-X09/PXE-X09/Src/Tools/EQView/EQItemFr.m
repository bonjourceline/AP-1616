//
//  EQItem.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/30.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "EQItemFr.h"


@implementation EQItemFr

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        //NSLog(@"WIND_Width = @%f",WIND_Width);
        //NSLog(@"WIND_Height = @%f",WIND_Height);
        [self setup];
    }
    return self;
}

- (void)setEQItemTag:(int)sTag{
    tag = sTag;
    [self.Lab_ID setTag:tag+TagStartEQItem_Lab_ID];
    [self.Btn_Gain setTag:tag+TagStartEQItem_Btn_Gain];
    [self.Btn_BW setTag:tag+TagStartEQItem_Btn_BW];
    [self.Btn_Freq setTag:tag+TagStartEQItem_Btn_Freq];
    [self.Btn_Reset setTag:tag+TagStartEQItem_Btn_Reset];
    [self.SB_Gain setTag:tag+TagStartEQItem_SB_Gain];
    [self setTag:tag+TagStartEQItem_Self];
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    //曲线框的边距
    BtnHeight = [Dimens GDimens:EQItem_BTN_HEIGHT];
    SBHeight = WIND_Height - BtnHeight*4;

    ColorNormal   = SetColor(Color_EQItemNormal);
    ColorPress    = SetColor(Color_EQItemPress);
    ColorDisable  = SetColor(Color_EQItemDisable);
    ColorSBProgress  = SetColor(Color_EQItemSBProgress);
    ColorSBProgressBg  = SetColor(Color_EQItemSBProgressBg);
    //ID
    self.Lab_ID = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_ID];
    
    [self.Lab_ID setBackgroundColor:[UIColor clearColor]];
    [self.Lab_ID setTextColor:ColorNormal];
    self.Lab_ID.text=[NSString stringWithFormat:@"%d",tag+1];
    self.Lab_ID.textAlignment = NSTextAlignmentCenter;
    self.Lab_ID.adjustsFontSizeToFitWidth = true;
    self.Lab_ID.font = [UIFont systemFontOfSize:EQItemTextSize];
//    [self.Lab_ID mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
//    }];
    self.Lab_ID.hidden=true;
    
    //Freq
    self.Btn_Freq = [[UIButton alloc]init];
    [self addSubview:self.Btn_Freq];
    
    [self.Btn_Freq setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Freq setTitleColor:ColorNormal forState:UIControlStateNormal];
    [self.Btn_Freq setTitle:@"Freq" forState:UIControlStateNormal] ;
    self.Btn_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Freq.titleLabel.font = [UIFont systemFontOfSize:EQItemTextSize];
    [self.Btn_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];

    
    //Reset
    self.Btn_Reset = [[UIButton alloc]init];
    [self addSubview:self.Btn_Reset];
    
    [self.Btn_Reset setImage:[[UIImage imageNamed:[PIMG DPIMG:@"eq_resetg_normal"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.Btn_Reset.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.Btn_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    //BW
    self.Btn_BW = [[UIButton alloc]init];
    [self addSubview:self.Btn_BW];
    
    [self.Btn_BW setBackgroundColor:[UIColor clearColor]];
    [self.Btn_BW setTitleColor:ColorNormal forState:UIControlStateNormal];
    [self.Btn_BW setTitle:@"BW" forState:UIControlStateNormal] ;
    self.Btn_BW.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_BW.titleLabel.font = [UIFont systemFontOfSize:EQItemTextSize];
    [self.Btn_BW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_Reset.mas_top).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    //Gain
    self.Btn_Gain = [[UIButton alloc]init];
    [self addSubview:self.Btn_Gain];
    
    [self.Btn_Gain setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Gain setTitleColor:ColorNormal forState:UIControlStateNormal];
    [self.Btn_Gain setTitle:@"Gain" forState:UIControlStateNormal] ;
    self.Btn_Gain.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Gain.titleLabel.font = [UIFont systemFontOfSize:EQItemTextSize];
    [self.Btn_Gain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_BW.mas_top).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    
    
    //SB Gain
    self.SB_Gain = [[UISlider alloc]initWithFrame:CGRectMake(-(SBHeight -WIND_Width)/2, BtnHeight*1+(SBHeight -WIND_Width)/2, SBHeight, WIND_Width)];
    [self addSubview:self.SB_Gain];
    
    self.SB_Gain.minimumTrackTintColor = ColorSBProgress; //滑轮左边颜色如果设置了左边的图片就不会显示
    self.SB_Gain.maximumTrackTintColor = ColorSBProgressBg; //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_Gain setBackgroundColor:[UIColor clearColor]];
    [self.SB_Gain setThumbImage:[UIImage imageNamed:[PIMG DPIMG:@"chs_mvs_thumb_normal"]] forState:UIControlStateNormal];
    [self.SB_Gain setThumbImage:[UIImage imageNamed:[PIMG DPIMG:@"chs_mvs_thumb_press"]] forState:UIControlStateHighlighted];

    self.SB_Gain.minimumValue = 0;//设置最小值
    self.SB_Gain.maximumValue = EQ_Gain_MAX;//设置最大值
    self.SB_Gain.value = EQ_Gain_MAX/2;//设置默认值
    self.SB_Gain.continuous = YES;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.SB_Gain.transform = trans;
    
}

//获取控件编号
- (int)getTag{
    return tag;
}

//设置控件颜色1：normal，2：press：3：Locked
- (void)setStateColor:(int)State{
    switch (State) {
        case 1:
            [self.Lab_ID setTextColor:ColorNormal];
            [self.Btn_Gain setTitleColor:ColorNormal forState:UIControlStateNormal];
            [self.Btn_BW setTitleColor:ColorNormal forState:UIControlStateNormal];
            [self.Btn_Freq setTitleColor:ColorNormal forState:UIControlStateNormal];
            break;
        case 2:
            [self.Lab_ID setTextColor:ColorPress];
            [self.Btn_Gain setTitleColor:ColorPress forState:UIControlStateNormal];
            [self.Btn_BW setTitleColor:ColorPress forState:UIControlStateNormal];
            [self.Btn_Freq setTitleColor:ColorPress forState:UIControlStateNormal];
            break;
        case 3:
            [self.Lab_ID setTextColor:ColorPress];
            [self.Btn_Gain setTitleColor:ColorPress forState:UIControlStateNormal];
            [self.Btn_BW setTitleColor:ColorDisable forState:UIControlStateNormal];
            [self.Btn_Freq setTitleColor:ColorDisable forState:UIControlStateNormal];
            break;
        case 4:
            [self.Lab_ID setTextColor:ColorPress];
            [self.Btn_Gain setTitleColor:ColorPress forState:UIControlStateNormal];
            [self.Btn_BW setTitleColor:ColorDisable forState:UIControlStateNormal];
            [self.Btn_Freq setTitleColor:ColorDisable forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}


@end

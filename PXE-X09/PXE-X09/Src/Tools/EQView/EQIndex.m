//
//  EQIndex.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/30.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "EQIndex.h"

@implementation EQIndex

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

- (void)frame:(CGRect)frame{
    if (self != nil) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        
        //NSLog(@"WIND_Width = @%f",WIND_Width);
        //NSLog(@"WIND_Height = @%f",WIND_Height);
        [self setup];
    }
}


- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    //曲线框的边距
    BtnHeight = [Dimens GDimens:EQItem_BTN_HEIGHT];
    SBHeight = WIND_Height - BtnHeight*7;
    
    ColorNormal   = SetColor(Color_EQIndexNormal);

    //ID
    self.Lab_ID = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_ID];
    [self.Lab_ID setBackgroundColor:[UIColor clearColor]];
    [self.Lab_ID setTextColor:ColorNormal];
    self.Lab_ID.text=[LANG DPLocalizedString:@"L_EQIndex_ID"];
    self.Lab_ID.textAlignment = NSTextAlignmentCenter;
    self.Lab_ID.adjustsFontSizeToFitWidth = true;
    self.Lab_ID.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_ID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    //Freq
    self.Lab_Freq = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_Freq];
    [self.Lab_Freq setBackgroundColor:[UIColor clearColor]];
    [self.Lab_Freq setTextColor:ColorNormal];
    self.Lab_Freq.text=[LANG DPLocalizedString:@"L_EQIndex_Freq"];
    self.Lab_Freq.textAlignment = NSTextAlignmentCenter;
    self.Lab_Freq.adjustsFontSizeToFitWidth = true;
    self.Lab_Freq.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_ID.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
   
    //
    //BW(q)
    self.Lab_BW = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_BW];
    [self.Lab_BW setBackgroundColor:[UIColor clearColor]];
    [self.Lab_BW setTextColor:ColorNormal];
    self.Lab_BW.text=[LANG DPLocalizedString:@"L_EQIndex_BW"];
    self.Lab_BW.textAlignment = NSTextAlignmentCenter;
    self.Lab_BW.adjustsFontSizeToFitWidth = true;
    self.Lab_BW.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_BW mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.Lab_Freq.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    
    //
    self.Lab_GainMax = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_GainMax];
    [self.Lab_GainMax setBackgroundColor:[UIColor clearColor]];
    [self.Lab_GainMax setTextColor:ColorNormal];
    if(EQ_Gain_MAX == 400){
        self.Lab_GainMax.text=@"+20dB";
    }else{
        self.Lab_GainMax.text=@"+12dB";
    }
    self.Lab_GainMax.textAlignment = NSTextAlignmentCenter;
    self.Lab_GainMax.adjustsFontSizeToFitWidth = true;
    self.Lab_GainMax.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_GainMax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_BW.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    self.Lab_GainMax.hidden=YES;
    //
    self.Lab_GainZero = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_GainZero];
    [self.Lab_GainZero setBackgroundColor:[UIColor clearColor]];
    [self.Lab_GainZero setTextColor:ColorNormal];
    self.Lab_GainZero.text=@"0dB";
    self.Lab_GainZero.textAlignment = NSTextAlignmentCenter;
    self.Lab_GainZero.adjustsFontSizeToFitWidth = true;
    self.Lab_GainZero.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_GainZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_GainMax.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, SBHeight));
    }];
    self.Lab_GainZero.hidden=YES;
    
    self.Lab_GainMin = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_GainMin];
    [self.Lab_GainMin setBackgroundColor:[UIColor clearColor]];
    [self.Lab_GainMin setTextColor:ColorNormal];
    if(EQ_Gain_MAX == 400){
        self.Lab_GainMin.text=@"-20dB";
    }else{
        self.Lab_GainMin.text=@"-12dB";
    }
    self.Lab_GainMin.textAlignment = NSTextAlignmentCenter;
    self.Lab_GainMin.adjustsFontSizeToFitWidth = true;
    self.Lab_GainMin.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_GainMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_GainZero.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    self.Lab_GainMin.hidden=YES;
    
    //Gain(db)
    self.Lab_Gain = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_Gain];
    [self.Lab_Gain setBackgroundColor:[UIColor clearColor]];
    [self.Lab_Gain setTextColor:ColorNormal];
    self.Lab_Gain.text=[LANG DPLocalizedString:@"L_EQIndex_Gain"];
    self.Lab_Gain.textAlignment = NSTextAlignmentCenter;
    self.Lab_Gain.adjustsFontSizeToFitWidth = true;
    self.Lab_Gain.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_Gain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_GainMin.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
        
    }];
  
    //Reset
    self.Lab_Reset = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, BtnHeight)];
    [self addSubview:self.Lab_Reset];
    [self.Lab_Reset setBackgroundColor:[UIColor clearColor]];
    [self.Lab_Reset setTextColor:ColorNormal];
    self.Lab_Reset.text=[LANG DPLocalizedString:@"L_EQIndex_Reset"];
    self.Lab_Reset.textAlignment = NSTextAlignmentCenter;
    self.Lab_Reset.adjustsFontSizeToFitWidth = true;
    self.Lab_Reset.font = [UIFont systemFontOfSize:EQindexTextSize];
    [self.Lab_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, BtnHeight));
    }];
    self.Lab_Reset.hidden=YES;
   
    
   
   
   
}
@end

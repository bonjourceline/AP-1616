//
//  XoveritemView.m
//  PXE-X09
//
//  Created by celine on 2018/10/9.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "XoveritemView.h"
#define btnBorderColor (0xFF212932)
#define btnTextColor (0xFFffffff)
@implementation XoveritemView{
    XoverType type;
    NSMutableArray *Filter_List;
    NSMutableArray *AllLevel;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)setXoverType:(XoverType)xoverType{
    type=xoverType;
    [self setup];
}
-(void)setup{
    Filter_List = [NSMutableArray array];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterLR"]];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterB"]];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterBW"]];
    
    AllLevel = [NSMutableArray array];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc6dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc12dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc18dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc24dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc30dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc36dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc42dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc48dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_OtcOFF"]];
    
    
    UIView *bgView=[[UIView alloc]init];
    [self addSubview:bgView];
    bgView.layer.borderWidth=1;
    bgView.layer.cornerRadius=5;
    bgView.layer.borderColor=SetColor(0xFF212932).CGColor;
    bgView.layer.masksToBounds=YES;
    
    UILabel *xoverLab=[[UILabel alloc]init];
    [self addSubview:xoverLab];
    xoverLab.backgroundColor=SetColor(0xFF111519);
    xoverLab.textColor=SetColor(0xFFbac5d0);
    xoverLab.textAlignment=NSTextAlignmentCenter;
    xoverLab.font=[UIFont systemFontOfSize:12];
    [xoverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        
        
    }];
    UIImageView *xoverImage=[[UIImageView alloc]init];
//    xoverImage.contentMode=UIViewContentModeLeft;
    [self addSubview:xoverImage];
    [xoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xoverLab.mas_top);
        make.bottom.equalTo(xoverLab.mas_bottom);
        make.left.equalTo(xoverLab.mas_left).offset([Dimens GDimens:-8]);
        make.right.equalTo(xoverLab.mas_right).offset([Dimens GDimens:8]);
    }];
    if (type==H_Type) {
        xoverLab.text=[LANG DPLocalizedString:@"L_XOver_HighPass"];
         [xoverImage setImage:[UIImage imageNamed:@"xover_left"]];
    }else{
        xoverLab.text=[LANG DPLocalizedString:@"L_XOver_LowPass"];
         [xoverImage setImage:[UIImage imageNamed:@"xover_right"]];
    }
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xoverLab.mas_centerY).offset([Dimens GDimens:5]);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
//类型
    UILabel *filterlab=[[UILabel alloc]init];
    [self addSubview:filterlab];
    filterlab.font=[UIFont systemFontOfSize:11];
    filterlab.textColor=SetColor(0xFF747e88);
    filterlab.adjustsFontSizeToFitWidth=YES;
    [filterlab setText:[LANG DPLocalizedString:@"L_XOver_Type"]];
    self.filterBtn=[[NormalButton alloc]init];
    [self.filterBtn  initViewBroder:3
                    withBorderWidth:1
                    withNormalColor:(0x00000000)
                     withPressColor:(0x00000000)
              withBorderNormalColor:btnBorderColor
               withBorderPressColor:btnBorderColor
                withTextNormalColor:btnTextColor
                 withTextPressColor:btnTextColor
                           withType:0];
    self.filterBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.filterBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:self.filterBtn];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-[Dimens GDimens:10]);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:25]));
    }];
    [filterlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.filterBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.filterBtn.mas_centerX);
        
    }];
    //频率
    UILabel *freqLab=[[UILabel alloc]init];
    [self addSubview:freqLab];
    freqLab.font=[UIFont systemFontOfSize:11];
    freqLab.textColor=SetColor(0xFF747e88);
    freqLab.adjustsFontSizeToFitWidth=YES;
    [freqLab setText:[LANG DPLocalizedString:@"L_XOver_Frequency"]];
    self.freqBtn=[[NormalButton alloc]init];
    [self addSubview:self.freqBtn];
    [self.freqBtn initViewBroder:3
                 withBorderWidth:1
                 withNormalColor:(0x00000000)
                  withPressColor:(0x00000000)
           withBorderNormalColor:btnBorderColor
            withBorderPressColor:btnBorderColor
             withTextNormalColor:btnTextColor
              withTextPressColor:btnTextColor
                        withType:0];
    self.freqBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.freqBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.freqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.filterBtn.mas_centerY);
        make.size.mas_equalTo(self.filterBtn);
    }];
    [freqLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.freqBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.freqBtn.mas_centerX);
        
    }];
    //斜率
    UILabel *levelLab=[[UILabel alloc]init];
    [self addSubview:levelLab];
    levelLab.font=[UIFont systemFontOfSize:11];
    levelLab.textColor=SetColor(0xFF747e88);
    levelLab.adjustsFontSizeToFitWidth=YES;
    [levelLab setText:[LANG DPLocalizedString:@"L_XOver_Slope"]];
    self.levelBtn=[[NormalButton alloc]init];
    [self addSubview:self.levelBtn];
    [self.levelBtn initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:(0x00000000)
                   withPressColor:(0x00000000)
            withBorderNormalColor:btnBorderColor
             withBorderPressColor:btnBorderColor
              withTextNormalColor:btnTextColor
               withTextPressColor:btnTextColor
                         withType:0];
    self.levelBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.levelBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.filterBtn.mas_centerY);
       make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-5]);
       make.size.mas_equalTo(self.filterBtn);
    }];
    [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.levelBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.levelBtn.mas_centerX);
    }];
    [self flashXover];
}
-(void)flashXover{
    if(RecStructData.OUT_CH[output_channel_sel].h_filter > 3 || RecStructData.OUT_CH[output_channel_sel].h_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].h_filter = 0;
        
        
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].h_filter=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].h_filter);
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_filter > 3 || RecStructData.OUT_CH[output_channel_sel].l_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].l_filter = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].l_filter=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].l_filter);
    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].h_level < 0){
        RecStructData.OUT_CH[output_channel_sel].h_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].h_level=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].h_level);
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].l_level < 0){
        RecStructData.OUT_CH[output_channel_sel].l_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].l_level=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].l_level);
    }
    if (type==H_Type) {
        [self.filterBtn setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_filter]]  forState:UIControlStateNormal];
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_level]]  forState:UIControlStateNormal];
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
    }else{
        [self.filterBtn setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_filter]]  forState:UIControlStateNormal];
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_level]]  forState:UIControlStateNormal];
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
    }
   
}
#pragma mark-------弹窗
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

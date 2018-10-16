//
//  SingleChItem.m
//  PXE-X09
//
//  Created by celine on 2018/10/5.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SingleChItem.h"
#import "VolSettingViewController.h"
#import "OutDelayViewController.h"
#import "SpkViewController.h"
#define borderNormal (0xFF313c45)
#define bgNormal (0xFF27323d)
#define bgPress (0xFF1d262e)
@implementation SingleChItem{
    int chIndex;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//
//        [self setup];
//    }
//    return self;
//}
-(void)setup{
    self.backgroundColor=[UIColor clearColor];
    
    self.sourceImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Source_Optical"]];
    self.sourceImage.contentMode=UIViewContentModeScaleAspectFit;
    
    self.chName=[[UILabel alloc]init];
    self.chName.font=[UIFont systemFontOfSize:12];
    self.chName.adjustsFontSizeToFitWidth=YES;
    self.chName.text=@"光纤";
    self.chName.textColor=SetColor(0xFF789ab0);
    UIStackView *stackView=[[UIStackView alloc]init];
    stackView.alignment=UIStackViewAlignmentCenter;
    stackView.axis=UILayoutConstraintAxisVertical;
    [stackView addArrangedSubview:self.sourceImage];
    [stackView addArrangedSubview:self.chName];
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:0]);
        make.width.mas_equalTo([Dimens GDimens:65]);
    }];
    self.flgView=[[UIView alloc]init];
    [self addSubview:self.flgView];
    self.flgView.backgroundColor=[UIColor greenColor];
    self.flgView.layer.cornerRadius=2.5;
    self.flgView.layer.masksToBounds=YES;
    [self.flgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stackView.mas_centerY);
        make.left.equalTo(stackView.mas_right);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    //线
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(borderNormal);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.flgView.mas_right).offset([Dimens GDimens:5]);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    self.lineTop=[[UIView alloc]init];
    [self addSubview:self.lineTop];
    self.lineTop.backgroundColor=SetColor(borderNormal);
    [self.lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(1);
    }];
    self.lineBottom=[[UIView alloc]init];
    [self addSubview:self.lineBottom];
    self.lineBottom.backgroundColor=SetColor(borderNormal);
    [self.lineBottom                                                 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(1);
    }];
    self.spkBtn=[[NormalButton alloc]init];
    [self.spkBtn
     initViewBroder:0
     withBorderWidth:1
     withNormalColor:bgNormal
     withPressColor:bgNormal
     withBorderNormalColor:borderNormal
     withBorderPressColor:borderNormal
     withTextNormalColor:(0xFFffffff)
     withTextPressColor:(0xFFffffff) withType:4];
    [self.spkBtn setTitle:@"前左高音" forState:UIControlStateNormal];
    self.spkBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    self.spkBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.spkBtn addTarget:self action:@selector(clickSpk:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.spkBtn];
    [self addSubview:self.spkBtn];
    [self.spkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_left).offset([Dimens GDimens:30+20]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:30]));
    }];
    self.eqBtn=[[NormalButton alloc]init];
    [self.eqBtn
     initViewBroder:0
     withBorderWidth:1
     withNormalColor:bgNormal
     withPressColor:bgPress
     withBorderNormalColor:borderNormal
     withBorderPressColor:borderNormal
     withTextNormalColor:(0xFFffffff)
     withTextPressColor:(0xFFffffff) withType:4];
    [self.eqBtn setImage:[UIImage imageNamed:@"eq_normal"] forState:UIControlStateNormal];
    [self.eqBtn addTarget:self action:@selector(clickeEqBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.eqBtn];
    [self.eqBtn setBackgroundImage:[UIImage imageNamed:@"eq_normal"] forState:UIControlStateNormal];
    [self.eqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.spkBtn.mas_centerX).offset([Dimens GDimens:85]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(self.spkBtn);
    }];
    
    self.sbVol=[[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:45], [Dimens GDimens:45])];
    [self addSubview:self.sbVol];
    [self.sbVol setMaxProgress:Input_CH_Volume_MAX];
    [self.sbVol mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.eqBtn.mas_centerX).offset([Dimens GDimens:80]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    self.volBtn=[[UIButton alloc]init];
    [self addSubview:self.volBtn];
    [self.volBtn setTitle:@"20" forState:UIControlStateNormal];
    [self.volBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.volBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    self.volBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.volBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.eqBtn.mas_centerX).offset([Dimens GDimens:80]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    [self.volBtn addTarget:self action:@selector(clickVol:) forControlEvents:UIControlEventTouchUpInside];
    
    self.muteBtn=[[NormalButton alloc]init];
//    [self.muteBtn initViewBroder:0
//                 withBorderWidth:2
//                 withNormalColor:bgNormal
//                  withPressColor:bgPress
//           withBorderNormalColor:UI_Master_SB_Volume_Normal
//            withBorderPressColor:(0xFF000000)
//             withTextNormalColor:bgNormal
//              withTextPressColor:bgNormal withType:4];
    [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    [self.muteBtn addTarget:self action:@selector(clickMute:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.muteBtn];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.volBtn.mas_centerX).offset([Dimens GDimens:75]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    
}
#pragma mark--------点击事件
-(void)clickMute:(NormalButton *)btn{
    if(RecStructData.IN_CH[chIndex].mute==0){
        RecStructData.IN_CH[chIndex].mute=1;
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }else{
         RecStructData.IN_CH[chIndex].mute=0;
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }
}
-(void)clickSpk:(UIButton *)btn{
    input_channel_sel=chIndex;
    SpkViewController *vc=[[SpkViewController alloc]init];
    vc.myType=SPKTYPE_IN;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock = ^{
        [self flashView];
    };
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
}
-(void)clickVol:(UIButton *)btn{
    input_channel_sel=chIndex;
    VolSettingViewController *vc=[[VolSettingViewController alloc]init];
    vc.chType=CH_INPUT;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock = ^{
        self.reloadblock();
        [self flashView];
    };
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
    
}
-(void)clickeEqBtn:(NormalButton *)btn{
    input_channel_sel=chIndex;
    self.eqblock(chIndex);
}
-(void)setChannelIndex:(int)index{
    chIndex=index;
}
-(void)flashView{
    if (RecStructData.IN_CH[chIndex].mute==0) {
         [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }else{
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }
    [self.sbVol setProgress:RecStructData.IN_CH[chIndex].gain];
    [self.volBtn setTitle:[NSString stringWithFormat:@"%d",RecStructData.IN_CH[chIndex].gain/Output_Volume_Step] forState:UIControlStateNormal];
    [self.spkBtn setTitle:[self getOutputSpkTypeNameByIndex:RecStructData.System.in_spk_type[chIndex]] forState:UIControlStateNormal];
}
- (NSString*)getOutputSpkTypeNameByIndex:(int)index{
    switch (index) {
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
            
        case 25: return [LANG DPLocalizedString:@"L_Out_Front_Subweeter"];
        case 26: return [LANG DPLocalizedString:@"L_Out_Rear_Subweeter"];
        case 27: return [LANG DPLocalizedString:@"L_Out_C_Front"];
        case 28: return [LANG DPLocalizedString:@"L_Out_C_Rear"];
            
        default: return [LANG DPLocalizedString:@"L_Out_NULL"];
    }
}
-(NSArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray=@[@"Source_Optical",
                      @"Source_Coaxial",
                      @"Source_Blue",
                      @"Source_High",
                      @"Source_Aux"];
    }
    return _ImageArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

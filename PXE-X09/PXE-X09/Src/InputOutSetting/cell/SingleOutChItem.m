//
//  SingleOutChItem.m
//  PXE-X09
//
//  Created by celine on 2018/10/8.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SingleOutChItem.h"
#import "Masonry.h"
#import "VolSettingViewController.h"
#import "OutDelayViewController.h"
#define borderNormal (0xFF313c45)
#define bgNormal (0xFF27323d)
#define bgPress (0xFF1d262e)
@implementation SingleOutChItem
{
    int chIndex;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    self.backgroundColor=[UIColor clearColor];
    self.sourceImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"output_Icon"]];
    self.sourceImage.contentMode=UIViewContentModeScaleAspectFit;
    
    self.chName=[[UILabel alloc]init];
    self.chName.font=[UIFont systemFontOfSize:12];
    self.chName.adjustsFontSizeToFitWidth=YES;
    self.chName.text=@"输出1";
    self.chName.textColor=SetColor(0xFF789ab0);
    UIStackView *stackView=[[UIStackView alloc]init];
    stackView.alignment=UIStackViewAlignmentCenter;
    stackView.axis=UILayoutConstraintAxisVertical;
    [stackView addArrangedSubview:self.sourceImage];
    [stackView addArrangedSubview:self.chName];
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset([Dimens GDimens:0]);
        make.width.mas_equalTo([Dimens GDimens:55]);
    }];
    //线
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(borderNormal);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:0]);
        make.right.equalTo(stackView.mas_left);
        make.height.mas_equalTo(1);
    }];
    self.lineTop=[[UIView alloc]init];
    [self addSubview:self.lineTop];
    self.lineTop.backgroundColor=SetColor(borderNormal);
    [self.lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(1);
    }];
    self.lineBottom=[[UIView alloc]init];
    [self addSubview:self.lineBottom];
    self.lineBottom.backgroundColor=SetColor(borderNormal);
    [self.lineBottom                                                 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(1);
    }];
//通道类型
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
    [self addSubview:self.spkBtn];
    [self.spkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_right).offset(-[Dimens GDimens:40]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:30]));
    }];
//静音
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
        make.centerX.equalTo(self.spkBtn.mas_centerX).offset(-[Dimens GDimens:65]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
//音量
    self.sbVol=[[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:45], [Dimens GDimens:45])];
    [self addSubview:self.sbVol];
    [self.sbVol setMaxProgress:Input_CH_Volume_MAX];
    [self.sbVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.muteBtn.mas_centerX).offset(-[Dimens GDimens:65]);
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
        make.centerX.equalTo(self.muteBtn.mas_centerX).offset(-[Dimens GDimens:65]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    [self.volBtn addTarget:self action:@selector(clickVol:) forControlEvents:UIControlEventTouchUpInside];
    
    self.msBtn=[[NormalButton alloc]init];
    [self addSubview:self.msBtn];
    [self.msBtn initViewBroder:0
               withBorderWidth:1
               withNormalColor:bgNormal
                withPressColor:bgNormal
         withBorderNormalColor:borderNormal
          withBorderPressColor:borderNormal
           withTextNormalColor:(0xFFffffff)
            withTextPressColor:(0xFFffffff) withType:4];
    
    [self.msBtn setTitle:@"20.000" forState:UIControlStateNormal];
    [self.msBtn setImage:[UIImage imageNamed:@"msicon"] forState:UIControlStateNormal];
    self.msBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    [self.msBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.msBtn.imageView.image.size.width, 0, [Dimens GDimens:18])];
    [self.msBtn setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(60-[Dimens GDimens:18])], 0, 0)];
    [self.msBtn addTarget:self action:@selector(clickDelay:) forControlEvents:UIControlEventTouchUpInside];
   self.msBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.msBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.msBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.volBtn.mas_centerX).offset(-[Dimens GDimens:65]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:20]));
    }];
    
    self.cmBtn=[[NormalButton alloc]init];
    [self addSubview:self.cmBtn];
    [self.cmBtn initViewBroder:0
               withBorderWidth:1
               withNormalColor:bgNormal
                withPressColor:bgNormal
         withBorderNormalColor:borderNormal
          withBorderPressColor:borderNormal
           withTextNormalColor:(0xFFffffff)
            withTextPressColor:(0xFFffffff) withType:4];
    [self.cmBtn addTarget:self action:@selector(clickDelay:) forControlEvents:UIControlEventTouchUpInside];
    [self.cmBtn setTitle:@"20.000" forState:UIControlStateNormal];
    self.cmBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.cmBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.cmBtn setImage:[UIImage imageNamed:@"cmicon"] forState:UIControlStateNormal];
    [self.cmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.cmBtn.imageView.image.size.width, 0, [Dimens GDimens:18])];
    [self.cmBtn setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(60-[Dimens GDimens:18])], 0, 0)];
    [self.cmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.volBtn.mas_centerX).offset(-[Dimens GDimens:65]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:20]));
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
    [self addSubview:self.eqBtn];
    [self.eqBtn setBackgroundImage:[UIImage imageNamed:@"eq_normal"] forState:UIControlStateNormal];
    [self.eqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cmBtn.mas_centerX).offset(-[Dimens GDimens:70]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(self.spkBtn);
    }];
    
    [self.eqBtn addTarget:self action:@selector(clickeEqBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setChannelIndex:(int)index{
    chIndex=index;
}
-(void)flashView{
    if (RecStructData.OUT_CH[chIndex].mute==0) {
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }else{
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }
    self.chName.text=[NSString stringWithFormat:@"输入%d",chIndex+1];
    [self.cmBtn setTitle:[self CountDelayCM:RecStructData.OUT_CH[chIndex].delay] forState:UIControlStateNormal];
     [self.msBtn setTitle:[self CountDelayMs:RecStructData.OUT_CH[chIndex].delay] forState:UIControlStateNormal];
    [self.sbVol setProgress:RecStructData.OUT_CH[chIndex].gain];
    [self.volBtn setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[chIndex].gain/Output_Volume_Step] forState:UIControlStateNormal];
}
#pragma mark /******* 延时时间转换  *******/

- (NSString*) CountDelayCM:(int)num{
    int m_nTemp=75;
    float Time = (float) (num/96.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+331.0)/1000.0*Time);
    LMT = LMT*100;
    
    int fr=(int) (LMT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    
    return [NSString stringWithFormat:@"%d",(int)ri];
}
- (NSString*) CountDelayMs:(int)num{
    int fr = num*10000/96;
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%.3f",(float)ri/1000];}

- (NSString*) CountDelayInch:(int)num{
    float base=(float) 331.0;
    if(num == DELAY_SETTINGS_MAX){
        base=(float) 331.4;
    }
    int m_nTemp=75;
    float Time = (float) (num/96.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+base)/1000.0*Time);
    
    float LFT = (float) (LMT*3.2808*12.0);
    
    int fr=(int) (LFT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%d",(int)ri];
}
#pragma mark--------点击事件
-(void)clickMute:(NormalButton *)btn{
    if(RecStructData.OUT_CH[chIndex].mute==0){
        RecStructData.OUT_CH[chIndex].mute=1;
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }else{
        RecStructData.OUT_CH[chIndex].mute=0;
        [self.muteBtn setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }

}
-(void)clickVol:(UIButton *)btn{
    output_channel_sel=chIndex;
    VolSettingViewController *vc=[[VolSettingViewController alloc]init];
    vc.chType=CH_OUT;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock = ^{
        
        [self flashView];
    };
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
   
}
-(void)clickDelay:(UIButton *)btn{
    output_channel_sel=chIndex;
    OutDelayViewController *vc=[[OutDelayViewController alloc]init];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock = ^{
        
        [self flashView];
    };
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
}
-(void)clickeEqBtn:(NormalButton *)btn{
    output_channel_sel=chIndex;
    self.eqblock(chIndex);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

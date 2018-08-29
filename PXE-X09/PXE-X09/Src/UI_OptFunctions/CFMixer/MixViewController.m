//
//  MixViewController.m
//  CHSDCP812
//
//  Created by chsdsp on 16/7/13.
//  Copyright © 2016年 hmaudio. All rights reserved.
//

#import "MixViewController.h"

#define TagStartMixerPolar 100
#define TagStartMixerSwitchVal 200
#define TagStartMixerSbVal 300


@interface MixViewController ()



@end

@implementation MixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
 
    
    
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    [self initView];
    [self initEncrypt];
    [self FlashPageUI];

 
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)initData{
    for(int i=0;i<Output_CH_MAX;i++){
        for(int j=0;j<Output_CH_EQ_MAX_USE;j++){
            BufStructData.OUT_CH[i].EQ[j].level = EQ_LEVEL_ZERO;
        }
    }
}
- (void)initView{
    //通道選擇
    self.channelBtn = [[ChannelBtn alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnHeight])];
    [self.view addSubview:self.channelBtn];
    [self.channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewMix4.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnHeight]));
    }];
    [self.channelBtn addTarget:self action:@selector(ChannelChange:) forControlEvents:UIControlEventValueChanged];

    //初始化Index
    [self.labelMix1 setBackgroundColor:[UIColor clearColor]];
    [self.labelMix1 setTextColor:SetColor(UI_MixerIndexTextColor)];
    self.labelMix1.text = [LANG DPLocalizedString:@"L_Mixer_IN1"];
    self.labelMix1.adjustsFontSizeToFitWidth = true;
    
    [self.labelMix2 setBackgroundColor:[UIColor clearColor]];
    [self.labelMix2 setTextColor:SetColor(UI_MixerIndexTextColor)];
    self.labelMix2.text = [LANG DPLocalizedString:@"L_Mixer_IN2"];
    self.labelMix2.adjustsFontSizeToFitWidth = true;

    
    [self.labelMix3 setBackgroundColor:[UIColor clearColor]];
    [self.labelMix3 setTextColor:SetColor(UI_MixerIndexTextColor)];
    self.labelMix3.text = [LANG DPLocalizedString:@"L_Mixer_IN3"];
    self.labelMix3.adjustsFontSizeToFitWidth = true;

    
    [self.labelMix4 setBackgroundColor:[UIColor clearColor]];
    [self.labelMix4 setTextColor:SetColor(UI_MixerIndexTextColor)];
    self.labelMix4.text = [LANG DPLocalizedString:@"L_Mixer_IN4"];
    self.labelMix4.adjustsFontSizeToFitWidth = true;
    //設置背景
    for(int i=0;i<Mixer_CH_MAX;i++){
        [self setMixerBgNormal:true index:i];
    }
    //Polar
    self.btnPol1.tag = TagStartMixerPolar+0;
    self.btnPol2.tag = TagStartMixerPolar+1;
    self.btnPol3.tag = TagStartMixerPolar+2;
    self.btnPol4.tag = TagStartMixerPolar+3;
    [self.btnPol1 addTarget:self action:@selector(MixerPolarClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPol2 addTarget:self action:@selector(MixerPolarClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPol3 addTarget:self action:@selector(MixerPolarClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPol4 addTarget:self action:@selector(MixerPolarClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self flashMixerPolar];
    
    
    //
    [self flashMixerVal];
    //Switch
    self.btnSwitchVol1.tag = TagStartMixerSwitchVal+0;
    self.btnSwitchVol2.tag = TagStartMixerSwitchVal+1;
    self.btnSwitchVol3.tag = TagStartMixerSwitchVal+2;
    self.btnSwitchVol4.tag = TagStartMixerSwitchVal+3;
    [self.btnSwitchVol1 addTarget:self action:@selector(MixerSwitchClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSwitchVol2 addTarget:self action:@selector(MixerSwitchClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSwitchVol3 addTarget:self action:@selector(MixerSwitchClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSwitchVol4 addTarget:self action:@selector(MixerSwitchClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self flashMixerSwitch];
    
    self.btnSwitchVol1.hidden = true;
    self.btnSwitchVol2.hidden = true;
    self.btnSwitchVol3.hidden = true;
    self.btnSwitchVol4.hidden = true;
    
    //SBVal
    self.sliderMixVol1.tag = TagStartMixerSbVal+0;
    self.sliderMixVol2.tag = TagStartMixerSbVal+1;
    self.sliderMixVol3.tag = TagStartMixerSbVal+2;
    self.sliderMixVol4.tag = TagStartMixerSbVal+3;
    
    [self.sliderMixVol1 setMaximumValue:0];
    [self.sliderMixVol1 setMaximumValue:Mixer_Volume_MAX];
    [self.sliderMixVol1 setBackgroundColor:[UIColor clearColor]];

    [self.sliderMixVol2 setMaximumValue:0];
    [self.sliderMixVol2 setMaximumValue:Mixer_Volume_MAX];
    [self.sliderMixVol2 setBackgroundColor:[UIColor clearColor]];
    
    [self.sliderMixVol3 setMaximumValue:0];
    [self.sliderMixVol3 setMaximumValue:Mixer_Volume_MAX];
    [self.sliderMixVol3 setBackgroundColor:[UIColor clearColor]];
    
    [self.sliderMixVol4 setMaximumValue:0];
    [self.sliderMixVol4 setMaximumValue:Mixer_Volume_MAX];
    [self.sliderMixVol4 setBackgroundColor:[UIColor clearColor]];
    

    [self.sliderMixVol1 addTarget:self action:@selector(MixerSbValClickEvent:) forControlEvents:UIControlEventValueChanged];
    [self.sliderMixVol2 addTarget:self action:@selector(MixerSbValClickEvent:) forControlEvents:UIControlEventValueChanged];
    [self.sliderMixVol3 addTarget:self action:@selector(MixerSbValClickEvent:) forControlEvents:UIControlEventValueChanged];
    [self.sliderMixVol4 addTarget:self action:@selector(MixerSbValClickEvent:) forControlEvents:UIControlEventValueChanged];
    
    self.sliderMixVol1.minimumTrackTintColor = SetColor(UI_MixerItemBgPressColor);
    self.sliderMixVol1.maximumTrackTintColor = SetColor(UI_MixerItemBgNormalColor);
    
    self.sliderMixVol2.minimumTrackTintColor = SetColor(UI_MixerItemBgPressColor);
    self.sliderMixVol2.maximumTrackTintColor = SetColor(UI_MixerItemBgNormalColor);

    self.sliderMixVol3.minimumTrackTintColor = SetColor(UI_MixerItemBgPressColor);
    self.sliderMixVol3.maximumTrackTintColor = SetColor(UI_MixerItemBgNormalColor);

    self.sliderMixVol4.minimumTrackTintColor = SetColor(UI_MixerItemBgPressColor);
    self.sliderMixVol4.maximumTrackTintColor = SetColor(UI_MixerItemBgNormalColor);

    [self.sliderMixVol1 setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.sliderMixVol1 setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    
    [self.sliderMixVol2 setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.sliderMixVol2 setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    
    [self.sliderMixVol3 setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.sliderMixVol3 setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    
    [self.sliderMixVol4 setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.sliderMixVol4 setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    
    
    
    
    [self.btnMixVol1 setTextColor:SetColor(UI_MixerItemValColor)];
    [self.btnMixVol2 setTextColor:SetColor(UI_MixerItemValColor)];
    [self.btnMixVol3 setTextColor:SetColor(UI_MixerItemValColor)];
    [self.btnMixVol4 setTextColor:SetColor(UI_MixerItemValColor)];
    
    [self flashMixerSbVal];
}
    
//通道選擇
- (void)ChannelChange:(ChannelBtn*)sender {
    output_channel_sel = [sender GetChannelSelected];
    //NSLog(@"FUCK ChannelChange channel=@%d",output_channel_sel);
    [self FlashPageUI];
    
}

- (void)MixerPolarClickEvent:(UIButton*)sender {
    input_channel_sel = (int) (sender.tag - TagStartMixerPolar);
    [self MixerItemSel:input_channel_sel];
    //NSLog(@"MixerPolarClickEvent input_channel_sel=%d",input_channel_sel);
    if((RecStructData.OUT_CH[output_channel_sel].IN15_Vol&(1<<input_channel_sel))==0){
        RecStructData.OUT_CH[output_channel_sel].IN15_Vol|=(1<<input_channel_sel);
        [self setMixerItemPolar_N:input_channel_sel];
    }else if((RecStructData.OUT_CH[output_channel_sel].IN15_Vol&(1<<input_channel_sel))>=1){
        RecStructData.OUT_CH[output_channel_sel].IN15_Vol&=~(1<<input_channel_sel);
        [self setMixerItemPolar_P:input_channel_sel];
    }
}

- (void)MixerSwitchClickEvent:(UIButton*)sender {
    input_channel_sel = (int) (sender.tag - TagStartMixerSwitchVal);
    [self MixerItemSel:input_channel_sel];

    if(([self getIN_VolByIndex:input_channel_sel] == 0)&&
       ([self getDataBufIN_VolByIndex:input_channel_sel] != 0)){
        [self setIN_VolByIndex:input_channel_sel withVal:[self getDataBufIN_VolByIndex:input_channel_sel]];
    }else if([self getIN_VolByIndex:input_channel_sel] != 0){
        [self setDataBufIN_VolByIndex:input_channel_sel withVal:[self getIN_VolByIndex:input_channel_sel]];
        [self setIN_VolByIndex:input_channel_sel withVal:0];
    }
    [self flashMixerSbVal];
    [self flashMixerVal];
    [self flashMixerSwitch:input_channel_sel];
}


- (void)MixerSbValClickEvent:(UISlider*)sender {
    input_channel_sel = (int) (sender.tag - TagStartMixerSbVal);
    [self MixerItemSel:input_channel_sel];
    //NSLog(@"MixerSbValClickEvent input_channel_sel=%d",input_channel_sel);
    [self flashMixerSwitch:input_channel_sel];
    [self setMixerVal:(int)sender.value byIndex:input_channel_sel];
}
- (void)flashMixerVal{
    
    self.btnMixVol1.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN1_Vol];
    self.btnMixVol2.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN2_Vol];
    self.btnMixVol3.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN3_Vol];
    self.btnMixVol4.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN4_Vol];
}
- (void)setMixerVal:(int)val byIndex:(int)index{
    switch (index) {
        case 0:
            RecStructData.OUT_CH[output_channel_sel].IN1_Vol=val;
            self.btnMixVol1.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN1_Vol];
            break;
        case 1:
            RecStructData.OUT_CH[output_channel_sel].IN2_Vol=val;
            self.btnMixVol2.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN2_Vol];
            break;
        case 2:
            RecStructData.OUT_CH[output_channel_sel].IN3_Vol=val;
            self.btnMixVol3.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN3_Vol];
            break;
        case 3:
            RecStructData.OUT_CH[output_channel_sel].IN4_Vol=val;
            self.btnMixVol4.text = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].IN4_Vol];
            break;
            
        default:
            break;
    }
}


- (void)flashMixerSwitch{
    
    for(int i=0;i<Mixer_CH_MAX;i++){
        [self flashMixerSwitch:i];
    }
}
- (void)flashMixerSwitch:(int)index{
    switch (index) {
        case 0:
            if(RecStructData.OUT_CH[output_channel_sel].IN1_Vol==0){
                [self.btnSwitchVol1 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
            }else{
                [self.btnSwitchVol1 setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
            }
            break;
            
        case 1:
            if(RecStructData.OUT_CH[output_channel_sel].IN2_Vol==0){
                [self.btnSwitchVol2 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
            }else{
                [self.btnSwitchVol2 setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
            if(RecStructData.OUT_CH[output_channel_sel].IN3_Vol==0){
                [self.btnSwitchVol3 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
            }else{
                [self.btnSwitchVol3 setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if(RecStructData.OUT_CH[output_channel_sel].IN4_Vol==0){
                [self.btnSwitchVol4 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
            }else{
                [self.btnSwitchVol4 setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (void)flashMixerSbVal{
    
    self.sliderMixVol1.value = RecStructData.OUT_CH[output_channel_sel].IN1_Vol;
    self.sliderMixVol2.value = RecStructData.OUT_CH[output_channel_sel].IN2_Vol;
    self.sliderMixVol3.value = RecStructData.OUT_CH[output_channel_sel].IN3_Vol;
    self.sliderMixVol4.value = RecStructData.OUT_CH[output_channel_sel].IN4_Vol;
    
}
- (void)setMixerSBVal:(int)val byIndex:(int)index{
    switch (index) {
        case 0:
            RecStructData.OUT_CH[output_channel_sel].IN1_Vol=val;
            self.sliderMixVol1.value = val;
            break;
        case 1:
            RecStructData.OUT_CH[output_channel_sel].IN2_Vol=val;
            self.sliderMixVol2.value = val;
            break;
        case 2:
            RecStructData.OUT_CH[output_channel_sel].IN3_Vol=val;
            self.sliderMixVol3.value = val;
            break;
        case 3:
            RecStructData.OUT_CH[output_channel_sel].IN4_Vol=val;
            self.sliderMixVol4.value = val;
            break;
            
        default:
            break;
    }
}



- (void)MixerItemSel:(int)sel{
    for(int i=0;i<Mixer_CH_MAX;i++){
        [self setMixerBgNormal:true index:i];
    }
    [self setMixerBgNormal:false index:sel];
}

- (void)setMixerBgNormal:(BOOL)normal index:(int)sel{
    CGColorSpaceRef colorSpaceMixViewNormal = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorrefMixViewNormal = CGColorCreate(colorSpaceMixViewNormal,(CGFloat[]){((UI_MixerItemBgNormalColor>>16)&0x00ff)/255.0 ,((UI_MixerItemBgNormalColor>>8)&0x00ff)/255.0,(UI_MixerItemBgNormalColor&0x000000ff)/255.0,((UI_MixerItemBgNormalColor>>24)&0x00ff)/255.0});
    CGColorSpaceRef colorSpaceMixViewPress = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorrefMixViewPress = CGColorCreate(colorSpaceMixViewPress,(CGFloat[]){((UI_MixerItemBgPressColor>>16)&0x00ff)/255.0 ,((UI_MixerItemBgPressColor>>8)&0x00ff)/255.0,(UI_MixerItemBgPressColor&0x000000ff)/255.0,((UI_MixerItemBgPressColor>>24)&0x00ff)/255.0});
    switch (sel) {
        case 0:
            {
                self.viewMix1.backgroundColor = [UIColor clearColor];
                [self.viewMix1.layer setMasksToBounds:YES];
                [self.viewMix1.layer setCornerRadius:5.0];
                [self.viewMix1.layer setBorderWidth:1.0];
                if(normal){
                    [self.viewMix1.layer setBorderColor:colorrefMixViewNormal];
                }else{
                    [self.viewMix1.layer setBorderColor:colorrefMixViewPress];
                }
            }
            break;
        case 1:
            {
                self.viewMix2.backgroundColor = [UIColor clearColor];
                [self.viewMix2.layer setMasksToBounds:YES];
                [self.viewMix2.layer setCornerRadius:5.0];
                [self.viewMix2.layer setBorderWidth:1.0];
                if(normal){
                    [self.viewMix2.layer setBorderColor:colorrefMixViewNormal];
                }else{
                    [self.viewMix2.layer setBorderColor:colorrefMixViewPress];
                }
            }
            break;
        case 2:
            {
                self.viewMix3.backgroundColor = [UIColor clearColor];
                [self.viewMix3.layer setMasksToBounds:YES];
                [self.viewMix3.layer setCornerRadius:5.0];
                [self.viewMix3.layer setBorderWidth:1.0];
                if(normal){
                    [self.viewMix3.layer setBorderColor:colorrefMixViewNormal];
                }else{
                    [self.viewMix3.layer setBorderColor:colorrefMixViewPress];
                }

            }
            break;
        case 3:
            {
                self.viewMix4.backgroundColor = [UIColor clearColor];
                [self.viewMix4.layer setMasksToBounds:YES];
                [self.viewMix4.layer setCornerRadius:5.0];
                [self.viewMix4.layer setBorderWidth:1.0];
                if(normal){
                    [self.viewMix4.layer setBorderColor:colorrefMixViewNormal];
                }else{
                    [self.viewMix4.layer setBorderColor:colorrefMixViewPress];
                }

            }
            break;
            
        default:
            break;
    }
    
}



- (void)flashMixerPolar{
    for(int i=0;i<Mixer_CH_MAX;i++){
        if((RecStructData.OUT_CH[output_channel_sel].IN15_Vol&(1<<i))==0){
            [self setMixerItemPolar_P:i];
        }else{
            [self setMixerItemPolar_N:i];
        }
    }
}


- (void)setMixerItemPolar_P:(int)index{
    switch (index) {
        case 0:
            [self.btnPol1 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
            [self.btnPol1 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
            break;
        case 1:
            [self.btnPol2 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
            [self.btnPol2 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
            break;
        case 2:
            [self.btnPol3 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
            [self.btnPol3 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
            break;
        case 3:
            [self.btnPol4 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
            [self.btnPol4 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
- (void)setMixerItemPolar_N:(int)index{
    switch (index) {
        case 0:
            [self.btnPol1 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
            [self.btnPol1 setTitleColor:SetColor(UI_MixerItemPolar_N) forState:UIControlStateNormal];
            break;
        case 1:
            [self.btnPol2 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
            [self.btnPol2 setTitleColor:SetColor(UI_MixerItemPolar_N) forState:UIControlStateNormal];
            break;
        case 2:
            [self.btnPol3 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
            [self.btnPol3 setTitleColor:SetColor(UI_MixerItemPolar_N) forState:UIControlStateNormal];
            break;
        case 3:
            [self.btnPol4 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
            [self.btnPol4 setTitleColor:SetColor(UI_MixerItemPolar_N) forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}



- (int)getIN_VolByIndex:(int)index{
    switch (index) {
        case 0: return RecStructData.OUT_CH[output_channel_sel].IN1_Vol;
        case 1: return RecStructData.OUT_CH[output_channel_sel].IN2_Vol;
        case 2: return RecStructData.OUT_CH[output_channel_sel].IN3_Vol;
        case 3: return RecStructData.OUT_CH[output_channel_sel].IN4_Vol;
        case 4: return RecStructData.OUT_CH[output_channel_sel].IN5_Vol;
        case 5: return RecStructData.OUT_CH[output_channel_sel].IN6_Vol;
        case 6: return RecStructData.OUT_CH[output_channel_sel].IN7_Vol;
        case 7: return RecStructData.OUT_CH[output_channel_sel].IN8_Vol;
        case 8: return RecStructData.OUT_CH[output_channel_sel].IN9_Vol;
        case 9: return RecStructData.OUT_CH[output_channel_sel].IN10_Vol;
        case 10: return RecStructData.OUT_CH[output_channel_sel].IN11_Vol;
        case 11: return RecStructData.OUT_CH[output_channel_sel].IN12_Vol;
        case 12: return RecStructData.OUT_CH[output_channel_sel].IN13_Vol;
        case 13: return RecStructData.OUT_CH[output_channel_sel].IN14_Vol;
        case 14: return RecStructData.OUT_CH[output_channel_sel].IN15_Vol;
        case 15: return RecStructData.OUT_CH[output_channel_sel].IN16_Vol;
        default:
            return 44;
            break;
    }
}
- (void)setIN_VolByIndex:(int)index withVal:(int)val{
    switch (index) {
        case 0: RecStructData.OUT_CH[output_channel_sel].IN1_Vol=val;break;
        case 1: RecStructData.OUT_CH[output_channel_sel].IN2_Vol=val;break;
        case 2: RecStructData.OUT_CH[output_channel_sel].IN3_Vol=val;break;
        case 3: RecStructData.OUT_CH[output_channel_sel].IN4_Vol=val;break;
        case 4: RecStructData.OUT_CH[output_channel_sel].IN5_Vol=val;break;
        case 5: RecStructData.OUT_CH[output_channel_sel].IN6_Vol=val;break;
        case 6: RecStructData.OUT_CH[output_channel_sel].IN7_Vol=val;break;
        case 7: RecStructData.OUT_CH[output_channel_sel].IN8_Vol=val;break;
        case 8: RecStructData.OUT_CH[output_channel_sel].IN9_Vol=val;break;
        case 9: RecStructData.OUT_CH[output_channel_sel].IN10_Vol=val;break;
        case 10: RecStructData.OUT_CH[output_channel_sel].IN11_Vol=val;break;
        case 11: RecStructData.OUT_CH[output_channel_sel].IN12_Vol=val;break;
        case 12: RecStructData.OUT_CH[output_channel_sel].IN13_Vol=val;break;
        case 13: RecStructData.OUT_CH[output_channel_sel].IN14_Vol=val;break;
        case 14: RecStructData.OUT_CH[output_channel_sel].IN15_Vol=val;break;
        case 15: RecStructData.OUT_CH[output_channel_sel].IN16_Vol=val;break;
        default:
            break;
    }
}

- (int)getDataBufIN_VolByIndex:(int)index{
    switch (index) {
        case 0: return BufStructData.OUT_CH[output_channel_sel].IN1_Vol;
        case 1: return BufStructData.OUT_CH[output_channel_sel].IN2_Vol;
        case 2: return BufStructData.OUT_CH[output_channel_sel].IN3_Vol;
        case 3: return BufStructData.OUT_CH[output_channel_sel].IN4_Vol;
        case 4: return BufStructData.OUT_CH[output_channel_sel].IN5_Vol;
        case 5: return BufStructData.OUT_CH[output_channel_sel].IN6_Vol;
        case 6: return BufStructData.OUT_CH[output_channel_sel].IN7_Vol;
        case 7: return BufStructData.OUT_CH[output_channel_sel].IN8_Vol;
        case 8: return BufStructData.OUT_CH[output_channel_sel].IN9_Vol;
        case 9: return BufStructData.OUT_CH[output_channel_sel].IN10_Vol;
        case 10: return BufStructData.OUT_CH[output_channel_sel].IN11_Vol;
        case 11: return BufStructData.OUT_CH[output_channel_sel].IN12_Vol;
        case 12: return BufStructData.OUT_CH[output_channel_sel].IN13_Vol;
        case 13: return BufStructData.OUT_CH[output_channel_sel].IN14_Vol;
        case 14: return BufStructData.OUT_CH[output_channel_sel].IN15_Vol;
        case 15: return BufStructData.OUT_CH[output_channel_sel].IN16_Vol;
        default:
            return 44;
            break;
    }
}
- (void)setDataBufIN_VolByIndex:(int)index withVal:(int)val{
    switch (index) {
        case 0: BufStructData.OUT_CH[output_channel_sel].IN1_Vol=val;break;
        case 1: BufStructData.OUT_CH[output_channel_sel].IN2_Vol=val;break;
        case 2: BufStructData.OUT_CH[output_channel_sel].IN3_Vol=val;break;
        case 3: BufStructData.OUT_CH[output_channel_sel].IN4_Vol=val;break;
        case 4: BufStructData.OUT_CH[output_channel_sel].IN5_Vol=val;break;
        case 5: BufStructData.OUT_CH[output_channel_sel].IN6_Vol=val;break;
        case 6: BufStructData.OUT_CH[output_channel_sel].IN7_Vol=val;break;
        case 7: BufStructData.OUT_CH[output_channel_sel].IN8_Vol=val;break;
        case 8: BufStructData.OUT_CH[output_channel_sel].IN9_Vol=val;break;
        case 9: BufStructData.OUT_CH[output_channel_sel].IN10_Vol=val;break;
        case 10: BufStructData.OUT_CH[output_channel_sel].IN11_Vol=val;break;
        case 11: BufStructData.OUT_CH[output_channel_sel].IN12_Vol=val;break;
        case 12: BufStructData.OUT_CH[output_channel_sel].IN13_Vol=val;break;
        case 13: BufStructData.OUT_CH[output_channel_sel].IN14_Vol=val;break;
        case 14: BufStructData.OUT_CH[output_channel_sel].IN15_Vol=val;break;
        case 15: BufStructData.OUT_CH[output_channel_sel].IN16_Vol=val;break;
        default:
            break;
    }
}


#pragma 加密
- (void)initEncrypt{
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    self.Encrypt = [[UIButton alloc]init];
    [self.view addSubview:self.Encrypt];
    self.Encrypt.frame = CGRectMake(0, [Dimens GDimens:UI_StartWithTopBar], KScreenWidth, KScreenHeight-[Dimens GDimens:ButtomBarHeight]);
    [self.Encrypt setTitle:[LANG DPLocalizedString:@"L_Master_EN_HadEncryption"] forState:UIControlStateNormal];
    [self.Encrypt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.Encrypt.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.Encrypt.titleLabel.font = [UIFont systemFontOfSize:50];
    [self.Encrypt addTarget:self action:@selector(Encrypt_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Encrypt setBackgroundColor:SetColor(UI_Master_EncryptColor)];
    self.Encrypt.hidden = true;
}
    
- (void)Encrypt_Click:(UIButton*)sender{
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    [self ShowSetDecipheringDialog];
}
- (void)ShowSetDecipheringDialog{
    setEnNum = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"]message:[LANG DPLocalizedString:@"L_Master_EN_SetDeciphering"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.textColor= [UIColor redColor];
        textField.text=setEnNum;
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(setEnTextDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_EN_EncryptionClean"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL_EncryptionFlag = FALSE;
        [_mDataTransmitOpt SEFF_EncryptClean];
        [self FlashPageUI];
        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Master_EN_EncryptionSave"] WithMode:SEFF_OPT_Save];
        
        //[alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if(setEnNum.length == 6){
            NSData* bytes = [setEnNum dataUsingEncoding:NSUTF8StringEncoding];
            Byte * temp = (Byte *)[bytes bytes];
            BOOL bool_EnR = true;
            for(int i=0;i<6;i++){
                if(Encryption_PasswordBuf[i] != *(temp+i)){
                    NSLog(@"Encryption_PasswordBuf= %d",Encryption_PasswordBuf[i]);
                    NSLog(@"temp= %d",*(temp+i));
                    bool_EnR = false;
                }
            }
            
            if(!bool_EnR){//密码错误
                //延时执行
                [self performSelector:@selector(showPasswordIncorrect) withObject:nil afterDelay:0.1];
            }else{//密码正确
                BOOL_EncryptionFlag = FALSE;
                [_mDataTransmitOpt SEFF_Save:0];
                [self FlashPageUI];
                [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Master_EN_EncryptionSave"] WithMode:SEFF_OPT_Save];
            }
            
        }else{
            //延时执行
            [self performSelector:@selector(showEN_EnterMsgMessage) withObject:nil afterDelay:0.1];
        }
        
        //NSLog(@"点击了确定按钮");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        //NSLog(@"点击了取消按钮");
        //[self presentViewController:alert animated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showPasswordIncorrect{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_Master_EN_PasswordIncorrect"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}
- (void)showEN_EnterMsgMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_Master_EN_EnterMsg"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}
    //音效操作进度
    /*
     Mode=1: 读取
     Mode=2: 保存
     */
-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode{
    [self initSaveLoadSEFFProgress];
    self.HUD_SEFF.detailsLabelText = Detail;
    [self.HUD_SEFF showWhileExecuting:@selector(HUD_SEFFProgressTask) onTarget:self withObject:nil animated:YES];
    
}
-(void)initSaveLoadSEFFProgress{
    
    self.HUD_SEFF = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD_SEFF];    //常用的设置
    //小矩形的背景色
    //self.HUD_SEFF.color = [UIColor blueColor];//这儿表示无背景clearColor
    //显示的文字
    self.HUD_SEFF.labelText = @"";
    //细节文字
    self.HUD_SEFF.detailsLabelText = @"";
    //是否有庶罩
    self.HUD_SEFF.dimBackground = YES;
    //[self.HUD_SEFF hide:YES afterDelay:2];
    
    self.HUD_SEFF.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD_SEFF.delegate = self;
    
}
-(void) HUD_SEFFProgressTask{
    
    
    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
    
    NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [_mDataTransmitOpt GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
        self.HUD_SEFF.progress = 1-progress/100.0;
        usleep(10000);
    }
}
    //输入框文字改变时 方法
-(void)setEnTextDidChange:(UITextField *)fd{
    if(fd.text.length > 6){
        fd.text = setEnNum;
    }
    NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
    setEnNum = fd.text;
}
    //连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    
#pragma
    
#pragma 广播通知
- (void)FlashPageUI{
    [self flashMixerVal];
    [self flashMixerPolar];
    [self flashMixerSbVal];
    [self flashMixerSwitch];
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        self.Encrypt.hidden = false;
        
        self.btnMixVol1.text = [NSString stringWithFormat:@"%d",0];
        self.btnMixVol2.text = [NSString stringWithFormat:@"%d",0];
        self.btnMixVol3.text = [NSString stringWithFormat:@"%d",0];
        self.btnMixVol4.text = [NSString stringWithFormat:@"%d",0];
        
        [self.btnPol1 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [self.btnPol1 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
        [self.btnPol2 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [self.btnPol2 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
        [self.btnPol3 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [self.btnPol3 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];
        [self.btnPol4 setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [self.btnPol4 setTitleColor:SetColor(UI_MixerItemPolar_P) forState:UIControlStateNormal];

        self.sliderMixVol1.value = 0;
        self.sliderMixVol2.value = 0;
        self.sliderMixVol3.value = 0;
        self.sliderMixVol4.value = 0;
        
        [self.btnSwitchVol1 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
        [self.btnSwitchVol2 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
        [self.btnSwitchVol3 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
        [self.btnSwitchVol4 setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
    }else{
        self.Encrypt.hidden = true;
    }
    
    
}
    
    //更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
    });
}
    
    
@end

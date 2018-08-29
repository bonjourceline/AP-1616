//
//  InputViewController.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "InputViewController.h"
#import "Masonry.h"
#import "IndexButton.h"
#import "MixerItem.h"
#import "ChannelBtn.h"


@interface InputViewController ()

@end

@implementation InputViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    
    
    
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
    
    //    Level_List  = [NSMutableArray array];
    //    LevelH_List = [NSMutableArray array];
    //    for(int i=0;i<9;i++){
    //        if(BOOL_XOverOctArry[i]){
    //            [Level_List addObject:[AllLevel objectAtIndex:i]];
    //        }
    //    }
    //    for(int i=0;i<9;i++){
    //        if(BOOL_XOverOctArryH[i]){
    //            [LevelH_List addObject:[AllLevel objectAtIndex:i]];
    //        }
    //    }
    
    if(RecStructData.INS_CH[input_channel_sel].h_filter > 3 || RecStructData.INS_CH[input_channel_sel].h_filter < 0){
        RecStructData.INS_CH[input_channel_sel].h_filter = 0;
    }
    if(RecStructData.INS_CH[input_channel_sel].l_filter > 3 || RecStructData.INS_CH[input_channel_sel].l_filter < 0){
        RecStructData.INS_CH[input_channel_sel].l_filter = 0;
    }
    
    if(RecStructData.INS_CH[input_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.INS_CH[input_channel_sel].h_level < 0){
        RecStructData.INS_CH[input_channel_sel].h_level = 0;
    }
    if(RecStructData.INS_CH[input_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.INS_CH[input_channel_sel].l_level < 0){
        RecStructData.INS_CH[input_channel_sel].l_level = 0;
    }
    
    if(RecStructData.INS_CH[input_channel_sel].h_freq > 20000 || RecStructData.INS_CH[input_channel_sel].h_freq < 20){
        RecStructData.INS_CH[input_channel_sel].h_freq = 20;
    }
    if(RecStructData.INS_CH[input_channel_sel].l_freq > 20000 || RecStructData.INS_CH[input_channel_sel].l_freq < 20){
        RecStructData.INS_CH[input_channel_sel].l_freq = 20000;
    }
    
}

- (void)initView{
    [self initInputSourceView];
    [self initInputChannelView];
    [self initEQView];
    [self initXOverView];
}


#pragma 音源
- (void)initInputSourceView{
    //音源选择
    self.Btn_InputSource = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_InputSource];
    [self.Btn_InputSource initView:3 withBorderWidth:1 withNormalColor:UI_SystemBtnColorNormal withPressColor:UI_SystemBtnColorNormal withType:1];
    [self.Btn_InputSource setBackgroundColor:SetColor(UI_Master_InputSourceBtnColor)];
    [self.Btn_InputSource setTitleColor:SetColor(UI_Master_InputSourceBtnTextColor) forState:UIControlStateNormal];
    [self.Btn_InputSource addTarget:self action:@selector(SelectInputSource:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
    self.Btn_InputSource.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_InputSource.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_InputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:80]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:MasterBtn_Height]));
    }];
}


//音源设置
- (void)SelectInputSource:(UIButton *)sender {
    NSArray *titles = @[
                        [LANG DPLocalizedString:@"L_InputSource_High"],
                        [LANG DPLocalizedString:@"L_InputSource_AUX"],
//                        [LANG DPLocalizedString:@"L_InputSource_Optical"],
//                        [LANG DPLocalizedString:@"L_InputSource_Coaxial"],
                        [LANG DPLocalizedString:@"L_InputSource_Bluetooth"]
                        ];
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_InputSourceSelect"]message:[LANG DPLocalizedString:@"L_MainInputSource"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecStructData.System.input_source = 1;
        [self.Btn_InputSource setTitle:[titles objectAtIndex:0] forState:UIControlStateNormal];
        [self dealWithInputsource];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecStructData.System.input_source = 3;
        [self.Btn_InputSource setTitle:[titles objectAtIndex:1] forState:UIControlStateNormal];
        [self dealWithInputsource];
        
        
    }]];
    
//    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        RecStructData.System.input_source = 0;
//        [self.Btn_InputSource setTitle:[titles objectAtIndex:2] forState:UIControlStateNormal];
//        [self dealWithInputsource];
//        
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:3] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        RecStructData.System.input_source = 4;
//        [self.Btn_InputSource setTitle:[titles objectAtIndex:3] forState:UIControlStateNormal];
//        [self dealWithInputsource];
//        
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecStructData.System.input_source = 2;
        [self.Btn_InputSource setTitle:[titles objectAtIndex:2] forState:UIControlStateNormal];
        [self dealWithInputsource];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];}
- (void)dealWithInputsource{
    
    [self FlashPageUI];
    [_mDataTransmitOpt setInputSourceNow];
    
}

-(void) FlashInputSource{
    switch (RecStructData.System.input_source) {
        case 1:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_High"] forState:UIControlStateNormal] ;
            break;
        case 3:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_AUX"] forState:UIControlStateNormal] ;
            break;
        case 0:
            //            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Digtit"] forState:UIControlStateNormal] ;
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Optical"] forState:UIControlStateNormal] ;
            break;
        case 4:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Coaxial"] forState:UIControlStateNormal] ;
            break;
        case 2:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
        default:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
    }
    [self flashInputChannel];
}

#pragma 通道选择

- (void)initInputChannelView{
    self.HI_CH = [[InputChannelSel alloc]init];
    [self.view addSubview:self.HI_CH];
    [self.HI_CH setChannelStart:0];
    [self.HI_CH setCurChannel:0];
    [self.HI_CH setLinkB:false];
    [self.HI_CH setLinkA:false];
    [self.HI_CH addTarget:self action:@selector(InputHiChannelSel:) forControlEvents:UIControlEventValueChanged];
    [self.HI_CH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_InputSource.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.Btn_InputSource.mas_right).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:350], [Dimens GDimens:MasterBtn_Height]));
    }];
    
    
    self.AUX_CH = [[InputChannelSel alloc]init];
    [self.view addSubview:self.AUX_CH];
    [self.AUX_CH setChannelStart:4];
    [self.AUX_CH setCurChannel:0];
    [self.AUX_CH setLinkB:false];
    [self.AUX_CH setLinkA:false];
    [self.AUX_CH addTarget:self action:@selector(InputAUXChannelSel:) forControlEvents:UIControlEventValueChanged];
    [self.AUX_CH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_InputSource.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.Btn_InputSource.mas_right).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:350], [Dimens GDimens:MasterBtn_Height]));
    }];
    self.AUX_CH.hidden = true;

}

- (void)InputHiChannelSel:(InputChannelSel *)sender {
    if([sender getEvent] == EVENT_CH){
        input_channel_sel = [sender getCurChannel];
        INS_LINKFlag[RecStructData.System.input_source][0] = [sender getLinkA];
        INS_LINKFlag[RecStructData.System.input_source][1] = [sender getLinkB];
    }else if([sender getEvent] == EVENT_LINKA){
        if(INS_LINKFlag[RecStructData.System.input_source][0]){
            INS_LINKFlag[RecStructData.System.input_source][0] = false;
            [sender setLinkA:false];
        }else{
            [self showInputChannelLinkLeftRightCopyDialog:EVENT_LINKA];
        }
    }else if([sender getEvent] == EVENT_LINKB){
        if(INS_LINKFlag[RecStructData.System.input_source][1]){
            INS_LINKFlag[RecStructData.System.input_source][1] = false;
            [sender setLinkB:false];
        }else{
            [self showInputChannelLinkLeftRightCopyDialog:EVENT_LINKB];
        }
    }
    [self checkINSLinkFlag];
    [self FlashEQXover];
}
- (void)InputAUXChannelSel:(InputChannelSel *)sender {
    if([sender getEvent] == EVENT_CH){
        input_channel_sel = [sender getCurChannel];
        INS_LINKFlag[RecStructData.System.input_source][0] = [sender getLinkA];
        INS_LINKFlag[RecStructData.System.input_source][1] = [sender getLinkB];
    }else if([sender getEvent] == EVENT_LINKA){
        if(INS_LINKFlag[RecStructData.System.input_source][0]){
            INS_LINKFlag[RecStructData.System.input_source][0] = false;
            [sender setLinkA:false];
        }else{
            [self showInputChannelLinkLeftRightCopyDialog:EVENT_LINKA];
        }
    }else if([sender getEvent] == EVENT_LINKB){
        if(INS_LINKFlag[RecStructData.System.input_source][1]){
            INS_LINKFlag[RecStructData.System.input_source][1] = false;
            [sender setLinkB:false];
        }else{
            [self showInputChannelLinkLeftRightCopyDialog:EVENT_LINKB];
        }
    }
    
    
    [self checkINSLinkFlag];
    [self FlashEQXover];
}

- (void)checkINSLinkFlag{
    BOOL Link = false;
    for(int i=0;i<16;i++){
        for(int j=0;j<4;j++){
            if(INS_LINKFlag[i][j]){
                Link = true;
                break;
            }
        }
    }
    
    BOOL_INS_LINKFlag = Link;
}

- (void)flashInputChannel{
    switch (RecStructData.System.input_source) {
        case 1:
            self.HI_CH.hidden  = false;
            self.AUX_CH.hidden = true;
            input_channel_sel = [self.HI_CH getCurChannel];
            break;
        case 3:
            self.HI_CH.hidden  = true;
            self.AUX_CH.hidden = false;
            input_channel_sel = [self.AUX_CH getCurChannel];
            break;
        case 2:
            self.HI_CH.hidden  = true;
            self.AUX_CH.hidden = true;
            input_channel_sel = 10;
            break;
//        case 0:
//            self.HI_CH.hidden  = true;
//            self.AUX_CH.hidden = true;
//            input_channel_sel = 8;
//            break;
//        case 4:
//            self.HI_CH.hidden  = true;
//            self.AUX_CH.hidden = true;
//            input_channel_sel = 9;
//            break;
        default:
            self.HI_CH.hidden  = true;
            self.AUX_CH.hidden = true;
            break;
    }
}


- (void)showInputChannelLinkLeftRightCopyDialog:(int)event{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Set_LinkLR"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Link"]preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_LeftToRight"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(RecStructData.System.input_source == 1){
            if(event == EVENT_LINKA){
                INS_DataCopy(0,1);
                [self.HI_CH setLinkA:true];
            }else{
                INS_DataCopy(2,3);
                [self.HI_CH setLinkB:true];
            }
        }else if(RecStructData.System.input_source == 3){
            if(event == EVENT_LINKA){
                INS_DataCopy(4,5);
                [self.AUX_CH setLinkA:true];
            }else{
                INS_DataCopy(6,7);
                [self.AUX_CH setLinkB:true];
            }
        }
        [self checkINSLinkFlag];
        [self FlashEQXover];
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_RightToLeft"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if(RecStructData.System.input_source == 1){
            if(event == EVENT_LINKA){
                INS_DataCopy(1,0);
                [self.HI_CH setLinkA:true];
            }else{
                INS_DataCopy(3,2);
                [self.HI_CH setLinkB:true];
            }
        }else if(RecStructData.System.input_source == 3){
            if(event == EVENT_LINKA){
                INS_DataCopy(5,4);
                [self.AUX_CH setLinkA:true];
            }else{
                INS_DataCopy(7,6);
                [self.AUX_CH setLinkB:true];
            }
        }
        [self checkINSLinkFlag];
        [self FlashEQXover];
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma 滤波器
- (void)initXOverView{

    self.LabHP_Text = [[UILabel alloc]init];
    [self.view addSubview:self.LabHP_Text];
    [self.LabHP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabHP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabHP_Text.text=[LANG DPLocalizedString:@"L_XOver_HighPass"];
    self.LabHP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabHP_Text.adjustsFontSizeToFitWidth = true;
    self.LabHP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabHP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_EQReset.mas_bottom).offset([Dimens GDimens:15]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:InputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    self.LabLP_Text = [[UILabel alloc]init];
    [self.view addSubview:self.LabLP_Text];
    [self.LabLP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabLP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabLP_Text.text=[LANG DPLocalizedString:@"L_XOver_LowPass"];
    self.LabLP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabLP_Text.adjustsFontSizeToFitWidth = true;
    self.LabLP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabLP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabHP_Text.mas_bottom).offset([Dimens GDimens:20]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:InputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    //高通
    self.H_Filter = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Filter];
    [self.H_Filter initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.H_Filter setBackgroundColor:[UIColor clearColor]];
    [self.H_Filter setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    [self.H_Filter addTarget:self action:@selector(H_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabHP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.LabHP_Text.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    self.H_Level = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Level];
    [self.H_Level initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.H_Level setBackgroundColor:[UIColor clearColor]];
    [self.H_Level setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    [self.H_Level addTarget:self action:@selector(H_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.H_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabHP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.H_Filter.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    self.H_Freq = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Freq];
    [self.H_Freq initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.H_Freq setBackgroundColor:[UIColor clearColor]];
    [self.H_Freq setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    
    [self.H_Freq addTarget:self action:@selector(H_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabHP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.H_Level.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    //低通
    self.L_Filter = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Filter];
    [self.L_Filter initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.L_Filter setBackgroundColor:[UIColor clearColor]];
    [self.L_Filter setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    
    [self.L_Filter addTarget:self action:@selector(L_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabLP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.LabLP_Text.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    self.L_Level = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Level];
    [self.L_Level initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.L_Level setBackgroundColor:[UIColor clearColor]];
    [self.L_Level setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    [self.L_Level addTarget:self action:@selector(L_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.L_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabLP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.L_Filter.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    
    self.L_Freq = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Freq];
    [self.L_Freq initView:3 withBorderWidth:1 withNormalColor:UI_XOver_Btn_Normal withPressColor:UI_XOver_Btn_Press withType:0];
    [self.L_Freq setBackgroundColor:[UIColor clearColor]];
    [self.L_Freq setTextColorWithNormalColor:UI_XOver_BtnText_Normal withPressColor:UI_XOver_BtnText_Press];
    
    [self.L_Freq addTarget:self action:@selector(L_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabLP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.L_Level.mas_right).offset([Dimens GDimens:InputPageBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:InputPageXoverBtnWidth], [Dimens GDimens:InputPageXoverBtnHeight]));
    }];
    


    
    
    [self.H_Filter setNormal];
    [self.H_Level setNormal];
    [self.H_Freq setNormal];
    
    [self.L_Filter setNormal];
    [self.L_Level setNormal];
    [self.L_Freq setNormal];
    
    [self flashXOver];
}

- (void)H_Fifter_CLick:(NormalButton*)sender{
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.INS_CH[input_channel_sel].h_level == 0){
            return;
        }
    }
    Bool_HL = true;
    B_Buf = sender;
    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)H_Level_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = true;
    [self showLevelOptDialog];
    
    
}
- (void)H_Freq_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = true;
    [self showFreqDialog];
    
}
- (void)L_Fifter_CLick:(NormalButton*)sender{
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.INS_CH[input_channel_sel].l_level == 0){
            return;
        }
    }
    Bool_HL = false;
    B_Buf = sender;
    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)L_Level_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = false;
    [self showLevelOptDialog];
    
}
- (void)L_Freq_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = false;
    [self showFreqDialog];
    
    
}

- (void)flashXOver{
    if(RecStructData.INS_CH[input_channel_sel].h_filter > 3 || RecStructData.INS_CH[input_channel_sel].h_filter < 0){
        RecStructData.INS_CH[input_channel_sel].h_filter = 0;
        
        
        NSLog(@"flashXOver ERROR  RecStructData.INS_CH[%d].h_filter=%d",output_channel_sel,RecStructData.INS_CH[input_channel_sel].h_filter);
    }
    if(RecStructData.INS_CH[input_channel_sel].l_filter > 3 || RecStructData.INS_CH[input_channel_sel].l_filter < 0){
        RecStructData.INS_CH[input_channel_sel].l_filter = 0;
        NSLog(@"flashXOver ERROR  RecStructData.INS_CH[%d].l_filter=%d",output_channel_sel,RecStructData.INS_CH[input_channel_sel].l_filter);
    }
    
    if(RecStructData.INS_CH[input_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.INS_CH[input_channel_sel].h_level < 0){
        RecStructData.INS_CH[input_channel_sel].h_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.INS_CH[%d].h_level=%d",output_channel_sel,RecStructData.INS_CH[input_channel_sel].h_level);
    }
    if(RecStructData.INS_CH[input_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.INS_CH[input_channel_sel].l_level < 0){
        RecStructData.INS_CH[input_channel_sel].l_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.INS_CH[%d].l_level=%d",output_channel_sel,RecStructData.INS_CH[input_channel_sel].l_level);
    }
    
    //滤波器
    [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].h_filter]]  forState:UIControlStateNormal];
    [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].l_filter]]  forState:UIControlStateNormal];
    //斜率
    [self.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.INS_CH[input_channel_sel].h_level]]  forState:UIControlStateNormal];
    [self.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.INS_CH[input_channel_sel].l_level]]  forState:UIControlStateNormal];
    //频率
    [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
    [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
    
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.INS_CH[input_channel_sel].h_level == 0){
            [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            
        }else{
            [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].h_filter]] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
    }else{
        [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].h_filter]] forState:UIControlStateNormal] ;
        [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }
    
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.INS_CH[input_channel_sel].l_level == 0){
            [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            
        }else{
            [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].l_filter]] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
    }else{
        [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.INS_CH[input_channel_sel].l_filter]] forState:UIControlStateNormal] ;
        [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }
}

#pragma 弹出选择 Filter

- (void)showFilterOptDialog{
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetFilter:0];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:1];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterBW"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:2];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetFilter:(int)val{
    if(Bool_HL){
        RecStructData.INS_CH[input_channel_sel].h_filter = val;
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.INS_CH[input_channel_sel].h_level == 0){
                [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
                
            }else{
                [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
                [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
            }
        }else{
            [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
        [self flashLinkSyncData:UI_INS_HFilter];
    }else{
        RecStructData.INS_CH[input_channel_sel].l_filter = val;
        
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.INS_CH[input_channel_sel].l_level == 0){
                [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            }else{
                [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
                [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
            }
        }else{
            [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
        [self flashLinkSyncData:UI_INS_LFilter];
    }
    
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}
#pragma 弹出选择 Level
- (void)showLevelOptDialog{
    
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc6dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:0];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:1];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc18dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:2];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc24dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:3];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc30dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:4];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc36dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:5];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc42dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:6];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc48dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:7];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_OtcOFF"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetLevel:8];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [B_Buf setNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetLevel:(int)val{
    if(Bool_HL){
        RecStructData.INS_CH[input_channel_sel].h_level = val;
        [self.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.INS_CH[input_channel_sel].h_filter];
        
        [self flashLinkSyncData:UI_INS_HOct];
    }else{
        RecStructData.INS_CH[input_channel_sel].l_level = val;
        [self.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.INS_CH[input_channel_sel].l_filter];
        
        [self flashLinkSyncData:UI_INS_LOct];
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}
#pragma 弹出选择 Freq

-(void)showFreqDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(0, 0, 280, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetFreq"];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelTitle];
    
    _btnFreqMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnFreqMinus.frame = CGRectMake(10, 100, 30, 30);
    _btnFreqMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnFreqMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnFreqMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [_btnFreqMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    _btnFreqMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnFreqMinus addTarget:self action:@selector(DialogFreqSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnFreqMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderFreq = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderFreq.dataSource = weakSelf;
    _sliderFreq.minimumValue = 0;
    _sliderFreq.maximumValue = 240;
    if(Bool_HL){
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].h_freq]];
    }else{
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].l_freq]];
    }
    
    [_sliderFreq addTarget:self action:@selector(SBDialogFreqSet) forControlEvents:UIControlEventValueChanged];
    
    /*
     UIImage *stetchTrack1 = [UIImage imageNamed:@"skslider1.png"];
     UIImage *stetchTrack2 = [[UIImage imageNamed:@"skslider2.png"]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
     [_slider setThumbImage: [UIImage imageNamed:@"skbit1.png"] forState:UIControlStateNormal];
     [_slider setMinimumTrackImage:stetchTrack2 forState:UIControlStateNormal];
     [_slider setMaximumTrackImage:stetchTrack1 forState:UIControlStateNormal];
     */
    [contentView addSubview:_sliderFreq];
    
    
    
    _btnFreqAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnFreqAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnFreqAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnFreqAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [_btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    _btnFreqAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnFreqAdd addTarget:self action:@selector(DialogFreqSet_Inc) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnFreqAdd];
    //长按
    UILongPressGestureRecognizer *longPressFreqVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_FreqVolumeSUB_LongPress:)];
    longPressFreqVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [_btnFreqMinus addGestureRecognizer:longPressFreqVolMinus];
    
    UILongPressGestureRecognizer *longPressFreqVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_FreqVolumeAdd_LongPress:)];
    longPressFreqVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [_btnFreqAdd addGestureRecognizer:longPressFreqVolAdd];
    
    
    
    
    
    NormalButton *btnOK = [NormalButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.frame = CGRectMake(110, 100, 60, 25);
    [btnOK initView:3 withBorderWidth:1 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
    [btnOK setTitleColor:SetColor(0xffffffff) forState:UIControlStateNormal];
    //[btnOK setTitleColor:SetColor(UI_SystemBtnColorNormal) forState:UIControlStateNormal];//常态
    [btnOK setTitleColor:SetColor(UI_SystemBtnColorPress) forState:UIControlStateHighlighted];//选中
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_PressStatus:) forControlEvents:UIControlEventTouchDown];
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_NormalStatus:) forControlEvents:UIControlEventTouchDragOutside];
    [btnOK setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    btnOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnOK addTarget:self action:@selector(dialogExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)dialogExit{
    [B_Buf setNormal];
}

- (void)KxMenutapCloseAction:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [B_Buf setNormal];
    });
}
- (void)SBDialogFreqSet{
    int sliderValue = (int)(_sliderFreq.value);
    _sliderFreq.showValue=[NSString stringWithFormat:@"%dHz",(int)FREQ241[sliderValue]];
    if(Bool_HL){
        RecStructData.INS_CH[input_channel_sel].h_freq = FREQ241[sliderValue];
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].h_freq =
            RecStructData.INS_CH[input_channel_sel].l_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].h_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].h_freq = 1000;
//                }
//            }
//        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].h_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq]];
        
        
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_HFreq];
    }else{
        RecStructData.INS_CH[input_channel_sel].l_freq = FREQ241[sliderValue];
        
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].l_freq =
            RecStructData.INS_CH[input_channel_sel].h_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].l_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].l_freq = 1000;
//                }
//            }
//        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].l_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq]];
        
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_LFreq];
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}

- (void)DialogFreqSet_Sub{
    if(Bool_HL){
        if(--RecStructData.INS_CH[input_channel_sel].h_freq < 20){
            RecStructData.INS_CH[input_channel_sel].h_freq = 20;
        }
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].h_freq =
            RecStructData.INS_CH[input_channel_sel].l_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].h_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].h_freq = 1000;
//                }
//            }
//        }
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].h_freq]];
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_HFreq];
    }else{
        if(--RecStructData.INS_CH[input_channel_sel].l_freq < 20){
            RecStructData.INS_CH[input_channel_sel].l_freq = 20;
        }
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].l_freq =
            RecStructData.INS_CH[input_channel_sel].h_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].l_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].l_freq = 1000;
//                }
//            }
//        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].l_freq]];
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_LFreq];
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}
- (void)DialogFreqSet_Inc{
    if(Bool_HL){
        if(++RecStructData.INS_CH[input_channel_sel].h_freq > 20000){
            RecStructData.INS_CH[input_channel_sel].h_freq = 20000;
        }
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].h_freq =
            RecStructData.INS_CH[input_channel_sel].l_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].h_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].h_freq = 1000;
//                }
//            }
//        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].h_freq]];
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_HFreq];
    }else{
        if(++RecStructData.INS_CH[input_channel_sel].l_freq > 20000){
            RecStructData.INS_CH[input_channel_sel].l_freq = 20000;
        }
        
        if(RecStructData.INS_CH[input_channel_sel].h_freq >
           RecStructData.INS_CH[input_channel_sel].l_freq){
            
            RecStructData.INS_CH[input_channel_sel].l_freq =
            RecStructData.INS_CH[input_channel_sel].h_freq;
        }
//        if(BOOL_SET_SpkType){
//            int fr=[self getChannelNum:output_channel_sel];
//            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
//                if(RecStructData.INS_CH[input_channel_sel].l_freq <1000){
//                    RecStructData.INS_CH[input_channel_sel].l_freq = 1000;
//                }
//            }
//        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.INS_CH[input_channel_sel].l_freq]];
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_INS_LFreq];
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}
//长按操作
-(void)Btn_FreqVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolFreqMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Sub) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolFreqMinusTimer.isValid){
            [_pVolFreqMinusTimer invalidate];
            _pVolFreqMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_FreqVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolFreqAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolFreqAddTimer.isValid){
            [_pVolFreqAddTimer invalidate];
            _pVolFreqAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}



#pragma EQ
- (void)initEQView{
    //EQ 曲线图
    self.EQV_INS = [[EQView alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:UI_StartWithTopBar+20], KScreenWidth, [Dimens GDimens:EQViewHeight])];
    [self.view addSubview:self.EQV_INS];
    [self.EQV_INS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.Btn_InputSource.mas_bottom).offset([Dimens GDimens:5]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:EQViewHeight]));
    }];
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[0]];
    
    //EQ提示边
    self.EQindex = [[EQIndex alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight])];
    [self.view addSubview:self.EQindex];
    [self.EQindex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.EQV_INS.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight]));
    }];
    
    //初始化scrollview
    [self initSVEQ];
    
    
    //EQ功能按键
    self.Btn_EQReset = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQReset];
    [self.Btn_EQReset initView:3 withBorderWidth:1 withNormalColor:UI_EQSet_Btn_Normal withPressColor:UI_EQSet_Btn_Press withType:1];
    [self.Btn_EQReset setTextColorWithNormalColor:UI_EQSet_BtnText_Normal withPressColor:UI_EQSet_BtnText_Press];
    self.Btn_EQReset.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQReset addTarget:self action:@selector(Btn_EQReset_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQReset setTitle:[LANG DPLocalizedString:@"L_EQ_ResetEQ"] forState:UIControlStateNormal] ;
    [self.Btn_EQReset setNormal];
    [self.Btn_EQReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SVEQ.mas_bottom).offset([Dimens GDimens:20]);
        make.leftMargin.mas_equalTo([Dimens GDimens:EQBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
    }];
    //直通与恢复
    self.Btn_EQByPass = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQByPass];
    [self.Btn_EQByPass initView:3 withBorderWidth:1 withNormalColor:UI_EQSet_Btn_Normal withPressColor:UI_EQSet_Btn_Press withType:1];
    [self.Btn_EQByPass setTextColorWithNormalColor:UI_EQSet_BtnText_Normal withPressColor:UI_EQSet_BtnText_Press];
    self.Btn_EQByPass.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQByPass addTarget:self action:@selector(Btn_EQByPass_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Bypass"] forState:UIControlStateNormal] ;
    [self.Btn_EQByPass setNormal];
    [self.Btn_EQByPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SVEQ.mas_bottom).offset([Dimens GDimens:20]);
        make.rightMargin.mas_equalTo([Dimens GDimens:-EQBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
//        make.top.equalTo(self.SVEQ.mas_bottom).offset([Dimens GDimens:20]);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
    }];
    //PG_MD
    self.Btn_EQPG_MD = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQPG_MD];
    [self.Btn_EQPG_MD initView:3 withBorderWidth:1 withNormalColor:UI_EQSet_Btn_Normal withPressColor:UI_EQSet_Btn_Press withType:1];
    [self.Btn_EQPG_MD setTextColorWithNormalColor:UI_EQSet_BtnText_Normal withPressColor:UI_EQSet_BtnText_Press];
    self.Btn_EQPG_MD.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQPG_MD addTarget:self action:@selector(Btn_PGEQMode_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    [self.Btn_EQPG_MD setNormal];
    [self.Btn_EQPG_MD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SVEQ.mas_bottom).offset([Dimens GDimens:20]);
        make.rightMargin.mas_equalTo([Dimens GDimens:-EQBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
    }];
    //if(!EnableGPEQ){
        self.Btn_EQPG_MD.hidden = true;
    //}
    
    if(RecStructData.INS_CH[input_channel_sel].eq_mode == 0){
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }
    
    [self checkByPass];
    
}


#pragma 滑动事件
- (void) initSVEQ{
    eqIndex = 0;
    self.SVEQ = [[UIScrollView alloc]init];
    [self.view addSubview:self.SVEQ];
    [self.SVEQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.EQindex.mas_right).offset(0);
        make.centerY.mas_equalTo(self.EQindex.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight]));
    }];
    self.SVEQ.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.SVEQ.delegate = self;
    // 设置内容大小
    //禁止UIScrollView垂直方向滚动，只允许水平方向滚动
    //scrollview.contentSize =  CGSizeMake(你要的长度, 0);
    //禁止UIScrollView水平方向滚动，只允许垂直方向滚动
    //scrollview.contentSize =  CGSizeMake(0, 你要的宽度);
    self.SVEQ.contentSize = CGSizeMake([Dimens GDimens:EQItemWidth]*INS_CH_EQ_MAX_USE, 0);
    // 是否反弹
    self.SVEQ.bounces = NO;
    // 是否分页
    //self.SVEQ.pagingEnabled = YES;
    // 是否滚动
    //self.SVEQ.scrollEnabled = NO;
    //self.SVEQ.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    // self.SVEQ.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //self.SVEQ.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //self.SVEQ.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [self.SVEQ flashScrollIndicators];
    // 是否同时运动,lock
    self.SVEQ.directionalLockEnabled = NO;
    
    
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        EQItem *eqitem = [[EQItem alloc]initWithFrame:CGRectMake([Dimens GDimens:EQItemWidth]*i, 0, [Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight])];
        [eqitem setTag:i];
        
        [self.SVEQ addSubview:eqitem];
        
        eqitem.Lab_ID.text = [NSString stringWithFormat:@"%d",i+1];
        ///
        [eqitem.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[i].level] forState:UIControlStateNormal] ;
        [eqitem.Btn_Gain addTarget:self action:@selector(EQ_Btn_Gain_Click:) forControlEvents:UIControlEventTouchUpInside];
        ///
        [eqitem.Btn_BW setTitle:[self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
        [eqitem.Btn_BW addTarget:self action:@selector(EQ_Btn_BW_Click:) forControlEvents:UIControlEventTouchUpInside];
        ///
        [eqitem.Btn_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
        [eqitem.Btn_Freq addTarget:self action:@selector(EQ_Btn_Freq_Click:) forControlEvents:UIControlEventTouchUpInside];
        //
        eqitem.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[i].level - EQ_LEVEL_MIN;
        [eqitem.SB_Gain addTarget:self action:@selector(EQ_SB_Gain_ValueChanged:) forControlEvents:UIControlEventValueChanged];
        //
        [eqitem.Btn_Reset addTarget:self action:@selector(EQ_Btn_Reset_Click:) forControlEvents:UIControlEventTouchUpInside];
        
        [eqitem setEQItemTag:i];
    }
    
}

- (void)EQ_Btn_Gain_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.INS_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    //NSLog(@"EQ_Btn_Gain_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Gain;
    EQ_MODE = 1;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_BW_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.INS_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    //NSLog(@"EQ_Btn_BW_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_BW;
    EQ_MODE = 2;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_Freq_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.INS_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    
    //NSLog(@"EQ_Btn_Freq_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Freq;
    EQ_MODE = 3;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_Reset_Click:(UIButton*)sender{
    //NSLog(@"EQ_Btn_Reset_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Reset;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    
    
    if((RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level == EQ_LEVEL_ZERO)
       &&(BufStructData.INS_CH[input_channel_sel].EQ[eqIndex].level != EQ_LEVEL_ZERO)){
        RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level =
        BufStructData.INS_CH[input_channel_sel].EQ[eqIndex].level;
        
        BufStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
        [_CurEQItem.Btn_Reset setImage:[UIImage imageNamed:@"eq_resetg_press"] forState:UIControlStateNormal];
    }else if((RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level != EQ_LEVEL_ZERO)){
        BufStructData.INS_CH[input_channel_sel].EQ[eqIndex].level =
        RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level;
        
        RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
        [_CurEQItem.Btn_Reset setImage:[UIImage imageNamed:@"eq_resetg_normal"] forState:UIControlStateNormal];
    }
    
    _CurEQItem.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level-EQ_LEVEL_MIN;
    [_CurEQItem.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level] forState:UIControlStateNormal] ;
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
    
    [self flashLinkSyncData:UI_INS_EQ_ALL];
}
- (void)EQ_SB_Gain_ValueChanged:(UISlider*)sender{
    //NSLog(@"EQ_SB_Gain_ValueChanged id=%d",(int)sender.tag);
    //NSLog(@"EQ_SB_Gain_ValueChanged value=%d",(uint16)sender.value);
    eqIndex = (int)sender.tag-TagStartEQItem_SB_Gain;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = (uint16)sender.value + EQ_LEVEL_MIN;
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
    BufStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
    [_CurEQItem.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level] forState:UIControlStateNormal] ;
    
    [self checkCurResetBtnState];
    [self flashLinkSyncData:UI_INS_EQ_Level];
}
- (NSString*)ChangeGainValume:(int) num{
    num -= EQ_LEVEL_MIN;
    return [NSString stringWithFormat:@"%.1fdB",0.0-(EQ_Gain_MAX/2-num)/10.0];
}
//获取Equalizer 的EQ的Q值数据显示
- (NSString*) ChangeBWValume:(int) num{
    if(num>EQ_BW_MAX){
        num=EQ_BW_MAX;
    }
    return [NSString stringWithFormat:@"%.3f",EQ_BW296[num]];
}

#pragma mark -
/*
 // 返回一个放大或者缩小的视图
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
 
 }
 // 开始放大或者缩小
 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:
 (UIView *)view
 {
 
 }
 
 // 缩放结束时
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
 
 }
 
 // 视图已经放大或缩小
 - (void)scrollViewDidZoom:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidScrollToTop");
 }
 */

// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScrollToTop");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating");
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
}
#pragma 响应事件

//EQ功能按键-重置EQ
- (void)Btn_EQReset_click:(NormalButton*)sender {
    [self.Btn_EQReset setPress];
    [self showEQResetDialog];
}

//EQ功能按键-直通与恢复EQ
- (void)Btn_EQByPass_click:(NormalButton*)sender {
    [self.Btn_EQByPass setPress];
    [self showEQByPassDialog];
}

- (void)Btn_PGEQMode_click:(NormalButton*)sender {
    if(RecStructData.INS_CH[input_channel_sel].eq_mode == 0){
        RecStructData.INS_CH[input_channel_sel].eq_mode = 1;
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        RecStructData.INS_CH[input_channel_sel].eq_mode = 0;
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }
    for(int j=0;j<INS_CH_EQ_MAX_USE;j++){
        RecStructData.INS_CH[input_channel_sel].EQ[j].bw = DefaultStructData.INS_CH[input_channel_sel].EQ[j].bw;
        RecStructData.INS_CH[input_channel_sel].EQ[j].freq = DefaultStructData.INS_CH[input_channel_sel].EQ[j].freq;
        RecStructData.INS_CH[input_channel_sel].EQ[j].level = DefaultStructData.INS_CH[input_channel_sel].EQ[j].level;
        RecStructData.INS_CH[input_channel_sel].EQ[j].shf_db= DefaultStructData.INS_CH[input_channel_sel].EQ[j].shf_db;
        RecStructData.INS_CH[input_channel_sel].EQ[j].type = DefaultStructData.INS_CH[input_channel_sel].EQ[j].type;
    }
    [self flashLinkSyncData:UI_INS_EQ_G_P_MODE_EQ];
    [self FlashPageUI];
}

#pragma 功能函数
- (void)setEQItemSelColorClean{
    EQItem *find_btn;
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
        if(RecStructData.INS_CH[input_channel_sel].eq_mode == 0){
            [find_btn setStateColor:EQItemNoramlColor];
        }else{
            [find_btn setStateColor:EQItemNoramlLockColor];
        }
    }
    [self flashLinkSyncData:UI_INS_EQ_ALL];
}
- (void)setEQItemSelColor{
    
    [self setEQItemSelColorClean];
    if(RecStructData.INS_CH[input_channel_sel].eq_mode == 0){
        [_CurEQItem setStateColor:EQItemPressColor];
    }else{
        [_CurEQItem setStateColor:EQItemLockedlColor];
    }
    
    
}

- (BOOL)getByPass{
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        if(RecStructData.INS_CH[input_channel_sel].EQ[i].level != EQ_LEVEL_ZERO){
            return false;
        }
    }
    return true;
}


- (void)checkByPass{
    
    bool_ByPass = [self getByPass];
    if(bool_ByPass){
        [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Restore"] forState:UIControlStateNormal] ;
        [self.Btn_EQByPass setNormal];
    }else{
        [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Bypass"] forState:UIControlStateNormal] ;
        [self.Btn_EQByPass setPress];
    }
}
- (void)checkCurResetBtnState{
    if(RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level == EQ_LEVEL_ZERO){
        [_CurEQItem.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [_CurEQItem.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    [self checkByPass];
}

- (void)setEQByPass{
    if(bool_ByPass){
        for(int j=0;j<INS_CH_EQ_MAX_USE;j++){
            RecStructData.INS_CH[input_channel_sel].EQ[j].level =
            RecStructData.OUT_CH_BUF[input_channel_sel].EQ[j].level;
        }
        
    }else{
        for(int j=0;j<INS_CH_EQ_MAX_USE;j++){
            RecStructData.OUT_CH_BUF[input_channel_sel].EQ[j].level =
            RecStructData.INS_CH[input_channel_sel].EQ[j].level;
            RecStructData.INS_CH[input_channel_sel].EQ[j].level = EQ_LEVEL_ZERO;
        }
    }
    [self flashLinkSyncData:UI_INS_EQ_Level];
    [self FlashPageUI];
}
#pragma 弹出对话框
- (void)showEQResetDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_EQ_ResetEQ"]message:[LANG DPLocalizedString:@"L_EQ_ResetEQ_Msg"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Btn_EQReset setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
            RecStructData.INS_CH[input_channel_sel].EQ[i].bw     = DefaultStructData.INS_CH[input_channel_sel].EQ[i].bw;
            RecStructData.INS_CH[input_channel_sel].EQ[i].freq   = DefaultStructData.INS_CH[input_channel_sel].EQ[i].freq;
            RecStructData.INS_CH[input_channel_sel].EQ[i].level  = DefaultStructData.INS_CH[input_channel_sel].EQ[i].level;
            RecStructData.INS_CH[input_channel_sel].EQ[i].shf_db = DefaultStructData.INS_CH[input_channel_sel].EQ[i].shf_db;
            RecStructData.INS_CH[input_channel_sel].EQ[i].type   = DefaultStructData.INS_CH[input_channel_sel].EQ[i].type;
        }
        //EQ复位用
        for(int j=0;j<INS_CH_EQ_MAX_USE;j++){
            BufStructData.INS_CH[input_channel_sel].EQ[j].level = EQ_LEVEL_ZERO;
        }
        [self flashLinkSyncData:UI_INS_EQ_ALL];
        [self FlashPageUI];
        [self.Btn_EQReset setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showEQByPassDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_EQ_Bypass"]message:[LANG DPLocalizedString:@"L_EQ_ByPass_Msg"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Btn_EQByPass setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [self.Btn_EQByPass setNormal];
        [self setEQByPass];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma 弹出选择 EQ
- (int)getFreqIndexFromArray:(int)freq{
    int i=0;
    for(i=0;i<240;i++){
        if((freq >= FREQ241[i])&&(freq <= FREQ241[i+1])){
            break;
        }
    }
    return i;
}
-(void)showEQDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(0, 0, 280, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_Delay_SetOutputDelay"];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelTitle];
    
    _btnEQMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnEQMinus.frame = CGRectMake(10, 100, 30, 30);
    _btnEQMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnEQMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnEQMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [_btnEQMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    _btnEQMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnEQMinus addTarget:self action:@selector(DialogEQSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnEQMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderEQ = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderEQ.dataSource = weakSelf;
    
    
    switch (EQ_MODE) {
        case 1:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetGain"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = EQ_Gain_MAX;
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level];
            [_sliderEQ setValue:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level- IN_EQ_LEVEL_MIN];
            break;
        case 2:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetEQ"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = EQ_BW_MAX;
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw];
            [_sliderEQ setValue:EQ_BW_MAX - RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw];
            break;
        case 3:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetFreq"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = 240;
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq];
            [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq]];
            break;
        default:
            break;
    }
    
    
    
    [_sliderEQ addTarget:self action:@selector(SBDialogEQSet) forControlEvents:UIControlEventValueChanged];
    
    /*
     UIImage *stetchTrack1 = [UIImage imageNamed:@"skslider1.png"];
     UIImage *stetchTrack2 = [[UIImage imageNamed:@"skslider2.png"]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
     [_slider setThumbImage: [UIImage imageNamed:@"skbit1.png"] forState:UIControlStateNormal];
     [_slider setMinimumTrackImage:stetchTrack2 forState:UIControlStateNormal];
     [_slider setMaximumTrackImage:stetchTrack1 forState:UIControlStateNormal];
     */
    [contentView addSubview:_sliderEQ];
    
    
    
    _btnEQAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnEQAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnEQAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnEQAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnEQAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnEQAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [_btnEQAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    _btnEQAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnEQAdd addTarget:self action:@selector(DialogEQSet_Inc) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnEQAdd];
    //长按
    UILongPressGestureRecognizer *longPressEQVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_EQVolumeSUB_LongPress:)];
    longPressEQVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [_btnEQMinus addGestureRecognizer:longPressEQVolMinus];
    
    UILongPressGestureRecognizer *longPressEQVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_EQVolumeAdd_LongPress:)];
    longPressEQVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [_btnEQAdd addGestureRecognizer:longPressEQVolAdd];
    
    
    
    
    
    NormalButton *btnOK = [NormalButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.frame = CGRectMake(110, 100, 60, 25);
    [btnOK initView:3 withBorderWidth:1 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
    [btnOK setTitleColor:SetColor(0xffffffff) forState:UIControlStateNormal];
    //[btnOK setTitleColor:SetColor(UI_SystemBtnColorNormal) forState:UIControlStateNormal];//常态
    [btnOK setTitleColor:SetColor(UI_SystemBtnColorPress) forState:UIControlStateHighlighted];//选中
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_PressStatus:) forControlEvents:UIControlEventTouchDown];
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_NormalStatus:) forControlEvents:UIControlEventTouchDragOutside];
    [btnOK setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    btnOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[btnOK addTarget:self action:@selector(gainExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)SBDialogEQSet{
    
    int sliderValue = (int)(_sliderEQ.value);
    switch (EQ_MODE) {
        case 1:
        {
            RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level=EQ_LEVEL_MIN+sliderValue;
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level];
            
            [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
            _CurEQItem.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [self checkCurResetBtnState];
            [self flashLinkSyncData:UI_INS_EQ_Level];
        }
            break;
        case 2:
        {
            sliderValue = EQ_BW_MAX - sliderValue;
            RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw=sliderValue;
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw];
            
            [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            [self flashLinkSyncData:UI_INS_EQ_BW];
        }
            break;
        case 3:
        {
            RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq= FREQ241[sliderValue];
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq];
            
            [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            [self flashLinkSyncData:UI_INS_EQ_Freq];
        }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}

- (void)DialogEQSet_Sub{
    switch (EQ_MODE) {
        case 1:
            {
                if(--RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level < IN_EQ_LEVEL_MIN){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = IN_EQ_LEVEL_MIN;
                }
                _sliderEQ.showValue = [self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level];
                _sliderEQ.value=RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
                
                [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
                _CurEQItem.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
                
                [self checkCurResetBtnState];
                [self flashLinkSyncData:UI_INS_EQ_Level];
            }
            break;
        case 2:
            {
                if(++RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw > EQ_BW_MAX){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw = EQ_BW_MAX;
                }
                _sliderEQ.showValue = [self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw];
                _sliderEQ.value=EQ_BW_MAX - RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw;
                
                [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
                [self flashLinkSyncData:UI_INS_EQ_BW];
            }
            break;
        case 3:
            {
                if(--RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq < 20){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq = 20;
                }
                _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq];
                [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq]];
                
                [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
                [self flashLinkSyncData:UI_INS_EQ_Freq];
            }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}
- (void)DialogEQSet_Inc{
    switch (EQ_MODE) {
        case 1:
            {
                if(++RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level > IN_EQ_LEVEL_MAX){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level = IN_EQ_LEVEL_MAX;
                }
                _sliderEQ.showValue = [self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level];
                _sliderEQ.value=RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
                
                [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
                _CurEQItem.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
                
                [self checkCurResetBtnState];
                [self flashLinkSyncData:UI_INS_EQ_Level];
            }
            break;
        case 2:
            {
                if(--RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw < 0){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw = 0;
                }
                _sliderEQ.showValue = [self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw];
                _sliderEQ.value=EQ_BW_MAX - RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].bw;
                
                [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
                [self flashLinkSyncData:UI_INS_EQ_BW];
            }
            
            break;
        case 3:
            {
                if(++RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq > 20000){
                    RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq = 20000;
                }
                _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq];
                [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.INS_CH[input_channel_sel].EQ[eqIndex].freq]];
                
                [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
                [self flashLinkSyncData:UI_INS_EQ_Freq];
            }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
}

//长按操作
-(void)Btn_EQVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolEQMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogEQSet_Sub) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolEQMinusTimer.isValid){
            [_pVolEQMinusTimer invalidate];
            _pVolEQMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_EQVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolEQAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogEQSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolEQAddTimer.isValid){
            [_pVolEQAddTimer invalidate];
            _pVolEQAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}
- (void)flashLinkSyncData:(int)ui{
//    if(BOOL_SET_SpkType){
//        
//        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
//            return;
//        }
//        flashLinkSyncData(ui);
//        
//    }
    
    if(BOOL_INS_LINKFlag){
        syncLinkData(ui);
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
    //NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
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
//检查可设置联调的通道
- (void) CheckChannelCanLink{
    int channelNameNum=0;
    int channelNameNumEls=0;
    int res=0;
    int inc=0;
    int i=0,j=0;
    ChannelLinkCnt = 0;
    for(i=0;i<16;i++){
        for(j=0;j<2;j++){
            ChannelLinkBuf[i][j]=EndFlag;
        }
    }
    for(i=0;i<Output_CH_MAX_USE;i++){
        channelNameNum=[self GetChannelNum:i];
        //NSLog(@"channelNameNum=%d",channelNameNum);
        if(channelNameNum>=0){
            for(j=i+1;j<Output_CH_MAX_USE;j++){
                channelNameNumEls=[self GetChannelNum:j];
                //NSLog(@"channelNameNumEls=%d",channelNameNumEls);
                if((channelNameNum>=1)&&(channelNameNum<=6)&&
                   (channelNameNumEls>=7)&&(channelNameNumEls<=12)){
                    res=channelNameNumEls-channelNameNum;
                    if(res==6){
                        ChannelLinkBuf[inc][0]=i;
                        ChannelLinkBuf[inc][1]=j;
                        ++inc;
                        //NSLog(@"#1 inc=%d",inc);
                    }
                }else if((channelNameNum>=7)&&(channelNameNum<=12)&&
                         (channelNameNumEls>=1)&&(channelNameNumEls<=6)){
                    res=channelNameNum-channelNameNumEls;
                    if(res==6){
                        ChannelLinkBuf[inc][0]=j;
                        ChannelLinkBuf[inc][1]=i;
                        ++inc;
                        //NSLog(@"#2 inc=%d",inc);
                    }
                }else if((channelNameNum>=13)&&(channelNameNum<=15)&&
                         (channelNameNumEls>=16)&&(channelNameNumEls<=18)){
                    res=channelNameNumEls-channelNameNum;
                    if(res==3){
                        ChannelLinkBuf[inc][0]=i;
                        ChannelLinkBuf[inc][1]=j;
                        ++inc;
                        //NSLog(@"#3 inc=%d",inc);
                    }
                }else if((channelNameNum>=16)&&(channelNameNum<=18)&&
                         (channelNameNumEls>=13)&&(channelNameNumEls<=15)){
                    res=channelNameNum-channelNameNumEls;
                    if(res==3){
                        ChannelLinkBuf[inc][0]=j;
                        ChannelLinkBuf[inc][1]=i;
                        ++inc;
                        //NSLog(@"#4 inc=%d",inc);
                    }
                }else if((channelNameNum==22)&&(channelNameNumEls==23)){
                    ChannelLinkBuf[inc][0]=i;
                    ChannelLinkBuf[inc][1]=j;
                    ++inc;
                    //NSLog(@"#5 inc=%d",inc);
                }else if((channelNameNum==23)&&(channelNameNumEls==22)){
                    ChannelLinkBuf[inc][0]=j;
                    ChannelLinkBuf[inc][1]=i;
                    ++inc;
                    //NSLog(@"#6 inc=%d",inc);
                }
            }
        }
    }
    //NSLog(@"inc=%d",inc);
    ChannelLinkCnt = inc;
}
- (int) GetChannelNum:(int)channel{
    //更新列表
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]  = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]  = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
    
    for(int i=0;i<16;i++){
        if(ChannelNumBuf[i]<0){
            ChannelNumBuf[i]=0;
        }
        if(ChannelNumBuf[i]>25){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
}
#pragma 广播通知
- (void)FlashEQXover{
    EQItem *find_btn;
    [self.EQV_INS SetINSEQData:RecStructData.INS_CH[input_channel_sel]];
    [self setEQItemSelColorClean];
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        
        
        
        find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
        //        if(output_channel_sel >=4){
        //            if(i>=8){
        //                find_btn.hidden = true;
        //            }
        //
        //        }else{
        //            if(i>=8){
        //                find_btn.hidden = false;
        //            }
        //
        //        }
        
        
        [find_btn.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.INS_CH[input_channel_sel].EQ[i].level] forState:UIControlStateNormal] ;
        find_btn.SB_Gain.value = RecStructData.INS_CH[input_channel_sel].EQ[i].level - IN_EQ_LEVEL_MIN;
        [find_btn.Btn_BW setTitle:[self ChangeBWValume:RecStructData.INS_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
        [find_btn.Btn_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.INS_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
        
        if(RecStructData.INS_CH[input_channel_sel].EQ[i].level == EQ_LEVEL_ZERO){
            [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    [self checkByPass];
    if(RecStructData.INS_CH[input_channel_sel].eq_mode == 0){
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        self.Encrypt.hidden = false;
        
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
        [self.EQV_INS SetINSEQData:DefaultStructData.INS_CH[input_channel_sel]];
        for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
            find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
            
            [find_btn.Btn_Gain setTitle:[self ChangeGainValume:DefaultStructData.INS_CH[input_channel_sel].EQ[i].level] forState:UIControlStateNormal] ;
            find_btn.SB_Gain.value = DefaultStructData.INS_CH[input_channel_sel].EQ[i].level - IN_EQ_LEVEL_MIN;
            [find_btn.Btn_BW setTitle:[self ChangeBWValume:DefaultStructData.INS_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
            [find_btn.Btn_Freq setTitle:[NSString stringWithFormat:@"%dHz",DefaultStructData.INS_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
            
            if(DefaultStructData.INS_CH[input_channel_sel].EQ[i].level == EQ_LEVEL_ZERO){
                [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else{
                [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
        }
        
    }else{
        self.Encrypt.hidden = true;
    }
}
- (void)FlashPageUI{

    [self flashInputChannel];
    [self FlashInputSource];
    [self FlashEQXover];
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];

    });
}


@end

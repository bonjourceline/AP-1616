//
//  XOverViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "XOverViewController.h"


@interface XOverViewController ()

@end

@implementation XOverViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Xover;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KxMenutapCloseAction:)
                                                 name:KGModalDidHideNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    LinkChannel=0;
    OldLinkChannel=1;
    [self initList];
    [self initView];
    [self initEncrypt];
    [self FlashXOverPageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma initView
- (void)initList{
    
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
//    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc36dB"]];
//    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc42dB"]];
//    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc48dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_OtcOFF"]];
    
    for(int i=0;i<16;i++){
        Level_Val[i]=i;
    }
    Level_Val[5]=7;
    

    if(RecStructData.OUT_CH[output_channel_sel].h_filter > 3 || RecStructData.OUT_CH[output_channel_sel].h_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].h_filter = 0;
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_filter > 3 || RecStructData.OUT_CH[output_channel_sel].l_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].l_filter = 0;
    }
    
//    if(RecStructData.OUT_CH[output_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].h_level < 0){
//        RecStructData.OUT_CH[output_channel_sel].h_level = 0;
//    }
//    if(RecStructData.OUT_CH[output_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].l_level < 0){
//        RecStructData.OUT_CH[output_channel_sel].l_level = 0;
//    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_freq > 20000 || RecStructData.OUT_CH[output_channel_sel].h_freq < 20){
        RecStructData.OUT_CH[output_channel_sel].h_freq = 20;
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_freq > 20000 || RecStructData.OUT_CH[output_channel_sel].l_freq < 20){
        RecStructData.OUT_CH[output_channel_sel].l_freq = 20000;
    }

}

- (void)initView{
    float height  = (KScreenHeight -[Dimens GDimens:UI_StartWithTopBar+50])/(Output_CH_MAX_USE/2);
    
    for (int i = 0; i<Output_CH_MAX; i++) {
        NSInteger x = i % (2);
        NSInteger y = i / (2);
        
        float Start_X = KScreenWidth/2*x;
        float Start_Y = height*y+[Dimens GDimens:UI_StartWithTopBar+10];
//        if(i>2){
//            Start_Y = height*y+[Dimens GDimens:UI_StartWithTopBar];
//        }
        XOverItem *mXOverItem = [[XOverItem alloc]init];
        mXOverItem.frame = CGRectMake(Start_X, Start_Y, KScreenWidth/2, height);
        [self.view addSubview:mXOverItem];
        [mXOverItem setTag:i];
        [mXOverItem setXOverItemTag:i];
        
        //ChannelID
        if(BOOL_SET_SpkType){
            [mXOverItem.Btn_Channel setTitle:[NSString stringWithFormat:@"CH%d",i+1] forState:UIControlStateNormal];
        }else{
            switch (i) {
                case 0:
                    [mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
                    break;
                case 1:[mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontRight"] forState:UIControlStateNormal] ;
                    break;
                case 2:[mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearLeft"] forState:UIControlStateNormal] ;
                    break;
                case 3:[mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearRight"] forState:UIControlStateNormal] ;
                    break;
                case 4:[mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_LeftSub"] forState:UIControlStateNormal] ;
                    break;
                case 5:[mXOverItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RightSub"] forState:UIControlStateNormal] ;
                    break;
                default:
                    break;
            }
        }
        
        

        //高通
        [mXOverItem.H_Filter addTarget:self action:@selector(H_Filter_Click:)forControlEvents:UIControlEventTouchUpInside];
        [mXOverItem.H_Level addTarget:self action:@selector(H_Level_Click:)forControlEvents:UIControlEventTouchUpInside];
        [mXOverItem.H_Freq addTarget:self action:@selector(H_Freq_Click:)forControlEvents:UIControlEventTouchUpInside];
        
        //低通
        [mXOverItem.L_Filter addTarget:self action:@selector(L_Filter_Click:)forControlEvents:UIControlEventTouchUpInside];
        [mXOverItem.L_Level addTarget:self action:@selector(L_Level_Click:)forControlEvents:UIControlEventTouchUpInside];
        [mXOverItem.L_Freq addTarget:self action:@selector(L_Freq_Click:)forControlEvents:UIControlEventTouchUpInside];
        //滤波器
        [mXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].h_filter]]  forState:UIControlStateNormal];
        [mXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].l_filter]]  forState:UIControlStateNormal];
        //斜率
        [mXOverItem.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[i].h_level]]  forState:UIControlStateNormal];
        [mXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[i].l_level]]  forState:UIControlStateNormal];
        //频率
        [mXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[i].h_freq] forState:UIControlStateNormal];
        [mXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[i].l_freq] forState:UIControlStateNormal];
        
        
    }
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
}

#pragma 点击事件

- (void)H_Filter_Click:(UIButton*)sender{
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].h_level == 0){
            return;
        }
    }
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_H_Filter;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = true;
    [self showFilterOptDialog];
}
- (void)H_Level_Click:(UIButton*)sender{
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_H_Level;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = true;
    [self showLevelOptDialog];
    
}

- (void)H_Freq_Click:(UIButton*)sender{
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_H_Freq;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = true;
    [self showFreqDialog];
}
/////
- (void)L_Filter_Click:(UIButton*)sender{
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].l_level == 0){
            return;
        }
    }
    
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_L_Filter;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = false;
    [self showFilterOptDialog];
}
- (void)L_Level_Click:(UIButton*)sender{
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_L_Level;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = false;
    [self showLevelOptDialog];

}

- (void)L_Freq_Click:(UIButton*)sender{
    [sender setTitleColor:SetColor(UI_XOver_BtnText_Press) forState:UIControlStateNormal];
    B_Buf = sender;
    output_channel_sel = (int)sender.tag - TagStart_XOVER_L_Freq;
    _CurXOverItem = (XOverItem *)[self.view viewWithTag:output_channel_sel+TagStart_XOVER_Self];
    [self checkAndGetLinkItem];
    Bool_HL = false;
    [self showFreqDialog];
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
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:1];
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterBW"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:2];
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetFilter:(int)val{
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_filter = val;
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.OUT_CH[output_channel_sel].h_level == 0){
                [_CurXOverItem.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            }else{
                [_CurXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            }
        }else{
            [_CurXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
        }
        [self flashLinkSyncData:UI_HFilter];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_filter = val;
        
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.OUT_CH[output_channel_sel].l_level == 0){
                [_CurXOverItem.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            }else{
                [_CurXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            }
        }else{
            [_CurXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
        }
        [self flashLinkSyncData:UI_LFilter];
    }
    
    
}
#pragma 弹出选择 Level
- (void)showLevelOptDialog{
    
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }

    
    for(int i=0;i<XOVER_OCT_MAX;i++){
        [alert addAction:[UIAlertAction actionWithTitle:[AllLevel objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:i];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }]];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetLevel:(int)val{
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_level = Level_Val[val];
        [_CurXOverItem.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.OUT_CH[output_channel_sel].h_filter];

        [self flashLinkSyncData:UI_HOct];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_level = Level_Val[val];
        [_CurXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.OUT_CH[output_channel_sel].l_filter];

        [self flashLinkSyncData:UI_LOct];
    }
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
    
    _btnMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnMinus.frame = CGRectMake(10, 100, 30, 30);
     _btnMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnMinus setBackgroundImage:[UIImage imageNamed:@"mastervolume_sub_press"] forState:UIControlStateNormal];
    _btnMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnMinus addTarget:self action:@selector(DialogFreqSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnMinus];


    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderFreq = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
//    __weak __typeof(self) weakSelf = self;
//    _sliderFreq.dataSource = weakSelf;
    _sliderFreq.minimumValue = 0;
    _sliderFreq.maximumValue = 240;
    if(Bool_HL){
        _sliderFreq.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].h_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];
    }else{
        _sliderFreq.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].l_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];
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
    
    
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnAdd setBackgroundImage:[UIImage imageNamed:@"mastervolume_inc_press"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAdd addTarget:self action:@selector(DialogFreqSet_Inc) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnAdd];
    //长按
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [_btnMinus addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [_btnAdd addGestureRecognizer:longPressVolAdd];

    
    
    
    
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
    [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
}

- (void)KxMenutapCloseAction:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    });
}
- (void)SBDialogFreqSet{
    int sliderValue = (int)(_sliderFreq.value);
    _sliderFreq.showValue=[NSString stringWithFormat:@"%d",(int)FREQ241[sliderValue]];
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_freq = FREQ241[sliderValue];
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
		}
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
	    }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        
        
        
        [_CurXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
 
        [self flashLinkSyncData:UI_HFreq];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_freq = FREQ241[sliderValue];
        
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        
        
        [_CurXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];

        [self flashLinkSyncData:UI_LFreq];
    }
    
}

- (void)DialogFreqSet_Sub{
    if(Bool_HL){
        if(--RecStructData.OUT_CH[output_channel_sel].h_freq < 20){
            RecStructData.OUT_CH[output_channel_sel].h_freq = 20;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
        }

        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];

        [_CurXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(--RecStructData.OUT_CH[output_channel_sel].l_freq < 20){
            RecStructData.OUT_CH[output_channel_sel].l_freq = 20;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];

        [_CurXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_LFreq];
    }
}
- (void)DialogFreqSet_Inc{
    if(Bool_HL){
        if(++RecStructData.OUT_CH[output_channel_sel].h_freq > 20000){
            RecStructData.OUT_CH[output_channel_sel].h_freq = 20000;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];

        [_CurXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(++RecStructData.OUT_CH[output_channel_sel].l_freq > 20000){
            RecStructData.OUT_CH[output_channel_sel].l_freq = 20000;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];

        [_CurXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_LFreq];
    }
}
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Sub) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolMinusTimer.isValid){
            [_pVolMinusTimer invalidate];
            _pVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_VolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}

- (int)getFreqIndexFromArray:(int)freq{
    int i=0;
    for(i=0;i<240;i++){
        if((freq >= FREQ241[i])&&(freq <= FREQ241[i+1])){
            break;
        }
    }
    return i;
}

- (void)flashLinkSyncData:(int)ui{
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
        if(BOOL_SET_SpkType){
            if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
                return;
            }
            syncLinkData(ui);
            
            int Dto=0;
            for(int i=0;i<ChannelLinkCnt;i++){
                if(ChannelLinkBuf[i][0]==output_channel_sel){
                    Dto=ChannelLinkBuf[i][1];
                    break;
                }else if(ChannelLinkBuf[i][1]==output_channel_sel){
                    Dto=ChannelLinkBuf[i][0];
                    break;
                }
            }
            
            if(UI_Type == UI_HFilter){
                [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].h_filter]] forState:UIControlStateNormal] ;
            }else if(UI_Type == UI_HOct){
                if(BOOL_FilterHide6DB_OCT){
                    if(RecStructData.OUT_CH[Dto].h_level == 0){
                        [LinkXOverItem.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                    }else{
                        [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].h_filter]] forState:UIControlStateNormal] ;
                    }
                }
                
                for(int i=0;i<XOVER_OCT_MAX;i++){
                    if(RecStructData.OUT_CH[Dto].h_level == Level_Val[i]){
                        [LinkXOverItem.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:i]] forState:UIControlStateNormal] ;
                        break;
                    }
                }

            }else if(UI_Type == UI_HFreq){
                [LinkXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[Dto].h_freq] forState:UIControlStateNormal];
            }else if(UI_Type == UI_LFilter){
                [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].l_filter]] forState:UIControlStateNormal] ;
            }else if(UI_Type == UI_LOct){
                if(BOOL_FilterHide6DB_OCT){
                    if(RecStructData.OUT_CH[Dto].l_level == 0){
                        [LinkXOverItem.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                    }else{
                        [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].l_filter]] forState:UIControlStateNormal] ;
                    }
                }
                
                for(int i=0;i<XOVER_OCT_MAX;i++){
                    if(RecStructData.OUT_CH[Dto].l_level == Level_Val[i]){
                        [LinkXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:i]] forState:UIControlStateNormal] ;
                        break;
                    }
                }
                
                [LinkXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[Dto].l_level]] forState:UIControlStateNormal] ;
            }else if(UI_Type == UI_LFreq){
                [LinkXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[Dto].l_freq] forState:UIControlStateNormal];
            }
            
        }
    }else if(LinkMODE == LINKMODE_FRS){
        if((ChannelConFLR == 0)&&(ChannelConRLR == 0)&&(ChannelConSLR == 0)){
            return;
        }
        syncLinkData(ui);
        if(UI_Type == UI_HFilter){
            [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[LinkChannel].h_filter]] forState:UIControlStateNormal] ;
        }else if(UI_Type == UI_HOct){
            if(BOOL_FilterHide6DB_OCT){
                if(RecStructData.OUT_CH[LinkChannel].h_level == 0){
                    [LinkXOverItem.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                }else{
                    [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[LinkChannel].h_filter]] forState:UIControlStateNormal] ;
                }
            }
            
            for(int i=0;i<XOVER_OCT_MAX;i++){
                if(RecStructData.OUT_CH[LinkChannel].h_level == Level_Val[i]){
                    [LinkXOverItem.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:i]] forState:UIControlStateNormal] ;
                    break;
                }
            }
            
        }else if(UI_Type == UI_HFreq){
            [LinkXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[LinkChannel].h_freq] forState:UIControlStateNormal];
        }else if(UI_Type == UI_LFilter){
            [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[LinkChannel].l_filter]] forState:UIControlStateNormal] ;
        }else if(UI_Type == UI_LOct){
            if(BOOL_FilterHide6DB_OCT){
                if(RecStructData.OUT_CH[LinkChannel].l_level == 0){
                    [LinkXOverItem.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                }else{
                    [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[LinkChannel].l_filter]] forState:UIControlStateNormal] ;
                }
            }
            
            for(int i=0;i<XOVER_OCT_MAX;i++){
                if(RecStructData.OUT_CH[LinkChannel].l_level == Level_Val[i]){
                    [LinkXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:i]] forState:UIControlStateNormal] ;
                    break;
                }
            }

        }else if(UI_Type == UI_LFreq){
            [LinkXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[LinkChannel].l_freq] forState:UIControlStateNormal];
        }
    }
    
}

- (void)checkAndGetLinkItem{
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
        if(BOOL_SET_SpkType){
            if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
                return;
            }
            
            int Dto=0xff;
            for(int i=0;i<ChannelLinkCnt;i++){
                if(ChannelLinkBuf[i][0]==output_channel_sel){
                    Dto=ChannelLinkBuf[i][1];
                    break;
                }else if(ChannelLinkBuf[i][1]==output_channel_sel){
                    Dto=ChannelLinkBuf[i][0];
                    break;
                }
            }
            LinkXOverItem = (XOverItem *)[self.view viewWithTag:Dto+TagStart_XOVER_Self];
    
        }
    }else if(LinkMODE == LINKMODE_FRS){
        if((ChannelConFLR == 0)&&(ChannelConRLR == 0)&&(ChannelConSLR == 0)){
            return;
        }
        BOOL haLinkb = false;
        if((ChannelConFLR == 1)&&((output_channel_sel == 0)||(output_channel_sel == 1))){
            haLinkb = true;
            if(output_channel_sel == 1){
                LinkChannel = 0;
            }else {
                LinkChannel = 1;
            }
        }
        
        if((ChannelConRLR == 1)&&((output_channel_sel == 2)||(output_channel_sel == 3))){
            haLinkb = true;
            if(output_channel_sel == 2){
                LinkChannel = 3;
            }else {
                LinkChannel = 2;
            }
        }
        
        if((ChannelConSLR == 1)&&((output_channel_sel == 4)||(output_channel_sel == 5))){
            haLinkb = true;
            if(output_channel_sel == 4){
                LinkChannel = 5;
            }else {
                LinkChannel = 4;
            }
        }
        
        if(haLinkb) {
            if(OldLinkChannel != LinkChannel){
                OldLinkChannel = LinkChannel;
                LinkXOverItem = (XOverItem *)[self.view viewWithTag:LinkChannel+TagStart_XOVER_Self];
            }
        }
    }
    
}
- (int) getChannelNum:(int)channel{
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8] = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9] = RecStructData.System.out10_spk_type;
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
        if(ChannelNumBuf[i]>maxSpkType){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
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
        [self FlashXOverPageUI];
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
                [self FlashXOverPageUI];
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
#pragma 广播通知
- (void)FlashXOverPageUI{
    [self checkAndGetLinkItem];
    dispatch_async(dispatch_get_main_queue(), ^{
        for(int i=0;i<Output_CH_MAX;i++){
            XOverItem * find_btn = (XOverItem *)[self.view viewWithTag:i+TagStart_XOVER_Self];
            
//            if(i <= 3){
//                if((RecStructData.OUT_CH[i].h_level < 0)
//                   ||(RecStructData.OUT_CH[i].h_level > XOVER_OCT_MAXL)){
//                    RecStructData.OUT_CH[i].h_level = XOVER_OCT_MAXL;
//                }
//                
//                if((RecStructData.OUT_CH[i].l_level < 0)
//                   ||(RecStructData.OUT_CH[i].l_level > XOVER_OCT_MAXL)){
//                    RecStructData.OUT_CH[i].l_level = XOVER_OCT_MAXL;
//                }
//            }else{
//                if((RecStructData.OUT_CH[i].h_level < 0)
//                   ||(RecStructData.OUT_CH[i].h_level > XOVER_OCT_MAXH)){
//                    RecStructData.OUT_CH[i].h_level = XOVER_OCT_MAXH;
//                }
//                
//                if((RecStructData.OUT_CH[i].l_level < 0)
//                   ||(RecStructData.OUT_CH[i].l_level > XOVER_OCT_MAXH)){
//                    RecStructData.OUT_CH[i].l_level = XOVER_OCT_MAXH;
//                }
//            }
            
            if(RecStructData.OUT_CH[i].h_filter > 3 || RecStructData.OUT_CH[i].h_filter < 0){
                RecStructData.OUT_CH[i].h_filter = 0;
            }
            if(RecStructData.OUT_CH[i].l_filter > 3 || RecStructData.OUT_CH[i].l_filter < 0){
                RecStructData.OUT_CH[i].l_filter = 0;
            }
            
            if(RecStructData.OUT_CH[i].h_freq > 20000 || RecStructData.OUT_CH[i].h_freq < 20){
                RecStructData.OUT_CH[i].h_freq = 20;
            }
            if(RecStructData.OUT_CH[i].l_freq > 20000 || RecStructData.OUT_CH[i].l_freq < 20){
                RecStructData.OUT_CH[i].l_freq = 20000;
            }
            
            for(int inx=0;inx<XOVER_OCT_MAX;inx++){
                if(RecStructData.OUT_CH[i].h_level == Level_Val[inx]){
                    [find_btn.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:inx]] forState:UIControlStateNormal] ;
                    break;
                }
            }
            for(int inx=0;inx<XOVER_OCT_MAX;inx++){
                if(RecStructData.OUT_CH[i].l_level == Level_Val[inx]){
                    [find_btn.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:inx]] forState:UIControlStateNormal] ;
                    break;
                }
            }
            
            [find_btn.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[i].h_freq] forState:UIControlStateNormal];
            [find_btn.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[i].l_freq] forState:UIControlStateNormal];
            
            if(BOOL_FilterHide6DB_OCT){
                if(RecStructData.OUT_CH[i].h_level == 0){
                    [find_btn.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                }else{
                    [find_btn.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].h_filter]] forState:UIControlStateNormal] ;
                }
                
                if(RecStructData.OUT_CH[i].l_level == 0){
                    [find_btn.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                }else{
                    [find_btn.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].l_filter]] forState:UIControlStateNormal] ;
                }
                
            }else{
                [find_btn.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].h_filter]] forState:UIControlStateNormal] ;
                [find_btn.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[i].l_filter]] forState:UIControlStateNormal] ;
                
            }
            
            if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
                self.Encrypt.hidden = false;
                
                [find_btn.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:0]] forState:UIControlStateNormal] ;
                [find_btn.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:0]] forState:UIControlStateNormal] ;
                
                [find_btn.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",20] forState:UIControlStateNormal];
                [find_btn.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",20000] forState:UIControlStateNormal];
                
                if(BOOL_FilterHide6DB_OCT){
                    [find_btn.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                    [find_btn.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                }else{
                    [find_btn.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:0]] forState:UIControlStateNormal] ;
                    [find_btn.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:0]] forState:UIControlStateNormal] ;
                    
                }
            }else{
                self.Encrypt.hidden = true;
            }
            
            
        }
    });
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashXOverPageUI];
    });
}


@end

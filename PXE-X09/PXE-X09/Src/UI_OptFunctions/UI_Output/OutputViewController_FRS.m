//
//  OutputViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutputViewController_FRS.h"


#define OutSet_Btn_Height 25
#define OutSet_Btn_Width 60

#define OutSetLink_Btn_Height 28
#define OutSetLink_Btn_Width 110

@interface OutputViewController_FRS ()

@end

@implementation OutputViewController_FRS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Output;
}
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
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    [self initData];
    [self initView];
    //[self initOutputSet];
    [self initOutputLinkFRS];
    if(!gConnectState){
        [self setOutputSpkTypeDefault];
    }
    [self FlashPageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma initView
- (void)initOutputSet{
    //重置
    self.Btn_Reset = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Reset];
    [self.Btn_Reset setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Reset setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
    [self.Btn_Reset initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
    [self.Btn_Reset setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.Btn_Reset.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Reset addTarget:self action:@selector(Btn_Reset_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Reset setTitle:[LANG DPLocalizedString:@"L_Out_Reset"] forState:UIControlStateNormal] ;
    self.Btn_Reset.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //锁定
    self.Btn_Lock = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Lock];
    [self.Btn_Lock setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Lock setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
    [self.Btn_Lock initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
    [self.Btn_Lock setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.Btn_Lock.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Lock addTarget:self action:@selector(Btn_Lock_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
    self.Btn_Lock.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Lock.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //联调
    self.Btn_Link = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Link];
    [self.Btn_Link setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Link setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
    [self.Btn_Link initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
    [self.Btn_Link setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.Btn_Link.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Link addTarget:self action:@selector(Btn_Link_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    self.Btn_Link.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Link.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //位置
    float height  = (KScreenHeight -[Dimens GDimens:UI_StartWithTopBar+50])/3;
    float Start_Y = [Dimens GDimens:UI_StartWithTopBar+10]+height/2;
    [self.Btn_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(Start_Y);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSet_Btn_Width], [Dimens GDimens:OutSet_Btn_Height]));
    }];

    
    [self.Btn_Lock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(Start_Y+height);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSet_Btn_Width], [Dimens GDimens:OutSet_Btn_Height]));
    }];

    
    [self.Btn_Link mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(Start_Y+height*2);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSet_Btn_Width], [Dimens GDimens:OutSet_Btn_Height]));
    }];
}

- (void)initView{
    float height  = [Dimens GDimens:150];
    float width   = [Dimens GDimens:180];
    float mid     = [Dimens GDimens:18];
    self.setOutNameDialog = [[OutNameSet alloc]init];
    for (int i = 0; i<Output_CH_MAX; i++) {
        NSInteger x = i % (2);
        NSInteger y = i / (2);
        
        float Start_X = mid+(mid + width)*x;
        float Start_Y = (mid + height)*y + [Dimens GDimens:90];

        OutputItemFRS *mOutputItem = [[OutputItemFRS alloc]initWithFrame:CGRectMake(Start_X, Start_Y, width, height)];
        if(x == 0){
            mOutputItem.frame = CGRectMake(Start_X, Start_Y, width, height);
        }else{
            mOutputItem.frame = CGRectMake(KScreenWidth - width -mid, Start_Y, width, height);
        }
        
        [self.view addSubview:mOutputItem];
        [mOutputItem setTag:i];
        [mOutputItem setOutputItemTag:i];
        //CH
        if(BOOL_SET_SpkType){
            [mOutputItem.Btn_Channel setTitle:[NSString stringWithFormat:@"CH%d",i+1] forState:UIControlStateNormal];
        }else{
            switch (i) {
                case 0:
                    [mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
                    break;
                case 1:[mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontRight"] forState:UIControlStateNormal] ;
                    break;
                case 2:[mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearLeft"] forState:UIControlStateNormal] ;
                    break;
                case 3:[mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearRight"] forState:UIControlStateNormal] ;
                    break;
                case 4:[mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_LeftSub"] forState:UIControlStateNormal] ;
                    break;
                case 5:[mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RightSub"] forState:UIControlStateNormal] ;
                    break;
                default:
                    break;
            }
        }
        
        [mOutputItem addTarget:self action:@selector(OutputItemEventValueChanged:) forControlEvents:UIControlEventValueChanged];
        [mOutputItem setOutputItemMax:Output_Volume_MAX/Output_Volume_Step];
        [mOutputItem setOutputItemVal:RecStructData.OUT_CH[i].gain/Output_Volume_Step];
        //Polar
        [mOutputItem.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
        if(RecStructData.OUT_CH[i].polar == 0){
            [mOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
            [mOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
        }else{
            [mOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
            [mOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
        }
        //Btn_Mute
        [mOutputItem.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
        if(RecStructData.OUT_CH[i].mute == 0){
            [mOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_press"] forState:UIControlStateNormal];
            [mOutputItem.Btn_Mute setPress];
        }else{
            [mOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
            [mOutputItem.Btn_Mute setNormal];
        }
        //Btn_Name
        [mOutputItem.Btn_Name addTarget:self action:@selector(Btn_Name_Click:) forControlEvents:UIControlEventTouchUpInside];
        [mOutputItem.Btn_Name setTitle:[self.setOutNameDialog getOutputChannelTypeName:i] forState:UIControlStateNormal];

    }
}
#pragma 输出调音响应事件
-(void)OutputItemEventValueChanged:(OutputItemFRS *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Self;
    int val = [sender getOutputItemVal];
    RecStructData.OUT_CH[output_channel_sel].gain = val*Output_Volume_Step;
    
//    if(OldChannelSel != output_channel_sel){
        OldChannelSel = output_channel_sel;
        _CurOutputItem = (OutputItemFRS *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
//    }
    
    [self checkAndGetLinkItem];
    [self flashLinkSyncData:UI_OutVal];
}

-(void)Btn_Polar_Click:(NormalButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Polar;
    _CurOutputItem = (OutputItemFRS *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
    [self checkAndGetLinkItem];
    
    if(RecStructData.OUT_CH[output_channel_sel].polar == 0){
        RecStructData.OUT_CH[output_channel_sel].polar = 1;
        [sender setPress];
        [_CurOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
    }else{
        RecStructData.OUT_CH[output_channel_sel].polar = 0;
        [sender setNormal];
        [_CurOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
    }
    [self flashLinkSyncData:UI_OutPolar];
}

-(void)Btn_Mute_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Mute;
    _CurOutputItem = (OutputItemFRS *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
    [self checkAndGetLinkItem];
    
    if(RecStructData.OUT_CH[output_channel_sel].mute == 0){
        RecStructData.OUT_CH[output_channel_sel].mute = 1;
        [_CurOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Mute setNormal];
    }else{
        RecStructData.OUT_CH[output_channel_sel].mute = 0;
        [_CurOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_press"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Mute setPress];
    }
}
-(void)Btn_Name_Click:(UIButton *)sender{
    
    
    if(BOOL_LOCK){
        return;
    }
    
    output_channel_sel = (int)sender.tag - TagStart_OutItem_OutName;
    _CurOutputItem = (OutputItemFRS *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];

    [self.setOutNameDialog flashOutputState:[self getChannelNum:output_channel_sel]];
    [self.setOutNameDialog.Btn_Ok addTarget:self action:@selector(setOutNameDialog_Ok_Click:) forControlEvents:UIControlEventTouchUpInside];
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] setOKButton:self.setOutNameDialog.Btn_Ok];
    [[KGModal sharedInstance] setOKButton:self.setOutNameDialog.Btn_Cancel];
    [[KGModal sharedInstance] showWithContentView:self.setOutNameDialog andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
    
}
-(void)setOutNameDialog_Ok_Click:(UIButton *)sender{
    NSLog(@"setOutNameDialog_Ok_Click");
    NSString *outname = [self.setOutNameDialog getOutputName];
    [self.setOutNameDialog flashOutputType:[self.setOutNameDialog getOutputTypeNum:outname]];
    UIButton *find_btn = (UIButton *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_OutName];
    [find_btn setTitle:outname forState:UIControlStateNormal];
    [self setOutputSpkType:[self.setOutNameDialog getCurSpkType]];
    
    //根据名字设置Xover频率
    //高频
    for(int i=0;i<6;i++){
        if(HighFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==HighFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=HighFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=HighFreq_LPFreq;
            }
        }
    }
    //中频
    for(int i=0;i<3;i++){
        if(MidFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==MidFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=MidFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=MidFreq_LPFreq;
            }
        }
    }
    //低频
    for(int i=0;i<6;i++){
        if(LowFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==LowFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=LowFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=LowFreq_LPFreq;
            }
        }
    }
    //中高
    for(int i=0;i<3;i++){
        if(MidHighFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==MidHighFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=MidHighFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=MidHighFreq_LPFreq;
            }
        }
    }
    //中低
    for(int i=0;i<3;i++){
        if(MidLowFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==MidLowFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=MidLowFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=MidLowFreq_LPFreq;
            }
        }
    }
    //超低
    for(int i=0;i<4;i++){
        if(SupperLowFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==SupperLowFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=SupperLowFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=SupperLowFreq_LPFreq;
            }
        }
    }
    
    //全频
    for(int i=0;i<7;i++){
        if(AllFreq[i]!=EndFlag){
            if(ChannelNumBuf[output_channel_sel]==AllFreq[i]){
                RecStructData.OUT_CH[output_channel_sel].h_freq=AllFreq_HPFreq;
                RecStructData.OUT_CH[output_channel_sel].l_freq=AllFreq_LPFreq;
            }
        }
    }
    
    if([self.setOutNameDialog getCurSpkType]==0){
        RecStructData.OUT_CH[output_channel_sel].h_filter=0;
        RecStructData.OUT_CH[output_channel_sel].l_filter=0;
        RecStructData.OUT_CH[output_channel_sel].h_level=1;
        RecStructData.OUT_CH[output_channel_sel].l_level=1;
        RecStructData.OUT_CH[output_channel_sel].h_freq=AllFreq_HPFreq;
        RecStructData.OUT_CH[output_channel_sel].l_freq=AllFreq_LPFreq;
    }
}

- (void)setOutputSpkType:(int)type{
    
    RecStructData.System.out_spk_type[output_channel_sel]=type;

    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

}

- (int) getChannelNum:(int)channel{
    //int ChannelNumBuf[16];
    
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
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
#pragma 输出设置响应事件

- (void)Btn_Reset_Click:(NormalButton*)sender{
    [self showOutputResetDialog];
}

- (void)Btn_Lock_Click:(NormalButton*)sender{
    [self showOutputLockDialog];
}

- (void)Btn_Link_Click:(NormalButton*)sender{
    
    if(BOOL_LINK){
        [self setUnlinkState];
    }else{
        [self CheckChannelCanLink];
        if(ChannelLinkCnt >0){
            [self showOutputLinkDialog];
        }else{
            [self showNoLinkDialog];
        }
    }
    
    
}

#pragma 弹出选择 Output channel set

- (void)showOutputResetDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Reset"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Set"]preferredStyle:UIAlertControllerStyleAlert];

    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_Emptied"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setOutputSpkTypeClean];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_Default"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setOutputSpkTypeDefault];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOutputLockDialog{
    UIAlertController *alert;
    
    if(BOOL_LOCK){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Unlock"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_unlock"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Locked"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Locked"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(BOOL_LOCK){
            BOOL_LOCK=false;
            [self setUnlinkState];
        }else{
            [self checkLock];
        }
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNotLockDialog{
    UIAlertController *alert;
    
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Locked"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_cannotlock"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)checkLock{
    BOOL lock=false;

    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
    for(int i=0;i<Output_CH_MAX;i++){
        if(ChannelNumBuf[i]!=0){
            lock=true;
            break;
        }
    }
    
    if(lock){
        BOOL_LOCK=true;
        [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Unlock"] forState:UIControlStateNormal] ;
        [self.Btn_Lock setPress];
    }else{
        [self showNotLockDialog];
    }
}




- (void)showOutputLinkDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Set_LinkLR"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Link"]preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_LeftToRight"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setLinkState];
        BOOL_LeftCyRight = true;
        setDataSyncLink();
        [self FlashPageUI];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_RightToLeft"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setLinkState];
        BOOL_LeftCyRight = false;
        setDataSyncLink();
        [self FlashPageUI];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNoLinkDialog{
    UIAlertController *alert;
    
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Link"]message:[LANG DPLocalizedString:@"L_Out_NoLinkLR"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma 功能函数

- (void)setOutputSpkTypeDefault{
  
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i]=ChannelTypeDefault[i];
    }

    
    for(int i=0;i<Output_CH_MAX;i++){
        //设置默认输出滤波器
        RecStructData.OUT_CH[i].h_filter=1;
        RecStructData.OUT_CH[i].l_filter=1;
        RecStructData.OUT_CH[i].h_level=1;
        RecStructData.OUT_CH[i].l_level=1;
        
        //根据名字设置Xover频率
        //高频
        for(int j=0;j<6;j++){
            if(HighFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==HighFreq[j]){
                    RecStructData.OUT_CH[i].h_freq = HighFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq = HighFreq_LPFreq;
                }
            }
        }
        //中频
        for(int j=0;j<3;j++){
            if(MidFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidFreq_LPFreq;
                }
            }
        }
        //低频
        for(int j=0;j<6;j++){
            if(LowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==LowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=LowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=LowFreq_LPFreq;
                }
            }
        }
        //中高
        for(int j=0;j<3;j++){
            if(MidHighFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidHighFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidHighFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidHighFreq_LPFreq;
                }
            }
        }
        //中低
        for(int j=0;j<3;j++){
            if(MidLowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidLowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidLowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidLowFreq_LPFreq;
                }
            }
        }
        //超低
        for(int j=0;j<4;j++){
            if(SupperLowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==SupperLowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=SupperLowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=SupperLowFreq_LPFreq;
                    
                    RecStructData.OUT_CH[i].h_filter=0;
                    RecStructData.OUT_CH[i].l_filter=0;
                    RecStructData.OUT_CH[i].h_level=1;
                    RecStructData.OUT_CH[i].l_level=1;
                }
            }
        }
        
        //全频
        for(int j=0;j<7;j++){
            if(AllFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==AllFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=AllFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=AllFreq_LPFreq;
                    
                    RecStructData.OUT_CH[i].h_filter=0;
                    RecStructData.OUT_CH[i].l_filter=0;
                    RecStructData.OUT_CH[i].h_level=1;
                    RecStructData.OUT_CH[i].l_level=1;
                }
            }
        }
    }
    
    [self FlashOutputSpkType];
}
- (void)setOutputSpkTypeClean{
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i]=0;
    }

    for(int i=0;i<Output_CH_MAX;i++){
        //设置默认输出滤波器
        RecStructData.OUT_CH[i].h_filter=1;
        RecStructData.OUT_CH[i].l_filter=1;
        RecStructData.OUT_CH[i].h_level=1;
        RecStructData.OUT_CH[i].l_level=1;
        RecStructData.OUT_CH[i].h_freq=20;
        RecStructData.OUT_CH[i].l_freq=20000;
    }
    
    
    [self FlashOutputSpkType];
    
}

- (void)FlashOutputSpkType{
    UIButton *find_btn;
    for(int i=0;i<Output_CH_MAX;i++){
        find_btn = (UIButton *)[self.view viewWithTag:i+TagStart_OutItem_OutName];
        [find_btn setTitle:[self.setOutNameDialog getOutputChannelTypeName:i] forState:UIControlStateNormal];
    }
    [self FlashPageUI];
}

- (void)setUnlinkState{
    BOOL_LINK = false;
    BOOL_LOCK = false;
    
    ChannelLinkCnt = 0;
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
    [self.Btn_Lock setNormal];
    
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    [self.Btn_Link setNormal];
}

- (void)setLinkState{
    BOOL_LINK = true;
    BOOL_LOCK = true;
    

    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Unlock"] forState:UIControlStateNormal] ;
    [self.Btn_Lock setPress];
    
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_UnLink"] forState:UIControlStateNormal] ;
    [self.Btn_Link setPress];
    
    [self checkAndGetLinkItem];
    
}
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
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

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


- (void)checkAndGetLinkItem{
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        
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
        LinkChannel = Dto;
        //if(OldLinkChannel != LinkChannel){
            OldLinkChannel = LinkChannel;
            LinkOutputItem = (OutputItemFRS *)[self.view viewWithTag:Dto+TagStart_OutItem_Self];
        //}
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
            //if(OldLinkChannel != LinkChannel){
                OldLinkChannel = LinkChannel;
                LinkOutputItem = (OutputItemFRS *)[self.view viewWithTag:LinkChannel+TagStart_OutItem_Self];
            //}
        }
    }
    
}

- (void)flashLinkSyncData:(int)ui{
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
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
        
        if(UI_Type == UI_OutVal){
            [LinkOutputItem setOutputItemVal:RecStructData.OUT_CH[Dto].gain/Output_Volume_Step];
        }else if(UI_Type == UI_OutMute){
        }else if(UI_Type == UI_OutPolar){
        }

    }else if(LinkMODE == LINKMODE_FRS){
        if((ChannelConFLR == 0)&&(ChannelConRLR == 0)&&(ChannelConSLR == 0)){
            return;
        }
        syncLinkData(ui);
        if(UI_Type == UI_OutVal){
            [LinkOutputItem setOutputItemVal:RecStructData.OUT_CH[LinkChannel].gain/Output_Volume_Step];
        }else if(UI_Type == UI_OutMute){
        }else if(UI_Type == UI_OutPolar){
            if(RecStructData.OUT_CH[LinkChannel].polar == 0){
                [LinkOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
                [LinkOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
                [LinkOutputItem.Btn_Polar setNormal];
                
            }else{
                [LinkOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
                [LinkOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
                [LinkOutputItem.Btn_Polar setPress];
            }
        }
    }

}
#pragma 联调界面 initOutputLinkFRS
- (void)initOutputLinkFRS{
    //前置联调
    self.BtnLinkFLR = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnLinkFLR];
    [self.BtnLinkFLR setBackgroundColor:[UIColor clearColor]];
    [self.BtnLinkFLR setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
//    [self.BtnLinkFLR initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
//    [self.BtnLinkFLR setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.BtnLinkFLR.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.BtnLinkFLR addTarget:self action:@selector(BtnLinkFLR_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnLinkFLR setTitle:[LANG DPLocalizedString:@"L_Out_FrontCoupling"] forState:UIControlStateNormal] ;
    self.BtnLinkFLR.titleLabel.adjustsFontSizeToFitWidth = true;
    self.BtnLinkFLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //
    self.BtnLinkFLR.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnLinkFLR.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.BtnLinkFLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.BtnLinkFLR.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.BtnLinkFLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.BtnLinkFLR.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:0],
        .bottom = 0,
        .right  = 0,
    };
    
    self.BtnLinkFLR.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:OutSetLink_Btn_Width-OutSetLink_Btn_Height],
    };
    //后置联调
    self.BtnLinkRLR = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnLinkRLR];
    [self.BtnLinkRLR setBackgroundColor:[UIColor clearColor]];
    [self.BtnLinkRLR setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
//    [self.BtnLinkRLR initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
//    [self.BtnLinkRLR setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.BtnLinkRLR.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.BtnLinkRLR addTarget:self action:@selector(BtnLinkRLR_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnLinkRLR setTitle:[LANG DPLocalizedString:@"L_Out_RearCoupling"] forState:UIControlStateNormal] ;
    self.BtnLinkRLR.titleLabel.adjustsFontSizeToFitWidth = true;
    self.BtnLinkRLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //
    self.BtnLinkRLR.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnLinkRLR.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.BtnLinkRLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.BtnLinkRLR.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.BtnLinkRLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.BtnLinkRLR.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:0],
        .bottom = 0,
        .right  = 0,
    };
    
    self.BtnLinkRLR.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:OutSetLink_Btn_Width-OutSetLink_Btn_Height],
    };

    //超低联调
    self.BtnLinkSLR = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnLinkSLR];
    [self.BtnLinkSLR setBackgroundColor:[UIColor clearColor]];
    [self.BtnLinkSLR setTitleColor:SetColor(UI_OutSet_BtnText_Normal) forState:UIControlStateNormal];
    
//    [self.BtnLinkSLR initView:3 withBorderWidth:1 withNormalColor:UI_OutSet_Btn_Normal withPressColor:UI_OutSet_Btn_Press withType:1];
//    [self.BtnLinkSLR setTextColorWithNormalColor:UI_OutSet_BtnText_Normal withPressColor:UI_OutSet_BtnText_Press];
    
    self.BtnLinkSLR.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.BtnLinkSLR addTarget:self action:@selector(BtnLinkSLR_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnLinkSLR setTitle:[LANG DPLocalizedString:@"L_Out_SubCoupling"] forState:UIControlStateNormal] ;
    self.BtnLinkSLR.titleLabel.adjustsFontSizeToFitWidth = true;
    self.BtnLinkSLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //
    self.BtnLinkSLR.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnLinkSLR.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.BtnLinkSLR.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.BtnLinkSLR.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.BtnLinkSLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.BtnLinkSLR.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:0],
        .bottom = 0,
        .right  = 0,
    };
    
    self.BtnLinkSLR.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:OutSetLink_Btn_Width-OutSetLink_Btn_Height],
    };

    //位置
    [self.BtnLinkFLR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:15]);
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:620]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSetLink_Btn_Width], [Dimens GDimens:OutSetLink_Btn_Height]));
    }];
    
    
    [self.BtnLinkRLR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.BtnLinkFLR.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSetLink_Btn_Width], [Dimens GDimens:OutSetLink_Btn_Height]));
    }];
    
    
    [self.BtnLinkSLR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:15]);
        make.centerY.equalTo(self.BtnLinkFLR.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutSetLink_Btn_Width], [Dimens GDimens:OutSetLink_Btn_Height]));
    }];

    
}

- (void)BtnLinkFLR_Click:(NormalButton*)sender{
    if(ChannelConFLR == 0){
        [self showFRSLinkDialog:1];
    }else{
        ChannelConFLR = 0;
        //[self.BtnLinkFLR setNormal];
        [self.self.BtnLinkFLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
}
- (void)BtnLinkRLR_Click:(NormalButton*)sender{
    if(ChannelConRLR == 0){
        [self showFRSLinkDialog:2];
    }else{
        ChannelConRLR = 0;
        //[self.BtnLinkRLR setNormal];
        [self.BtnLinkRLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}
- (void)BtnLinkSLR_Click:(NormalButton*)sender{
    if(ChannelConSLR == 0){
        [self showFRSLinkDialog:3];
    }else{
        ChannelConSLR = 0;
        //[self.BtnLinkSLR setNormal];
        [self.self.BtnLinkSLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
}

- (void)flashLinkBtnState{
    if(ChannelConFLR == 1){
        //[self.BtnLinkFLR setPress];
        [self.self.BtnLinkFLR setImage:[[UIImage imageNamed:@"link_check_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        //[self.BtnLinkFLR setNormal];
        [self.self.BtnLinkFLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    if(ChannelConRLR == 1){
        //[self.BtnLinkRLR setPress];
        [self.self.BtnLinkRLR setImage:[[UIImage imageNamed:@"link_check_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        //[self.BtnLinkRLR setNormal];
        [self.self.BtnLinkRLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }

    
    if(ChannelConSLR == 1){
        //[self.BtnLinkSLR setPress];
        [self.self.BtnLinkSLR setImage:[[UIImage imageNamed:@"link_check_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        //[self.BtnLinkSLR setNormal];
        [self.self.BtnLinkSLR setImage:[[UIImage imageNamed:@"link_check_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }

}

- (void)showFRSLinkDialog:(int)CH{
    NSString *title,*msg,*cont1,*cont2;
    switch (CH) {
        case 1:
            title = [LANG DPLocalizedString:@"L_Out_FrontCoupling"];
            msg   = [LANG DPLocalizedString:@"L_Out_LinkBase"];
            cont1 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh1"];
            cont2 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh2"];
            break;
        case 2:
            title = [LANG DPLocalizedString:@"L_Out_RearCoupling"];
            msg   = [LANG DPLocalizedString:@"L_Out_LinkBase"];
            cont1 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh3"];
            cont2 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh4"];
            break;
        case 3:
            title = [LANG DPLocalizedString:@"L_Out_SubCoupling"];
            msg   = [LANG DPLocalizedString:@"L_Out_LinkBase"];
            cont1 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh5D"];
            cont2 = [LANG DPLocalizedString:@"L_Out_LinkBaseCh6D"];
            break;
            
        default:
            break;
    }
    BOOL_LeftCyRight = true;
    
    
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:cont1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
        BOOL_LeftCyRight = true;
        [self dealWithLink:CH];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:cont2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        BOOL_LeftCyRight = false;
        [self dealWithLink:CH];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)dealWithLink:(int)opt{
    switch (opt) {
        case 1:
            ChannelConFLR = 1;
            if(BOOL_LeftCyRight){
                copyGroupData(0,1);
            }else{
                copyGroupData(1,0);
            }
            break;
        case 2:
            ChannelConRLR = 1;
            if(BOOL_LeftCyRight){
                copyGroupData(2,3);
            }else{
                copyGroupData(3,2);
            }
            break;
        case 3:
            ChannelConSLR = 1;
            if(BOOL_LeftCyRight){
                copyGroupData(4,5);
            }else{
                copyGroupData(5,4);
            }
            break;
        default:
            break;
    }
    
    [self FlashPageUI];
    [self.mDataTransmitOpt ComparedToSendData:false];
    [self.mDataTransmitOpt SEFF_Save:0];
}

#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashLinkBtnState];
        OutputItemFRS *find_btn;
        for(int i=0;i<Output_CH_MAX;i++){
            find_btn = (OutputItemFRS *)[self.view viewWithTag:i+TagStart_OutItem_Self];
            //Volume
            [find_btn setOutputItemVal:RecStructData.OUT_CH[i].gain/Output_Volume_Step];
            //Polar
            if(RecStructData.OUT_CH[i].polar == 0){
                [find_btn.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
                [find_btn.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
                [find_btn.Btn_Polar setNormal];
                
            }else{
                [find_btn.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
                [find_btn.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
                [find_btn.Btn_Polar setPress];
            }
            //Mute
            if(RecStructData.OUT_CH[i].mute == 0){
                [find_btn.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_press"] forState:UIControlStateNormal];
                [find_btn.Btn_Mute setPress];
            }else{
                [find_btn.Btn_Mute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
                [find_btn.Btn_Mute setNormal];
            }
            //Name
            [find_btn.Btn_Name setTitle:[self.setOutNameDialog getOutputChannelTypeName:i] forState:UIControlStateNormal];
        }

    });
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
    });
}



#pragma initData

- (void)initData{
    LinkChannel=0;
    OldLinkChannel=1;
}


@end

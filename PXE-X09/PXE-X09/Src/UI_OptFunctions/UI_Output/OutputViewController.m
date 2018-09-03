//
//  OutputViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutputViewController.h"


#define OutSet_Btn_Height 25
#define OutSet_Btn_Width 60

@interface OutputViewController ()

@end

@implementation OutputViewController
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
    
    [self initData];
    [self initView];
    [self initOutputSet];

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
    float height  = (KScreenHeight -[Dimens GDimens:UI_StartWithTopBar+50])/(Output_CH_MAX_USE/2);
    self.setOutNameDialog = [[OutNameSet alloc]init];
    for (int i = 0; i<Output_CH_MAX; i++) {
        NSInteger x = i % (2);
        NSInteger y = i / (2);
        
        float Start_X = KScreenWidth/2*x;
        float Start_Y = height*y+[Dimens GDimens:UI_StartWithTopBar+0];
        if(i>2){
            Start_Y = height*y+[Dimens GDimens:UI_StartWithTopBar-5];
        }
        OutputItem *mOutputItem = [[OutputItem alloc]init];
        mOutputItem.frame = CGRectMake(Start_X, Start_Y, KScreenWidth/2, height);
        [self.view addSubview:mOutputItem];
        [mOutputItem setTag:i];
        [mOutputItem setOutputItemTag:i];
        //CH
        [mOutputItem.Btn_Channel setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"CH%d",i+1]] forState:UIControlStateNormal];
        //Sb
        [mOutputItem.SB_Volume setProgress:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
        [mOutputItem.SB_Volume addTarget:self action:@selector(VolumeSBChange:) forControlEvents:UIControlEventValueChanged];
        //Btn_Volume
        [mOutputItem.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[i].gain/Output_Volume_Step] forState:UIControlStateNormal];
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
            [mOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        }else{
            [mOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        }
        //Btn_Name
        [mOutputItem.Btn_Name addTarget:self action:@selector(Btn_Name_Click:) forControlEvents:UIControlEventTouchUpInside];
        [mOutputItem.Btn_Name setTitle:[self.setOutNameDialog getOutputChannelTypeName:i] forState:UIControlStateNormal];

    }
}
#pragma 输出调音响应事件
-(void)VolumeSBChange:(VolumeCircleIMLine *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_SB_Volume;
    
    if(OldChannelSel != output_channel_sel){
        OldChannelSel = output_channel_sel;
        _CurOutputItem = (OutputItem *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
    }
    
    [self checkAndGetLinkItem];
    
    
    RecStructData.OUT_CH[output_channel_sel].gain = [sender GetProgress]*Output_Volume_Step;

    [_CurOutputItem.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",[sender GetProgress]] forState:UIControlStateNormal] ;

    [self flashLinkSyncData:UI_OutVal];
}

-(void)Btn_Polar_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Polar;
    _CurOutputItem = (OutputItem *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
    [self checkAndGetLinkItem];
    
    if(RecStructData.OUT_CH[output_channel_sel].polar == 0){
        RecStructData.OUT_CH[output_channel_sel].polar = 1;

        [_CurOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
    }else{
        RecStructData.OUT_CH[output_channel_sel].polar = 0;

        [_CurOutputItem.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
        [_CurOutputItem.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
    }
}

-(void)Btn_Mute_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Mute;
    _CurOutputItem = (OutputItem *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];
    [self checkAndGetLinkItem];
    
    if(RecStructData.OUT_CH[output_channel_sel].mute == 0){
        RecStructData.OUT_CH[output_channel_sel].mute = 1;
        [_CurOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }else{
        RecStructData.OUT_CH[output_channel_sel].mute = 0;
        [_CurOutputItem.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }
}
-(void)Btn_Name_Click:(UIButton *)sender{
    
    
    if(BOOL_LOCK){
        return;
    }
    
    output_channel_sel = (int)sender.tag - TagStart_OutItem_OutName;
    _CurOutputItem = (OutputItem *)[self.view viewWithTag:output_channel_sel+TagStart_OutItem_Self];

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
    if(BOOL_SET_SpkType){
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
        if(OldLinkChannel != LinkChannel){
            OldLinkChannel = LinkChannel;
            LinkOutputItem = (OutputItem *)[self.view viewWithTag:Dto+TagStart_OutItem_Self];
        }

    }
}

- (void)flashLinkSyncData:(int)ui{
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
        
        if(UI_Type == UI_OutVal){
            [LinkOutputItem.SB_Volume setProgress:RecStructData.OUT_CH[Dto].gain/Output_Volume_Step];
            [LinkOutputItem.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[Dto].gain/Output_Volume_Step] forState:UIControlStateNormal] ;
        }else if(UI_Type == UI_OutMute){
        }else if(UI_Type == UI_OutPolar){
        }
    }
    
}


#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        OutputItem *find_btn;
        for(int i=0;i<Output_CH_MAX;i++){
            find_btn = (OutputItem *)[self.view viewWithTag:i+TagStart_OutItem_Self];
            //Volume
            [find_btn.SB_Volume setProgress:RecStructData.OUT_CH[i].gain/Output_Volume_Step];
            [find_btn.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[i].gain/Output_Volume_Step] forState:UIControlStateNormal] ;
            //Polar
            if(RecStructData.OUT_CH[i].polar == 0){
                [find_btn.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
                [find_btn.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
                
            }else{
                [find_btn.Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
                [find_btn.Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
            }
            //Mute
            if(RecStructData.OUT_CH[i].mute == 0){
                [find_btn.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
            }else{
                [find_btn.Btn_Mute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
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
    OldLinkChannel=2;
    OldChannelSel=3;
}


@end

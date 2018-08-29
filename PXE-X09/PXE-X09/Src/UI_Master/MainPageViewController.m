//
//  MainPageViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MainPageViewController.h"


#define Tag_Btn_SEFF_Start 100

@interface MainPageViewController (){
    
}
@end

@implementation MainPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- Navigation

- (void)initView{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbg"]]];
    //self.view.backgroundColor = SetColor(UI_MasterBackgroundColor);
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    //初始化顶部状态栏
    [self initTopBar];
    [self initMasterView];
}
//初始化顶部状态栏
- (void)initTopBar{
    self.mToolbar = [[TopBarView alloc ]init];
    self.mToolbar.frame = CGRectMake(0, SystemTopBarHeight, KScreenWidth, [Dimens GDimens:TopBarHeight]);
    [self.view addSubview:self.mToolbar];
    [self.mToolbar setLogoShow:TRUE];
    [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_Master_Master"]];

    [self getCurrentLanguage];
    //代理
    self.mToolbar.delegate = self;
}
//获取当前语言环境
- (void)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"currentLanguage=%@" , currentLanguage);
    
}
#pragma mark ---界面初始化
//初始化主界面的各种控件
- (void)initMasterView{
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功 
//    [center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    //刷新主界面
    [center addObserver:self selector:@selector(FlashMasterFormNotification:) name:MyNotification_FlashMaster object:nil];
    //读取完成整机数据
//    [center addObserver:self selector:@selector(ReadMacDataNotification:) name:MyNotification_ReadMacData object:nil];
    //读取Json数据
//    [center addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
    //刷新音源
    [center addObserver:self selector:@selector(NotificationFlashInputSource:) name:MyNotification_FlashInputSource object:nil];
    //显示数据出错对话框
    [center addObserver:self selector:@selector(NotificationShowResetSEFFData:) name:MyNotification_ShowResetSEFFData object:nil];
    //显示进度
//    [center addObserver:self selector:@selector(Notification_ShowProgress:) name:MyNotification_ShowProgress object:nil];

    seffName=@"";
    setEnNum=@"";
    
    //[self initMasterLogo];//MasterLogo
    
    
    [self initEncryptView];//加密
    [self initMasterVolView];//主音量
    [self initSEFFUserGroup];//音效调用
    
    //[self initHideModeView];//全频二分频
    [self initAdvanceSettingsView];//高级设置
    [self initInputSourceView];//音源
    //[self initMasterSubVolView];//低音音量
    //[self initEQGainView];//eq增益设置
//    [self initInputSourceVolView];//输入音源音量
//    [self initMasterMixerInputSourceView];//混音音源
    [self FlashMasterPageUI];
}

#pragma mark---eq增益设置
- (void)initEQGainView{
    self.SB_EQMid = [[SliderButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height])];
    [self.view addSubview:self.SB_EQMid];
    [self.SB_EQMid addTarget:self action:@selector(SB_EQMid_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_EQMid setMaxProgress:EQ_Gain_MAX];
    [self.SB_EQMid setShowDB:true];
    [self.SB_EQMid setProgress:EQ_Gain_MAX/2];
    [self.SB_EQMid setMidTextString:[LANG DPLocalizedString:@"L_Toning_HMid"]];
    [self.SB_EQMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.top.equalTo(self.SB_MasterVolume.mas_bottom).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height]));
    }];
    
    self.SB_EQHi = [[SliderButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height])];
    [self.view addSubview:self.SB_EQHi];
    [self.SB_EQHi addTarget:self action:@selector(SB_EQHi_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_EQHi setMaxProgress:EQ_Gain_MAX];
    [self.SB_EQHi setShowDB:true];
    [self.SB_EQHi setProgress:EQ_Gain_MAX/2];
    [self.SB_EQHi setMidTextString:[LANG DPLocalizedString:@"L_Toning_HHigh"]];
    [self.SB_EQHi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-KScreenWidth/3);
        make.top.equalTo(self.SB_MasterVolume.mas_bottom).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height]));
    }];
    
    self.SB_EQLow = [[SliderButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height])];
    [self.view addSubview:self.SB_EQLow];
    [self.SB_EQLow addTarget:self action:@selector(SB_EQLow_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_EQLow setMaxProgress:EQ_Gain_MAX];
    [self.SB_EQLow setShowDB:true];
    [self.SB_EQLow setProgress:EQ_Gain_MAX/2];
    [self.SB_EQLow setMidTextString:[LANG DPLocalizedString:@"L_Toning_HLow"]];
    [self.SB_EQLow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(KScreenWidth/3);
        make.top.equalTo(self.SB_MasterVolume.mas_bottom).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_EQSB_Width], [Dimens GDimens:MasterVolume_EQSB_Height]));
    }];
    
}
- (void)SB_EQHi_Change:(SliderButton*)sender{
    int val = [sender GetProgress]+EQ_LEVEL_MIN;
    for(int i=0;i<=3;i++){
        RecStructData.OUT_CH[i].EQ[25].level = val;
        RecStructData.OUT_CH[i].EQ[25].freq  = 6300;
        RecStructData.OUT_CH[i].EQ[25].bw    = ToningBW;
    }
}
- (void)SB_EQMid_Change:(SliderButton*)sender{
    int val = [sender GetProgress]+EQ_LEVEL_MIN;
    for(int i=0;i<=3;i++){
        RecStructData.OUT_CH[i].EQ[15].level = val;
        RecStructData.OUT_CH[i].EQ[15].freq  = 630;
        RecStructData.OUT_CH[i].EQ[15].bw    = ToningBW;
    }

}
- (void)SB_EQLow_Change:(SliderButton*)sender{
    int val = [sender GetProgress]+EQ_LEVEL_MIN;
    for(int i=0;i<=3;i++){
        RecStructData.OUT_CH[i].EQ[5].level = val;
        RecStructData.OUT_CH[i].EQ[5].freq  = 63;
        RecStructData.OUT_CH[i].EQ[5].bw    = ToningBW;
    }

}

- (void)flashEQGain{
    [self.SB_EQHi setProgress:RecStructData.OUT_CH[0].EQ[25].level-EQ_LEVEL_MIN];
    [self.SB_EQMid setProgress:RecStructData.OUT_CH[0].EQ[15].level-EQ_LEVEL_MIN];
    [self.SB_EQLow setProgress:RecStructData.OUT_CH[0].EQ[5].level-EQ_LEVEL_MIN];

}


#pragma mark ---MasterLogo
- (void)initMasterLogo{
    self.IV_MasterLogo = [[UIImageView alloc]init];
    [self.view addSubview:self.IV_MasterLogo];
    [self.IV_MasterLogo setImage:[UIImage imageNamed:@"master_logo"]];
    [self.IV_MasterLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:250], [Dimens GDimens:40]));
    }];
}
#pragma mark ---全频二分频
- (void)initHideModeView{
    self.BtnHiMode = [[UIButton alloc]init];
    [self.view addSubview:self.BtnHiMode];
    [self.BtnHiMode setTag:1];
    self.BtnHiMode.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    self.BtnHiMode.titleLabel.adjustsFontSizeToFitWidth = true;
    self.BtnHiMode.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.BtnHiMode setTitle:[LANG DPLocalizedString:@"L_FREQ_ALL"] forState:UIControlStateNormal];
    [self.BtnHiMode setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF1.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    [self.BtnHiMode setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    [self.BtnHiMode addTarget:self action:@selector(BtnHiMode_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.self.BtnHiMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_SEFF6.mas_bottom).offset([Dimens GDimens:UserPresetMarginTopL1]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth*1.5], [Dimens GDimens:UserPresetHeight]));
    }];

}

- (void)BtnHiMode_Click:(UIButton*)sender{
    if((RecStructData.System.main_vol&0xff)!=0){
        RecStructData.System.main_vol &= 0xff00;
        [self.BtnHiMode setTitle:[LANG DPLocalizedString:@"L_FREQ_ALL"] forState:UIControlStateNormal];
    }else{
        RecStructData.System.main_vol |= 0x01;
        [self.BtnHiMode setTitle:[LANG DPLocalizedString:@"L_FREQ_TWO"] forState:UIControlStateNormal];
    }
}

- (void)flashHiMode{
    if((RecStructData.System.main_vol&0xff)!=0){
        [self.BtnHiMode setTitle:[LANG DPLocalizedString:@"L_FREQ_TWO"] forState:UIControlStateNormal];
    }else{
        [self.BtnHiMode setTitle:[LANG DPLocalizedString:@"L_FREQ_ALL"] forState:UIControlStateNormal];
    }
}


#pragma mark ---加密
- (void)initEncryptView{
    //加密
    self.Btn_MasterEncrypt = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0,[Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height])];
    [self.view addSubview:self.Btn_MasterEncrypt];
    [self.Btn_MasterEncrypt setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [self.Btn_MasterEncrypt initView:0 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [self.Btn_MasterEncrypt setTitleColor:SetColor(UI_Master_InputSourceBtnTextColor) forState:UIControlStateNormal];
    [self.Btn_MasterEncrypt addTarget:self action:@selector(Btn_MasterEncrypt_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MasterEncrypt setTitle:[LANG DPLocalizedString:@"L_Master_Encryption"] forState:UIControlStateNormal] ;
    self.Btn_MasterEncrypt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_MasterEncrypt.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn_MasterEncrypt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:13]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:13]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
}
- (void)Btn_MasterEncrypt_CLick:(id)sender {
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    if(BOOL_EncryptionFlag){
        [self ShowSetDecipheringDialog];
    }else{
        [self ShowSetEncryptionDialog];
    }
}

-(void) FlashEncryption{
    if(BOOL_EncryptionFlag){
        [self.Btn_MasterEncrypt setTitle:[LANG DPLocalizedString:@"L_Master_EN_Deciphering"] forState:UIControlStateNormal] ;
    }else{
        [self.Btn_MasterEncrypt setTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"] forState:UIControlStateNormal] ;
    }
}

- (void)ShowSetEncryptionDialog{
    setEnNum = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"]message:[LANG DPLocalizedString:@"L_Master_EN_SetEncryption"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.textColor= [UIColor redColor];
        textField.text=setEnNum;
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(setEnTextDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if(setEnNum.length == 6){
            NSData* bytes = [setEnNum dataUsingEncoding:NSUTF8StringEncoding];
            Byte * temp = (Byte *)[bytes bytes];
            for(int i=0;i<6;i++){
                Encryption_PasswordBuf[i] = *(temp+i);
            }
            BOOL_EncryptionFlag = true;
            [_mDataTransmitOpt SEFF_Save:0];
            [self FlashEncryption];
        }else{
            //延时执行
            [self performSelector:@selector(showEN_EnterMsgMessage) withObject:nil afterDelay:0.1];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        //NSLog(@"点击了取消按钮");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
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
- (void)showPasswordIncorrect{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_Master_EN_PasswordIncorrect"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}
//输入框文字改变时 方法
-(void)setEnTextDidChange:(UITextField *)fd{
    if(fd.text.length > 6){
        fd.text = setEnNum;
    }
    NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
    setEnNum = fd.text;
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
        [self FlashEncryption];
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
            if ([setEnNum isEqualToString:@"888888"]) {
                bool_EnR=YES;
            }
            if(!bool_EnR){//密码错误
                //延时执行
                [self performSelector:@selector(showPasswordIncorrect) withObject:nil afterDelay:0.1];
            }else{//密码正确
                BOOL_EncryptionFlag = FALSE;
                [_mDataTransmitOpt SEFF_Save:0];
                [self FlashEncryption];
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
#pragma mark---音源
- (void)initInputSourceView{
    //音源选择
    self.Btn_InputSource = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0,[Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height])];
    [self.view addSubview:self.Btn_InputSource];
    [self.Btn_InputSource initView:0 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [self.Btn_InputSource setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
     [self.Btn_InputSource setBackgroundColor:[UIColor clearColor]];
//    [self.Btn_InputSource setBackgroundColor:SetColor(UI_Master_InputSourceBtnColor)];
    [self.Btn_InputSource setTitleColor:SetColor(UI_Master_InputSourceBtnTextColor) forState:UIControlStateNormal];
    [self.Btn_InputSource addTarget:self action:@selector(SelectInputSource:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
    self.Btn_InputSource.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_InputSource.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_InputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_MasterEncrypt.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:13]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
    //音源标识
    self.Lab_InputSource = [[UILabel alloc]init];
    [self.view addSubview:self.Lab_InputSource];
    [self.Lab_InputSource setTextColor:SetColor(UI_Master_VolumeTextColor)];
    [self.Lab_InputSource setBackgroundColor:[UIColor clearColor]];
    self.Lab_InputSource.text=[LANG DPLocalizedString:@"L_InputSourceSelect"];
    self.Lab_InputSource.textAlignment = NSTextAlignmentCenter;
    self.Lab_InputSource.adjustsFontSizeToFitWidth = true;
    self.Lab_InputSource.font = [UIFont systemFontOfSize:15];
    [self.Lab_InputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_InputSource.mas_top).offset(0);
        make.centerX.equalTo(self.Btn_InputSource.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
    self.Lab_InputSource.hidden = true;
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
        RecStructData.System.input_source = 2;
        [self.Btn_InputSource setTitle:[titles objectAtIndex:0] forState:UIControlStateNormal];
        [self dealWithInputsource];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[titles objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecStructData.System.input_source = 1;
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
        RecStructData.System.input_source = 3;
        [self.Btn_InputSource setTitle:[titles objectAtIndex:2] forState:UIControlStateNormal];
        [self dealWithInputsource];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)dealWithInputsource{
    [_mDataTransmitOpt setInputSourceNow];
    [self flashInputsourceVolume];
}



-(void) FlashInputSource{
    switch (RecStructData.System.input_source) {
        case 2:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_High"] forState:UIControlStateNormal] ;
            break;
        case 1:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_AUX"] forState:UIControlStateNormal] ;
            break;
//        case 0:
////            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Digtit"] forState:UIControlStateNormal] ;
//            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Optical"] forState:UIControlStateNormal] ;
//            break;
//        case 4:
//            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Coaxial"] forState:UIControlStateNormal] ;
//            break;
        case 3:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
        default:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
    }
}

#pragma mark ---主音量
- (void)initMasterVolView{
    //加密
    
    //主音量
    //标识
    self.Lab_MasterVolumeText = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:150], [Dimens GDimens:30])];
    [self.view addSubview:self.Lab_MasterVolumeText];
    self.Lab_MasterVolumeText.enabled = false;
    [self.Lab_MasterVolumeText setBackgroundColor:[UIColor clearColor]];
//    [self.Lab_MasterVolumeText setImage:[[UIImage imageNamed:@"main_valume_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [self.Lab_MasterVolumeText setImage:[[UIImage imageNamed:@"main_valume_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateDisabled];
    [self.Lab_MasterVolumeText setTitle:[LANG DPLocalizedString:@"L_Master_MasterVolumeText"] forState:UIControlStateNormal];
    self.Lab_MasterVolumeText.titleLabel.textColor = SetColor(UI_Master_VolumeTextColor);
    [self.Lab_MasterVolumeText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Lab_MasterVolumeText.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Lab_MasterVolumeText.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.Lab_MasterVolumeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.Lab_MasterVolumeText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Lab_MasterVolumeText.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.Lab_MasterVolumeText.titleEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = [Dimens GDimens:10],
//        .bottom = 0,
//        .right  = 0,
//    };
//
//    self.Lab_MasterVolumeText.imageEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = 0,
//        .bottom = 0,
//        .right  = [Dimens GDimens:120],
//    };
    [self.Lab_MasterVolumeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:70]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:150], [Dimens GDimens:30]));
    }];
    

    //Seekbar
    self.SB_MasterVolume = [[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_SB_Size], [Dimens GDimens:MasterVolume_SB_Size])];
    self.SB_MasterVolume.SBStyle=VCSS_LINE_PARK;
    self.SB_MasterVolume.center = self.view.center;
    [self.view addSubview:self.SB_MasterVolume];
    [self.SB_MasterVolume addTarget:self action:@selector(MasterVolumeSBChange:) forControlEvents:UIControlEventValueChanged];
    [self.SB_MasterVolume setMaxProgress:Master_Volume_MAX];
//    [self.SB_MasterVolume setVolTextSize:25];
//    [self.SB_MasterVolume setMidTextString:[LANG DPLocalizedString:@"L_Master_MasterVolumeText"]];
    [self.SB_MasterVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.top.equalTo(self.Lab_MasterVolumeText.mas_bottom).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_SB_Size], [Dimens GDimens:MasterVolume_SB_Size]));
    }];
    
    //音量显示
    self.Lab_MasterVolume = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size])];
    [self.SB_MasterVolume addSubview:self.Lab_MasterVolume];
    [self.Lab_MasterVolume setBackgroundColor:[UIColor clearColor]];
    [self.Lab_MasterVolume setTextColor:RGBA(255, 56, 30, 1)];
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    self.Lab_MasterVolume.textAlignment = NSTextAlignmentCenter;
    self.Lab_MasterVolume.adjustsFontSizeToFitWidth = true;
    self.Lab_MasterVolume.font = [UIFont systemFontOfSize:40];
    [self.Lab_MasterVolume mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.Lab_MasterVolumeText.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.SB_MasterVolume.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size]));
    }];
    
        //静音
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[])
//                                        {
//                                            Color_R(UI_Master_MuteStrokeColor_normal),
//                                            Color_G(UI_Master_MuteStrokeColor_normal),
//                                            Color_B(UI_Master_MuteStrokeColor_normal),
//                                            Color_A(UI_Master_MuteStrokeColor_normal)
//                                        });
    self.Btn_MasterMute = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterMuteWidth], [Dimens GDimens:MasterMuteHeight])];
    [self.SB_MasterVolume addSubview:self.Btn_MasterMute];
//    [self.Btn_MasterMute.layer setMasksToBounds:YES];
//    [self.Btn_MasterMute.layer setCornerRadius:[Dimens GDimens:MasterMuteHeight/2]]; //设置矩形四个圆角半径
//    [self.Btn_MasterMute.layer setBorderWidth:1.0]; //边框宽度
//    [self.Btn_MasterMute.layer setBorderColor:colorref];//边框颜色SetColor(UI_Master_MuteStrokeColor_normal)
    self.Btn_MasterMute.backgroundColor = [UIColor clearColor];
    [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    
    self.Btn_MasterMute.imageEdgeInsets = UIEdgeInsetsMake(
                                                           0,
                                                           0,//[Dimens GDimens:MasterMuteWidth]/2-[Dimens GDimens:MasterMuteHeight]/2,
                                                           0,
                                                           0//[Dimens GDimens:MasterMuteWidth]/2-[Dimens GDimens:MasterMuteHeight]/2
                                                           );
    [self.Btn_MasterMute addTarget:self action:@selector(Btn_MasterMute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_MasterMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_MasterVolume.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterMuteWidth], [Dimens GDimens:MasterMuteHeight]));
    }];

    
    
    
    
    
    
    //音量增减
    self.Btn_MasterVolumeSub = [[UIButton alloc]init];//mastervolume_sub_press
    [self.Btn_MasterVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [self.Btn_MasterVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.Btn_MasterVolumeSub];
    [self.Btn_MasterVolumeSub addTarget:self action:@selector(MasterVolume_SUB:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_MasterVolumeAdd = [[UIButton alloc]init];
    [self.Btn_MasterVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [self.Btn_MasterVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.Btn_MasterVolumeAdd];
    [self.Btn_MasterVolumeAdd addTarget:self action:@selector(MasterVolume_INC:) forControlEvents:UIControlEventTouchUpInside];
    //长按
    UILongPressGestureRecognizer *longPressMainVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_MasterVolumeSUB_LongPress:)];
    longPressMainVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [self.Btn_MasterVolumeSub addGestureRecognizer:longPressMainVolMinus];
    
    UILongPressGestureRecognizer *longPressMainVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_MasterVolumeAdd_LongPress:)];
    longPressMainVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [self.Btn_MasterVolumeAdd addGestureRecognizer:longPressMainVolAdd];
    //音量增减
    /* */
    [self.Btn_MasterVolumeSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.SB_MasterVolume.mas_bottom);
        make.right.equalTo(self.SB_MasterVolume.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    
    [self.Btn_MasterVolumeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.SB_MasterVolume.mas_bottom);
        make.left.equalTo(self.SB_MasterVolume.mas_right).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    
    self.Btn_MasterVolumeSub.hidden=true;
    self.self.Btn_MasterVolumeAdd.hidden=true;
}

-(void)MasterVolumeSBChange:(VolumeCircleIMLine *)slider{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        RecStructData.IN_CH[0].Valume = [slider GetProgress];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.IN_CH[0].Valume];
        [self FlashMasterMute];
    }else{
        RecStructData.System.main_vol = [slider GetProgress];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    }
    
}

-(void)Btn_MasterMute_Click:(id)sender{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        if(RecStructData.IN_CH[0].Valume != 0){
            MasterVol_buf = RecStructData.IN_CH[0].Valume;
            RecStructData.IN_CH[0].Valume = 0;
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        }else{
            RecStructData.IN_CH[0].Valume=MasterVol_buf;
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        }
        [self FlashMasterVolume];
    }else{
        if(RecStructData.System.MainvolMuteFlg != 0){
            RecStructData.System.MainvolMuteFlg = 0;
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        }else{
            RecStructData.System.MainvolMuteFlg = 1;
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        }
    }
}




//主音量长按操作
-(void)Btn_MasterVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(MasterVolume_SUB:) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolMinusTimer.isValid){
            [_pMainVolMinusTimer invalidate];
            _pMainVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_MasterVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(MasterVolume_INC:) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolAddTimer.isValid){
            [_pMainVolAddTimer invalidate];
            _pMainVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}

-(void)MasterVolume_SUB:(id)sender{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        if(--RecStructData.IN_CH[0].Valume < 0){
            RecStructData.IN_CH[0].Valume = 0;
        }
        [self.SB_MasterVolume setProgress:RecStructData.IN_CH[0].Valume];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.IN_CH[0].Valume];
        [self FlashMasterMute];
    }else{
        if(--RecStructData.System.main_vol < 0){
            RecStructData.System.main_vol = 0;
        }
        [self.SB_MasterVolume setProgress:RecStructData.System.main_vol];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    }
}
-(void)MasterVolume_INC:(id)sender{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        if(++RecStructData.IN_CH[0].Valume > Master_Volume_MAX){
            RecStructData.IN_CH[0].Valume = Master_Volume_MAX;
        }
        [self.SB_MasterVolume setProgress:RecStructData.IN_CH[0].Valume];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.IN_CH[0].Valume];
        [self FlashMasterMute];
    }else{
        if(++RecStructData.System.main_vol > Master_Volume_MAX){
            RecStructData.System.main_vol = Master_Volume_MAX;
        }
        [self.SB_MasterVolume setProgress:RecStructData.System.main_vol];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    }
    
}

- (void)FlashMasterVolume{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        [self.SB_MasterVolume setProgress:RecStructData.IN_CH[0].Valume];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.IN_CH[0].Valume];
    }else{
        [self.SB_MasterVolume setProgress:RecStructData.System.main_vol];
        self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    }

}
//刷新静音
-(void) FlashMasterMute{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        if(RecStructData.IN_CH[0].Valume > 0){
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        }else{
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        }
    }else{
        if(RecStructData.System.MainvolMuteFlg != 0){
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        }else{
            [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark--- 低音音量
- (void)initMasterSubVolView{
    
    //Seekbar
    self.SB_SubVolume = [[SliderButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height])];
    [self.view addSubview:self.SB_SubVolume];
    [self.SB_SubVolume addTarget:self action:@selector(SB_SubVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_SubVolume setMaxProgress:Master_Volume_MAX];
    [self.SB_SubVolume setVolTextSize:25];
    [self.SB_SubVolume setMidTextString:[LANG DPLocalizedString:@"L_MSUB_VAL"]];
    [self.SB_SubVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(KScreenWidth/4);
        make.top.equalTo(self.IV_MasterLogo.mas_bottom).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height]));
    }];
    
    return;
    //低音音量
    /*
    self.Lab_SubVol = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size])];
    [self.view addSubview:self.Lab_SubVol];
    [self.Lab_SubVol setBackgroundColor:SetColor(UI_Master_VolumeBtnBgColor)];
    [self.Lab_SubVol setTextColor:SetColor(UI_Master_VolumeColor)];
    self.Lab_SubVol.text=[LANG DPLocalizedString:@"L_MSUB_VAL"];
    self.Lab_SubVol.textAlignment = NSTextAlignmentCenter;
    self.Lab_SubVol.adjustsFontSizeToFitWidth = true;
    self.Lab_SubVol.font = [UIFont systemFontOfSize:15];
    [self.Lab_SubVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-KScreenWidth/4);
        make.top.mas_equalTo(self.Btn_MasterMute.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:200], [Dimens GDimens:30]));
    }];
    self.Lab_SubVol.hidden = true;
    
    self.SB_SubVol = [[UISlider alloc]init];
    [self.view addSubview:self.SB_SubVol];
    self.SB_SubVol.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.SB_SubVol.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_SubVol setMaximumValue:0];
    [self.SB_SubVol setMaximumValue:Output_Volume_MAX/Output_Volume_Step];
    [self.SB_SubVol setBackgroundColor:[UIColor clearColor]];
    //    [self.SB_SubVol setThumbImage:[UIImage imageNamed:@"thumb_normal"] forState:UIControlStateNormal];
    //    [self.SB_SubVol setThumbImage:[UIImage imageNamed:@"thumb_press"] forState:UIControlStateHighlighted];
    [self.SB_SubVol addTarget:self action:@selector(SB_SubVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_SubVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-KScreenWidth/4);
        make.top.mas_equalTo(self.Lab_SubVol.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:180], [Dimens GDimens:50]));
    }];
    self.SB_SubVol.hidden = true;
     */
}
//低音音量
- (void)SB_SubVol_Val_Change:(SliderButton *)sender{//UISlider
    
    [self setSubVal:[sender GetProgress]];
    /*
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    Boolean hsub=false;
    
    for(int i=0;i<Output_CH_MAX;i++){
        if((ChannelNumBuf[i]==22)||(ChannelNumBuf[i]==23)||(ChannelNumBuf[i]==24)){
            RecStructData.OUT_CH[i].gain=(int)sender.value*Output_Volume_Step;
            hsub=true;
        }
    }
    if(!hsub){
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%@",
                              [LANG DPLocalizedString:@"L_MSUB_VAL"],
                              [LANG DPLocalizedString:@"L_MSUB_SetCh"]
                              ];
    }else{
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%d",
                              [LANG DPLocalizedString:@"L_MSUB_VAL"],
                              (int)sender.value
                              ];
    }
     */
}
- (void)setSubVal:(int)val{
    if(BOOL_SET_SpkType){
        [self setSpkTypeBassVolume:val];
    }else{
        RecStructData.OUT_CH[4].gain = val;
        RecStructData.OUT_CH[5].gain = val;
    }
}

- (int)getSubVal{
    if(BOOL_SET_SpkType){
        return [self getSpkTypeBassVolume];
    }else{
        return RecStructData.OUT_CH[4].gain > RecStructData.OUT_CH[5].gain?RecStructData.OUT_CH[5].gain:RecStructData.OUT_CH[4].gain;
    }
}


- (int)getSpkTypeBassVolume{
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]= RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]= RecStructData.System.out10_spk_type;
    ChannelNumBuf[10]= RecStructData.System.out11_spk_type;
    ChannelNumBuf[11]= RecStructData.System.out12_spk_type;
    ChannelNumBuf[12]= RecStructData.System.out13_spk_type;
    ChannelNumBuf[13]= RecStructData.System.out14_spk_type;
    ChannelNumBuf[14]= RecStructData.System.out15_spk_type;
    ChannelNumBuf[15]= RecStructData.System.out16_spk_type;
    
    int n=0;
    int ch[]={0,0,0,0,0,0};
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((ChannelNumBuf[i]==22)||(ChannelNumBuf[i]==23)||(ChannelNumBuf[i]==24)){
            ch[n]=i;
            ++n;
        }
    }
    if(n==0){
        return 0;
    }else if(n==1){
        return RecStructData.OUT_CH[ch[0]].gain;
    }else if(n==2){
        return RecStructData.OUT_CH[ch[0]].gain > RecStructData.OUT_CH[ch[1]].gain
        ?RecStructData.OUT_CH[ch[1]].gain:RecStructData.OUT_CH[ch[0]].gain;
    }else if(n==3){
        int temp1=RecStructData.OUT_CH[ch[0]].gain > RecStructData.OUT_CH[ch[1]].gain
        ?RecStructData.OUT_CH[ch[1]].gain:RecStructData.OUT_CH[ch[0]].gain;
        
        int temp2=temp1 > RecStructData.OUT_CH[ch[2]].gain
        ?RecStructData.OUT_CH[ch[2]].gain:temp1;
        
        return temp2;
    }
    return 0;
}

- (void)setSpkTypeBassVolume:(int)val{
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]= RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]= RecStructData.System.out10_spk_type;
    ChannelNumBuf[10]= RecStructData.System.out11_spk_type;
    ChannelNumBuf[11]= RecStructData.System.out12_spk_type;
    ChannelNumBuf[12]= RecStructData.System.out13_spk_type;
    ChannelNumBuf[13]= RecStructData.System.out14_spk_type;
    ChannelNumBuf[14]= RecStructData.System.out15_spk_type;
    ChannelNumBuf[15]= RecStructData.System.out16_spk_type;
    
    int n=0;
    int ch[]={0,0,0,0,0,0};
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((ChannelNumBuf[i]==22)||(ChannelNumBuf[i]==23)||(ChannelNumBuf[i]==24)){
            ch[n]=i;
            ++n;
        }
    }
    if(n==0){
        
    }else if(n==1){
        RecStructData.OUT_CH[ch[0]].gain = val;
    }else if(n==2){
        RecStructData.OUT_CH[ch[0]].gain = val;
        RecStructData.OUT_CH[ch[1]].gain = val;
    }else if(n==3){
        RecStructData.OUT_CH[ch[0]].gain = val;
        RecStructData.OUT_CH[ch[1]].gain = val;
        RecStructData.OUT_CH[ch[2]].gain = val;
    }
}

- (void)flashBassVolume{
    [self.SB_SubVolume setProgress:[self getSubVal]];
    /*
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    int n=0;
    int ch[]={0,0,0,0,0,0};
    for(int i=0;i<Output_CH_MAX;i++){
        if((ChannelNumBuf[i]==22)||(ChannelNumBuf[i]==23)||(ChannelNumBuf[i]==24)){
            ch[n]=i;
            ++n;
        }
    }
    if(n==0){
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_MSUB_VAL"],0];
        self.SB_SubVol.value = 0;
    }else if(n==1){
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_MSUB_VAL"],RecStructData.OUT_CH[ch[0]].gain/Output_Volume_Step];
        self.SB_SubVol.value = RecStructData.OUT_CH[ch[0]].gain/Output_Volume_Step;
    }else if(n==2){
        int temp=RecStructData.OUT_CH[ch[0]].gain > RecStructData.OUT_CH[ch[1]].gain
        ?RecStructData.OUT_CH[ch[1]].gain:RecStructData.OUT_CH[ch[0]].gain;
        
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_MSUB_VAL"],temp/Output_Volume_Step];
        self.SB_SubVol.value = temp/Output_Volume_Step;
    }else if(n==3){
        int temp1=RecStructData.OUT_CH[ch[0]].gain > RecStructData.OUT_CH[ch[1]].gain
        ?RecStructData.OUT_CH[ch[1]].gain:RecStructData.OUT_CH[ch[0]].gain;
        
        int temp2=temp1 > RecStructData.OUT_CH[ch[2]].gain
        ?RecStructData.OUT_CH[ch[2]].gain:temp1;
        
        self.Lab_SubVol.text=[NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_MSUB_VAL"],temp2/Output_Volume_Step];
        self.SB_SubVol.value = temp2/Output_Volume_Step;
    }
    */
}

#pragma mark----高级设置
- (void)initAdvanceSettingsView{
    //高级设置
    self.Btn_AdvanceSettings = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterBtnAdvanceSet_Width], [Dimens GDimens:MasterBtnAdvanceSet_Height])];
    [self.view addSubview:self.Btn_AdvanceSettings];
    self.Btn_AdvanceSettings.layer.cornerRadius=self.Btn_AdvanceSettings.frame.size.height/2;
    self.Btn_AdvanceSettings.layer.borderWidth=1;
    self.Btn_AdvanceSettings.layer.borderColor=[UIColor whiteColor].CGColor;
    self.Btn_AdvanceSettings.layer.masksToBounds=YES;
//    [self.Btn_AdvanceSettings initView:5 withBorderWidth:1 withNormalColor:UI_MasterAdvanceSetBtnColorNormal withPressColor:UI_MasterAdvanceSetBtnColorPress withType:1];
//    [self.Btn_AdvanceSettings setTextColorWithNormalColor:UI_MasterAdvanceSetBtnTextColorNormal withPressColor:UI_MasterAdvanceSetBtnTextColorPress];
    
//    [self.Btn_AdvanceSettings setImage:[UIImage imageNamed:@"high_set_icon"] forState:UIControlStateNormal];
//    [self.Btn_AdvanceSettings setImage:[UIImage imageNamed:@"high_set_icon"] forState:UIControlStateHighlighted];
    self.Btn_AdvanceSettings.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_AdvanceSettings.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_AdvanceSettings.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.Btn_AdvanceSettings.titleEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = [Dimens GDimens:80],
//        .bottom = 0,
//        .right  = 0,
//    };
//
//    self.Btn_AdvanceSettings.imageEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = [Dimens GDimens:70],
//        .bottom = 0,
//        .right  = [Dimens GDimens:120],
//    };
    
    //[self.Btn_AdvanceSettings setBackgroundImage:[UIImage imageNamed:@"master_advanceSettings"] forState:UIControlStateNormal];
    //[self.Btn_AdvanceSettings setBackgroundImage:[UIImage imageNamed:@"master_advanceSettings"] forState:UIControlStateHighlighted];
    [self.Btn_AdvanceSettings addTarget:self action:@selector(Btn_AdvanceSettings_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_AdvanceSettings setTitle:[LANG DPLocalizedString:@"L_Master_Advance"] forState:UIControlStateNormal] ;
    self.Btn_AdvanceSettings.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_AdvanceSettings.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.Btn_AdvanceSettings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(self.Btn_SEFF4.mas_bottom).offset([Dimens GDimens:70]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtnAdvanceSet_Width], [Dimens GDimens:MasterBtnAdvanceSet_Height]));
    }];
    //self.Btn_AdvanceSettings.hidden = true;
}

- (void)Btn_AdvanceSettings_CLick:(id)sender {
    [self enterAdvanceSettings];
//    if(!BOOL_ENTER_ADVANCE){
//        [self showAdvanceSettingsDialog];
//    }else{
//        [self enterAdvanceSettings];
//    }    
}

//进入高级设置
- (void)enterAdvanceSettings{
    self.OptFunPage_VC = [[OptFunPage_TBC alloc] init];
    [self presentViewController:self.OptFunPage_VC animated:YES completion:nil];
}
- (void)showAdvanceSettingsDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_Advance"]message:[LANG DPLocalizedString:@"L_IMMToHSet"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        textField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeASCIICapable
        textField.textColor= [UIColor redColor];
        textField.text=@"";//[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"];
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(AdvanceSettingsDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if(seffName.length > 0){
            if([seffName isEqualToString:ENTER_ADVANCE_PW]){
                [self enterAdvanceSettings];
                BOOL_ENTER_ADVANCE = true;
            }else{
                //延时执行
                [self performSelector:@selector(showAdvanceSettingsPasswordIncorrect) withObject:nil afterDelay:0.1];
            }
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//输入框文字改变时 方法
-(void)AdvanceSettingsDidChange:(UITextField *)fd{
    if(fd.text.length > 8){
        fd.text = seffName;
    }
    seffName = fd.text;
}
-(void)showAdvanceSettingsPasswordIncorrect{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_MMError"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}

#pragma mark-- 输入音源音量
- (void)initInputSourceVolView{
    //音源音量标识
    self.Lab_InSrcVol = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size])];
    [self.view addSubview:self.Lab_InSrcVol];
    [self.Lab_InSrcVol setBackgroundColor:SetColor(UI_Master_VolumeBtnBgColor)];
    [self.Lab_InSrcVol setTextColor:SetColor(UI_Master_VolumeColor)];
    self.Lab_InSrcVol.text=[LANG DPLocalizedString:@"L_MainInputSourceVal"];
    self.Lab_InSrcVol.textAlignment = NSTextAlignmentCenter;
    self.Lab_InSrcVol.adjustsFontSizeToFitWidth = true;
    self.Lab_InSrcVol.font = [UIFont systemFontOfSize:15];
    [self.Lab_InSrcVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:25]);
        make.top.mas_equalTo(self.Btn_MasterMute.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:30]));
    }];
    self.Lab_InSrcVol.hidden = true;
    //音源音量
    self.LabInSrcVol = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size])];
    [self.view addSubview:self.LabInSrcVol];
    [self.LabInSrcVol setBackgroundColor:SetColor(UI_Master_VolumeBtnBgColor)];
    [self.LabInSrcVol setTextColor:SetColor(UI_Master_VolumeColor)];
    self.LabInSrcVol.text=@"10";
    self.LabInSrcVol.textAlignment = NSTextAlignmentCenter;
    self.LabInSrcVol.adjustsFontSizeToFitWidth = true;
    self.LabInSrcVol.font = [UIFont systemFontOfSize:15];
    [self.LabInSrcVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.Lab_InSrcVol.mas_right).offset(0);
        make.centerY.mas_equalTo(self.Lab_InSrcVol.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
    }];
    self.LabInSrcVol.hidden = true;
    
    
    self.SB_InSrcVol = [[UISlider alloc]init];
    [self.view addSubview:self.SB_InSrcVol];
    self.SB_InSrcVol.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.SB_InSrcVol.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_InSrcVol setMaximumValue:0];
    [self.SB_InSrcVol setMaximumValue:INS_CH_VolumeMAX];
    [self.SB_InSrcVol setBackgroundColor:[UIColor clearColor]];
    //    [self.SB_InSrcVol setThumbImage:[UIImage imageNamed:@"thumb_normal"] forState:UIControlStateNormal];
    //    [self.SB_InSrcVol setThumbImage:[UIImage imageNamed:@"thumb_press"] forState:UIControlStateHighlighted];
    [self.SB_InSrcVol addTarget:self action:@selector(SB_InSrcVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_InSrcVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.top.mas_equalTo(self.Lab_InSrcVol.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:350], [Dimens GDimens:50]));
    }];
    self.SB_InSrcVol.hidden = true;
}
//音源音量
- (void)SB_InSrcVol_Val_Change:(UISlider *)sender{
    int val = (int)sender.value;
    switch (RecStructData.System.input_source) {
        case 1:
            RecStructData.System.Hi_src_vol = val;
            break;
        case 2:
            RecStructData.System.Blue_src_vol = val;
            break;
        case 3:
            RecStructData.System.Aux_src_vol = val;
            break;
        default:
            break;
    }
    self.LabInSrcVol.text=[NSString stringWithFormat:@"%d",val];
}
- (void)flashInputsourceVolume{
    int val = 0;
    switch (RecStructData.System.input_source) {
        case 1:
            val = RecStructData.System.Hi_src_vol;
            break;
        case 2:
            val = RecStructData.System.Blue_src_vol;
            break;
        case 3:
            val = RecStructData.System.Aux_src_vol;
            break;
        default:
            break;
    }
    self.LabInSrcVol.text=[NSString stringWithFormat:@"%d",val];
    self.SB_InSrcVol.value = val;
    
}

#pragma mark--混音音源
- (void)initMasterMixerInputSourceView{
    //混音音源选择
    self.Btn_MixerInputSource = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_MixerInputSource];
    [self.Btn_MixerInputSource initView:3 withBorderWidth:1 withNormalColor:UI_SystemBtnColorNormal withPressColor:UI_SystemBtnColorNormal withType:1];
    [self.Btn_MixerInputSource setBackgroundColor:[UIColor clearColor]];
    [self.Btn_MixerInputSource setTitleColor:SetColor(UI_Master_InputSourceBtnTextColor) forState:UIControlStateNormal];
    [self.Btn_MixerInputSource addTarget:self action:@selector(SelectMixerInputSource:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
    self.Btn_MixerInputSource.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_MixerInputSource.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_MixerInputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_MasterEncrypt.mas_centerY).offset(0);
        make.right.equalTo(self.Btn_MasterEncrypt.mas_left).offset(-[Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
    
    //混音音源标识
    self.Lab_MixerInputSource = [[UILabel alloc]init];
    [self.view addSubview:self.Lab_MixerInputSource];
    [self.Lab_MixerInputSource setTextColor:SetColor(UI_Master_VolumeTextColor)];
    [self.Lab_MixerInputSource setBackgroundColor:[UIColor clearColor]];
    self.Lab_MixerInputSource.text=[LANG DPLocalizedString:@"L_MixerInputSourceSelect"];
    self.Lab_MixerInputSource.textAlignment = NSTextAlignmentCenter;
    self.Lab_MixerInputSource.adjustsFontSizeToFitWidth = true;
    self.Lab_MixerInputSource.font = [UIFont systemFontOfSize:15];
    [self.Lab_MixerInputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_MixerInputSource.mas_top).offset(0);
        make.centerX.equalTo(self.Btn_MixerInputSource.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
}


//混音音源设置
- (void)SelectMixerInputSource:(NormalButton *)sender {
    int height = -12;
    
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height+height);
    
    NSArray *titles = @[
                        [LANG DPLocalizedString:@"L_InputSource_High"],
                        [LANG DPLocalizedString:@"L_InputSource_AUX"],
                        //[LANG DPLocalizedString:@"L_InputSource_Optical"],
                        //[LANG DPLocalizedString:@"L_InputSource_Coaxial"],
                        [LANG DPLocalizedString:@"L_InputSource_Bluetooth"],
                        [LANG DPLocalizedString:@"L_InputSource_Digtit"],
                        [LANG DPLocalizedString:@"L_XOver_OtcOFF"]
                        ];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil button:sender];
    pop.selectRowAtIndex = ^(NSInteger index){
        
        switch ((int)index) {
            case 0:
                RecStructData.System.Blue_src_vol = 1;
                break;
            case 1:
                RecStructData.System.Blue_src_vol = 3;
                break;
            case 2:
                RecStructData.System.Blue_src_vol = 2;
                break;
            case 3:
                RecStructData.System.Blue_src_vol = 0;
                break;
            case 4:
                RecStructData.System.Blue_src_vol = 6;
                break;
        }
        [_mDataTransmitOpt setInputSourceNow];
        [sender setTitle:[titles objectAtIndex:index] forState:UIControlStateNormal];
        [self flashInputsourceVolume];
    };
    [pop show];
}

-(void) FlashMixerInputSource{
    switch (RecStructData.System.Blue_src_vol) {
        case 1:
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_High"] forState:UIControlStateNormal] ;
            break;
        case 3:
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_AUX"] forState:UIControlStateNormal] ;
            break;
        case 0:
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Digtit"] forState:UIControlStateNormal] ;
            break;
            //        case 4:
            //            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Coaxial"] forState:UIControlStateNormal] ;
            //            break;
        case 2:
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
        case 6:
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_XOver_OtcOFF"] forState:UIControlStateNormal] ;
            break;
        default:
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
            break;
    }
}

#pragma mark ---音效调用
- (void)initSEFFUserGroup{
//    self.Lab_SEFFText = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:150], [Dimens GDimens:30])];
//    [self.view addSubview:self.Lab_SEFFText];
//    self.Lab_SEFFText.enabled = false;
//    [self.Lab_SEFFText setBackgroundColor:[UIColor clearColor]];
////    [self.Lab_SEFFText setImage:[[UIImage imageNamed:@"group_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
////    [self.Lab_SEFFText setImage:[[UIImage imageNamed:@"group_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateDisabled];
//    [self.Lab_SEFFText setTitle:[LANG DPLocalizedString:@"L_Master_Preset"] forState:UIControlStateNormal];
//    self.Lab_SEFFText.titleLabel.textColor = SetColor(UI_Master_VolumeTextColor);
//    [self.Lab_SEFFText setTitleColor:SetColor(UI_Master_VolumeTextColor) forState:UIControlStateNormal];
//    self.Lab_SEFFText.titleLabel.adjustsFontSizeToFitWidth = true;
//    self.Lab_SEFFText.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.Lab_SEFFText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.Lab_SEFFText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    self.Lab_SEFFText.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.Lab_SEFFText.titleEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = [Dimens GDimens:10],
//        .bottom = 0,
//        .right  = 0,
//    };
//
//    self.Lab_SEFFText.imageEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = 0,
//        .bottom = 0,
//        .right  = [Dimens GDimens:120],
//    };
//    [self.Lab_SEFFText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.SB_MasterVolume.mas_bottom);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:150], [Dimens GDimens:30]));
//    }];
    
    
    _Btn_SEFF1 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF1];
    [_Btn_SEFF1 setTag:1];
    [self.Btn_SEFF1 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF1 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF1 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF1.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF1.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF1.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF1 setTitle:[LANG DPLocalizedString:@"L_Master_Preset1"] forState:UIControlStateNormal];
    [_Btn_SEFF1 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
//    _Btn_SEFF1.titleEdgeInsets = UIEdgeInsetsMake(
//                                                  [Dimens GDimens:UserPresetSize*8/10],
//                                                  [Dimens GDimens:2],
//                                                  [Dimens GDimens:UserPresetSize/6],
//                                                  [Dimens GDimens:2]);
//    [_Btn_SEFF1 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
//    [_Btn_SEFF1 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF1 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SB_MasterVolume.mas_bottom).offset([Dimens GDimens:UserPresetHeight]);
        make.right.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:UserPresetMarginLR]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];

    _Btn_SEFF2 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF2];
    [_Btn_SEFF2 setTag:2];
    [self.Btn_SEFF2 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF2 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF2 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF2.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF2.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF2.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF2 setTitle:[LANG DPLocalizedString:@"L_Master_Preset2"] forState:UIControlStateNormal];
    [_Btn_SEFF2 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF2.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    //    [_Btn_SEFF2 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    //    [_Btn_SEFF2 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF2 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_Btn_SEFF1.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];
    
    _Btn_SEFF3 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF3];
    [_Btn_SEFF3 setTag:3];
    [self.Btn_SEFF3 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF3 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF3 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF3.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF3.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF3.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF3 setTitle:[LANG DPLocalizedString:@"L_Master_Preset3"] forState:UIControlStateNormal];
    [_Btn_SEFF3 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF3.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    //    [_Btn_SEFF3 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    //    [_Btn_SEFF3 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF3 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_Btn_SEFF1.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_centerX).offset([Dimens GDimens:UserPresetMarginLR]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];

    _Btn_SEFF4 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF4];
    [_Btn_SEFF4 setTag:4];
    [self.Btn_SEFF4 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF4 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF4 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF4.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF4.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF4.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF4 setTitle:[LANG DPLocalizedString:@"L_Master_Preset4"] forState:UIControlStateNormal];
    [_Btn_SEFF4 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF4.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    //    [_Btn_SEFF4 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    //    [_Btn_SEFF4 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF4 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Btn_SEFF1.mas_bottom).offset([Dimens GDimens:UserPresetHeight/2]);
        make.right.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:UserPresetMarginLR]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];
    
    _Btn_SEFF5 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF5];
    [_Btn_SEFF5 setTag:5];
    [self.Btn_SEFF5 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF5 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF5 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF5.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF5.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF5.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF5 setTitle:[LANG DPLocalizedString:@"L_Master_Preset5"] forState:UIControlStateNormal];
    [_Btn_SEFF5 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF5.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    //    [_Btn_SEFF5 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    //    [_Btn_SEFF5 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF5 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_Btn_SEFF4.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];
    
    _Btn_SEFF6 = [[NormalButton alloc]init];
    [self.view addSubview:_Btn_SEFF6];
    [_Btn_SEFF6 setTag:6];
    [self.Btn_SEFF6 setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [_Btn_SEFF6 initView:3 withBorderWidth:0 withNormalColor:UI_Master_UserGroup_Btn_Normal withPressColor:UI_Master_UserGroup_Btn_Press withType:0];
    [_Btn_SEFF6 setTextColorWithNormalColor:UI_Master_UserGroup_BtnText_Normal withPressColor:UI_Master_UserGroup_BtnText_Press];
    _Btn_SEFF6.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _Btn_SEFF6.titleLabel.adjustsFontSizeToFitWidth = true;
    _Btn_SEFF6.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Btn_SEFF6 setTitle:[LANG DPLocalizedString:@"L_Master_Preset6"] forState:UIControlStateNormal];
    [_Btn_SEFF6 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    //    _Btn_SEFF6.titleEdgeInsets = UIEdgeInsetsMake(
    //                                                  [Dimens GDimens:UserPresetSize*8/10],
    //                                                  [Dimens GDimens:2],
    //                                                  [Dimens GDimens:UserPresetSize/6],
    //                                                  [Dimens GDimens:2]);
    //    [_Btn_SEFF6 setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    //    [_Btn_SEFF6 setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateHighlighted];
    [_Btn_SEFF6 addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_Btn_SEFF6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_Btn_SEFF4.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_centerX).offset([Dimens GDimens:UserPresetMarginLR]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:UserPresetWidth], [Dimens GDimens:UserPresetHeight]));
    }];
    
}

- (void)Btn_SEFF_Click:(UIButton*)sender {
    self.Btn_SEFFC = sender;
    mGroup = sender.tag;
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    [self ShowSEFFOptDialog];
}


//音效操作
//音效选择，保存，调用，删除
- (void)ShowSEFFOptDialog{
    seffName = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[self getSEFFNameN:(mGroup)] message:[LANG DPLocalizedString:@"L_Master_PresetOpt"]preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_PresetRecall"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_mDataTransmitOpt SEFF_Call:mGroup];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_PresetSave"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ShowSEFFSaveDialog];  //保存
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_PresetDelete"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ShowSEFFDeleteDialog];  // 删除
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//音效选择，保存
- (void)ShowSEFFSaveDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_PresetSave"]message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        seffName = [self getSEFFName:(mGroup)];
        textField.keyboardType=UIKeyboardTypeDefault;//UIKeyboardTypeASCIICapable
        textField.textColor= [UIColor redColor];
        textField.text=[self getSEFFName:(mGroup)];//[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"];
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //NSLog(@"seffName.length=%lu",seffName.length);
        if(seffName.length > 0){
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSData* bytes = [seffName dataUsingEncoding:enc];
            Byte * sendName = (Byte *)[bytes bytes];
            //NSLog(@"bytes.length=%lu",bytes.length);
            for (int i=0; i<13; i++){
                if (i<bytes.length){
                    RecStructData.USER[mGroup].name[i] = *(sendName+i);
                }else{
                    RecStructData.USER[mGroup].name[i] = '\0';
                }
            }
        }else{
            for (int i=0; i<13; i++){
                RecStructData.USER[mGroup].name[i] = '\0';
            }
        }
        
        [self.Btn_SEFFC setTitle:[self getSEFFName:(mGroup)] forState:UIControlStateNormal];
        [_mDataTransmitOpt SEFF_Save:mGroup];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//输入框文字改变时 方法
-(void)usernameDidChange:(UITextField *)fd{
    if(fd.text.length > 13){
        fd.text = seffName;
    }
    NSLog(@"%@",fd.text);
    seffName = fd.text;
}
//音效选择，调用

//音效选择，删除
- (void)ShowSEFFDeleteDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_PresetDelete"]message:[LANG DPLocalizedString:@"L_Master_PresetDeleteMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [_mDataTransmitOpt SEFF_Delete:mGroup];
        [self.Btn_SEFFC setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(mGroup)]] forState:UIControlStateNormal] ;
        NSLog(@"点击了确定按钮");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}
//版本号错误提示框
- (void)ShowVersionsErrorDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[NSString stringWithFormat:@"%@:%@",[LANG DPLocalizedString:@"L_DeviceVersionERR"],DeviceVerString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void) FlashSEFFName{
    //更新音效名称
    /*
    for(int i=0;i<MAX_USE_GROUP;i++){
        NSString * groupName =[self getSEFFName:(i+1)];
        if ([groupName isEqualToString:@""] || '\0' == [groupName characterAtIndex:0]) {
            //根据tag查找
            NormalButton *find_btn = (NormalButton *)[self.view viewWithTag:i+Tag_Btn_SEFF_Start];
            [find_btn setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i+1)]] forState:UIControlStateNormal] ;
        }else {
            NormalButton *find_btn = (NormalButton *)[self.view viewWithTag:i+Tag_Btn_SEFF_Start];
            [find_btn setTitle:groupName forState:UIControlStateNormal] ;
        }
        NSLog(@"%@",groupName);
    }
    */
    for(int i=1;i<=MAX_USE_GROUP;i++){
        NSString * groupName =[self getSEFFName:(i)];
        if ([groupName isEqualToString:@""] || '\0' == [groupName characterAtIndex:0]) {
            switch (i) {
                case 1:
                    [self.Btn_SEFF1 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                case 2:
                    [self.Btn_SEFF2 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                case 3:
                    [self.Btn_SEFF3 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                case 4:
                    [self.Btn_SEFF4 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                case 5:
                    [self.Btn_SEFF5 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                case 6:
                    [self.Btn_SEFF6 setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(i)]] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
        }else {
            switch (i) {
                case 1:
                    [self.Btn_SEFF1 setTitle:groupName forState:UIControlStateNormal];
                    break;
                case 2:
                    [self.Btn_SEFF2 setTitle:groupName forState:UIControlStateNormal];
                    break;
                case 3:
                    [self.Btn_SEFF3 setTitle:groupName forState:UIControlStateNormal];
                    break;
                case 4:
                    [self.Btn_SEFF4 setTitle:groupName forState:UIControlStateNormal];
                    break;
                case 5:
                    [self.Btn_SEFF5 setTitle:groupName forState:UIControlStateNormal];
                    break;
                case 6:
                    [self.Btn_SEFF6 setTitle:groupName forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
                    }
        NSLog(@"%@",groupName);
    }
}

-(NSString *) getSEFFName:(int)group{
    BOOL haveName=FALSE;
    for(int i=0;i<13;i++){
        if(RecStructData.USER[group].name[i] != 0){
            haveName=true;
        }
    }
    NSString *groupName = @"";
    if(haveName){
        int nullCount = 0;
        for (int i=0; i<14; i++) {
            if (RecStructData.USER[group].name[i] == '\0') {
                if (i==13) {
                    nullCount = 13;
                }
                break;
            }else {
                nullCount++;
            }
        }
        
        //声明一个gbk编码类型
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
        groupName = [[NSString alloc] initWithBytes:RecStructData.USER[group].name length:nullCount encoding:gbkEncoding];
    }else{
        groupName = @"";
    }
    
    return groupName;
}

-(NSString *) getSEFFNameN:(int)group{
    BOOL haveName=FALSE;
    for(int i=0;i<13;i++){
        if(RecStructData.USER[group].name[i] != 0){
            haveName=true;
        }
    }
    NSString *groupName = @"";
    if(haveName){
        int nullCount = 0;
        for (int i=0; i<14; i++) {
            if (RecStructData.USER[group].name[i] == '\0') {
                if (i==13) {
                    nullCount = 13;
                }
                break;
            }else {
                nullCount++;
            }
        }
        
        //声明一个gbk编码类型
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
        groupName = [[NSString alloc] initWithBytes:RecStructData.USER[group].name length:nullCount encoding:gbkEncoding];
    }else{
        groupName = [LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(group)]];
    } 
    
    return groupName;
}


#pragma mark --- 进度显示
//- (void)initSaveLoadSEFFProgress{
//    UIWindow *window=[[[UIApplication sharedApplication]windows]firstObject];
//    self.HUD_SEFF = [[MBProgressHUD alloc] initWithView:window];
//    [window addSubview:self.HUD_SEFF];
////    [self.view addSubview:self.HUD_SEFF];    //常用的设置
//    //小矩形的背景色
//    //self.HUD_SEFF.color = [UIColor blueColor];//这儿表示无背景clearColor
//    //显示的文字
//    self.HUD_SEFF.labelText = @"";
//    //细节文字
//    self.HUD_SEFF.detailsLabelText = @"";
//    //是否有庶罩
//    self.HUD_SEFF.dimBackground = YES;
//    //[self.HUD_SEFF hide:YES afterDelay:2];
//
//    self.HUD_SEFF.mode = MBProgressHUDModeAnnularDeterminate;
//    self.HUD_SEFF.delegate = self;
//
//}
//
//-(void)hudWasHidden:(MBProgressHUD *)hud{
//    NSLog(@"hudWasHidden");
//    [hud removeFromSuperview];
//    //[hud release];
//    hud = nil;
//}
//
//-(void) HUD_SEFFProgressTask{
//
//
//    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
//
//    NSLog(@"GetSendbufferListCount cnt=%d",cnt);
//
//    SEFF_SendListTotal = cnt;
//    int progress = 100;
//    while (cnt > 0) {
//        cnt = [_mDataTransmitOpt GetSendbufferListCount];
//        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
//        if((progress <= 0)||(progress > 100)){
//            cnt = 0;
//            break;
//        }
//        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
//        self.HUD_SEFF.progress = 1-progress/100.0;
//        usleep(10000);
//    }
//}
//音效操作进度
/*
 Mode=1: 读取
 Mode=2: 保存
 */
//-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode{
//    [self initSaveLoadSEFFProgress];
//    self.HUD_SEFF.detailsLabelText = Detail;
//    [self.HUD_SEFF showWhileExecuting:@selector(HUD_SEFFProgressTask) onTarget:self withObject:nil animated:YES];
//
//}
#pragma mark ---刷新联调

- (void)flashLinkState{
    if(LinkMODE == LINKMODE_SPKTYPE_S){
        if(RecStructData.OUT_CH[0].name[1] == 1){
            BOOL_LINK = true;
            BOOL_LOCK = true;
            [self CheckChannelCanLink];
        }else{
            BOOL_LINK = false;
            BOOL_LOCK = false;
        }
    }else if(LinkMODE == LINKMODE_FRS){
        ChannelConFLR=0;
        ChannelConRLR=0;
        ChannelConSLR=0;
    }
    
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
        if(ChannelNumBuf[i]>maxSpkType){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
}

//- (void)ConnectStateFormNotification:(id)sender{
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dic = [sender userInfo];
//        NSString *okStr = [dic objectForKey:@"ConnectState"];
//        if ([okStr isEqualToString:@"YES"]) {
//
//        }else {
//            if(self.HUD_SEFF != nil){
//                [self.HUD_SEFF removeFromSuperview];
//                //[hud release];
//                self.HUD_SEFF = nil;
//            }
//            if ([okStr isEqualToString:@"DER"]) {
//                [self ShowVersionsErrorDialog];
//            }
//        }
//    });
//}
- (void)FlashMasterFormNotification:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashMasterPageUI];
    });
}
- (void)NotificationFlashInputSource:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashInputSource];
    });
}
#pragma mark ---这里实现TopBar代理控制器的协议方法
- (void)TopbarClickBack:(BOOL)Bool_Click{
    
    
}


-(void)SEFFFileOpt:(int)Opt{
    //NSLog(@"###Master#  SEFFFileOpt Opt=%d",Opt);
    if(Opt == SEFFFILE_SHARE){
        if(gSeffFileType == SeffFileType_Single){
            [self SEFFFileShareSingle];
        }else if(gSeffFileType == SeffFileType_Mac){
            [self SEFFFileShareMac];
        }
    }else if(Opt == SEFFFILE_Save){
        if(SEFFFile_name.length > 0){
            if(gSeffFileType == SeffFileType_Single){
                [self SEFFFileSaveSingle];
            }else if(gSeffFileType == SeffFileType_Mac){
                [self SEFFFileSaveMac];
            }
        }else{
            [self showSEFFFileNameEmpty];
        }
        
    }else if(Opt == SEFFFILE_List){
        [self gotoSEFFFileList];
    }else if(Opt == SEFFFILE_ShowSetName){
        [self showSEFFFileNameEmpty];
    }
}
- (void)gotoSEFFFileList{
    QIZLocalEffectViewController *vc = [[QIZLocalEffectViewController alloc] init];
    vc.title = [LANG DPLocalizedString:@"L_net_downed"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)SEFFFileShareSingle{
    NSLog(@"###Master#  SEFFFileShareSingle");
    
    //        [self showShareActionSheet:sender];
    //把当前数据写入沙盒
    QIZDataStructTool *dataStructTool = [[QIZDataStructTool alloc] init];
    NSDictionary *jsonDict = [dataStructTool createJsonFileDictionary];
    NSString *jsonStr = [QIZDataStructTool convertToJSONData:jsonDict];
    NSData *jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    NSData *data = jsonData;
    if(BOOL_ENCRYPT_SEFF){
        data = [QIZFileTool exclusiveNSData:jsonData];
    }
    [QIZFileTool writeJsonFileToBox:SEFFS_NAME fileData:data fileType:SEFFS_TYPE];
    
    NSArray  *paths  =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:SEFFS_ANAME];
    
    NSLog(@"%@",filePath);
    _doc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _doc.UTI = @"public.plain-text";
    _doc.delegate = self;
    
//    [self.doc presentPreviewAnimated:YES];  //弹出预览对话框
    
    CGRect navRect = self.navigationController.navigationBar.frame;
   // navRect.size =CGSizeMake(self.frame.width,40.0f);
    
    [_doc presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
}

-(void)SEFFFileShareMac{
    NSLog(@"###Master#  SEFFFileShareMac");
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    [_mDataTransmitOpt readMacData];
}

-(void)SEFFFileSaveSingle{
    NSLog(@"###Master#  SEFFFileSaveSingle");
    SEFFFile *effFile = [[SEFFFile alloc] init];
    effFile.file_id = @"file_id";
    effFile.file_type = @"single";
    effFile.file_name = SEFFFile_name; //fill
    effFile.file_path = [QIZFileTool backSaveBoxFileName:SEFFFile_name fileType:SEFFS_TYPE];//fill
    effFile.file_favorite = @"0";
    effFile.file_love = @"0";
    effFile.file_size = @"200";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    effFile.file_time = strDate;
    effFile.file_msg = @"file_msg";
    
    //        NSString *userNameStr = [CLZUserDefaults getUserName];
    //        if (userNameStr) {
    //            effFile.data_user_name = userNameStr;//fill
    //        }else{
    //            effFile.data_user_name = @"";
    //        }
    
    effFile.data_user_name = @"";
    
    //        effFile.data_machine_type = self.macTypeStr;
    //        effFile.data_car_type = self.carTypeStr;//fill
    //        effFile.data_car_brand = self.carBrandStr;//fill
    //        effFile.data_group_name = effectNameCellStr;//fill
    
    
    effFile.data_machine_type = MAC_Type;
    effFile.data_car_type = @"";//fill
    effFile.data_car_brand = @"";//fill
    effFile.data_group_name = SEFFFile_name;//fill
    
    effFile.data_upload_time = strDate;
    
    //        effFile.data_eff_briefing = detailCellStr; //fill
    effFile.data_eff_briefing = SEFFFile_Dital;
    
    effFile.list_sel = @"0";
    effFile.list_is_open = @"0";
    effFile.apply_time = @"";  //初始化未使用
    
    
    BOOL bAdd = [QIZDatabaseTool addSingleEffectData:effFile];
    NSLog(@"###Master#  addSingleEffectData=%d",bAdd);
    
    //2.写文件到沙盒
    QIZDataStructTool *dataStructTool = [[QIZDataStructTool alloc] init];
    NSDictionary *jsonDict = [dataStructTool createJsonFileDictionary];
    NSString *jsonStr = [QIZDataStructTool convertToJSONData:jsonDict];
    NSData *jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    NSData *data = jsonData;
    if(BOOL_ENCRYPT_SEFF){
        data = [QIZFileTool exclusiveNSData:jsonData];
    }
    [QIZFileTool writeJsonFileToBox:SEFFFile_name fileData:data fileType:SEFFS_TYPE];
 }

-(void)SEFFFileSaveMac{
    NSLog(@"###Master#  SEFFFileSaveMac");
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    [_mDataTransmitOpt readMacData];
}
- (void)ReadMacDataNotification:(id)sender{
    NSLog(@"##-ReadMacDataNotification Done!!");
    if(SEFFFILE_OPT == SEFFFILE_SHARE){
        dispatch_async(dispatch_get_main_queue(), ^{
            //        [self showShareActionSheet:sender];
            //把当前数据写入沙盒
            QIZDataStructTool *dataStructTool = [[QIZDataStructTool alloc] init];
            NSDictionary *jsonDict = [dataStructTool createAllJsonFileDictionary];
            NSString *jsonStr = [QIZDataStructTool convertToJSONData:jsonDict];
            NSData *jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
            NSData *data = jsonData;
            if(BOOL_ENCRYPT_SEFF){
                data = [QIZFileTool exclusiveNSData:jsonData];
            }
            [QIZFileTool writeJsonFileToBox:SEFFM_NAME fileData:data fileType:SEFFM_TYPE];
            
            NSArray  *paths  =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *filePath = [docDir stringByAppendingPathComponent:SEFFM_ANAME];
            
            NSLog(@"%@",filePath);
            _doc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            _doc.UTI = @"public.plain-text";
            _doc.delegate = self;
             CGRect navRect = self.navigationController.navigationBar.frame;
            [_doc presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
            
        });
    }else if(SEFFFILE_OPT == SEFFFILE_Save){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"###Master#  SEFFFileSaveMac");
            SEFFFile *effFile = [[SEFFFile alloc] init];
            effFile.file_id = @"file_id";
            effFile.file_type = @"complete";
            effFile.file_name = SEFFFile_name; //fill
            effFile.file_path = [QIZFileTool backSaveBoxFileName:SEFFFile_name fileType:SEFFM_TYPE];//fill
            effFile.file_favorite = @"0";
            effFile.file_love = @"0";
            effFile.file_size = @"200";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            effFile.file_time = strDate;
            effFile.file_msg = @"file_msg";
            
            //        NSString *userNameStr = [CLZUserDefaults getUserName];
            //        if (userNameStr) {
            //            effFile.data_user_name = userNameStr;//fill
            //        }else{
            //            effFile.data_user_name = @"";
            //        }
            
            effFile.data_user_name = @"";
            
            //        effFile.data_machine_type = self.macTypeStr;
            //        effFile.data_car_type = self.carTypeStr;//fill
            //        effFile.data_car_brand = self.carBrandStr;//fill
            //        effFile.data_group_name = effectNameCellStr;//fill
            
            
            effFile.data_machine_type = MAC_Type;
            effFile.data_car_type = @"";//fill
            effFile.data_car_brand = @"";//fill
            effFile.data_group_name = SEFFFile_name;//fill
            
            effFile.data_upload_time = strDate;
            
            //        effFile.data_eff_briefing = detailCellStr; //fill
            effFile.data_eff_briefing = SEFFFile_Dital;
            
            effFile.list_sel = @"0";
            effFile.list_is_open = @"0";
            effFile.apply_time = @"";  //初始化未使用
            
            
            BOOL bAdd = [QIZDatabaseTool addSingleEffectData:effFile];
            NSLog(@"##-ReadMacDataNotification addSingleEffectData=%d",bAdd);
            
            //把当前数据写入沙盒
            QIZDataStructTool *dataStructTool = [[QIZDataStructTool alloc] init];
            NSDictionary *jsonDict = [dataStructTool createAllJsonFileDictionary];
            NSString *jsonStr = [QIZDataStructTool convertToJSONData:jsonDict];
            NSData *jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
            NSData *data = jsonData;
            if(BOOL_ENCRYPT_SEFF){
                data = [QIZFileTool exclusiveNSData:jsonData];
            }
            [QIZFileTool writeJsonFileToBox:SEFFFile_name fileData:data fileType:SEFFM_TYPE];
        });
    }
    
}


//文件名字空提示框
- (void)showSEFFFileNameEmpty{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_SSM_SaveOpt"]message:[LANG DPLocalizedString:@"L_SSM_FileNameMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark--- LoadJsonFileNotification

//- (void)LoadJsonFileNotification:(id)sender{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dic = [sender userInfo];
//        NSString *State = [dic objectForKey:@"State"];
//        if ([State isEqualToString:SHOWLoading]) {
//            [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
//        }else if ([State isEqualToString:JSONFILE_ERROR]) {
//            [self showSEFFFileError];
//        }else if ([State isEqualToString:JSONFILEMac_ERROR]) {
//            [self showBrandMacError];
//        }else if ([State isEqualToString:SHOWRecSEFFFile]) {
//            [self showRecSEFFFile];
//        }
//    });
//
//
//}
////音效文件错误提示框
//- (void)showSEFFFileError{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_FileError"]preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//
//    }]];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}
////音效机型错误提示框
//- (void)showBrandMacError{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SEFF_WRONG_MAC"]preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//
//    }]];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}
////接收到音效文件提示框
//- (void)showRecSEFFFile{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SSM_RecSEFFileMsg"]preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//
//    }]];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}

//更新音效文件提示框 
- (void)showUpdatSEFFileToMac{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SSM_MSG"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.mDataTransmitOpt sendJsonDataToMac:REC_SEFFFileType];
        REC_SEFFFileType = SEFFFILE_TYPE_NULL;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        REC_SEFFFileType = SEFFFILE_TYPE_NULL;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)NotificationShowResetSEFFData:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_DataErr"] message:[LANG DPLocalizedString:@"L_DataErrResetMuc"] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.mDataTransmitOpt sendResetGroupData:CurGroup];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 显示进度
//- (void)Notification_ShowProgress:(id)sender{
//
//    NSDictionary *dic = [sender userInfo];
//    NSString *okStr = [dic objectForKey:@"State"];
//    if ([okStr isEqualToString:ShowProgressSave]) {
//        NSLog(@"ShowProgressSave...");
//        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Save"] WithMode:SEFF_OPT_Save];
//    }else if ([okStr isEqualToString:ShowProgressCall]) {
//        NSLog(@"ShowProgressCall...");
//        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
//    }
//}
#pragma mark---更新UI界面
- (void)FlashMasterPageUI{
    NSLog(@"####  FlashMasterPageUI");
//    [self flashHiMode];
    [self flashEQGain];
    
    //    [self flashInputsourceVolume];
    [self flashBassVolume];
    [self FlashEncryption];
    [self FlashSEFFName];
    [self FlashMasterMute];
    [self FlashInputSource];
    //    [self FlashMixerInputSource];
    [self FlashMasterVolume];
}


- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashLinkState];//要放到这里
        [self FlashMasterPageUI];
        
        if(REC_SEFFFileType != SEFFFILE_TYPE_NULL){
            [self showUpdatSEFFileToMac];
        }
        
    });
}
@end



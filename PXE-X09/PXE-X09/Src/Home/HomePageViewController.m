//
//  MainPageViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "HomePageViewController.h"
#import "OptFunPage_TBC.h"
#import "AppDelegate.h"
#import "DataProgressHUD.h"
#import "AdvertisementView.h"
#import "DetailViewController.h"
#define BOOL_USEG false
#define Tag_Btn_SEFF_Start 100

@interface HomePageViewController (){
    
}
@property(nonatomic,strong)NSArray *SourceArray;
@property(nonatomic,strong)NSArray *SourceImages;

@end

@implementation HomePageViewController
//@synthesize name = _name;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DataCManager sendGetSystemDataCMD];
    CurPage = UI_Page_Home;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DataProgressHUD shareManager].showVolView=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //广告
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatAdView) name:MyNotification_ShowAD object:nil];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    [[BLEManager shareBLEManager]doScanBluetoothPeriphals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatAdView{
    
    AdvertisementView *adView=[[AdvertisementView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:394], [Dimens GDimens:570])];
    __weak typeof(self) weakself=self;
    adView.openUrlBlock = ^(NSString *url) {
        [[KGModal sharedInstance]hideWithCompletionBlock:^{
            DetailViewController *vc=[[DetailViewController alloc]init];
            vc.urlStr=url;
            [weakself.navigationController pushViewController:vc animated:YES];
            
        }];
    };
    [[KGModal sharedInstance]setModalBackgroundColor:[UIColor clearColor]];
    
    [[KGModal sharedInstance]showWithContentView:adView andAnimated:YES];
    [[KGModal sharedInstance]setOKButton:adView.closeBtn];
    [KGModal sharedInstance].closeButtonType=KGModalCloseButtonTypeNone;
    
}
#pragma mark - Navigation

- (void)initView{
    
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    
    [self initMasterView];
    DataCManager.UpdataAduanceData=true;
}

//获取当前语言环境
- (void)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"currentLanguage=%@" , currentLanguage);
    
}
#pragma 界面初始化
//初始化主界面的各种控件
- (void)initMasterView{
    [self.mToolbar setLogoShow:true];
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_Master_Master"];
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //    //通信连接成功
    //    [center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    //刷新主界面
    [center addObserver:self selector:@selector(FlashMasterFormNotification:) name:MyNotification_FlashMaster object:nil];
    //读取完成整机数据
    [center addObserver:self selector:@selector(ReadMacDataNotification:) name:MyNotification_ReadMacData object:nil];
    //读取Json数据
    //    [center addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
    //刷新音源
    [center addObserver:self selector:@selector(NotificationFlashInputSource:) name:MyNotification_FlashInputSource object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(flashBassVolume) name:MyNotification_updateVol object:nil];
    
    seffName=@"";
    setEnNum=@"";
    boolMasterSub = true;
    
    
   
//    [self initEncryptView];//加密
    [self initInputSourceView];//音源
     [self initMasterVolView];//主音量
    [self initMasterMixerInputSourceView];//混音音源
    [self initUserGroupList];//音效调用
    //[self initSEFFUserGroupList];//音效调用
    //    [self initMasterSubVolView];//低音音量
//    [self initAdvanceSettingsView];//高级设置
    //    [self initInputSourceVolView];//输入音源音量
    [self FlashMasterPageUI];
    
}


#pragma mark ---------------------------->> 加密
- (void)initEncryptView{
    //加密
    self.Btn_MasterEncrypt = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_MasterEncrypt];
    [self.Btn_MasterEncrypt initViewBroder:3
                           withBorderWidth:0
                           withNormalColor:UI_DelayBtn_NormalIN
                            withPressColor:UI_DelayBtn_PressIN
                     withBorderNormalColor:UI_SystemBtnColorNormal
                      withBorderPressColor:UI_SystemBtnColorPress
                       withTextNormalColor:UI_SystemLableColorNormal
                        withTextPressColor:UI_SystemLableColorPress
                                  withType:5];
    
    [self.Btn_MasterEncrypt addTarget:self action:@selector(Btn_MasterEncrypt_CLick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.Btn_MasterEncrypt setImage:[UIImage imageNamed:@"chs_home_unlock"] forState:UIControlStateNormal];
//    self.Btn_MasterEncrypt.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.Btn_MasterEncrypt setTitle:[LANG DPLocalizedString:@"L_Master_Encryption"] forState:UIControlStateNormal] ;
        self.Btn_MasterEncrypt.titleLabel.font = [UIFont systemFontOfSize:13];
        self.Btn_MasterEncrypt.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.Btn_MasterEncrypt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SB_MasterVolume.mas_bottom).offset([Dimens GDimens:35]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
//    self.Btn_MasterEncrypt.hidden=YES;
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
//        [self.Btn_MasterEncrypt setImage:[UIImage imageNamed:@"chs_home_lock"] forState:UIControlStateNormal];
    }else{
//        [self.Btn_MasterEncrypt setImage:[UIImage imageNamed:@"chs_home_unlock"] forState:UIControlStateNormal];
                [self.Btn_MasterEncrypt setTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"] forState:UIControlStateNormal] ;
    }
}
#pragma mark ----------------- 高级设置
- (void)initAdvanceSettingsView{
    //高级设置
    
    self.Btn_AdvanceSettings = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_AdvanceSettings];
    //    [self.Btn_AdvanceSettings initView:5 withBorderWidth:0 withNormalColor:UI_MasterAdvanceSetBtnColorNormal withPressColor:UI_MasterAdvanceSetBtnColorPress withType:1];
    [self.Btn_AdvanceSettings initViewBroder:0
                             withBorderWidth:0
                             withNormalColor:UI_MasterAdvanceSetBtnColorNormal
                              withPressColor:UI_DelayBtn_PressIN
                       withBorderNormalColor:UI_MasterAdvanceSetBtnBorderColorNormal
                        withBorderPressColor:UI_Master_UserGroup_Btn_Press
                         withTextNormalColor:UI_MasterAdvanceSetBtnTextColorNormal
                          withTextPressColor:UI_MasterAdvanceSetBtnTextColorPress
                                    withType:5];
    [self.Btn_AdvanceSettings addTarget:self action:@selector(Btn_AdvanceSettings_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_AdvanceSettings setBackgroundImage:[UIImage imageNamed:@"master_advanceSettings"] forState:UIControlStateNormal];
    [self.Btn_AdvanceSettings setTitle:[LANG DPLocalizedString:@"L_Master_Advance"] forState:UIControlStateNormal] ;
    self.Btn_AdvanceSettings.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_AdvanceSettings.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.Btn_AdvanceSettings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_SEFF6.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtnAdvanceSet_Width], [Dimens GDimens:MasterBtnAdvanceSet_Height]));
    }];
    //    self.Btn_AdvanceSettings.hidden = true;
}

- (void)Btn_AdvanceSettings_CLick:(id)sender {
    [self enterAdvanceSettings];
    //    if(!BOOL_ENTER_ADVANCE){
    //        [self showAdvanceSettingsDialog];
    //    }else{
    //        [self enterAdvanceSettings];
    //    }
}


#pragma mark ------------------音源
- (void)initInputSourceView{
    
   
    
    
    //音源标识
    self.Lab_InputSource = [[UILabel alloc]init];
    [self.view addSubview:self.Lab_InputSource];
    [self.Lab_InputSource setTextColor:SetColor(UI_Master_VolumeTextColor)];
    [self.Lab_InputSource setBackgroundColor:[UIColor clearColor]];
    self.Lab_InputSource.text=[LANG DPLocalizedString:@"L_MainInputSource"];
    self.Lab_InputSource.textAlignment = NSTextAlignmentCenter;
    self.Lab_InputSource.adjustsFontSizeToFitWidth = true;
    self.Lab_InputSource.font = [UIFont systemFontOfSize:14];
    [self.Lab_InputSource mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:15]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
    //音源选择
    self.Btn_InputSource = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_InputSource];
    [self.Btn_InputSource initViewBroder:[Dimens GDimens:MasterBtn_Height]/2
                         withBorderWidth:1
                         withNormalColor:UI_DelayBtn_NormalIN
                          withPressColor:UI_DelayBtn_PressIN
                   withBorderNormalColor:UI_SystemBtnColorNormal
                    withBorderPressColor:UI_SystemBtnColorPress
                     withTextNormalColor:UI_SystemLableColorNormal
                      withTextPressColor:UI_SystemLableColorPress
                                withType:4];
    [self.Btn_InputSource addTarget:self action:@selector(SelectInputSource:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_InputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
    self.Btn_InputSource.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_InputSource.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_InputSource.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:10],
        .bottom = 0,
        .right  = [Dimens GDimens:10],
    };
//
//    self.Btn_InputSource.imageEdgeInsets = (UIEdgeInsets){
//        .top    = 0,
//        .left   = [Dimens GDimens:0],
//        .bottom = 0,
//        .right  = [Dimens GDimens:MasterBtn_Width - MasterBtn_Height],
//    };
    [self.Btn_InputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Lab_InputSource.mas_bottom).offset([Dimens GDimens:8]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];

    [self FlashInputSource];
    
}


//音源设置
- (void)SelectInputSource:(UIButton *)sender {
    [self showInputSourceOptDialog];
}
- (void)dealWithInputsource{
    [_mDataTransmitOpt setInputSourceNow];
    [self flashInputsourceVolume];
    [self selectMixerSourceAndInputSource];
    
    
    
    
}



- (void)showInputSourceOptDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_InputSourceSelect"]message:[LANG DPLocalizedString:@"L_MainInputSource"]preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i=0; i<self.SourceArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RecStructData.System.input_source=i;
            [self.Btn_InputSource setTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:i]] forState:UIControlStateNormal];
            NSString *imageStr=self.SourceImages[i];
            UIImage *image=[UIImage imageNamed:imageStr];
            [self.Btn_InputSource setImage:image forState:UIControlStateNormal];
            
            [self dealWithInputsource];
        }]];
    }
   
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark --------------------音源音量
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
        make.top.mas_equalTo(self.Btn_MasterMute.mas_bottom).offset(0);
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
        make.centerX.mas_equalTo(self.view.mas_centerX).offset([Dimens GDimens:-10]);
        make.top.mas_equalTo(self.Lab_InSrcVol.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:350], [Dimens GDimens:50]));
    }];
    self.SB_InSrcVol.hidden = true;
    
}

//音源音量
- (void)SB_InSrcVol_Val_Change:(UISlider *)sender{
    int val = (int)sender.value;
    switch (RecStructData.System.input_source) {
//        case 1:
//            RecStructData.System.Hi_src_vol = val;
//            break;
//        case 2:
//            RecStructData.System.Blue_src_vol = val;
//            break;
//        case 3:
//            RecStructData.System.Aux_src_vol = val;
//            break;
//        default:
//            break;
    }
    self.LabInSrcVol.text=[NSString stringWithFormat:@"%d",val];
}

#pragma mark --------------------混音音源
- (void)initMasterMixerInputSourceView{
    //混音音源选择
    self.Btn_MixerInputSource = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_MixerInputSource];
    [self.Btn_MixerInputSource initViewBroder:0
                              withBorderWidth:0
                              withNormalColor:UI_DelayBtn_NormalIN
                               withPressColor:UI_DelayBtn_PressIN
                        withBorderNormalColor:UI_SystemBtnColorNormal
                         withBorderPressColor:UI_SystemBtnColorPress
                          withTextNormalColor:UI_Master_InputSourceBtnTextColor
                           withTextPressColor:UI_Master_InputSourceBtnTextColor
                                     withType:0];
    [self.Btn_MixerInputSource addTarget:self action:@selector(SelectMixerInputSource:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:@"L_InputSource_Bluetooth"] forState:UIControlStateNormal] ;
    [self.Btn_MixerInputSource setBackgroundImage:[UIImage imageNamed:@"mixerInput"] forState:UIControlStateNormal];
    self.Btn_MixerInputSource.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_MixerInputSource.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_MixerInputSource.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:20],
        .bottom = 0,
        .right  = 0,
    };
    [self.Btn_MixerInputSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY);
        make.centerX.equalTo(self.view.mas_left).offset([Dimens GDimens:2*MasterMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
    }];
    
    //混音音源标识
//    self.Lab_MixerInputSource = [[UILabel alloc]init];
//    [self.view addSubview:self.Lab_MixerInputSource];
//    [self.Lab_MixerInputSource setTextColor:SetColor(UI_Master_VolumeTextColor)];
//    [self.Lab_MixerInputSource setBackgroundColor:[UIColor clearColor]];
//    self.Lab_MixerInputSource.text=[LANG DPLocalizedString:@"L_MixerInputSourceSelect"];
//    self.Lab_MixerInputSource.textAlignment = NSTextAlignmentCenter;
//    self.Lab_MixerInputSource.adjustsFontSizeToFitWidth = true;
//    self.Lab_MixerInputSource.font = [UIFont systemFontOfSize:14];
//    [self.Lab_MixerInputSource mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.Btn_MixerInputSource.mas_top).offset(-[Dimens GDimens:5]);
//        make.centerX.equalTo(self.Btn_MixerInputSource.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Width], [Dimens GDimens:MasterBtn_Height]));
//    }];
    [self FlashMixerInputSource];
    
}


//混音音源设置
- (void)SelectMixerInputSource:(NormalButton *)sender {
    [self showMixerSourceOptDialog];
}
- (void)dealWithMixersource{
    [self selectMixerSourceAndInputSource];
    
    
}



- (void)showMixerSourceOptDialog{

    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_MixerInputSourceSelect"]message:[LANG DPLocalizedString:@""]preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i=0; i<self.SourceArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:i]] forState:UIControlStateNormal];
            RecStructData.System.mixer_source=i;
            
//            [self dealWithMixersource];
        }]];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark---筛选主音源和混音源
-(void)selectMixerSourceAndInputSource{
    
    
    
}

#pragma mark ---------------------低音音量
- (void)initMasterSubVolView{
    //低音音量
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
    
}


//低音音量
- (void)SB_SubVol_Val_Change:(UISlider *)sender{
    for (int i=0; i<8; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    
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
}

#pragma mark --------------------主音量
- (void)initMasterVolView{
    //    CGColorSpaceRef normalColorSpaceWhite = CGColorSpaceCreateDeviceRGB();
    
    //    CGColorRef normalColorrefWhite = CGColorCreate(normalColorSpaceWhite,(CGFloat[]){((UI_Master_UserGroup_Btn_Normal>>16)&0x00ff)/255.0 ,((UI_Master_UserGroup_Btn_Normal>>8)&0x00ff)/255.0,(UI_Master_UserGroup_Btn_Normal&0x000000ff)/255.0,((UI_Master_UserGroup_Btn_Normal>>24)&0x00ff)/255.0});
    
    /*
     self.IV_MasterBg = [[UIView alloc]init];
     [self.view addSubview:self.IV_MasterBg];
     [self.IV_MasterBg.layer setMasksToBounds:YES];
     [self.IV_MasterBg.layer setCornerRadius:5]; //设置矩形四个圆角半径
     [self.IV_MasterBg.layer setBorderWidth:1];   //边框宽度
     [self.IV_MasterBg.layer setBorderColor:normalColorrefWhite]; //边框颜色
     [self.IV_MasterBg mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.Btn_SEFF4.mas_bottom).offset([Dimens GDimens:30]);
     make.centerX.equalTo(self.view.mas_centerX);
     make.size.mas_equalTo(CGSizeMake(KScreenWidth - [Dimens GDimens:MasterMarginSide*2], [Dimens GDimens:150]));
     }];
     */
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,[Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height])];
    [imageView setImage:[UIImage imageNamed:@"output_slider_normal"]];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    imageView.transform = trans;
    [self.view addSubview:imageView];
    //音量显示
    self.Lab_MasterVolume = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size])];
    [self.view addSubview:self.Lab_MasterVolume];
    //    [self.Lab_MasterVolume setBackgroundColor:[UIColor clearColor]];
    [self.Lab_MasterVolume setTextColor:SetColor(UI_Master_VolumeColor)];
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
    self.Lab_MasterVolume.textAlignment = NSTextAlignmentCenter;
    self.Lab_MasterVolume.adjustsFontSizeToFitWidth = true;
    self.Lab_MasterVolume.font = [UIFont systemFontOfSize:50];
    [self.Lab_MasterVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_InputSource.mas_bottom).offset([Dimens GDimens:40]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:Master_Lab_Volume_Size], [Dimens GDimens:Master_Lab_Volume_Size]));
    }];
    //SB
    self.SB_MasterVolume = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height])];
    
    [self.view addSubview:self.SB_MasterVolume];
    //    self.SB_MasterVolume.backgroundColor=SetColor(UI_Master_SB_Volume_BG);
    
        self.SB_MasterVolume.minimumValue = 0;
        self.SB_MasterVolume.maximumValue = Master_Volume_MAX;
//    [self.SB_MasterVolume setMinimumTrackImage:[UIImage imageNamed:@"output_slider_press"] forState:UIControlStateNormal];
//    [self.SB_MasterVolume setMaximumTrackImage:[UIImage imageNamed:@"output_slider_normal"] forState:UIControlStateNormal];
        self.SB_MasterVolume.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
        self.SB_MasterVolume.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_MasterVolume setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.SB_MasterVolume addTarget:self action:@selector(MasterVolumeSBChange:) forControlEvents:UIControlEventValueChanged];
    CGAffineTransform trans1 = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.SB_MasterVolume.transform = trans1;
    //self.SB_MasterVolume.showValue = [NSString stringWithFormat:@"%d",RecStructData.System.main_vol];
            [self.SB_MasterVolume setValue:RecStructData.System.main_vol];
//    [self.SB_MasterVolume setMaxProgress:Master_Volume_MAX];
//    [self.SB_MasterVolume setProgress:RecStructData.System.main_vol];
    
    [self.SB_MasterVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset([Dimens GDimens:50]);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height]));
    }];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_SB_Width], [Dimens GDimens:MasterVolume_SB_Height]));
    }];
    
   
    //主音量
    //标识
    self.Lab_MasterVolumeText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:Master_Lab_Volume_Text_Width], [Dimens GDimens:Master_Lab_Volume_Text_Height])];
    [self.view addSubview:self.Lab_MasterVolumeText];
    [self.Lab_MasterVolumeText setBackgroundColor:[UIColor clearColor]];
    [self.Lab_MasterVolumeText setTextColor:SetColor(UI_Master_VolumeTextColor)];
    self.Lab_MasterVolumeText.text = [LANG DPLocalizedString:@"L_Master_MasterVolumeText"];
    self.Lab_MasterVolumeText.adjustsFontSizeToFitWidth = true;
    self.Lab_MasterVolumeText.font = [UIFont systemFontOfSize:18];
    self.Lab_MasterVolumeText.textAlignment = NSTextAlignmentCenter;
    [self.Lab_MasterVolumeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset([Dimens GDimens:60+MasterVolume_SB_Width/2+20]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:MasterBtn_Height]));
    }];
    
    //静音
    self.Btn_MasterMute = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_MasterMute];
    [self.Btn_MasterMute initViewBroder:0
                        withBorderWidth:0
                        withNormalColor:UI_DelayBtn_NormalIN
                         withPressColor:(0x00ff2f2f)
                  withBorderNormalColor:UI_Master_MuteBtnColor_Normal
                   withBorderPressColor:UI_Master_MuteBtnColor_Press
                    withTextNormalColor:UI_SystemLableColorNormal
                     withTextPressColor:UI_SystemLableColorPress
                               withType:0];
    
    [self.Btn_MasterMute addTarget:self action:@selector(Btn_MasterMute_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_MasterMute.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    //    self.Btn_MasterMute.imageEdgeInsets = UIEdgeInsetsMake(
    //                                                           0,
    //                                                           [Dimens GDimens:MasterMuteWidth]/2-[Dimens GDimens:MasterMuteHeight]/2,
    //                                                           0,
    //                                                           [Dimens GDimens:MasterMuteWidth]/2-[Dimens GDimens:MasterMuteHeight]/2
    //                                                           );
    [self.Btn_MasterMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY);
        make.centerX.equalTo(self.view.mas_right).offset(-[Dimens GDimens:2*MasterMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height]));
    }];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.Btn_InputSource.mas_left);
        make.height.mas_equalTo(1);
    }];
    UIView *line1=[[UIView alloc]init];
    line1.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(self.Btn_InputSource.mas_right);
        make.right.equalTo(self.view.mas_centerX).offset([Dimens GDimens:-30]);
         make.height.mas_equalTo(1);
    }];
    
    UIView *line2=[[UIView alloc]init];
    line2.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(self.view.mas_centerX).offset([Dimens GDimens:60]);
        make.right.equalTo(self.Btn_MasterMute.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    UIView *line3=[[UIView alloc]init];
    line3.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(self.Btn_MasterMute.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
//    self.Btn_MasterMute.hidden=YES;
    
    
    //音量增减
    self.Btn_MasterVolumeSub = [[UIButton alloc]init];
    [self.Btn_MasterVolumeSub setBackgroundImage:[UIImage imageNamed:@"mastervolume_sub_normal"] forState:UIControlStateNormal];
    //    [self.Btn_MasterVolumeSub setBackgroundImage:[UIImage imageNamed:@"mastervolume_sub_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.Btn_MasterVolumeSub];
    [self.Btn_MasterVolumeSub addTarget:self action:@selector(MasterVolume_SUB:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_MasterVolumeAdd = [[UIButton alloc]init];
    [self.Btn_MasterVolumeAdd setBackgroundImage:[UIImage imageNamed:@"mastervolume_inc_normal"] forState:UIControlStateNormal];
    //    [self.Btn_MasterVolumeAdd setBackgroundImage:[UIImage imageNamed:@"mastervolume_inc_press"] forState:UIControlStateHighlighted];
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
    [self.Btn_MasterVolumeSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY).offset([Dimens GDimens:MasterBtn_Width+20]);
        make.left.equalTo(self.view.mas_centerX).offset([Dimens GDimens:MasterBtn_Height/2+20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:35], [Dimens GDimens:35]));
    }];
    
    [self.Btn_MasterVolumeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_MasterVolume.mas_centerY).offset([Dimens GDimens:-MasterBtn_Width-17]);
        make.left.equalTo(self.Btn_MasterVolumeSub.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:35], [Dimens GDimens:35]));
       
    }];
//
//    self.Btn_MasterVolumeSub.hidden = true;
//    self.Btn_MasterVolumeAdd.hidden = true;
}



//音量设置
-(void)MasterVolumeSBChange:(UISlider *)sender{
//    int val = [sender GetProgress];
    int val = (int)sender.value;//
    if(boolMasterSub){
        if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
//            RecStructData.IN_CH[0].Valume = val;
        }else{
            RecStructData.System.main_vol = val;
            
            //设置非静音
            if(RecStructData.System.MainvolMuteFlg == 0){
                RecStructData.System.MainvolMuteFlg = 1;
                [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
                [self.Btn_MasterMute setNormal];
            }
            
        }
    }else{
        [self setSubVal:val*Output_Volume_Step];
        if(BOOL_SET_SpkType){
            if([self checkBassChannel] <= 0){
                //self.LabSubVal.text = @"NULL";
            }
        }
    }
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",val];
    
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
    int vol=0;
    if(boolMasterSub){
        if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
//            if(--RecStructData.IN_CH[0].Valume < 0){
//                RecStructData.IN_CH[0].Valume = 0;
//            }
//            vol = RecStructData.IN_CH[0].Valume;
        }else{
            if(--RecStructData.System.main_vol < 0){
                RecStructData.System.main_vol = 0;
            }
            vol = RecStructData.System.main_vol;
            
            //设置非静音
            if(RecStructData.System.MainvolMuteFlg == 0){
                RecStructData.System.MainvolMuteFlg = 1;
                [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
                [self.Btn_MasterMute setNormal];
            }
        }
    }else{
        vol = [self getSubVal];
        vol -= Output_Volume_Step;
        if(vol < 0){
            vol = 0;
        }
        [self setSubVal:vol];
        vol /= Output_Volume_Step;
    }
    
        self.SB_MasterVolume.value = vol;
//    [self.SB_MasterVolume setProgress:vol];
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",vol];
}


-(void)MasterVolume_INC:(id)sender{
    int vol=0;
    if(boolMasterSub){
        if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
//            if(++RecStructData.IN_CH[0].Valume > Master_Volume_MAX){
//                RecStructData.IN_CH[0].Valume = Master_Volume_MAX;
//            }
//            vol = RecStructData.IN_CH[0].Valume;
        }else{
            if(++RecStructData.System.main_vol > Master_Volume_MAX){
                RecStructData.System.main_vol = Master_Volume_MAX;
            }
            vol = RecStructData.System.main_vol;
            
            //设置非静音
            if(RecStructData.System.MainvolMuteFlg == 0){
                RecStructData.System.MainvolMuteFlg = 1;
                [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
                [self.Btn_MasterMute setNormal];
            }
        }
    }else{
        vol = [self getSubVal];
        vol += Output_Volume_Step;
        if(vol > Output_Volume_MAX){
            vol = Output_Volume_MAX;
        }
        [self setSubVal:vol];
        vol /= Output_Volume_Step;
    }
    
        self.SB_MasterVolume.value = vol;
//    [self.SB_MasterVolume setProgress:vol];
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",vol];
}
-(void)Btn_MasterMute_Click:(UIButton*)sender{
    if(RecStructData.System.MainvolMuteFlg != 0){
        RecStructData.System.MainvolMuteFlg = 0;
        [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        [self.Btn_MasterMute setPress];
    }else{
        RecStructData.System.MainvolMuteFlg = 1;
        [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        [self.Btn_MasterMute setNormal];
    }
}
//音量切换
- (void)Btn_CMaster_Event:(UIButton*)sender{
    boolMasterSub = true;
    [self flashMasterSubSelect:true];
}

- (void)Btn_CSub_Event:(UIButton*)sender{
    boolMasterSub = false;
    [self flashMasterSubSelect:false];
}

- (void)flashMasterSubSelect:(Boolean)Bm{
    int val=0;
    if(Bm){
        [self.Btn_CMaster setBackgroundImage:[UIImage imageNamed:@"chs_mastersub_val_set_sel"] forState:UIControlStateNormal];
        [self.Btn_CSub setBackgroundImage:[UIImage imageNamed:@"vivid_bg"] forState:UIControlStateNormal];
//        [self.SB_MasterVolume setMaxProgress:Master_Volume_MAX];
                [self.SB_MasterVolume setMaximumValue:Master_Volume_MAX];
        if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
         }else{
//            [self.SB_MasterVolume setProgress:RecStructData.System.main_vol];
                        self.SB_MasterVolume.value = RecStructData.System.main_vol;
            val = RecStructData.System.main_vol;
        }
        
        
    }else{
        [self.Btn_CSub setBackgroundImage:[UIImage imageNamed:@"chs_mastersub_val_set_sel"] forState:UIControlStateNormal];
        [self.Btn_CMaster setBackgroundImage:[UIImage imageNamed:@"vivid_bg"] forState:UIControlStateNormal];
        
        //[self.MasterVolSlider setMaxProgress:CurMacMode.Out.MaxOutVol/CurMacMode.Out.StepOutVol];
        //[self.MasterVolSlider setProgress:[self getSubVal]/CurMacMode.Out.StepOutVol];
        val = [self getSubVal]/Output_Volume_Step;
//        [self.SB_MasterVolume setMaxProgress:Output_Volume_MAX/Output_Volume_Step];
                [self.SB_MasterVolume setMaximumValue:Output_Volume_MAX/Output_Volume_Step];
                self.SB_MasterVolume.value = val;
//        [self.SB_MasterVolume setProgress:val];
    }
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",val];
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


- (int)checkBassChannel{
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    
    int n=0;
    int ch[]={0,0,0,0,0,0};
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((ChannelNumBuf[i]==22)||(ChannelNumBuf[i]==23)||(ChannelNumBuf[i]==24)){
            ch[n]=i;
            ++n;
        }
    }
    return n;
}

- (int)getSpkTypeBassVolume{
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
//    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
//    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
//    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
//    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
//    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
//    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
//    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
//    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
//
//    ChannelNumBuf[8]= RecStructData.System.out9_spk_type;
//    ChannelNumBuf[9]= RecStructData.System.out10_spk_type;
//    ChannelNumBuf[10]= RecStructData.System.out11_spk_type;
//    ChannelNumBuf[11]= RecStructData.System.out12_spk_type;
//    ChannelNumBuf[12]= RecStructData.System.out13_spk_type;
//    ChannelNumBuf[13]= RecStructData.System.out14_spk_type;
//    ChannelNumBuf[14]= RecStructData.System.out15_spk_type;
//    ChannelNumBuf[15]= RecStructData.System.out16_spk_type;
    
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
    
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

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
#pragma 音效List
- (void)initSEFFUserGroupList{
    UIView *ml = [[UIView alloc]init];
    [self.view addSubview:ml];
    [ml setBackgroundColor:SetColor(0xFF70788f)];
    [ml mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_MasterEncrypt.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:380], 1));
    }];
    
    self.SVList = [[UIScrollView alloc]init];
    [self.view addSubview:self.SVList];
    [self.SVList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ml.mas_bottom).offset([Dimens GDimens:40]);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:220]));
    }];
    self.SVList.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.SVList.delegate = self;
    // 设置内容大小
    //禁止UIScrollView垂直方向滚动，只允许水平方向滚动
    //scrollview.contentSize =  CGSizeMake(你要的长度, 0);
    //禁止UIScrollView水平方向滚动，只允许垂直方向滚动
    //scrollview.contentSize =  CGSizeMake(0, 你要的宽度);
    self.SVList.contentSize = CGSizeMake([Dimens GDimens:MasterMarginSide/2]+[Dimens GDimens:UserPresetSize+MasterMarginSide]*8, 0);
    // 是否反弹
    self.SVList.bounces = NO;
    // 是否分页
    //self.SVList.pagingEnabled = YES;
    // 是否滚动
    //self.SVList.scrollEnabled = NO;
    //self.SVList.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    // self.SVList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //self.SVList.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //self.SVList.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [self.SVList flashScrollIndicators];
    // 是否同时运动,lock
    self.SVList.directionalLockEnabled = NO;
    
    
    for(int i=0;i<MAX_USE_GROUP;i++){
        if((i%2) == 0){
            NormalButton *BtnSEFF = [[NormalButton alloc]initWithFrame:CGRectMake(
                                                                                  [Dimens GDimens:30]+[Dimens GDimens:UserPresetSize+MasterMarginSide]*(i/2),
                                                                                  0 ,
                                                                                  [Dimens GDimens:UserPresetSize],
                                                                                  [Dimens GDimens:UserPresetSize])];
            [self.SVList addSubview:BtnSEFF];
            [BtnSEFF setTag:1+i];
            [BtnSEFF initViewBroder:5
                    withBorderWidth:0
                    withNormalColor:UI_DelayBtn_NormalIN
                     withPressColor:UI_DelayBtn_PressIN
              withBorderNormalColor:UI_Master_UserGroup_Btn_Normal
               withBorderPressColor:UI_Master_UserGroup_Btn_Press
                withTextNormalColor:UI_Master_UserGroup_BtnText_Normal
                 withTextPressColor:UI_Master_UserGroup_BtnText_Press
                           withType:5];
            [BtnSEFF addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
            [BtnSEFF setTitle:[NSString stringWithFormat:@"%@%d",[LANG DPLocalizedString:@"L_Master_Preset"],i+1] forState:UIControlStateNormal] ;
            BtnSEFF.titleLabel.adjustsFontSizeToFitWidth = true;
            BtnSEFF.titleLabel.font = [UIFont systemFontOfSize:13];
        }else{
            NormalButton *BtnSEFF = [[NormalButton alloc]initWithFrame:CGRectMake(
                                                                                  [Dimens GDimens:30]+[Dimens GDimens:UserPresetSize+MasterMarginSide]*((i-1)/2),
                                                                                  [Dimens GDimens:UserPresetSize+40] ,
                                                                                  [Dimens GDimens:UserPresetSize],
                                                                                  [Dimens GDimens:UserPresetSize])];
            [self.SVList addSubview:BtnSEFF];
            [BtnSEFF setTag:1+i];
            [BtnSEFF initViewBroder:5
                    withBorderWidth:0
                    withNormalColor:UI_DelayBtn_NormalIN
                     withPressColor:UI_DelayBtn_PressIN
              withBorderNormalColor:UI_Master_UserGroup_Btn_Normal
               withBorderPressColor:UI_Master_UserGroup_Btn_Press
                withTextNormalColor:UI_Master_UserGroup_BtnText_Normal
                 withTextPressColor:UI_Master_UserGroup_BtnText_Press
                           withType:5];
            [BtnSEFF addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
            [BtnSEFF setTitle:[NSString stringWithFormat:@"%@%d",[LANG DPLocalizedString:@"L_Master_Preset"],i+1] forState:UIControlStateNormal] ;
            BtnSEFF.titleLabel.adjustsFontSizeToFitWidth = true;
            BtnSEFF.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    
    
}

#pragma mark -----------------音效
-(void)initUserGroupList{
    int btnw = KScreenWidth/5+[Dimens GDimens:10];
    //    int btnh = [Dimens GDimens:60];
    
    self.SVList = [[UIScrollView alloc]init];
    [self.view addSubview:self.SVList];
    [self.SVList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset([Dimens GDimens:-20]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:UserPresetHeight]));
    }];
    self.SVList.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.SVList.delegate = self;
    // 设置内容大小
    //禁止UIScrollView垂直方向滚动，只允许水平方向滚动
    //scrollview.contentSize =  CGSizeMake(你要的长度, 0);
    //禁止UIScrollView水平方向滚动，只允许垂直方向滚动
    //scrollview.contentSize =  CGSizeMake(0, 你要的宽度);
    self.SVList.contentSize = CGSizeMake(btnw*MAX_USE_GROUP, 0);
    // 是否反弹
    self.SVList.bounces = NO;
    // 是否分页
    //self.SVList.pagingEnabled = YES;
    // 是否滚动
    //self.SVList.scrollEnabled = NO;
    self.SVList.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    // self.SVList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //self.SVList.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //self.SVList.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [self.SVList flashScrollIndicators];
    // 是否同时运动,lock
    self.SVList.directionalLockEnabled = NO;
    NSArray *seffColors=@[@(0xFFc9b178),@(0xFF2da14c),@(0xFF2eb0b6),@(0xFFbd3e43),@(0xFF3993c6),@(0xFFc9b178)];
    
    for(int i=0;i<MAX_USE_GROUP;i++){
        
        NormalButton *btn_seff = [[NormalButton alloc]initWithFrame:CGRectMake(btnw*i, 0, btnw-[Dimens GDimens:10],  [Dimens GDimens:UserPresetHeight])];
        btn_seff.layer.borderWidth=1;
        btn_seff.layer.cornerRadius=3;
        btn_seff.layer.borderColor=SetColor([seffColors[i] intValue]).CGColor;
        btn_seff.layer.masksToBounds=YES;
        [self.SVList addSubview:btn_seff];
        [btn_seff setTag:Tag_Btn_SEFF_Start+i+1];
        [btn_seff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_seff addTarget:self action:@selector(Btn_SEFF_Click:) forControlEvents:UIControlEventTouchUpInside];
//        [btn_seff setTitle:[NSString stringWithFormat:@"%@ %d",[LANG DPLocalizedString:@"L_Master_Preset"],i+1] forState:UIControlStateNormal] ;
        btn_seff.titleLabel.adjustsFontSizeToFitWidth = true;
//        btn_seff.titleLabel.numberOfLines=2;
        btn_seff.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    
}

- (void)Btn_SEFF_Click:(NormalButton*)sender {
    
    //    if(self.Btn_SEFFC != nil){
    //        [self.Btn_SEFFC setPress];
    //    }
    
    if(gConnectState){
        //        [sender setPress];
        self.Btn_SEFFC = sender;
        mGroup = sender.tag-Tag_Btn_SEFF_Start;
        //        [self.Btn_SEFFC setNormal];
        [self ShowSEFFOptDialog];
    }else{
        [self ShowConnectDialog];
    }
    
    
}


#pragma mark -----------------------界面响应事件
//模式按钮高亮状态下的背景色
- (void)modeBtnBackGroundHighlighted:(UIButton *)sender{
    [sender setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Press) forState:UIControlStateNormal];
    [sender setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Press)];
}
- (void)modeBtnBackGroundNormalOutside:(UIButton *)sender{
    [sender setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [sender setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
}
//模式按钮普通状态下的背景色
- (void)modeBtnBackGroundNormal:(UIButton *)sender
{
    [sender setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [sender setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    mGroup = sender.tag;
    mAlertType = 1;
    NSLog(@"BUG modeBtnBackGroundNormal mGroup=@%d",mGroup);
    //第二次点击
    if(BOOL_GroupClick[mGroup]){
        mAlertType = 2;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetDeleteMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Delete"], nil];
        [alert show];
    }
    BOOL_GroupClick[mGroup] = true;
    //延时执行
    [self performSelector:@selector(userGroupClick) withObject:nil afterDelay:0.5];
}

-(void)userGroupClick {
    NSLog(@"BUG userGroupClick");
    BOOL_GroupClick[mGroup] = false;
    if(mAlertType == 1){
        [_mDataTransmitOpt SEFF_Call:mGroup];
    }
}

-(void)Setbtn_SEFFNormalState{
    [self.Btn_SEFF1 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF1 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF2 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF2 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF3 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF3 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF4 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF4 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF5 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF5 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF6 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF6 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF7 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF7 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF8 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF8 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF9 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF9 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
    
    [self.Btn_SEFF10 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_SEFF10 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
}
-(void)Btn_SEFF_Sel:(int) sel{
    [self Setbtn_SEFFNormalState];
    switch (sel) {
        case 1:
            [self.Btn_SEFF1 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF1 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 2:
            [self.Btn_SEFF2 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF2 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 3:
            [self.Btn_SEFF3 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF3 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 4:
            [self.Btn_SEFF4 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF4 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 5:
            [self.Btn_SEFF5 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF5 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 6:
            [self.Btn_SEFF6 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF6 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 7:
            [self.Btn_SEFF7 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF7 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 8:
            [self.Btn_SEFF8 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF8 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 9:
            [self.Btn_SEFF9 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF9 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        case 10:
            [self.Btn_SEFF10 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
            [self.Btn_SEFF10 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
            break;
        default:
            break;
    }
}

//长按保存组数据
-(void)Btn_SEFF1_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 1;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF2_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 2;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF3_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 3;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF4_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 4;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF5_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 5;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF6_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 6;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF7_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 7;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF8_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 8;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF9_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 9;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"] delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"], nil];
        [alert show];
    }
}
-(void)Btn_SEFF10_UILongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        mGroup = 10;
        mAlertType = 3;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_Master_PresetOpt"]
                                                      message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"]
                                                     delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_Cancel"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Save"],nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"buttonIndex%i",buttonIndex);
    [self Setbtn_SEFFNormalState];
    if(buttonIndex == 1){
        switch (mAlertType) {
            case 1:
                
                break;
            case 2:
                [_mDataTransmitOpt SEFF_Delete:mGroup];
                break;
            case 3:
                [_mDataTransmitOpt SEFF_Save:mGroup];
                break;
            default:
                break;
        }
    }
    [self FlashUserGroupWithInputSource:RecStructData.System.input_source];
}



//进入高级设置
- (void)enterAdvanceSettings{
    if((!gConnectState)&&(!U0SynDataSucessFlg)){
        OptFunPage_TBC *OptFunPage_VC = [[OptFunPage_TBC alloc] init];
        [self presentViewController:OptFunPage_VC animated:YES completion:nil];
    }else {
        if(!DataCManager.UpdataAduanceData){
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_SyncDataMsg"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [DataCManager SEFF_Call:0];
                
                OptFunPage_TBC *OptFunPage_VC = [[OptFunPage_TBC alloc] init];
                
                [self presentViewController:OptFunPage_VC animated:YES completion:nil];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            OptFunPage_TBC *OptFunPage_VC = [[OptFunPage_TBC alloc] init];
            [self presentViewController:OptFunPage_VC animated:YES completion:nil];
        }
    }
    
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

-(void) FlashMasterMute{
    if(RecStructData.System.MainvolMuteFlg != 0){
        [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
        [self.Btn_MasterMute setNormal];
    }else{
        [self.Btn_MasterMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
        [self.Btn_MasterMute setPress];
    }
}
-(NSArray *)SourceArray{
    if (!_SourceArray) {
        _SourceArray=@[@"L_InputSource_Optical",@"L_InputSource_Coaxial",@"L_InputSource_Bluetooth",@"L_InputSource_High",@"L_InputSource_AUX"];
    }
    return _SourceArray;
}
-(NSArray *)SourceImages{
    if (!_SourceImages) {
        _SourceImages=@[@"icon_optical",@"icon_coaxial",@"icon_bluetooth_default",@"icon_hi_default",@"icon_aux_default"];
    }
    return _SourceImages;
}
-(void) FlashMixerInputSource{
    
    [self.Btn_MixerInputSource setTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:RecStructData.System.mixer_source]] forState:UIControlStateNormal];

    
}

-(void) FlashInputSource{
    
    [self.Btn_InputSource setTitle:[LANG DPLocalizedString:[self.SourceArray objectAtIndex:RecStructData.System.input_source]] forState:UIControlStateNormal];
    [self.Btn_InputSource setImage:[UIImage imageNamed:self.SourceImages[RecStructData.System.input_source]] forState:UIControlStateNormal];

    [self selectMixerSourceAndInputSource];
    
}

-(void) FlashUserGroupWithInputSource:(int)inputsource{
    /*
     [_Btn_SEFF1 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF1 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF1 setEnabled:false];
     
     [_Btn_SEFF2 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF2 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF2 setEnabled:false];
     
     [_Btn_SEFF3 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF3 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF3 setEnabled:false];
     
     [_Btn_SEFF4 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF4 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF4 setEnabled:false];
     
     [_Btn_SEFF5 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF5 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF5 setEnabled:false];
     
     [_Btn_SEFF6 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF6 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF6 setEnabled:false];
     
     [_Btn_SEFF7 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF7 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF7 setEnabled:false];
     
     
     [_Btn_SEFF8 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF8 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF8 setEnabled:false];
     
     [_Btn_SEFF9 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF9 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF9 setEnabled:false];
     
     [_Btn_SEFF10 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Disable) forState:UIControlStateNormal];
     [_Btn_SEFF10 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Disable)];
     [_Btn_SEFF10 setEnabled:false];
     
     
     switch (inputsource) {
     case 0:{//光纤，7
     [_Btn_SEFF7 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF7 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF7 setEnabled:true];
     }
     break;
     case 1:{//高电平，1-4
     [_Btn_SEFF1 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF1 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF1 setEnabled:true];
     
     [_Btn_SEFF2 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF2 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF2 setEnabled:true];
     
     [_Btn_SEFF3 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF3 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF3 setEnabled:true];
     
     [_Btn_SEFF4 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF4 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF4 setEnabled:true];
     }
     break;
     case 2:{//蓝牙，9-10
     [_Btn_SEFF9 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF9 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF9 setEnabled:true];
     
     [_Btn_SEFF10 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF10 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF10 setEnabled:true];
     
     }
     break;
     case 3:{//AUX，5-6
     [_Btn_SEFF5 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF5 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF5 setEnabled:true];
     
     [_Btn_SEFF6 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF6 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF6 setEnabled:true];
     }
     break;
     case 4:{//同轴，8
     [_Btn_SEFF8 setTitleColor:SetColor(UI_Master_UserGroup_BtnText_Normal) forState:UIControlStateNormal];
     [_Btn_SEFF8 setBackgroundColor:SetColor(UI_Master_UserGroup_Btn_Normal)];
     [_Btn_SEFF8 setEnabled:true];
     }
     break;
     default:
     break;
     }
     */
}
#pragma mark -----------------加密操作
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
    //NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
    setEnNum = fd.text;
}
- (void)ShowSetDecipheringDialog{
    setEnNum = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"]message:[LANG DPLocalizedString:@"L_Master_EN_SetDeciphering"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.secureTextEntry=YES;
        textField.textColor= [UIColor redColor];
        textField.text=setEnNum;
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(setEnTextDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_EN_EncryptionClean"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL_EncryptionFlag = FALSE;
        [_mDataTransmitOpt SEFF_EncryptClean];
        [self FlashEncryption];
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
#pragma mark-----------------音效操作
//音效选择，保存，调用，删除
- (void)ShowSEFFOptDialog{
    seffName = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[self getSEFFNameN:(mGroup)] message:[LANG DPLocalizedString:@"L_Master_PresetOpt"]preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_PresetRecall"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_mDataTransmitOpt SEFF_Call:mGroup];
        [self.Btn_SEFFC setNormal];
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
        [self.Btn_SEFFC setNormal];
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
        [self.Btn_SEFFC setNormal];
        [_mDataTransmitOpt SEFF_Save:mGroup];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        [self.Btn_SEFFC setNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//输入框文字改变时 方法
-(void)usernameDidChange:(UITextField *)fd{
    int zz=0,cc=0;
    
    for(int i=0; i< [fd.text length];i++){
        int a = [fd.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            zz++;
        }else{
            cc++;
        }
    }
    
    if((cc+zz*2) > 13){
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
        [self.Btn_SEFFC setNormal];
        NSLog(@"点击了确定按钮");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        [self.Btn_SEFFC setNormal];
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
#pragma mark -----保存数据到本地
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
            [_doc presentOptionsMenuFromRect:navRect inView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
            
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
            
            [self ShowSaveSuccessDialog];
        });
    }
}
- (void)ShowSaveSuccessDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SSM_SaveSuccessMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark---------------更新UI界面
- (void)flashBassVolume{
    for (int i=0; i<8; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    
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
}



-(void) FlashSEFFName{
    //更新音效名称
    /**/
    for(int i=1;i<=MAX_USE_GROUP;i++){
        NSString * groupName =[self getSEFFNameN:i];
        NormalButton *find_btn = (NormalButton *)[self.view viewWithTag:i+Tag_Btn_SEFF_Start];
        [find_btn setTitle:groupName forState:UIControlStateNormal] ;
        
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
        groupName = [NSString stringWithFormat:@"%@%d",[LANG DPLocalizedString:@"L_Master_Preset"],(group)];
    }
    
    return groupName;
}
- (void)flashInputsourceVolume{
    int val = 0;
//    switch (RecStructData.System.input_source) {
//        case 1:
//            val = RecStructData.System.Hi_src_vol;
//            break;
//        case 2:
//            val = RecStructData.System.Blue_src_vol;
//            break;
//        case 3:
//            val = RecStructData.System.Aux_src_vol;
//            break;
//        default:
//            break;
//    }
    self.LabInSrcVol.text=[NSString stringWithFormat:@"%d",val];
    self.SB_InSrcVol.value = val;
    
}

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
    }else if(LinkMODE == LINKMODE_AUTO){
        [self checkLinkAuto];
    }else{
        BOOL_LINK = false;
        BOOL_LOCK = false;
    }
    
}
-(void)checkLinkAuto{
    BOOL_LINK=false;
    for(int j=1;j<=16;j++){
        ChannelAnyLinkBuf[j]=0;
    }
    
//    for(int i=0;i<Output_CH_MAX_USE;i++){
//        if((RecStructData.OUT_CH[i].linkgroup_num <= Output_CH_MAX_USE)
//           && (RecStructData.OUT_CH[i].linkgroup_num!=0)){
//            ChannelAnyLinkBuf[i+1]=RecStructData.OUT_CH[i].linkgroup_num;
//            BOOL_LINK = true;
//        }
//    }
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        LG.Data[ChannelAnyLinkBuf[i]].group[LG.Data[ChannelAnyLinkBuf[i]].cnt]=i-1;
        LG.Data[ChannelAnyLinkBuf[i]].cnt+=1;
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
-(void)FlashPageUI{
    [self FlashMasterPageUI];
}
- (void)FlashMasterPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"####  FlashMasterPageUI");
        
        //    [self flashInputsourceVolume];
        //    [self flashBassVolume];
        [self FlashEncryption];
        [self FlashSEFFName];
        [self FlashMasterMute];
        [self FlashInputSource];
        [self flashMasterSubSelect:boolMasterSub];
        [self FlashMixerInputSource];
        //    [self FlashUserGroupWithInputSource:RecStructData.System.input_source];
    });
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashLinkState];
        [self FlashMasterPageUI];
    });
}

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

- (void)NotificationShowResetSEFFData:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_DataErr"] message:[LANG DPLocalizedString:@"L_DataErrResetMuc"] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.mDataTransmitOpt sendResetGroupData:CurGroup];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark--------------------这里实现TopBar代理控制器的协议方法
- (void)TopbarClickBack:(BOOL)Bool_Click{
    
    
}
- (void)gotoSEFFFileList{
    
    QIZLocalEffectViewController *vc = [[QIZLocalEffectViewController alloc] init];
    vc.title = [LANG DPLocalizedString:@"L_net_downed"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark ---------------SystemVolDelegate
-(void)updateVolValue:(int)value{
    self.SB_MasterVolume.value=value;
//    [self.SB_MasterVolume setProgress:value];
    self.Lab_MasterVolume.text=[NSString stringWithFormat:@"%d",value];
}

@end



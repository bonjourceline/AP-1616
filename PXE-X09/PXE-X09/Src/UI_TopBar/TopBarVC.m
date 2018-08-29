//
//  TopBarVC.m
//  HS-DAP812-DSP-8012
//
//  Created by chsdsp on 2017/8/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "TopBarVC.h"

@interface TopBarVC ()

@end

@implementation TopBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    [self initView];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 初始化
- (void) initView{
    
    //1.创建UI
    self.im_Logo     = [[UIImageView alloc] init];
    self.Btn_Back    = [[UIButton alloc] init];
    self.lab_Title   = [[UILabel  alloc] init];
    self.lab_Logo    = [[UILabel  alloc] init];
    self.Btn_Connect = [[UIButton alloc] init];
    self.Btn_Menu    = [[UIButton alloc] init];
    self.IVLine      = [[UIView alloc] init];
    
    [self.view addSubview:self.im_Logo];
    [self.view addSubview:self.Btn_Back];
    [self.view addSubview:self.lab_Title];
    [self.view addSubview:self.lab_Logo];
    [self.view addSubview:self.Btn_Connect];
    [self.view addSubview:self.Btn_Menu];
    [self.view addSubview:self.IVLine];
    self.IVLine.hidden = TRUE;
    
    
    //初始化
    //状态栏颜色
    self.view.frame = CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:TopBarHeight]);
    self.view.backgroundColor = [UIColor clearColor];
    //设置Logo
    [self.im_Logo setImage:[[UIImage imageNamed:@"topbar_logo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //[self.im_Logo setHidden:true];
    
    
    self.lab_Logo.font=[UIFont systemFontOfSize:18];
    self.lab_Logo.adjustsFontSizeToFitWidth=true;
    self.lab_Logo.textColor = SetColor(UI_ToolbarTitleColor);
    self.lab_Logo.textAlignment = NSTextAlignmentCenter;
    self.lab_Logo.text = welcome_logo;
    [self.lab_Logo setHidden:true];
    //设置返回
    [self.Btn_Back addTarget:self action:@selector(ClickEventOfBack) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Back setImage:[[UIImage imageNamed:@"topbar_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.Btn_Back setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.textColor = SetColor(UI_ToolbarBackTextColor);
    [self.Btn_Back setTitleColor:SetColor(UI_ToolbarBackTextColor) forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Back.titleLabel.font = [UIFont systemFontOfSize:15];
    self.Btn_Back.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_Back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_Back.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[self.Btn_Back setBackgroundColor:[UIColor blueColor]];
    self.Btn_Back.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:5],
        .bottom = 0,
        .right  = 0,
    };
    
    self.Btn_Back.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:0],
        .bottom = 0,
        .right  = [Dimens GDimens:TopBarLogoWidth - (TopBarLogoHeight+10)],
    };
    //设置主题
    self.lab_Title.font=[UIFont systemFontOfSize:20];
    self.lab_Title.textColor = SetColor(UI_ToolbarTitleColor);
    self.lab_Title.adjustsFontSizeToFitWidth = true;
    self.lab_Title.font = [UIFont systemFontOfSize:18];
    self.lab_Title.textAlignment = NSTextAlignmentCenter;
    self.lab_Title.text = [LANG DPLocalizedString:@"L_Master_Master"];
    //[self.lab_Title setHidden:true];
    //设置连接状态
    [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect"] forState:UIControlStateNormal];
    [self.Btn_Connect addTarget:self action:@selector(deviceConnect) forControlEvents:UIControlEventTouchUpInside];
    //设置菜单图片
    [self.Btn_Menu setImage:[UIImage imageNamed:@"topbar_menu"] forState:UIControlStateNormal];
    [self.Btn_Menu addTarget:self action:@selector(showPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    //设置大小位置
    //设置大小位置
    [self.im_Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    [self.lab_Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:5]);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    
    [self.Btn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    [self.lab_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(0);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:44]));
        
    }];
    
    [self.Btn_Menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:10]);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarMenuWidth], [Dimens GDimens:TopBarMenuHeight]));
    }];
    
    [self.Btn_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.Btn_Menu.mas_left).offset(-[Dimens GDimens:5]);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarConnectSize], [Dimens GDimens:TopBarConnectSize]));
    }];
    
    
    self.IVLine.frame = CGRectMake(0, [Dimens GDimens:TopBarHeight-1], KScreenWidth, 1);
    [self.IVLine setBackgroundColor:SetColor(UI_ToolbarBackgroundLineColor)];
    
    //    self.Btn_Back.hidden = TRUE;
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //连接BLE设备
    [center addObserver:self selector:@selector(noiceScanBLE:) name:MyNotification_NoticeScanBLE object:nil];
    //通信连接成功
    [center addObserver:self selector:@selector(setConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
}

//设置是否显示Logo
- (void)setLogoShow:(BOOL)Show{
    if(Show){
        self.im_Logo.hidden  = false;
        self.Btn_Back.hidden = true;
    }else{
        self.im_Logo.hidden  = TRUE;
        self.Btn_Back.hidden = false;
    }
}

//设置是否显示Menu
- (void)setMenuShow:(BOOL)Show{
    if(Show){
        self.Btn_Menu.hidden  = false;
        [self.Btn_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.Btn_Menu.mas_left).offset(-[Dimens GDimens:20]);
            make.centerY.equalTo(self.view).offset(0);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarConnectSize], [Dimens GDimens:TopBarConnectSize]));
        }];
    }else{
        self.Btn_Menu.hidden  = TRUE;
        [self.Btn_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.Btn_Menu.mas_left).offset(-[Dimens GDimens:0]);
            make.centerY.equalTo(self.view).offset(0);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarConnectSize], [Dimens GDimens:TopBarConnectSize]));
        }];
        
    }
}

//设置标题名字
- (void)setTitle:(NSString*)Name{
    [self.lab_Title setText:Name];
}

//设置连接状态 ConnectState
- (void)setConnectStateFormNotification:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [sender userInfo];
        
        NSString *okStr = [dic objectForKey:@"ConnectState"];
        if ([okStr isEqualToString:@"YES"]) {
            [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_connected"] forState:UIControlStateNormal];
        }else {
            [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect"] forState:UIControlStateNormal];
            [self.bleManager NotifyValue:NO];
            gConnectState = false;
            gOldConnectState = false;
            U0SynDataSucessFlg = false;
        }
    });
    
}

- (void)setConnectState:(BOOL)Bool_Connect{
    if(Bool_Connect){
        [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_connected"] forState:UIControlStateNormal];
    }else {
        [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect"] forState:UIControlStateNormal];
    }
}
//返回点击事件
- (void)ClickEventOfBack{
//    if ([self.delegate respondsToSelector:@selector(TopbarClickBack:)]) { // 如果协议响应了sendValue:方法
//        [self.delegate TopbarClickBack:TRUE]; // 通知执行协议方法
//    }
}


//音效操作
- (void)gotoSEFFFileOpt:(int)set{
    [self SEFFFile_Opt:set];
//    NSLog(@"gotoSEFFFileOpt:%d",set);
//    if ([self.delegate respondsToSelector:@selector(SEFFFileOpt:)]) { // 如果协议响应了sendValue:方法
//        [self.delegate SEFFFileOpt:set]; // 通知执行协议方法
//    }
}
//点击menu
/**
 *  弹出菜单监听处理
 */
-(void)showPopMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:[LANG DPLocalizedString:@"L_Menu_Share"]
                     image:[UIImage imageNamed:@"menu_share"]
                    target:self
                    action:@selector(pushShareEffect:)],
      
      [KxMenuItem menuItem:[LANG DPLocalizedString:@"L_Menu_Save"]
                     image:[UIImage imageNamed:@"menu_save"]
                    target:self
                    action:@selector(pushSaveEffect:)],
      
      [KxMenuItem menuItem:[LANG DPLocalizedString:@"L_Menu_Open"]
                     image:[UIImage imageNamed:@"menu_loadfile"]
                    target:self
                    action:@selector(pushOpenEffect:)],
      
      [KxMenuItem menuItem:[LANG DPLocalizedString:@"L_Menu_About"]
                     image:[UIImage imageNamed:@"menu_about"]
                    target:self
                    action:@selector(pushMenuAbout:)],
      
      ];
    //    KxMenuItem *item1 = menuItems[0];
    //    //item1.foreColor = [UIColor colorWithRed:60/255.0f green:160/255.0f blue:250/255.0f alpha:1.0];
    //    item1.foreColor = [UIColor whiteColor];
    //    //item1.alignment = NSTextAlignmentCenter;
    //
    //    KxMenuItem *item2 = menuItems[1];
    //    //    item2.foreColor = [UIColor colorWithRed:60/255.0f green:160/255.0f blue:250/255.0f alpha:1.0];
    //    item2.foreColor = [UIColor whiteColor];
    //    //item2.alignment = NSTextAlignmentCenter;
    //
    //    /*
    //     KxMenuItem *item3 = menuItems[2];
    //     //    item3.foreColor = [UIColor colorWithRed:60/255.0f green:160/255.0f blue:250/255.0f alpha:1.0];
    //     item3.foreColor = [UIColor whiteColor];
    //     //item3.alignment = NSTextAlignmentCenter;
    //     */
    
    
    CGRect fromRect = CGRectMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame)+5, sender.frame.size.width, sender.frame.size.height);
    [KxMenu showMenuInView:self.view.window
                  fromRect:fromRect
                 menuItems:menuItems];
}
#pragma About
//关于弹出窗口
- (void) pushMenuAbout:(id)sender{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    contentView.backgroundColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(10, 1, 60, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_Menu_About"];
    [contentView addSubview:labelTitle];
    
    UILabel *deviceType = [[UILabel alloc] init];
    deviceType.textColor = [UIColor whiteColor];
    deviceType.frame = CGRectMake(10, 30, 260, 30);
    deviceType.font = [UIFont systemFontOfSize:12];
    NSString *deviceTypeVersion = [LANG DPLocalizedString:@"L_Menu_About_device"];
    NSString *deviceTypeStr = [deviceTypeVersion stringByAppendingString:welcome_logo];
    
    deviceType.text = deviceTypeStr;
    [contentView addSubview:deviceType];
    
    UILabel *deviceVersion = [[UILabel alloc] init];
    deviceVersion.textColor = [UIColor whiteColor];
    deviceVersion.frame = CGRectMake(10, 60, 260, 30);
    deviceVersion.font = [UIFont systemFontOfSize:12];
    NSString *deviceMCUVersion = [LANG DPLocalizedString:@"L_Menu_About_DevVersion"];
    NSString *deviceVersionStr = [deviceMCUVersion stringByAppendingString:DeviceVerString];
    deviceVersion.text = deviceVersionStr;
    [contentView addSubview:deviceVersion];
    
    UILabel *softVersion = [[UILabel alloc] init];
    softVersion.textColor = [UIColor whiteColor];
    softVersion.frame = CGRectMake(10, 90, 260, 30);
    softVersion.font = [UIFont systemFontOfSize:12];
    NSString *softWVersion = [LANG DPLocalizedString:@"L_Menu_About_SoftVersion"];
    NSString *softVersionStr = [softWVersion stringByAppendingString:App_versions];
    softVersion.text = softVersionStr;
    [contentView addSubview:softVersion];
    
    UILabel *copyRight = [[UILabel alloc] init];
    copyRight.numberOfLines = 0;// 值设定为0时，多行显示。
    copyRight.textColor = [UIColor whiteColor];
    copyRight.frame = CGRectMake(10, 120, 260, 30);
    copyRight.font = [UIFont systemFontOfSize:12];
    //NSString *cr = [LANG DPLocalizedString:@"L_Menu_About_Copyright"];
    //NSString *copyRightStr = [cr stringByAppendingString:Copyright];
    copyRight.text = Copyright;
    [contentView addSubview:copyRight];
    
    
    NormalButton *btnOK = [NormalButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.frame = CGRectMake(100, 170, 80, 25);
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
    
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}
//- (void)Btn_NormalButtom_NormalStatus:(NormalButton *)sender {
//    [sender setNormal];
//}
//- (void)Btn_NormalButtom_PressStatus:(NormalButton *)sender {
//    [sender setPress];
//}
#pragma 分享
- (void)pushShareEffect:(id)sender{
    SEFFFile_name = @"";
    SEFFFile_Dital = @"";
    
    int contentW = 300;
    int contentH = 160;
    int margin = 10;
    int btnPadding = 35;
    int btnW = (contentW-3*btnPadding)/2;
    int btnH = 35;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    //1.文件名称label
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(10, 1, 250, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_SSM_ShareMSG"];
    labelTitle.font = [UIFont systemFontOfSize:15.0];
    labelTitle.textColor = [UIColor blackColor];
    [contentView addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).mas_equalTo(margin*0.5);
        make.size.mas_equalTo(CGSizeMake(contentW, 30));
    }];
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    
    //3.选择单组、整组部分
    UIView *saView = [[UIView alloc] init];
    saView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:saView];
    [saView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelTitle.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(contentW, 70));
    }];
    
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [singleBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [singleBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Single"] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    singleBtn.tag = 0;
    [saView addSubview:singleBtn];
    [singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_top).mas_equalTo(3);
        make.left.mas_equalTo(saView.mas_left).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(70, 35));
    }];
    self.singleChoiceBtn = singleBtn;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.tag = 1;
    [allBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [allBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Machine"] forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(singleBtn.mas_centerY);
        make.left.mas_equalTo(singleBtn.mas_right).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(70, 35));
    }];
    
    self.allChoiceBtn = allBtn;
    
    //
    UILabel *allGroupNotice = [[UILabel alloc] init];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.frame = CGRectMake(10, 1, 70, 30);
    allGroupNotice.text = [LANG DPLocalizedString:@"L_SSM_ShareMacMSG"];
    allGroupNotice.textColor = [UIColor blackColor];
    allGroupNotice.font = [UIFont systemFontOfSize:15.0];
    [saView addSubview:allGroupNotice];
    
    [allGroupNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(saView.mas_centerX);
        make.top.mas_equalTo(allBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(contentW, 35));
    }];
    
    allGroupNotice.textAlignment = NSTextAlignmentCenter;
    self.allChoiceLabel = allGroupNotice;
    self.allChoiceLabel.hidden = YES;
    
    gSeffFileType = SeffFileType_Single;
    //添加监听事件
    [singleBtn addTarget:self action:@selector(doChoiceShareMode:) forControlEvents:UIControlEventTouchUpInside];
    [allBtn addTarget:self action:@selector(doChoiceShareMode:) forControlEvents:UIControlEventTouchUpInside];
    
    //4.按钮部分
    UIView *btnsView = [[UIView alloc] init];
    [contentView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    btnsView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btnsView addSubview:saveBtn];
    [btnsView addSubview:cancelBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(btnsView.mas_left).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:[LANG DPLocalizedString:@"L_SSM_ShareOpt"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [saveBtn addTarget:self action:@selector(doShareEffectFileOK) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(saveBtn.mas_right).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_SSM_CancelOpt"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)doShareEffectFileOK{
    SEFFFILE_OPT = SEFFFILE_SHARE;
    [self gotoSEFFFileOpt:SEFFFILE_SHARE];
    [[KGModal sharedInstance] hide];
}

- (void)doCancel{
    [[KGModal sharedInstance] hideAnimated:YES];
}

//选择单组、整组
- (void)doChoiceSaveMode:(UIButton *)btn
{
    //整组
    if (btn.tag == 1) {
        self.allChoiceLabel.text = [LANG DPLocalizedString:@"L_SSM_SaveMacMSG"];
        gSeffFileType = SeffFileType_Mac;
        [self.singleChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.allChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        
        self.allChoiceLabel.hidden = false;
    } else {//单组
        gSeffFileType = SeffFileType_Single;
        [self.singleChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        [self.allChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        
        self.allChoiceLabel.hidden = true;
    }
}

//选择单组、整组
- (void)doChoiceShareMode:(UIButton *)btn
{
    //整组
    if (btn.tag == 1) {
        self.allChoiceLabel.text = [LANG DPLocalizedString:@"L_SSM_SaveMacMSG"];
        gSeffFileType = SeffFileType_Mac;
        [self.singleChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.allChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        
        self.allChoiceLabel.hidden = false;
    } else {//单组
        gSeffFileType = SeffFileType_Single;
        [self.singleChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        [self.allChoiceBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
        
        self.allChoiceLabel.hidden = true;
    }
}

#pragma 保存
- (void)pushSaveEffect:(id)sender{
    SEFFFile_name = @"";
    SEFFFile_Dital = @"";
    
    int contentW = 300;
    int contentH = 210;
    int margin = 10;
    int btnPadding = 35;
    int btnW = (contentW-3*btnPadding)/2;
    int btnH = 35;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    contentView.backgroundColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    
    //1.文件名称label
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(10, 1, 70, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_SSM_FileName"];
    labelTitle.adjustsFontSizeToFitWidth = true;
    labelTitle.font = [UIFont systemFontOfSize:13];
    labelTitle.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).mas_equalTo(margin*0.5);
        make.top.mas_equalTo(contentView.mas_top).mas_equalTo(margin*0.5);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    //2.输入文件名称
    
    UITextField *nameTextField = [[UITextField alloc] init];
    [contentView addSubview:nameTextField];
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(labelTitle.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(contentW-70-2*margin, 35));
    }];
    
    nameTextField.placeholder = @"";
    nameTextField.textAlignment = NSTextAlignmentCenter;
    [nameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    nameTextField.returnKeyType = UIReturnKeyDone;
    self.fileNameTextField = nameTextField;
    
    [nameTextField addTarget:self  action:@selector(valueChangedWithSaveLocalFile:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    //3.详情label
    UILabel *labelDetail = [[UILabel alloc] init];
    labelDetail.textColor = [UIColor whiteColor];
    labelDetail.frame = CGRectMake(10, 1, 70, 30);
    labelDetail.text = [LANG DPLocalizedString:@"L_SSM_Detials"];
    labelDetail.adjustsFontSizeToFitWidth = true;
    labelDetail.font = [UIFont systemFontOfSize:13];
    labelDetail.textAlignment = NSTextAlignmentRight;
    
    [contentView addSubview:labelDetail];
    
    [labelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).mas_equalTo(margin*0.5);
        make.top.mas_equalTo(nameTextField.mas_bottom).mas_equalTo(margin);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    //4.详情
    UITextField *detailTextField = [[UITextField alloc] init];
    [contentView addSubview:detailTextField];
    
    [detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelDetail.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(labelDetail.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(contentW-70-2*margin, 35));
    }];
    
    detailTextField.placeholder = @"";
    detailTextField.textAlignment = NSTextAlignmentCenter;
    [detailTextField setBorderStyle:UITextBorderStyleRoundedRect];
    detailTextField.textColor = [UIColor blackColor];
    detailTextField.keyboardType = UIKeyboardTypeDefault;
    detailTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    detailTextField.returnKeyType = UIReturnKeyDone;
    self.detailTextField = detailTextField;
    
    [detailTextField addTarget:self  action:@selector(valueChangedWithSaveLocalFileDetail:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    //3.选择单组、整组部分
    UIView *saView = [[UIView alloc] init];
    saView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:saView];
    [saView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailTextField.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(contentW, 70));
    }];
    
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [singleBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [singleBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Single"] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    singleBtn.tag = 0;
    [saView addSubview:singleBtn];
    [singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_top).mas_equalTo(3);
        make.left.mas_equalTo(saView.mas_left).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(70, 35));
    }];
    self.singleChoiceBtn = singleBtn;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.tag = 1;
    [allBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [allBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Machine"] forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(singleBtn.mas_centerY);
        make.left.mas_equalTo(singleBtn.mas_right).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(70, 35));
    }];
    
    self.allChoiceBtn = allBtn;
    
    //
    UILabel *allGroupNotice = [[UILabel alloc] init];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.frame = CGRectMake(10, 1, 70, 30);
    allGroupNotice.text = [LANG DPLocalizedString:@"L_SSM_SaveMacMSG"];
    allGroupNotice.textColor = [UIColor blackColor];
    allGroupNotice.font = [UIFont systemFontOfSize:15.0];
    [saView addSubview:allGroupNotice];
    
    [allGroupNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(saView.mas_centerX);
        make.top.mas_equalTo(allBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(contentW, 35));
    }];
    
    allGroupNotice.textAlignment = NSTextAlignmentCenter;
    self.allChoiceLabel = allGroupNotice;
    self.allChoiceLabel.hidden = YES;
    
    gSeffFileType = SeffFileType_Single;
    //添加监听事件
    [singleBtn addTarget:self action:@selector(doChoiceSaveMode:) forControlEvents:UIControlEventTouchUpInside];
    [allBtn addTarget:self action:@selector(doChoiceSaveMode:) forControlEvents:UIControlEventTouchUpInside];
    
    //4.按钮部分
    UIView *btnsView = [[UIView alloc] init];
    [contentView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    btnsView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btnsView addSubview:saveBtn];
    [btnsView addSubview:cancelBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(btnsView.mas_left).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:[LANG DPLocalizedString:@"L_SSM_SaveOpt"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [saveBtn addTarget:self action:@selector(doSaveEffectFileOK) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(saveBtn.mas_right).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_SSM_CancelOpt"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    //    [[KGModal sharedInstance] setOKButton:saveBtn];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
    
}

- (void)valueChangedWithSaveLocalFile:(UITextField *)textField
{
    if(textField.text.length > 12){
        textField.text = self.saveLocalName;
    }
    self.saveLocalName = textField.text;
}

- (void)valueChangedWithSaveLocalFileDetail:(UITextField *)textField
{
    self.saveLocalNameDetail = textField.text;
    //    NSLog(@"valueChangedWithSaveLocalFileDetail");
}

- (void)doSaveEffectFileOK{
    SEFFFILE_OPT = SEFFFILE_Save;
    SEFFFile_name = self.saveLocalName;
    SEFFFile_Dital = self.saveLocalNameDetail;
    
    if(SEFFFile_name.length > 0){
        [self gotoSEFFFileOpt:SEFFFILE_Save];
        [[KGModal sharedInstance] hideAnimated:YES];
    }else{
        self.allChoiceLabel.hidden = false;
        self.allChoiceLabel.text = [LANG DPLocalizedString:@"L_SSM_FileNameMsg"];
    }
    
}

#pragma 打开文件列表
- (void)pushOpenEffect:(id)sender{
    [self gotoSEFFFileOpt:SEFFFILE_List];
}


#pragma Bluetooth
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex){
        return;
    }
    
    QIZLog(@"选择了蓝牙设备:%d",(int)buttonIndex);
    //    _bChooseBLEConnect = TRUE;
    //    _nScanBLEConnectIndex = (int)buttonIndex;
    [self connectBluetoothDevice:buttonIndex];
}
//连接蓝牙
- (void)connectBluetoothDevice:(NSInteger)nIndex{
    if (self.peripherals.count > 0){
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:nIndex];
        
        self.currPeripheral = peripheral;
        self.bleManager.currPeripheral = peripheral;
        
        [NSThread sleepForTimeInterval:0.01];
        
        self.bleManager.baby.having(self.currPeripheral).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
}
//蓝牙相关
//接收到蓝牙扫描通知
-(void)noiceScanBLE:(id)sender{
    NSDictionary *dic = [sender userInfo];
    NSString *okStr = [dic objectForKey:@"CancelScan"];
    if ([okStr isEqualToString:@"OK"]) {
        self.peripherals = self.bleManager.peripherals;
        if (self.peripherals.count>0) {
            [self showBluetoothDeviceList];
        }
    }
}
//判断蓝牙通知
-(void)noticeDisconectDevice:(id)sender{
    
    gConnectState = false;
    gOldConnectState = false;
    U0SynDataSucessFlg = false;
    QIZLog(@"noticeHomeDisconectDevice");
    
    [self.Btn_Connect setImage:[UIImage imageNamed:@"disconnect"] forState:UIControlStateNormal];
    [self.bleManager NotifyValue:NO];
}
//蓝牙设备连接
-(void)deviceConnect{
    if (gConnectState) {
        [self.bleManager NotifyValue:NO];
        //连接状态
        NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
        ConnectState[@"ConnectState"] = @"NO";
        //创建一个消息对象
        NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
        [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
    }else {
        self.bleManager = [BLEManager shareBLEManager];
        [self.bleManager doScanBluetoothPeriphals];
    }
    
}

/**
 * 显示扫描到的蓝牙列表
 */
-(void)showBluetoothDeviceList
{
    //__weak __typeof(self) weakSelf = self;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:[LANG DPLocalizedString:@"L_BLE_DeviceSEL"]
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    for (int i=0; i<self.peripherals.count; i++){
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:i];
        [sheet addButtonWithTitle:peripheral.name];
    }
    
    
    // 同时添加一个取消按钮
    [sheet addButtonWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]];
    // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮
    // NB - 这会导致该按钮显示时有黑色背景
    sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    [sheet showInView:self.view];
}



-(void)SEFFFile_Opt:(int)Opt{
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
//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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


#pragma LoadJsonFileNotification

- (void)LoadJsonFileNotification:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [sender userInfo];
        NSString *State = [dic objectForKey:@"State"];
        if ([State isEqualToString:SHOWLoading]) {
            [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
        }else if ([State isEqualToString:JSONFILE_ERROR]) {
            [self showSEFFFileError];
        }else if ([State isEqualToString:JSONFILEMac_ERROR]) {
            [self showBrandMacError];
        }else if ([State isEqualToString:SHOWRecSEFFFile]) {
            [self showRecSEFFFile];
        }
    });
    
    
}
//音效文件错误提示框
- (void)showSEFFFileError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_FileError"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//音效机型错误提示框
- (void)showBrandMacError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SEFF_WRONG_MAC"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//接收到音效文件提示框
- (void)showRecSEFFFile{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SSM_RecSEFFileMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

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

#pragma 显示进度
- (void)Notification_ShowProgress:(id)sender{
    
    NSDictionary *dic = [sender userInfo];
    NSString *okStr = [dic objectForKey:@"State"];
    if ([okStr isEqualToString:ShowProgressSave]) {
        NSLog(@"ShowProgressSave...");
        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Save"] WithMode:SEFF_OPT_Save];
    }else if ([okStr isEqualToString:ShowProgressCall]) {
        NSLog(@"ShowProgressCall...");
        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
    }
}

#pragma 进度显示
- (void)initSaveLoadSEFFProgress{
    
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

-(void)hudWasHidden:(MBProgressHUD *)hud{
    NSLog(@"hudWasHidden");
    [hud removeFromSuperview];
    //[hud release];
    hud = nil;
}

-(void) HUD_SEFFProgressTask{
    
    
    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
    
    NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [_mDataTransmitOpt GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
        if((progress <= 0)||(progress > 100)){
            cnt = 0;
            break;
        }
        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
        self.HUD_SEFF.progress = 1-progress/100.0;
        usleep(10000);
    }
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
@end

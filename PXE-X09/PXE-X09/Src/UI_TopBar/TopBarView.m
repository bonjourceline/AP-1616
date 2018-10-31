//
//  TopBarView.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/28.
//  Copyright © 2017年 dsp. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TopBarView.h"

#import "Define_Color.h"
#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"
#import "DataProgressHUD.h"
#import "QIZDatabaseTool.h"

@implementation TopBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void) initView{
    
    //1.创建UI
    self.im_Logo     = [[UIImageView alloc] init];
    self.Btn_Back    = [[UIButton alloc] init];
    self.lab_Title   = [[UILabel  alloc] init];
    self.lab_Logo    = [[UILabel  alloc] init];
    self.Btn_Connect = [[UIButton alloc] init];
    self.Btn_Menu    = [[UIButton alloc] init];
    self.IVLine      = [[UIView alloc] init];
    self.lab_Connect    = [[UILabel  alloc] init];
    
    [self addSubview:self.im_Logo];
    [self addSubview:self.Btn_Back];
    [self addSubview:self.lab_Title];
    [self addSubview:self.lab_Logo];
    [self addSubview:self.Btn_Connect];
    [self addSubview:self.Btn_Menu];
    [self addSubview:self.IVLine];
    [self addSubview:self.lab_Connect];
    self.IVLine.hidden = false;
    self.lab_Connect.hidden = TRUE;
    
    //初始化
    //状态栏颜色
    self.frame = CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:TopBarHeight]);
    self.backgroundColor = [UIColor clearColor];
    //设置Logo
    [self.im_Logo setImage:[[UIImage imageNamed:@"topbar_logo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[self.im_Logo setHidden:true];
    self.im_Logo.contentMode=UIViewContentModeLeft;
    
    self.lab_Logo.font=[UIFont systemFontOfSize:18];
    self.lab_Logo.adjustsFontSizeToFitWidth=true;
    self.lab_Logo.textColor = SetColor(UI_ToolbarTitleColor);
    self.lab_Logo.textAlignment = NSTextAlignmentCenter;
    self.lab_Logo.text = welcome_logo;
    [self.lab_Logo setHidden:true];
    //设置返回
    [self.Btn_Back addTarget:self action:@selector(ClickEventOfBack) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Back setImage:[[UIImage imageNamed:@"topbar_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //    [self.Btn_Back setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];
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
    
    self.lab_Title.textColor = SetColor(UI_ToolbarTitleColor);
    self.lab_Title.adjustsFontSizeToFitWidth = true;
    self.lab_Title.font = [UIFont systemFontOfSize:20];
    self.lab_Title.textAlignment = NSTextAlignmentCenter;
    self.lab_Title.text = [LANG DPLocalizedString:@"L_Master_Master"];
    //[self.lab_Title setHidden:true];
    //设置连接状态
    //    [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect"] forState:UIControlStateNormal];
    //    self.Btn_Connect.layer.borderWidth=1;
    [self setConnectBtn_Normal];
    self.Btn_Connect.titleLabel.font=[UIFont systemFontOfSize:[Dimens GDimens:12]];
    [self.Btn_Connect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    self.Btn_Connect.layer.cornerRadius=[Dimens GDimens:TopBarConnectSize]/2;
    //    self.Btn_Connect.layer.masksToBounds=YES;
    [self.Btn_Connect addTarget:self action:@selector(deviceConnect) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_Connect.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    self.lab_Connect.font=[UIFont systemFontOfSize:20];
    self.lab_Connect.textColor = SetColor(UI_Connect_Normal);
    self.lab_Connect.text = [LANG DPLocalizedString:@"L_Disconnected"];
    self.lab_Connect.adjustsFontSizeToFitWidth = true;
    self.lab_Connect.font = [UIFont systemFontOfSize:7];
    self.lab_Connect.textAlignment = NSTextAlignmentCenter;
    
    
    //设置菜单图片
    [self.Btn_Menu setImage:[UIImage imageNamed:@"topbar_menu"] forState:UIControlStateNormal];
    self.Btn_Menu.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.Btn_Menu addTarget:self action:@selector(showPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    //设置大小位置
    //设置大小位置
    [self.im_Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    [self.lab_Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    
    [self.Btn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    [self.lab_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset([Dimens GDimens:0]);
        make.centerY.equalTo(self.mas_centerY).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:44]));
    }];
    
    [self.Btn_Menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-[Dimens GDimens:10]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarMenuWidth], [Dimens GDimens:TopBarMenuHeight]));
    }];
    
    [self.Btn_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.Btn_Menu.mas_left).offset(-[Dimens GDimens:13]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarConnectWidth], [Dimens GDimens:TopBarConnectSize]));
    }];
    [self.lab_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.Btn_Connect.mas_centerX).offset(-[Dimens GDimens:0]);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:30]));
    }];
    
    self.IVLine.frame = CGRectMake(0, [Dimens GDimens:TopBarHeight+6], KScreenWidth, 1);
    [self.IVLine setBackgroundColor:SetColor(UI_ToolbarBackgroundLineColor)];
    self.IVLine.hidden=YES;
    //    self.Btn_Back.hidden = TRUE;
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //连接BLE设备
    //    [center addObserver:self selector:@selector(noiceScanBLE:) name:MyNotification_NoticeScanBLE object:nil];
    if (gConnectState) {
        [self setConnectState:true];
    }
    //通信连接成功
    [center addObserver:self selector:@selector(setConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
}
-(void)setConnectBtn_Normal{
    [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect_E"] forState:UIControlStateNormal];
    //    self.Btn_Connect.layer.borderColor=SetColor(UI_Connect_Border_Normal).CGColor;
    //    self.Btn_Connect.backgroundColor=SetColor(UI_Connect_Normal);
    //    [self.Btn_Connect setTitle: [LANG DPLocalizedString:@"L_Disconnected"] forState:UIControlStateNormal];
}
-(void)setConnectBtn_Press{
    [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_connected_E"] forState:UIControlStateNormal];
    //    self.Btn_Connect.layer.borderColor=SetColor(UI_Connect_Border_Press).CGColor;
    //    self.Btn_Connect.backgroundColor=SetColor(UI_Connect_Press);
    //    [self.Btn_Connect setTitle:[LANG DPLocalizedString:@"L_Connected"] forState:UIControlStateNormal];
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
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarConnectSize], [Dimens GDimens:TopBarConnectSize]));
        }];
    }else{
        self.Btn_Menu.hidden  = TRUE;
        [self.Btn_Connect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.Btn_Menu.mas_left).offset(-[Dimens GDimens:0]);
            make.centerY.mas_equalTo(self);
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
            [self setConnectState:true];
        }else {
            [self setConnectState:false];
            [self.bleManager NotifyValue:NO];
            
            [[BLEManager shareBLEManager].baby cancelAllPeripheralsConnection];
            gConnectState = false;
            gOldConnectState = false;
            U0SynDataSucessFlg = false;
            DataCManager.UpdataAduanceData=true;
            [DataCManager setFlagDefault];
            [self tisFailConnect];
        }
    });
    
}
-(void)tisFailConnect{
    [[DataProgressHUD shareManager]showFailConnectionHub];
}
- (void)setConnectState:(BOOL)Bool_Connect{
    if(Bool_Connect){
        //        [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_connected"] forState:UIControlStateNormal];
        [self setConnectBtn_Press];
//        self.lab_Connect.textColor = SetColor(UI_Connect_Press);
//        self.lab_Connect.text = [LANG DPLocalizedString:@"L_Connected"];
    }else {
        //        [self.Btn_Connect setImage:[UIImage imageNamed:@"topbar_disconnect"] forState:UIControlStateNormal];
        [self setConnectBtn_Normal];
//        self.lab_Connect.textColor = SetColor(UI_Connect_Normal);
//        self.lab_Connect.text = [LANG DPLocalizedString:@"L_Disconnected"];
    }
}
//返回点击事件
- (void)ClickEventOfBack{
    if ([self.delegate respondsToSelector:@selector(TopbarClickBack:)]) { // 如果协议响应了sendValue:方法
        [self.delegate TopbarClickBack:TRUE]; // 通知执行协议方法
    }
}

#pragma mark-----------------------------代理
//音效操作
- (void)gotoSEFFFileOpt:(int)set{
    
    NSLog(@"gotoSEFFFileOpt:%d",set);
    if ([self.delegate respondsToSelector:@selector(SEFFFileOpt:)]) { // 如果协议响应了sendValue:方法
        [self.delegate SEFFFileOpt:set]; // 通知执行协议方法
    }
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
    [KxMenu showMenuInView:self.window
                  fromRect:fromRect
                 menuItems:menuItems];
}
#pragma mark ---- About
//关于弹出窗口
- (void) pushMenuAbout:(id)sender{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    contentView.backgroundColor =SetColor(0xFF052545);
    
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
    [btnOK setTitle:[LANG DPLocalizedString:@"L_System_Confirm"] forState:UIControlStateNormal];
    btnOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[btnOK addTarget:self action:@selector(gainExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xFF052545)];
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
#pragma mark -------------------分享
- (void)pushShareEffect:(id)sender{
    SEFFFile_name = @"";
    SEFFFile_Dital = @"";
    
    int contentW = 300;
    int contentH = 170;
    int margin = 10;
    int btnPadding = 35;
    int btnW = (contentW-3*btnPadding)/2;
    int btnH = 35;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    contentView.backgroundColor = SetColor(0xFF052545);
    
    //1.文件名称label
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(10, 1, 250, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_SSM_ShareMacMSG"];
    labelTitle.numberOfLines=2;
    labelTitle.font = [UIFont systemFontOfSize:15.0];
    labelTitle.textColor = [UIColor whiteColor];
    [contentView addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).mas_equalTo(margin*0.5);
        make.size.mas_equalTo(CGSizeMake(contentW, 50));
    }];
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    
    //3.选择单组、整组部分
    UIView *saView = [[UIView alloc] init];
    saView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:saView];
    [saView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelTitle.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(contentW, [Dimens GDimens:60]));
    }];
    
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [singleBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [singleBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Single"] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    singleBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    singleBtn.titleLabel.numberOfLines=2;
    //    singleBtn.backgroundColor=[UIColor yellowColor];
    singleBtn.tag = 0;
    [saView addSubview:singleBtn];
    [singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_top).mas_equalTo(3);
        make.right.mas_equalTo(saView.mas_centerX).mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(110, 35));
    }];
    self.singleChoiceBtn = singleBtn;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.tag = 1;
    //    allBtn.backgroundColor=[UIColor yellowColor];
    [allBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [allBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Machine"] forState:UIControlStateNormal];
    allBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    allBtn.titleLabel.numberOfLines=2;
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(singleBtn.mas_centerY);
        make.left.mas_equalTo(saView.mas_centerX).mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    allBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.allChoiceBtn = allBtn;
    
    //
    UILabel *allGroupNotice = [[UILabel alloc] init];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.frame = CGRectMake(10, 1, 70, 30);
    allGroupNotice.text = [LANG DPLocalizedString:@"L_SSM_ShareMacMSG"];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.font = [UIFont systemFontOfSize:15.0];
    allGroupNotice.adjustsFontSizeToFitWidth=YES;
    //        [saView addSubview:allGroupNotice];
    //
    //        [allGroupNotice mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.centerX.mas_equalTo(saView.mas_centerX);
    //            make.top.mas_equalTo(allBtn.mas_bottom);
    //            make.size.mas_equalTo(CGSizeMake(contentW, 35));
    //        }];
    //
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
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(0xFF1e3b57);
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnsView.mas_top).offset([Dimens GDimens:-10]);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    //    btnsView.backgroundColor = SetColor(c);
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.layer.borderWidth=1;
    saveBtn.layer.cornerRadius=5;
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.layer.borderWidth=1;
    cancelBtn.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    cancelBtn.layer.cornerRadius=5;
    cancelBtn.layer.masksToBounds=YES;
    [btnsView addSubview:saveBtn];
    [btnsView addSubview:cancelBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(btnsView.mas_left).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    //    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    //    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:[LANG DPLocalizedString:@"L_SSM_ShareOpt"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:SetColor(UI_Master_SB_Volume_Press) forState:UIControlStateNormal];
    
    [saveBtn addTarget:self action:@selector(doShareEffectFileOK) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(saveBtn.mas_right).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_SSM_CancelOpt"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:SetColor(UI_Master_SB_Volume_Press) forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xFF052545)];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)doShareEffectFileOK{
    SEFFFILE_OPT = SEFFFILE_SHARE;
    [[KGModal sharedInstance] hideWithCompletionBlock:^{
        [self gotoSEFFFileOpt:SEFFFILE_SHARE];
    }];
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

#pragma mark----------------------保存
- (void)pushSaveEffect:(id)sender{
    SEFFFile_name = @"";
    SEFFFile_Dital = @"";
    
    int contentW = 300;
    int contentH = 260;
    int margin = 10;
    int btnPadding = 35;
    int btnW = (contentW-3*btnPadding)/2;
    int btnH = 35;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    contentView.backgroundColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:0.0];
    UILabel *TitleLab=[[UILabel alloc]initWithFrame:CGRectMake(margin*0.5, 0, 70, 30)];
    TitleLab.text=[LANG DPLocalizedString:@"L_System_Save"];
    TitleLab.textColor = [UIColor whiteColor];
    TitleLab.font=[UIFont systemFontOfSize:16];
    [contentView addSubview:TitleLab];
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
        make.top.mas_equalTo(contentView.mas_top).mas_equalTo(margin*0.5+30);
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
    nameTextField.backgroundColor=[UIColor clearColor];
    [nameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    nameTextField.layer.borderWidth=1;
    nameTextField.layer.cornerRadius=5;
    nameTextField.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    nameTextField.textColor = [UIColor whiteColor];
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
    detailTextField.textColor = [UIColor whiteColor];
    detailTextField.backgroundColor=[UIColor clearColor];
    detailTextField.layer.borderWidth=1;
    detailTextField.layer.cornerRadius=5;
    detailTextField.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    detailTextField.keyboardType = UIKeyboardTypeDefault;
    detailTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    detailTextField.returnKeyType = UIReturnKeyDone;
    self.detailTextField = detailTextField;
    
    [detailTextField addTarget:self  action:@selector(valueChangedWithSaveLocalFileDetail:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    //3.选择单组、整组部分
    UIView *saView = [[UIView alloc] init];
    saView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:saView];
    [saView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailTextField.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(contentW, 90));
    }];
    
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [singleBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    singleBtn.titleLabel.numberOfLines=2;
    [singleBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Single"] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    singleBtn.tag = 0;
    [saView addSubview:singleBtn];
    [singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saView.mas_top).mas_equalTo(3);
        make.left.mas_equalTo(saView.mas_left).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(85, 35));
    }];
    self.singleChoiceBtn = singleBtn;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.tag = 1;
    allBtn.titleLabel.numberOfLines=2;
    [allBtn setImage:[[UIImage imageNamed:@"ssm_btncheck_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [allBtn setTitle:[LANG DPLocalizedString:@"L_SSM_Machine"] forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(singleBtn.mas_centerY);
        make.left.mas_equalTo(singleBtn.mas_right).mas_equalTo((contentW-2*70)/3);
        make.size.mas_equalTo(CGSizeMake(85, 35));
    }];
    
    self.allChoiceBtn = allBtn;
    
    //
    UILabel *allGroupNotice = [[UILabel alloc] init];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.frame = CGRectMake(10, 1, 70, 30);
    allGroupNotice.text = [LANG DPLocalizedString:@"L_SSM_SaveMacMSG"];
    allGroupNotice.textColor = [UIColor whiteColor];
    allGroupNotice.numberOfLines=2;
    allGroupNotice.font = [UIFont systemFontOfSize:15.0];
    allGroupNotice.adjustsFontSizeToFitWidth=YES;
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
    
    btnsView.backgroundColor = [UIColor clearColor];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(0xFF1e3b57);
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnsView.mas_top).offset([Dimens GDimens:-10]);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.layer.borderWidth=1;
    saveBtn.layer.cornerRadius=5;
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.layer.borderWidth=1;
    cancelBtn.layer.cornerRadius=5;
    cancelBtn.layer.masksToBounds=YES;
    cancelBtn.layer.borderColor=SetColor(UI_Master_SB_Volume_Press).CGColor;
    
    [btnsView addSubview:saveBtn];
    [btnsView addSubview:cancelBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(btnsView.mas_left).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    //    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    //    [saveBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:[LANG DPLocalizedString:@"L_SSM_SaveOpt"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:SetColor(UI_Master_SB_Volume_Press) forState:UIControlStateNormal];
    
    [saveBtn addTarget:self action:@selector(doSaveEffectFileOK) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnsView.mas_centerY);
        make.left.mas_equalTo(saveBtn.mas_right).mas_equalTo(btnPadding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_normal"] forState:UIControlStateNormal];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ssm_btn_press"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_SSM_CancelOpt"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:SetColor(UI_Master_SB_Volume_Press) forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    //    [[KGModal sharedInstance] setOKButton:saveBtn];
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xFF052545)];
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
        //         [[KGModal sharedInstance] hideAnimated:YES];
        if ([QIZDatabaseTool queryExistFileName:self.saveLocalName]) {
            self.allChoiceLabel.hidden = false;
            //            self.allChoiceLabel.text = [LANG DPLocalizedString:@"L_SSM_Save_repeat"];
            [[DataProgressHUD shareManager]showHub:[LANG DPLocalizedString:@"L_SSM_Save_repeat"] WithTime:1.5];
        }else{
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                [self gotoSEFFFileOpt:SEFFFILE_Save];
            }];
        }
        
        
        
    }else{
        self.allChoiceLabel.hidden = false;
        self.allChoiceLabel.text = [LANG DPLocalizedString:@"L_SSM_FileNameMsg"];
    }
    
}
#pragma mark --打开文件列表
- (void)pushOpenEffect:(id)sender{
    [self gotoSEFFFileOpt:SEFFFILE_List];
}


#pragma mark ---Bluetooth
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
//-(void)noiceScanBLE:(id)sender{
//    NSLog(@"该头栏父类对象是%@",[self superview]);
//    NSDictionary *dic = [sender userInfo];
//    NSString *okStr = [dic objectForKey:@"CancelScan"];
//    if ([okStr isEqualToString:@"OK"]) {
//        self.peripherals = self.bleManager.peripherals;
//        if (self.peripherals.count>0) {
//            [self showBluetoothDeviceList];
//        }
//    }
//}
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
    [[BLEManager shareBLEManager].baby AutoReconnectCancel:[BLEManager shareBLEManager].currPeripheral];
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

@end

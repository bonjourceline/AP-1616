//
//  OptFunsPageCVViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//
#import "OptFunPage_CTbar_VC.h"



@interface OptFunPage_CTbar_VC ()

@end

@implementation OptFunPage_CTbar_VC

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
//    [center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    //刷新主界面
    //[center addObserver:self selector:@selector(FlashMasterFormNotification:) name:MyNotification_FlashMaster object:nil];
    //读取完成整机数据
    [center addObserver:self selector:@selector(ReadMacDataNotification:) name:MyNotification_ReadMacData object:nil];
//    //读取Json数据
//    [center addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
    //刷新音源
    //[center addObserver:self selector:@selector(NotificationFlashInputSource:) name:MyNotification_FlashInputSource object:nil];
    //显示数据出错对话框
    [center addObserver:self selector:@selector(NotificationShowResetSEFFData:) name:MyNotification_ShowResetSEFFData object:nil];
//    //显示进度
//    [center addObserver:self selector:@selector(Notification_ShowProgress:) name:MyNotification_ShowProgress object:nil];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbg"]]];
    //[self.view setBackgroundColor:SetColor(UI_SystemBgColor)];
    //初始化默认数据
    initDataStruct();
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    //初始化顶部状态栏
    
    [self initTopBar];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTopBar{
    
//    self.mCDelayPage  = [[CDelayViewController alloc]init];
    self.mDelayPage_FRS  = [[DelayViewController_FRS alloc]init];
    self.mDelayPage  = [[DelayViewController alloc]init];
    self.mXOverPage  = [[XOverViewController alloc]init];
    self.mOutputPage = [[OutputViewController alloc]init];
    self.mOutputPage_FRS = [[OutputViewController_FRS alloc]init];
    self.mEQPage     = [[EQViewController alloc]init];
    self.mXOverOutput= [[XOverOutputViewController alloc]init];
    self.mMixer      = [[MixerViewController alloc]init];
    self.mCFMixer    = [[MixViewController alloc]init];
    self.mHome       = [[HomePageViewController alloc]init];
    self.mInputPage    = [[InputViewController alloc]init];
    self.mOutputFunsPage       = [[OutputPageViewController alloc]init];
    
    
    [self.view addSubview:self.mDelayPage.view];
    [self.view addSubview:self.mXOverOutput.view];
    [self.view addSubview:self.mHome.view];
    [self.view addSubview:self.mEQPage.view];
    [self.view addSubview:self.mMixer.view];
    

    self.mDelayPage.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.mXOverOutput.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.mHome.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.mEQPage.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.mMixer.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self flashViewPage:3];
    
    self.mBottomBar = [[BottomBar alloc]initWithFrame:CGRectMake(0, KScreenHeight-[Dimens GDimens:CBottomBarHeight], KScreenWidth, [Dimens GDimens:CBottomBarHeight])];
    [self.view addSubview:self.mBottomBar];
    [self.mBottomBar addTarget:self action:@selector(BottomBarClickEvent:) forControlEvents:UIControlEventValueChanged];
    [self.mBottomBar setDataVal:3];
    [self.mBottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:CBottomBarHeight]));
    }];
    
    self.mToolbar = [[TopBarView alloc ]init];
    self.mToolbar.frame = CGRectMake(0, SystemTopBarHeight, KScreenWidth, [Dimens GDimens:TopBarHeight]);
    [self.view addSubview:self.mToolbar];
    [self.mToolbar setLogoShow:true];
    [self.mToolbar setMenuShow:true];
    if(gConnectState){
        [self.mToolbar setConnectState:true];
    }else{
        [self.mToolbar setConnectState:false];
    }
    [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_Master_Master"]];
    //代理
    self.mToolbar.delegate = self;//要放后面
    

}

- (void)BottomBarClickEvent:(BottomBar*)sender{
    pageNum = [sender getDataVal];
    [self flashViewPage:pageNum];
}


- (void)flashViewPage:(int)sel{
    self.mDelayPage.view.hidden = true;
    self.mXOverOutput.view.hidden = true;
    self.mHome.view.hidden = true;
    self.mEQPage.view.hidden = true;
    self.mMixer.view.hidden = true;
    
    switch (sel) {
        case 1:
            self.mDelayPage.view.hidden = false;
            [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_TabBar_Delay"]];
            [self.mDelayPage FlashPageUI];
            break;
        case 2:
            self.mXOverOutput.view.hidden = false;
            [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_TabBar_Output"]];
            [self.mXOverOutput FlashPageUI];
            break;
        case 3:
            self.mHome.view.hidden = false;
            [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_Master_Master"]];
            [self.mHome FlashMasterPageUI];
            break;
        case 4:
            self.mEQPage.view.hidden = false;
            [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_TabBar_EQ"]];
            [self.mEQPage FlashPageUI];
            break;
        case 5:
            self.mMixer.view.hidden = false;
            [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_TabBar_Mixer"]];
            [self.mMixer FlashPageUI];
            break;
            
        default:
            break;
    }
}


#pragma 这里实现TopBar代理控制器的协议方法
// 这里实现TopBar代理控制器的协议方法
- (void)TopbarClickBack:(BOOL)Bool_Click{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSMutableDictionary *State = [NSMutableDictionary dictionary];
    State[@"State"] = @"NO";
    //创建一个消息对象
    NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_FlashMaster object:nil userInfo:State];
    [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
    
    
    //UI AlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"sdfas" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alertView show];
}
-(void)SEFFFileOpt:(int)Opt{
    NSLog(@"###OPT_CT#  SEFFFileOpt Opt=%d",Opt);
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
    NSLog(@"####  gotoSEFFFileList");
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
    [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
    
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
    [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
    
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
            
            //    [self.doc presentPreviewAnimated:YES];  //弹出预览对话框
            
            CGRect navRect = self.navigationController.navigationBar.frame;
            // navRect.size =CGSizeMake(self.frame.width,40.0f);
            
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

//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 进度提示框
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

//-(void)hudWasHidden:(MBProgressHUD *)hud{
//    NSLog(@"hudWasHidden");
//    [hud removeFromSuperview];
//    //[hud release];
//    hud = nil;
//}


-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode{
    [self initSaveLoadSEFFProgress];
    self.HUD_SEFF.detailsLabelText = Detail;
    [self.HUD_SEFF showWhileExecuting:@selector(HUD_SEFFProgressTask) onTarget:self withObject:nil animated:YES];
    
}
-(void) HUD_SEFFProgressTask{
    
    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
    NSLog(@"##GetSendbufferListCount cnt=%d",cnt);
    
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
-(void)loadDialog:(int)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"loadDialog -----");
        [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_Save];
    });
}

- (void)ConnectStateFormNotification:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [sender userInfo];
        NSString *okStr = [dic objectForKey:@"ConnectState"];
        if ([okStr isEqualToString:@"YES"]) {
            NSLog(@"ConnectStateFormNotification YES");
            [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
        }else {
            if(self.HUD_SEFF != nil){
                [self.HUD_SEFF removeFromSuperview];
                //[hud release];
                self.HUD_SEFF = nil;
                if ([okStr isEqualToString:@"DER"]) {
                    [self ShowVersionsErrorDialog];
                }
            }
        }
    });
}
//版本号错误提示框
- (void)ShowVersionsErrorDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[NSString stringWithFormat:@"%@:%@",[LANG DPLocalizedString:@"L_DeviceVersionERR"],DeviceVerString] preferredStyle:UIAlertControllerStyleAlert];
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



- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashLinkState];//要放到这里
        if(REC_SEFFFileType != SEFFFILE_TYPE_NULL){
            [self showUpdatSEFFileToMac];
        }
        
    });
}

#pragma 刷新联调

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

@end

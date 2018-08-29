//
//  OptFunsPageCVViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//
#import "OptFunPage_TBC_VC.h"



@interface OptFunPage_TBC_VC ()

@end

@implementation OptFunPage_TBC_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //读取完成整机数据
    [center addObserver:self selector:@selector(ReadMacDataNotification:) name:MyNotification_ReadMacData object:nil];
    //通信连接成功
//    [center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    //读取Json数据
//    [center addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
//    //显示进度
//    [center addObserver:self selector:@selector(Notification_ShowProgress:) name:MyNotification_ShowProgress object:nil];
    //显示数据出错对话框
    [center addObserver:self selector:@selector(NotificationShowResetSEFFData:) name:MyNotification_ShowResetSEFFData object:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbg"]]];
    //[self.view setBackgroundColor:SetColor(UI_SystemBgColor)];
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    //初始化顶部状态栏
    
    [self initTabBarC];
    [self initTopBar];
    //代理
    self.mToolbar.delegate = self;
    self.mTabBarC.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTopBar{
    self.mToolbar = [[TopBarView alloc ]init];
    self.mToolbar.frame = CGRectMake(0, SystemTopBarHeight, KScreenWidth, [Dimens GDimens:TopBarHeight]);
    [self.view addSubview:self.mToolbar];
    [self.mToolbar setLogoShow:false];
    [self.mToolbar setMenuShow:false];
    if(gConnectState){
        [self.mToolbar setConnectState:true];
    }else{
        [self.mToolbar setConnectState:false];
    }
    [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_TabBar_OutputPage"]];
}

- (void)initTabBarC{
    self.mTabBarC = [[OptFunPage_TBC alloc]init];
    [self.view addSubview:self.mTabBarC.view];
    [self .mTabBarC.mDelayPage FlashPageUI];
    self.mTabBarC.selectedIndex = 2;
}


// 这里实现UITabBarController代理控制器的协议方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;//这里做一下解释，该方法用于控制TabBarItem能不能选中，返回NO，将禁止用户点击某一个TabBarItem被选中。
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;

    [self.mToolbar setTitle:viewController.tabBarItem.title];
    
    if([tbselect isEqual:_mTabBarC.mDelayPage]){
        [_mTabBarC.mDelayPage FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mXOverPage]){
        [_mTabBarC.mXOverPage FlashXOverPageUI];
    }else if([tbselect isEqual:_mTabBarC.mOutputPage]){
        [_mTabBarC.mOutputPage FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mEQPage]){
        [_mTabBarC.mEQPage FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mMixer]){
        [_mTabBarC.mMixer FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mXOverOutput]){
        [_mTabBarC.mXOverOutput FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mHome]){
        [_mTabBarC.mHome FlashMasterPageUI];
    }else if([tbselect isEqual:_mTabBarC.mInputPage]){
        [_mTabBarC.mInputPage FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mOutputFunsPage]){
        [_mTabBarC.mOutputFunsPage FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mDelayPage_FRS]){
        [_mTabBarC.mDelayPage_FRS FlashPageUI];
    }else if([tbselect isEqual:_mTabBarC.mOutputPage_FRS]){
        [_mTabBarC.mOutputPage_FRS FlashPageUI];
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
    NSLog(@"###Master#  SEFFFileOpt Opt=%d",Opt);
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

@end

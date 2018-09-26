//
//  rootViewController.m
//  JH-DBP4106-PPP42DSP
//
//  Created by chs on 2017/10/16.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "rootViewController.h"
#import "QIZLocalEffectViewController.h"

@interface rootViewController ()

@end

@implementation rootViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self FlashPageUI];
}
-(void)FlashPageUI{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopbarStyle];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    NSLog(@"释放%@",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
-(void)addTopbarStyle{
//    self.view.backgroundColor=[UIColor yellowColor];
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [bgImage setImage:[UIImage imageNamed:@"rootbg"]];
    [self.view addSubview:bgImage];
    [self.view insertSubview:bgImage atIndex:0];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbg"]]];
//    self.view.backgroundColor=SetColor(UI_MasterBackgroundColor);
        self.mToolbar = [[TopBarView alloc ]init];
    if (KScreenHeight==812) {
        self.mToolbar.frame=CGRectMake(0, 44, KScreenWidth, [Dimens GDimens:44]);
    }else{
         self.mToolbar.frame = CGRectMake(0, 20, KScreenWidth, [Dimens GDimens:44] );
    }
    
        [self.view addSubview:self.mToolbar];
        [self.mToolbar setLogoShow:false];
//        [self.mToolbar setTitle:[LANG DPLocalizedString:@"L_Master_Master"]];
    
        //代理
        self.mToolbar.delegate = self;
   self.mToolbar.IVLine.frame=CGRectMake(0, [Dimens GDimens:TopBarHeight], KScreenWidth, 1);
    
}
#pragma mark ---这里实现TopBar代理控制器的协议方法
- (void)TopbarClickBack:(BOOL)Bool_Click{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:kN_TopbarBackButton object:nil];
    
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
    _doc1 = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _doc1.UTI = @"public.plain-text";
    _doc1.delegate = self;
    
    //    [self.doc presentPreviewAnimated:YES];  //弹出预览对话框
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    // navRect.size =CGSizeMake(self.frame.width,40.0f);
    
    [_doc1 presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
}

-(void)SEFFFileShareMac{
    NSLog(@"###Master#  SEFFFileShareMac");
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    [DataCManager readMacData];
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
    
    [DataCManager readMacData];
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
            _doc1 = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            _doc1.UTI = @"public.plain-text";
            _doc1.delegate = self;
            CGRect navRect = self.navigationController.navigationBar.frame;
            [_doc1 presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
            
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

@end

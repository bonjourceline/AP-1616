//
//  DataProgressHUD.m
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/8.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "DataProgressHUD.h"

@implementation DataProgressHUD
+ (instancetype)shareManager
{
    static DataProgressHUD *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[DataProgressHUD alloc]init];
    });
    return share;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
      
    }
    return self;
}
-(MasterVolView *)volView{
    
    if (!_volView) {
        _volView=[[MasterVolView alloc]initWithFrame:CGRectMake(5, 20, KScreenWidth-10, [Dimens GDimens:64])];
        _volView.backgroundColor=SetColor(UI_Master_VolSliderBackG);
        [[[UIApplication sharedApplication]keyWindow]addSubview:_volView];
        
    }
    return _volView;
}

-(void)addNotification{
    //通信连接成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    //读取Json数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
    //显示进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notification_ShowProgress:) name:MyNotification_ShowProgress object:nil];
    
}
- (void)ConnectStateFormNotification:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [sender userInfo];
        NSString *okStr = [dic objectForKey:@"ConnectState"];
        if ([okStr isEqualToString:@"YES"]) {
            NSLog(@"ConnectStateFormNotification YES");
            [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_READ];
            
        }else {
//            if(self.HUD_SEFF != nil){

                [self.HUD_SEFF hide:YES];
                
                self.HUD_SEFF = nil;
                if ([okStr isEqualToString:@"DER"]) {
                    [self ShowVersionsErrorDialog];
                }
//            }
        }
    });
}
//版本号错误提示框
- (void)ShowVersionsErrorDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[NSString stringWithFormat:@"%@:%@",[LANG DPLocalizedString:@"L_DeviceVersionERR"],DeviceVerString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {


    }]];
   
    UIWindow  *window=[[UIApplication sharedApplication]keyWindow];
    UIViewController *vc=window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];

}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    NSLog(@"hudWasHidden");
    [hud removeFromSuperview];
//    [hud release];
    hud = nil;
}

-(void) HUD_SEFFProgressTask{
    
    
    int cnt = [DataCManager GetSendbufferListCount];
    
    NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [DataCManager GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
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
-(void)initSaveLoadSEFFProgress{
//    [self.HUD_SEFF hide:YES];
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    self.HUD_SEFF=[[MBProgressHUD alloc]initWithWindow:window];
    
    [window addSubview:self.HUD_SEFF];
    //常用的设置
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
    [self.HUD_SEFF show:YES];
}
#pragma mark--- LoadJsonFileNotification

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
    
    UIWindow  *window=[[UIApplication sharedApplication]keyWindow];
    UIViewController *vc=window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}
//音效机型错误提示框
- (void)showBrandMacError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SEFF_WRONG_MAC"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    UIWindow  *window=[[UIApplication sharedApplication]keyWindow];
    UIViewController *vc=window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}
//接收到音效文件提示框
- (void)showRecSEFFFile{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_SSM_RecSEFFileMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    UIWindow  *window=[[UIApplication sharedApplication]keyWindow];
    UIViewController *vc=window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}
#pragma mark --- 显示进度
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
-(void)showFailConnectionHub{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_BLE_Disconnect"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    UIViewController *vc=window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}
@end

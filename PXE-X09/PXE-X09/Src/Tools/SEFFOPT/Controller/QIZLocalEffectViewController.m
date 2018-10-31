//
//  QIZLocalEffectViewController.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/30.
//  Copyright © 2016年 dsp. All rights reserved.
//

#define kSearchBtnW 40
#define kSearchBtnH 40

#import "QIZLocalEffectViewController.h"
#import "QIZSearchEffectTableViewController.h"

#import "QIZDatabaseTool.h"
#import "Define_Dimens.h"
#import "Define_Color.h"
#import "Masonry.h"
#import "LANG.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"
#import "Define_NSNotification.h"
#import "Dimens.h"
@interface QIZLocalEffectViewController ()

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation QIZLocalEffectViewController

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[
                       [LANG DPLocalizedString:@"L_down_title_name"],
//                       [LANG DPLocalizedString:@"L_down_title_Collect"],
                       [LANG DPLocalizedString:@"L_down_title_Favorite"],
                       [LANG DPLocalizedString:@"L_down_title_Recently"]];
    }
    return _titleData;
}
#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        
//        self.titleColorSelected = QIZColor(61, 135, 216);
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
        self.menuHeight = 50;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    [self setupNavigationBar];
    self.view.backgroundColor = SetColor(UI_SystemBgColor);
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //读取Json数据
    [center addObserver:self selector:@selector(LoadJsonFileNotification:) name:MyNotification_LoadJsonFile object:nil];
}


- (void)setupNavigationBar
{
    self.backHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [self.backHomeBtn setImage:[UIImage imageNamed:@"topbar_back_seff"] forState:UIControlStateNormal];
    [self.backHomeBtn addTarget:self action:@selector(doBackHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.backHomeBtn setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];

    [self.backHomeBtn setTitleColor:SetColor(UI_SEFFFToolbarBackTitleColor) forState:UIControlStateNormal];
    self.backHomeBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    self.backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backHomeBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSearchBtnW, kSearchBtnH)];
    [self.searchBtn setImage:[UIImage imageNamed:@"topbar_search"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(doSearchEffect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.translucent=NO;
    
    self.navigationController.navigationBar.barTintColor = SetColor(UI_TSEFFFToolbarBgColor);//[UIColor colorWithRed:23/255.0 green:56/255.0 blue:123/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setBackgroundColor:SetColor(UI_TSEFFFToolbarBgColor)];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:SetColor(UI_SEFFFToolbarBackTitleColor)}];
}

- (void)doBackHome:(UIButton *)sender
{
//    QIZLog(@"doBackHome");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -----查找监听事件------
-(void)doSearchEffect:(UIButton *)sender
{
    QIZSearchEffectTableViewController *searchEffVc = [[QIZSearchEffectTableViewController alloc] init];
    searchEffVc.arrayM =  [QIZDatabaseTool queryAllData];
    
    [self.navigationController pushViewController:searchEffVc animated:YES];
    
//    QIZLog(@"doSearchEffect");
}


#pragma mark - Datasource & Delegate

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:{
            QIZAllEffectTableViewController  *vcClass = [[QIZAllEffectTableViewController alloc] init];
            vcClass.arrayM =  [QIZDatabaseTool queryAllData];
            vcClass.title = @"1";
            self.allEffectVC = vcClass;
//            QIZLog(@"切换到名称页面");
            return vcClass;
        }
            
            break;
//        case 1:{
//
//            QIZCollectionTableViewController *vcClass = [QIZCollectionTableViewController new];
//            vcClass.arrayM =  [QIZDatabaseTool queryFilefavorite:@"1"];
//            vcClass.title = @"2";
//             self.collectionVC = vcClass;
////            QIZLog(@"切换到收藏页面");
//
//            return vcClass;
//
//        }
//            break;
        case 1:{
            
            QIZLikeTableViewController *vcClass = [QIZLikeTableViewController new];
            vcClass.arrayM =  [QIZDatabaseTool queryFilelove:@"1"];
            vcClass.title = @"3";
             self.likeVC = vcClass;
//            QIZLog(@"切换到喜欢页面");
            return vcClass;
            
        }
            break;
        case 2:{
            
            QIZLatelyTableViewController *vcClass = [QIZLatelyTableViewController new];
            vcClass.arrayM =  [QIZDatabaseTool queryApplyTimeAllData];
            vcClass.title = @"4";
             self.latelyVC = vcClass;
//            QIZLog(@"切换到最近页面");
            return vcClass;
            
        }
            
            break;
        default:{
            QIZAllEffectTableViewController  *vcClass = [[QIZAllEffectTableViewController alloc] init];
            vcClass.title = @"1";
//            QIZLog(@"切换到收藏页面");
            return vcClass;
        }
            
            break;
            

    }
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:{
            self.allEffectVC.arrayM = [QIZDatabaseTool queryAllData];
            [self.allEffectVC.tableView reloadData];
        }
            break;
        case 1:{
//            self.collectionVC.arrayM = [QIZDatabaseTool queryFilefavorite:@"1"];
//            [self.collectionVC.tableView reloadData];
            self.likeVC.arrayM = [QIZDatabaseTool queryFilelove:@"1"];
            [self.likeVC.tableView reloadData];
        }
            break;
        case 2:{
//            self.likeVC.arrayM = [QIZDatabaseTool queryFilelove:@"1"];
//            [self.likeVC.tableView reloadData];
            self.latelyVC.arrayM = [QIZDatabaseTool queryApplyTimeAllData];
            [self.latelyVC.tableView reloadData];
        }
            break;
        case 3:{
            self.latelyVC.arrayM = [QIZDatabaseTool queryApplyTimeAllData];
            [self.latelyVC.tableView reloadData];
        }
            break;
        default:
            break;
    }
    return self.titleData[index];
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
//    //NSLog(@"hudWasHidden");
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
    //NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [_mDataTransmitOpt GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
        self.HUD_SEFF.progress = 1-progress/100.0;
        usleep(10000);
    }
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
            [self showUpdatSEFFileToMac];
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

@end

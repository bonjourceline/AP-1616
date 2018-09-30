//
//  MainViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MainViewController.h"
//#import "MainPageViewController.h"
#import "HomePageViewController.h"
#import "MacDefine.h"
#import "DataCommunication.h"
#import "OptFunPage_TBC.h"
#import "AppDelegate.h"
#import "SourceSettingController.h"
@interface MainViewController (){
    
}

//@property (nonatomic,strong) MainPageViewController *mMainPage;


- (void)initView;//初始化主界面UI

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //连接BLE设备
//    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];

    //初始化默认数据
    initDataStruct();
    //初始化主界面UI
    [self initView];
    
    //[self.view setBackgroundColor:[UIColor clearColor]];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MyNotification_UpdateUI object:nil];
}
#pragma mark UI界面初始化相关
//初始化主界面UI
- (void)initView{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(BOOL_USE_ADVANCE){
        //加载主界面
//        self.mMainPage = [[MainPageViewController alloc] init];
//        //self.mMainPage.view.frame = CGRectMake(0, UI_StartNoTopBar, KScreenWidth, UI_EndNoBottomBar);
//        [self addChildViewController:self.mMainPage];
//        [self.view addSubview:self.mMainPage.view];
        
        HomePageViewController *homeVC=[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:homeVC];
        
        delegate.window.rootViewController=nav;
        nav.navigationBar.hidden=YES;
//        [self addChildViewController:homeVC];
//        [self.view addSubview:homeVC.view];
    }else{

//        if ([self isFisrtStarApp]) {
//
//            SourceSettingController *vc=[[SourceSettingController alloc]init];
//            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
//            nav.navigationBar.hidden=YES;
//            delegate.window.rootViewController=
//            nav;
//        }else{
        
            OptFunPage_TBC *rootVC=[[OptFunPage_TBC alloc]init];
            delegate.window.rootViewController=rootVC;
//        }

    }

}

//消息通知
- (void)UpdateMasterViewUI:(id)sender{
//    U0SynDataSucessFlg = true;
//    gConnectState = true;
//    [DataCManager ComparedToSendData:false];
    
}


@end

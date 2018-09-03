//
//  AppDelegate.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ADView.h"
#import "DeviceUtils.h"
#import <AFNetworking.h>
#import "SplanViewController.h"
#import <sys/utsname.h>
#import "MacDefine.h"
#import "SEFFFile.h"

#import "DataProgressHUD.h"


#define LastAdid @"LastAdid"//最后加载的广告id
@interface AppDelegate ()

@end

NSString* phoneModel;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] init];
//    self.window.bounds = [[UIScreen mainScreen] bounds];
//    MainViewController *vc = [[MainViewController alloc] init];
//    self.window.rootViewController = vc;
//    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    [[DataProgressHUD shareManager]addNotification];
    KScreenWidth  = [UIScreen mainScreen].bounds.size.width;
    KScreenHeight = [UIScreen mainScreen].bounds.size.height;

    
    float scare = [UIScreen mainScreen].scale;
    if((KScreenWidth == 320.0) && (KScreenHeight == 480.0)){
        NSLog(@"##### 1");//ipad air/2;ipad pro 9.7
        KScreenTYPE=0.6f;
    }else if ((KScreenWidth == 320.0f) && (KScreenHeight == 568.0f)){
        NSLog(@"##### 2");//ipad pro 12.9;iphone 5;iphone 5s;iphone se
        KScreenTYPE=0.75f;
    }else if ((KScreenWidth == 375.0f) && (KScreenHeight == 667.0f)){
        NSLog(@"##### 3");//iphone 6;iphone 6s;iphone 6;
        KScreenTYPE=0.90f;
    }else if ((KScreenWidth == 414.0f) && (KScreenHeight == 736.0f)){
        NSLog(@"##### 4");//iphone 6 plus;iphone 6s plus;iphone 7 plus;
        KScreenTYPE=1.0f;
    }else if((KScreenWidth==375.0f)&&(KScreenHeight==812.0f)){
        KScreenTYPE=0.9f;
    }else{
        NSLog(@"##### 5");
        KScreenTYPE=0.6f;
    }
    
    NSLog(@"scale = %f", scare);
    NSLog(@"KScreenWidth = %f", KScreenWidth);
    NSLog(@"KScreenHeight = %f",KScreenHeight);
    //1.手机系统版本：9.1
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    //2.手机类型：iPhone 6
    phoneModel = [self iphoneType];
    //3.手机系统：iPhone OS
    NSString * iponeM = [[UIDevice currentDevice] systemName];
    //4.电池电量
    CGFloat batteryLevel=[[UIDevice currentDevice]batteryLevel];
    
    NSLog(@"phoneVersion = @%@",phoneVersion);
    NSLog(@"phoneModel = @%@",phoneModel);
    NSLog(@"iponeM = @%@",iponeM);
    NSLog(@"batteryLevel = @%f",batteryLevel);
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    
    SplanViewController * spVc = [[SplanViewController alloc]init];
    self.window.rootViewController = spVc;
    [self.window makeKeyAndVisible];
    [self sendNetData];
//    OptFunPage_TBC_VC * spVc = [[OptFunPage_TBC_VC alloc]init];
//    self.window.rootViewController = spVc;
    
    
    return YES;
}
-(void)sendNetData{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    NSDictionary *dict=@{
                         @"AgentID":@(AgentID),
                         @"softtype":@"1",
                         @"macName":MAC_Type,
                         @"macAddr":[DeviceUtils identifier],
                         @"clientModel":[DeviceUtils deviceModel],
                         @"SoftVersion":App_versions,
                         @"osType":[[UIDevice currentDevice] systemVersion]};
    NSString *urlbase=[NSString stringWithFormat:@"%@%@",API_BASE_HOST_STRING,@"index.php?m=Index&a=GetPC_User_Message"];
    [manager GET:urlbase parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"======%@",task.currentRequest.URL);
        QIZLog(@"成功上传=====%@====",responseObject);
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict=[responseObject objectForKey:@"data"];
            //            self.Ad_model=[[AdModel alloc]init];
            NSLog(@"%@",self.Ad_model);
            self.Ad_model.Ad_Status=[[dict objectForKey:@"Ad_Status"] intValue];
            if (self.Ad_model.Ad_Status==1) {
                
                self.Ad_model.AdID=[[dict objectForKey:@"AdID"] intValue];
                NSInteger lastAdid=[[NSUserDefaults standardUserDefaults]integerForKey:LastAdid];
                if ((self.Ad_model.AdID==lastAdid)) {
                    QIZLog(@"已展示过此id====%ld",lastAdid);
                }else{
                    self.Ad_model.Ad_Title=[dict objectForKey:@"Ad_Title"];
                    self.Ad_model.Ad_Image_Path=[dict objectForKey:@"Ad_Image_Path"];
                    self.Ad_model.Ad_URL=[dict objectForKey:@"Ad_URL"];
                    if (self.Ad_model.Ad_URL.length>0) {
                        
                        if ([self.Ad_model.Ad_URL hasPrefix:@"http://crm.chschs.com/index.php?m=Index&a=Ad_Show_Page"]) {
                            self.Ad_model.Ad_URL=[NSString stringWithFormat:@"%@&macAddr=%@",[dict objectForKey:@"Ad_URL"],[DeviceUtils identifier] ];
                        }
                        
                        NSLog(@"============%@",self.Ad_model.Ad_URL);
                    }
                    self.Ad_model.Ad_Close_URL=[dict objectForKey:@"Ad_Close_URL"];
                    if (self.Ad_model.Ad_Close_URL.length>0) {
                        
                        self.Ad_model.Ad_Close_URL=[NSString stringWithFormat:@"%@&macAddr=%@",[dict objectForKey:@"Ad_Close_URL"],[DeviceUtils identifier]];
                        
                    }
                    [self closeUrl];
                    [[NSNotificationCenter defaultCenter]postNotificationName:MyNotification_ShowAD object:nil];
                }
                
            }else{
                QIZLog(@"没有广告");
                //                [[NSNotificationCenter defaultCenter]postNotificationName:MyNotification_ShowAD object:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败====%@",error.description);
    }];
    
}
-(void)closeUrl{
    //    AppDelegate *mainDelegte=(AppDelegate *)[UIApplication sharedApplication].delegate;
    //
    [[NSUserDefaults standardUserDefaults]setInteger:self.Ad_model.AdID forKey:LastAdid];
    [[NSUserDefaults standardUserDefaults]synchronize];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSString *url=self.Ad_model.Ad_Close_URL;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        QIZLog(@"成功上传");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QIZLog(@"上传失败%@",url);
    }];
    
}
-(AdModel *)Ad_model{
    if (!_Ad_model) {
        _Ad_model=[[AdModel alloc]init];
    }
    return _Ad_model;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MT_IOS"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



-(BOOL)isFisrtStarApp{
    //获得单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //读取次数（用户上一次启动app的次数）
    NSString *number = [userDefaults objectForKey:kAppFirstLoadKey];
    //判断是否有值
    if (number!=nil) {
        //能够取到值，则不是第一次启动
        NSInteger starNumer = [number integerValue];
        //用上一次的次数+1次
        NSString *str = [NSString stringWithFormat:@"%lu",(long)++starNumer];
        //存的是用户这一次启动的次数
        [userDefaults setObject:str forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return NO;
    }else{
        //不能取到值，则是第一次启动
        NSLog(@"用户是第一次启动");
        [userDefaults setObject:@"1" forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return YES;
    }
}

-(void)showGuide{
    NSArray *imageArray = @[@"newGuide1@2x.png"
                            ,@"newGuide2@2x.png"
                            ,@"newGuide3@2x.png"
                            ,@"newGuide4@2x.png"
                            ,@"newGuide5@2x.png"
                            ];
    
    self.adView = [[ADView alloc]initWithArray:imageArray andFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andBlock:^{
        //        [self viewDidLoadInit];
    }];
    [self.window addSubview:self.adView];
}

- (NSString *)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";

    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}



#pragma 加载Json文件

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [self.mDataTransmitOpt fileJSSHLoad:url];
    NSLog(@"###分享的URL%@",url);
    return YES;
}



@end

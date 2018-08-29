//
//  AppDelegate.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BLEManager.h"
#import "DataCommunication.h"
#import "ADView.h"
#import "AdModel.h"



/**
 *  第一次启动App的Key
 */
#define kAppFirstLoadKey @"kAppFirstLoadKey"
extern NSString* phoneModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    //定义全局数据结构
    @public

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ADView *adView;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;
//****** 数据通信 ******//
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

@property (nonatomic,strong)UIView *systemVolView;
/**
 *蓝牙通信部分
 */
@property (nonatomic,strong) BLEManager *bleManager;
@property (nonatomic,strong) BabyBluetooth *baby;
@property (nonatomic,strong) NSMutableArray *peripherals;
@property (nonatomic,strong) NSMutableArray *peripheralsAD;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBCharacteristic *writecharacteristic;
@property (nonatomic,strong) CBCharacteristic *readcharacteristic;
@property (nonatomic,strong) CBPeripheral *savePeripheral;
//广告模型
@property (nonatomic,strong)AdModel *Ad_model;
@end


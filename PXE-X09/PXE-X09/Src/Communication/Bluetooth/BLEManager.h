//
//  BLEManager.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/14.
//  Copyright © 2016年 dsp. All rights reserved.
//

/**
 蓝牙连接可以大致分为以下几个步骤
 1.建立一个Central Manager实例进行蓝牙管理
 2.搜索外围设备
 3.连接外围设备
 4.获得外围设备的服务
 5.获得服务的特征
 6.从外围设备读数据
 7.给外围设备发送数据
 其他：提醒
 */

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "DataCommunication.h"

#ifdef DEBUG // 处于开发阶段
#define QIZLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define QIZLog(...)
#endif

//@class Command,AudioData;



@interface BLEManager : NSObject
{
    NSTimer *_pSendDataTimer;
    
    int _nReadCount; //接受数据计数
    //NSMutableData *_ReadDeviceData;
    int _nBluetoothDeviceState;
    BOOL _bChooseBLEConnect;

    BOOL BluetoothSwitch;
    //BOOL _bReadOver;
    //BOOL _bHeadFlag;
    //Byte _frameType;
    //Byte _dataType;
    //int _nRevDataLen;
    //int _nRevNum;
    //int _nRouteid;

}

/**
 *蓝牙通信部分
 */
@property (nonatomic,strong) BabyBluetooth *baby;
@property (nonatomic,strong) NSMutableArray *peripherals;
@property (nonatomic,strong) NSMutableArray *peripheralsAD;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBCharacteristic *writecharacteristic;
@property (nonatomic,strong) CBCharacteristic *readcharacteristic;
@property (nonatomic,strong) CBPeripheral *savePeripheral;

/**
 * 真实数据收发处理类
 */
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

/**
 * 初始化蓝牙管理
 */
-(void)initBLEManager;
+ (instancetype)shareBLEManager;


/**
 * 蓝牙代理方法
 */
-(void)babyDelegate;

/**
 * 扫描蓝牙外设
 */
-(void)doScanBluetoothPeriphals;

/**
 *扫描到的蓝牙设备名称
 */
-(NSArray *)scanBluetoothPeriphals;

/**
 *正式连接蓝牙设备
 */
-(void)connectBLEDevice:(int)index;

/**
 * 蓝牙发送数据
 */
//- (void)bluetoothSendData;

/**
 * 蓝牙接收数据处理
 */
-(void)bluetoothReceiveData;

/**
 * 订阅值
 */
-(void)NotifyValue:(BOOL)bNotify;
/**
 *主动断开所有连接
 */
-(void)cancelAllConnection;
/**
 *通过设备id或者服务id搜索已连接的设备
 */
-(NSArray <CBPeripheral *> *)getRetrievePeripheralsWithIdentifiers:(NSArray <NSString *>*)peripheralUuids AndserviceIds:(NSArray <NSString *> *)serviceUuids;
@end

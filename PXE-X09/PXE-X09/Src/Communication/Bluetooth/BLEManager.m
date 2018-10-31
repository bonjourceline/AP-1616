//
//  BLEManager.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/14.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "BLEManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "DataCommunication.h"
#import "ScanViewController.h"
#import "DataProgressHUD.h"
#import "ConnectAlert.h"
#define LastServiceIds  @"LastServiceIds"
#define DSPHDS @"DSP HD"
#define SPPLE @"DSP CC"
@interface BLEManager()<DataCommunicationDelegate,UIActionSheetDelegate>{
    int failsTime;
}
@property (nonatomic,strong)ConnectAlert *connectionAlert;
@property (nonatomic,assign)CBCentralManager *Mycentral;
@property (nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)ScanViewController *scanVC;
@end

@implementation BLEManager

+ (instancetype)shareBLEManager
{
    static BLEManager *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[BLEManager alloc]init];
    });
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
        self.peripherals = [[NSMutableArray alloc]init];
        self.peripheralsAD = [[NSMutableArray alloc]init];
        self.baby = [BabyBluetooth shareBabyBluetooth];
        self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
        self.mDataTransmitOpt.delegate = self;
        [self babyDelegate];
        BluetoothSwitch = true;
        self.isAutoConnect=YES;
    }
    return self;
}
-(ScanViewController *)scanVC{
    if (!_scanVC) {
        _scanVC=[[ScanViewController alloc]init];
        _scanVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        _scanVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    }
    return _scanVC;
}

-(void)initBLEManager
{
    //蓝牙初始化
    self.peripherals = [[NSMutableArray alloc]init];
    self.peripheralsAD = [[NSMutableArray alloc]init];
    self.baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
}

#pragma mark 蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            BluetoothSwitch = true;
            QIZLog(@"手机蓝牙开关打开");
        }
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        QIZLog(@"搜索到的蓝牙设备名称:%@",peripheral.name);
        //搜索到设备加入蓝牙周边设备数据
        [weakSelf insertPeripherals:peripheral advertisementData:advertisementData];
    }];
    
    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //查找前缀
        //@"DSP HD-A007B7"
        //if ([peripheralName hasPrefix:@"DSP HD"] ) {
        //            return YES;
        //}
        
        if ([peripheralName hasPrefix:DSPHDS]|[peripheralName hasPrefix:SPPLE]|[peripheralName hasPrefix:@"DSP Play"]) {//DSP HD
            return YES;
        }
        return NO;
        
    }];
    
    
    //设置设备连接成功的委托
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        QIZLog(@"连接成功的设备名称为：%@--连接成功",peripheral.name);
        weakSelf.currPeripheral=peripheral;
        [weakSelf.baby AutoReconnect:peripheral];
        QIZLog(@"连接成功的设备名称为：%@--连接成功 identifier:%@--",peripheral.name,peripheral.identifier.UUIDString);
        [[DataProgressHUD shareManager]hideFailConnectionHud];
        [weakSelf.scanVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    //设置设备连接失败的委托
    [self.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        QIZLog(@"设备连接失败");
        [[DataProgressHUD shareManager]showAlertWithtis:[LANG DPLocalizedString:@"L_BLE_DeviceConnectERR"]];
    }];
    
    //设置断开Peripherals的连接委托
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        if (COM_BLE_DEVICECONNECTED) {
            COM_BLE_DEVICECONNECTED=false;
            NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
            ConnectState[@"ConnectState"] = @"NO";
            [[NSNotificationCenter defaultCenter]postNotificationName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
            QIZLog(@"设备连接断开");
            QIZLog(@"设备断开原因：=========%@==========",error);
        }
    }];
    
    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            [[NSUserDefaults standardUserDefaults]setValue:service.UUID.UUIDString forKey:LastServiceIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
            QIZLog(@"搜索到蓝牙的服务UUID:%@",service.UUID.UUIDString);
        }
    }];
    
    //设置发现设service的Characteristics的委托  （读写特征）
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *c in service.characteristics) {
            
            if([[c UUID] isEqual:[CBUUID UUIDWithString:@"FFE1"]]){//8888
                QIZLog(@"BUG ###+++读特征名称UUID :%@",c.UUID);
                weakSelf.readcharacteristic = c;
                
                
            }else if ([[c UUID] isEqual:[CBUUID UUIDWithString:@"FFE2"]]){//8877
                
                QIZLog(@"BUG ###+++写特征名称UUID :%@",c.UUID);
                weakSelf.writecharacteristic = c;
            }else {
                QIZLog(@"BUG ###+++特征名称UUID :%@",c.UUID);
            }
        }
        
    }];
    
    
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        QIZLog(@"FUCK------读取到的特征名称是:%@ 特征值是:%@",characteristics.UUID,characteristics.value);
        //        NSData *data = characteristics.value;
        //        Byte *readByte = (Byte *)[data bytes];
        //        for(int i=0;i<(int)[data length];i++){
        //            [_mDataTransmitOpt ReceiveDataFromDevice : readByte[i] : COM_WITH_MODE];
        //        }
        
    }];
    
    
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"发现描述符UUID :%@",d.UUID);
        }
    }];
    
    //设置读取Descriptor的委托 （设置读取到Characteristics描述的值的block）
    [self.baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        QIZLog(@"读取到描述符名称UUID是:%@ 描述符的值是:%@",descriptor.characteristic.UUID, descriptor.value);
        //这个方法你可以放在button的响应里面，也可以在找到特征的时候就写入，具体看你业务需求怎么用啦
        [weakSelf NotifyValue:YES];
        QIZLog(@"订阅NotifyValue");
    }];
    
    //数据读写委托
    //写Characteristic成功后的block
    [self.baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        QIZLog(@"写的特征值是:%@",characteristic.value);
    }];
    
    //写descriptor成功后的block
    [self.baby setBlockOnDidWriteValueForDescriptor:^(CBDescriptor *descriptor, NSError *error) {
        QIZLog(@"写描述符成功");
    }];
    
    //characteristic订阅状态改变的block
    [self.baby setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        QIZLog(@"订阅状态改变接收到的数据是：%@",characteristic.value);
        NSData *data = characteristic.value;
        Byte *readByte = (Byte *)[data bytes];
        for(int i=0;i<(int)[data length];i++){
            [weakSelf.mDataTransmitOpt ReceiveDataFromDevice : readByte[i] : COM_WITH_MODE];
        }
        
    }];
    
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        QIZLog(@"取消所有蓝牙设备扫描");
    }];
    
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        QIZLog(@"取消蓝牙设备扫描");
        
        if(weakSelf.scanVC.isShow){
            [weakSelf.scanVC.activityIndicator stopAnimating];
            
        }
        [weakSelf hideAllHUDs];
        //通知显示扫描出来的蓝牙列表，如果有显示出来，没有提示未发现
        NSMutableDictionary *noticeScanBLE = [NSMutableDictionary dictionary];
        noticeScanBLE[@"CancelScan"] = @"OK";
        //        if (self.peripherals.count>0) {
        //            [weakSelf showBluetoothDeviceList];
        //        }
        
    }];
    
    
}

#pragma mark ------蓝牙选择器
-(void)showBluetoothDeviceList
{
    //__weak __typeof(self) weakSelf = self;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:[LANG DPLocalizedString:@"L_BLE_DeviceSEL"]
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    for (int i=0; i<self.peripherals.count; i++){
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:i];
        [sheet addButtonWithTitle:peripheral.name];
    }
    
    
    // 同时添加一个取消按钮
    [sheet addButtonWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]];
    // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮
    // NB - 这会导致该按钮显示时有黑色背景
    sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    
    UIWindow *window=[[[UIApplication sharedApplication]windows]firstObject];
    [sheet showInView:window];
}
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
        if (self.isAutoConnect) {
            self.isAutoConnect=NO;
        }
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:nIndex];
        
        self.currPeripheral = peripheral;
        self.currPeripheral = peripheral;
        
        [NSThread sleepForTimeInterval:0.01];
        
        [self getComPlayTypeWith:self.currPeripheral]; self.baby.having(self.currPeripheral).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
}
-(void)getComPlayTypeWith:(CBPeripheral *)peripheral{
    NSString *Name=peripheral.name;
    if ([Name hasPrefix:@"DSP HD-"]) {
        COMBleType=BT_Apple_Type;
    }else if ([Name hasPrefix:@"DSP CC"]){
        COMBleType=BT_Conrol_Type;
    }else if ([Name hasPrefix:@"DSP Play"]||[Name hasPrefix:@"DSP HDs"]){
        COMBleType=BT_ATS2825_Type;
    }else{
        COMBleType=0x00;
    }
    
}
#pragma mark 扫描到蓝牙周边设备添加进数组
-(void)insertPeripherals:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![self.peripherals containsObject:peripheral]){
        
        [self.peripherals addObject:peripheral];
        if (advertisementData) {
            [self.peripheralsAD addObject:advertisementData];
        }
        
        if(self.scanVC.isShow){
            [self.scanVC reloadMytableView];
        }
        
        NSString *lastName=[[NSUserDefaults standardUserDefaults]stringForKey:LastPeripheralName];
        NSString *lastId=[[NSUserDefaults standardUserDefaults]stringForKey:LastPeripheral];
        //是否上次连接过的
        if ([peripheral.identifier.UUIDString isEqualToString:lastId]&&[peripheral.name isEqualToString:lastName]) {
            BOOL isCancelAuto = [[NSUserDefaults standardUserDefaults]boolForKey:@"AutoConnectFlg"];
            if (self.isAutoConnect&&(!isCancelAuto)) {
                [self.baby cancelScan];
                self.currPeripheral=peripheral;
                [self getComPlayTypeWith:self.currPeripheral];
                self.baby.having(self.currPeripheral).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
                self.scanVC.LastSelectP=peripheral;
                self.isAutoConnect=NO;
            }else{
                self.scanVC.LastSelectP=peripheral;
            }
            
            
        }
    }
}

-(void)showDeviceScan{
    self.hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    self.hud.labelText=[LANG DPLocalizedString:@"L_BLE_DeviceScan"];
    self.hud.removeFromSuperViewOnHide=YES;
    [self.hud show:YES];
    
}
-(void)hideAllHUDs{
    //    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [self.hud hide:YES];
}
/**
 * 扫描蓝牙外设 返回
 */

-(void)doScanBluetoothPeriphals{
    [self.baby cancelScan];
    [self hideAllHUDs];
    
    
    if (self.baby.centralManager.state == CBCentralManagerStatePoweredOn){
        
        failsTime=0;
        //        [self showDeviceScan];
        BluetoothSwitch = true;
        //清除原来的蓝牙设备名称
        [self.peripherals removeAllObjects];
        
        //停止之前的连接
        [self.baby cancelAllPeripheralsConnection];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        //baby.scanForPeripherals().begin();
        if (!self.scanVC.isShow) {
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            [self.scanVC reloadMytableView];
            [window.rootViewController presentViewController:self.scanVC animated:YES completion:^{
                [self.scanVC.activityIndicator startAnimating];
                self.baby.scanForPeripherals().begin().stop(30);
                [self getLastPeriphals];
            }];
            
        }else{
            [self.scanVC.activityIndicator startAnimating];
            self.baby.scanForPeripherals().begin().stop(30);
            [self getLastPeriphals];
        }
        
    }else{
        
        __weak typeof(self)weakself=self;
        [weakself.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
            NSLog(@"检测蓝牙状态");
            failsTime=0;
            self.Mycentral=central;
            if (central.state == CBCentralManagerStatePoweredOn){
                [self.connectionAlert dismissViewControllerAnimated:NO completion:nil];
                self.connectionAlert=nil;
                //                [self showDeviceScan];
                BluetoothSwitch = true;
                //停止之前的连接
                [self.baby cancelAllPeripheralsConnection];
                [self.peripherals removeAllObjects];
                [self.scanVC reloadMytableView];
                //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
                if (!self.scanVC.isShow) {
                    UIWindow *window=[UIApplication sharedApplication].keyWindow;
                    [self.scanVC reloadMytableView];
                    [window.rootViewController presentViewController:self.scanVC animated:YES completion:^{
                        [self.scanVC.activityIndicator startAnimating];
                        self.baby.scanForPeripherals().begin().stop(30);
                        [self getLastPeriphals];
                    }];
                    
                }else{
                    [self.scanVC.activityIndicator startAnimating];
                    self.baby.scanForPeripherals().begin().stop(30);
                    [self getLastPeriphals];
                }
            }else if (central.state == CBCentralManagerStatePoweredOff){
                if (COM_BLE_DEVICECONNECTED) {
                    NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
                    ConnectState[@"ConnectState"] = @"NO";
                    NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
                    [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                }
                [self.peripherals removeAllObjects];
                [self.scanVC reloadMytableView];
                [self.scanVC dismissViewControllerAnimated:NO completion:nil];
                BluetoothSwitch = false;
                if (!self.connectionAlert||(!self.connectionAlert.isShow)) {
                    self.connectionAlert=[ConnectAlert alertControllerWithTitle:[LANG DPLocalizedString:@"L_BLE_DeviceOpen"] message:[LANG DPLocalizedString:@"L_BLE_DeviceOpenSettings"] preferredStyle:UIAlertControllerStyleAlert];
                    [self.connectionAlert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        if (UIApplicationOpenSettingsURLString != NULL) {
                            NSURL *appSettings = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
                            if([[UIApplication sharedApplication]canOpenURL:appSettings]){
                                
                                [[UIApplication sharedApplication] openURL:appSettings];
                            }
                            
                        }
                        self.connectionAlert=nil;
                    }]];
                    [self.connectionAlert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        self.connectionAlert=nil;
                    }]];
                    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
                    UIViewController *vc=window.rootViewController;
                    [vc presentViewController:self.connectionAlert animated:YES completion:nil];
                }
                
            }else if (central.state ==CBCentralManagerStateUnknown){
                NSLog(@"========CBCentralManagerStateUnknown");
            }else if (central.state==CBCentralManagerStateResetting){
                NSLog(@"========该设备不支持蓝牙功能,请检查系统设置");
            }else if (central.state==CBCentralManagerStateUnsupported){
                NSLog(@"========该设备蓝牙未授权,请检查系统设置");
            }else if (central.state==CBCentralManagerStateUnauthorized){
                NSLog(@"========该设备蓝牙未授权,请检查系统设置");
            }
        }];
    }
    if(!BluetoothSwitch&&self.Mycentral.state==CBCentralManagerStatePoweredOff){//蓝牙开关已打开
        failsTime++;
        if (failsTime>2) {
            [[DataProgressHUD shareManager]showAlertWithtis:[LANG DPLocalizedString:@"blueToothFailsOpen"]];
        }
        if (!self.connectionAlert||(!self.connectionAlert.isShow)) {
            self.connectionAlert=[ConnectAlert alertControllerWithTitle:[LANG DPLocalizedString:@"L_BLE_DeviceOpen"] message:[LANG DPLocalizedString:@"L_BLE_DeviceOpenSettings"] preferredStyle:UIAlertControllerStyleAlert];
            [self.connectionAlert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
                self.connectionAlert=nil;
            }]];
            [self.connectionAlert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.connectionAlert=nil;
            }]];
            UIWindow *window=[[UIApplication sharedApplication]keyWindow];
            UIViewController *vc=window.rootViewController;
            [vc presentViewController:self.connectionAlert animated:YES completion:nil];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
    
}


-(NSArray *)scanBluetoothPeriphals
{
    return self.peripherals;
}

/**
 *正式连接蓝牙设备
 */
-(void)connectBLEDevice:(int)index;{
    [self.baby cancelScan];
    if (self.peripherals.count > 0){
        if (self.isAutoConnect) {
            self.isAutoConnect=NO;
        }
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:index];
        
        self.currPeripheral = peripheral;
        [self getComPlayTypeWith:self.currPeripheral]; self.baby.having(self.currPeripheral).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
    
}


/**
 * 订阅值
 */
-(void)NotifyValue:(BOOL)bNotify{
    __weak typeof(self)weakSelf = self;
    if (self.readcharacteristic.properties & CBCharacteristicPropertyNotify){
        if(bNotify){
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.readcharacteristic];
            //开机读取联机数据
            COM_BLE_DEVICECONNECTED = true;
            [self.mDataTransmitOpt InitLoad];
            [self bluetoothReceiveData];
        }else{
            [self.baby cancelNotify:self.currPeripheral characteristic:self.readcharacteristic];
        }
    }else{
        COM_BLE_DEVICECONNECTED = false;
        QIZLog(@"这个characteristic没有nofity的权限");
        return;
    }
}


/**
 * 蓝牙接收数据处理
 */
-(void)bluetoothReceiveData
{
    [self.baby notify:self.currPeripheral
       characteristic:self.readcharacteristic
                block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                    NSLog(@"notify block接收蓝牙的数据 %@",characteristics.value);
                    //数据处理开始
                    NSData *data = characteristics.value;
                    Byte *readByte = (Byte *)[data bytes];
                    for(int i=0;i<(int)[data length];i++){
                        [_mDataTransmitOpt ReceiveDataFromDevice : readByte[i] : COM_WITH_MODE];
                    }
                }
     ];
    
}
//通过设备id或者服务id 找到已和系统连接的设备对象（用于搜索普通扫不到的设备）
-(NSArray <CBPeripheral *> *)getRetrievePeripheralsWithIdentifiers:(NSArray <NSString *>*)peripheralUuids AndserviceIds:(NSArray <NSString *> *)serviceUuids{
    NSMutableArray *peripherals=[[NSMutableArray alloc]init];
    //通过设备uuid获取
    if (peripheralUuids.count>0) {
        NSMutableArray *nsUuids=[[NSMutableArray alloc]init];
        for (NSString *uuidStr in peripheralUuids) {
            
            [nsUuids addObject:[[NSUUID alloc]initWithUUIDString:uuidStr]];
        }
        NSArray *uuidPeriperals=[self.baby.centralManager retrievePeripheralsWithIdentifiers:nsUuids];
        [peripherals addObjectsFromArray:uuidPeriperals];
    }
    //通过服务uuid获取
    if (serviceUuids.count>0) {
        NSMutableArray *cbUuids=[[NSMutableArray alloc]init];
        for (NSString *uuidStr in serviceUuids) {
            
            [cbUuids addObject:[CBUUID UUIDWithString:uuidStr]];
            
        }
        NSArray *servicePeriperals=[self.baby.centralManager retrieveConnectedPeripheralsWithServices:cbUuids];
        //过滤重复的对象
        for (CBPeripheral *peripheral in servicePeriperals) {
            if (![peripherals containsObject:peripheral]) {
                [peripherals addObject:peripheral];
            }
        }
        
    }
    return peripherals;
}
-(void)getLastPeriphals{
    NSString *serviceStr=[[NSUserDefaults standardUserDefaults]stringForKey:LastServiceIds];
    if (serviceStr.length>0) {
        NSArray *peripherals=[self getRetrievePeripheralsWithIdentifiers:nil AndserviceIds:@[serviceStr]];
        for (CBPeripheral *peripheral in peripherals) {
            [self insertPeripherals:peripheral advertisementData:nil];
        }
    }
}
- (void)sendData:(Byte[])data withSendMode:(int)mode{
    //    if (mode == COM_WITH_BLE) { //蓝牙发送
    //QIZLog(@"####### 蓝牙发送 #######");
    NSData* sendData = [[NSData alloc] initWithBytes:data length:20];
    NSLog(@"分包发送数据：%@",sendData);
    [self.currPeripheral writeValue:sendData forCharacteristic:self.writecharacteristic type:CBCharacteristicWriteWithoutResponse];
    [NSThread sleepForTimeInterval:0.05f];
    //    } else { //wifi
    //
    //    }
}



@end

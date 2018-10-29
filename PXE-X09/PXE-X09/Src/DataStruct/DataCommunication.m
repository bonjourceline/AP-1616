//
//  DataCommunication.m
//  DCP812
//
//  Created by chsdsp on 2017/2/14.
//  Copyright © 2017年 hmaudio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DataCommunication.h"
#import "MacDefine.h"
#import "DataStruct.h"
#import "BLEManager.h"

//音效文件
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#import "QIZLocalEffectViewController.h"
#import "SEFFFile.h"
#import "SliderButton.h"
#define BT_SEND_DATA_PACK_SIZE 20

@implementation DataCommunication

+ (instancetype)shareDataCommunication
{
    static DataCommunication *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[DataCommunication alloc]init];
    });
    return share;
}
-(NSMutableArray *)sendListBufferList{
    if (!_sendListBufferList) {
        _sendListBufferList=[[NSMutableArray alloc]init];
    }
    
    return _sendListBufferList;
}
-(NSMutableArray *)sendMusicBufferList{
    if (!_sendMusicBufferList) {
        _sendMusicBufferList=[[NSMutableArray alloc]init];
    }
    return _sendMusicBufferList;
}
-(id)init{
    if(self = [super init]){
        U0RcvFrameFlg = false;     // 有新接收到数据的标志
        U0SendFrameFlg = false;    // 有数据要发送的标志
        U0SynDataSucessFlg = false;// 同步初始化数据完成标志
        //        U0SynDataError = false;    // 同步初始化数据是否出错
        DeviceVerErrorFlg = false;
        U0HeadFlg = false;
        
        U0HeadCnt = 0;
        U0DataCnt = 0;
        
        SendbufferList = [[NSMutableArray alloc] init];//要发送的数据值表
        for(int i=0; i<(U0DataLen + CMD_LENGHT);i++){
            FrameDataBuf[i] = 0;
        }
        FrameDataSUM = 0;
        //数据发送线程
        
        // 创建
        self.sendDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
        // 启动
        [self.sendDataThread start];
        
    }
    return self;
}
-(void)setFlagDefault{
    U0HeadFlg = false;
    U0HeadCnt = 0;
    U0DataCnt = 0;
}
#pragma mark ------灯包
- (void)run:(NSThread *)thread{
    int OutTimeCnt2 =0;
    int OutTimeCnt = 0;
    int RetryCnt = 0;
    
    //连接状态
    NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
    ConnectState[@"ConnectState"] = @"NO";
    //创建一个消息对象
    NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
    //同步更新数据
    NSMutableDictionary *DictionaryMSG = [NSMutableDictionary dictionary];
    DictionaryMSG[@"SynDataSucessFlg"] = @"YES";
    //创建一个消息对象
    NSNotification * noticeSynDataSucess = [NSNotification notificationWithName:MyNotification_UpdateUI object:nil userInfo:DictionaryMSG];
    while (true) {
        if(COM_BLE_DEVICECONNECTED){
            //            if (MusicBoxManger.isSendStatus) {
            //                [MusicBoxManger MBoxCmd];
            //            }
            //            [NSThread sleepForTimeInterval:1];
            //            continue;
            //if([BLEManager shareBLEManager].baby.centralManager.state == CBCentralManagerStatePoweredOn){
            // 用户有新数据插入时发送
            if (SendbufferList.count > 0){//列表有數據發送
                U0RcvFrameFlg = false;//有新接收到数据的标志，清除标志
                OutTimeCnt2 =0;
                OutTimeCnt = 0;
                RetryCnt = 0;
                //第-次发送
                [self BT_SendPack:[SendbufferList objectAtIndex:0] withSize:[[SendbufferList objectAtIndex:0] count] ];
                while(!U0RcvFrameFlg){
                    if (!COM_BLE_DEVICECONNECTED) {
                        break;
                    }
                    [NSThread sleepForTimeInterval:0.01];
                    
                    if(SendAgainFlg){
                        SendAgainFlg=false;
                        QIZLog(@"## Channel OutTimeCnt Get ERROR,Send again");
                        [self BT_SendPack:[SendbufferList objectAtIndex:0] withSize:[[SendbufferList objectAtIndex:0] count] ];
                    }
                    
                    // 发送数据无回应时，单次重试的时间间隔
                    if (++OutTimeCnt > 500){
                        OutTimeCnt = 0;
                        //第二次发送
                        if(SendbufferList.count>0){//Dug:会引发空指针错误
                            QIZLog(@"## Channel OutTimeCnt !1! SendbufferList.length:%d", (int)[[SendbufferList objectAtIndex:0] count]);
                            [self BT_SendPack:[SendbufferList objectAtIndex:0] withSize:[[SendbufferList objectAtIndex:0] count] ];
                        }
                        // 4次发送数据无回应时，断开连接
                        if (++RetryCnt >= 2){
                            QIZLog(@"## RetryCnt  WHAT_IS_CONNECT_ERROR");
                            //发送消息
                            ConnectState[@"ConnectState"] = @"NO";
                            [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                            break;
                        }
                        
                    }
                }
                if(SendbufferList.count>0){//Dug:会引发空指针错误
                    //成功发送，清除已经发送的列表
                    [SendbufferList removeObjectAtIndex:0];
                }
                if (SendbufferList.count == 0){
                    if((!U0SynDataSucessFlg)||(BOOL_SeffOpt)){
                        BOOL_SeffOpt=FALSE;
                        //发送消息
                        [[NSNotificationCenter defaultCenter] postNotification:noticeSynDataSucess];
                        
                        U0SynDataSucessFlg = true;
                        gConnectState = true;
                        [DataCManager ComparedToSendData:false];
                    }
                }
                // 发送进度条消息给主线程
                //if (progressDialogStep > 0) {
                //   Message msg = Message.obtain();
                //    msg.what = WHAT_IS_PROGRESSDIALOG;
                //    msg.arg1 = SendbufferList.size();
                //    mHandler.sendMessage(msg);
                //}
            }else{//列表没有数据发送，则检测数据有没有理性和更新信号包
                /**/
                if (U0SynDataSucessFlg) {//同步初始化数据完成
                    //经比较之前的数据（初始化数等），如有更新则发送新数据
                    [self ComparedToSendData:true];
                    
                    if(++LEDPackageCnt > 1){
                        LEDPackageCnt = 0;
                        
                        U0RcvFrameFlg = false;//有新接收到数据的标志，清除标志
                        OutTimeCnt = 0;
                        RetryCnt = 0;
                        
                        // 没有数据更新时，请求信号灯，空闲时同步更新信号灯
                        SendFrameData.FrameType = READ_CMD;
                        SendFrameData.DeviceID = 0x01;
                        SendFrameData.UserID = 0x00;
                        SendFrameData.DataType = SYSTEM;
                        SendFrameData.ChannelID = LED_DATA;
                        // 请求信号灯
                        SendFrameData.DataID = 0x00;
                        SendFrameData.PCFadeInFadeOutFlg = 0x00;
                        SendFrameData.PcCustom = 0x00;
                        SendFrameData.DataLen = 0x00;
                        
                        [self SendDataToDevice:true];
                        while(!U0RcvFrameFlg){
                            if (COM_BLE_DEVICECONNECTED) {
                                [NSThread sleepForTimeInterval:0.01];
                                // 发送数据无回应时，单次重试的时间间隔
                                if (++OutTimeCnt > 500){
                                    OutTimeCnt = 0;
                                    //第二次发送
                                    [self SendDataToDevice:true];
                                    //发送数据无回应时，断开连接
                                    if (++RetryCnt >= 2){
                                        QIZLog(@"## RetryCnt READ_CMD WHAT_IS_CONNECT_ERROR=======================");
                                        //发送消息
                                        ConnectState[@"ConnectState"] = @"NO";
                                        [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                                        break;
                                    }
                                    
                                }
                            }else{
                                break;
                            }
                            
                        }
                        
                    }
                }
            }
        }else {//无连接
            //空闲检测连接状态
            [NSThread sleepForTimeInterval:0.5];
        }
    }
}


// 处理检包后的数据，分类存储器起来
- (void) ProcessRecFrameData {
    uint8 databuf[12];
    //    if(RecFrameData.DataType != 9){
    //        NSLog(@"##-RecFrameData.FrameType=%d",RecFrameData.FrameType);
    //        NSLog(@"##-RecFrameData.UserID=%d",RecFrameData.UserID);
    //        NSLog(@"##-RecFrameData.DataType=%d",RecFrameData.DataType);
    //        NSLog(@"##-RecFrameData.ChannelID=%d",RecFrameData.ChannelID);
    //        NSLog(@"##-RecFrameData.DataLen=%d",RecFrameData.DataLen);
    //    }
    
    
    if (RecFrameData.FrameType == DATA_ACK){ // 数据回应帧
        if (RecFrameData.DataType == MUSIC) {/*读取整MUSIC.2通道的整个数据*/
            if(BOOL_ReadMacData){
                if(BOOL_USE_INS){
                    int c = 0;
                    for(int ch=0;ch<INS_CH_MAX;ch++){
                        for(int cnt=0;cnt<INS_LEN;cnt++){
                            JsonMacData.Data[RecFrameData.UserID].JIN.MusicJ[ch][cnt]=RecFrameData.DataBuf[cnt+10+c++];
                        }
                    }
                    
                }else{
                    for(int cnt=0;cnt<IN_LEN;cnt++){
                        JsonMacData.Data[RecFrameData.UserID].JIN.MusicJ[RecFrameData.ChannelID][cnt]=RecFrameData.DataBuf[cnt+10];
                    }
                }
            }else{
                [self FillRecDataStruct:MUSIC withChannelID:RecFrameData.ChannelID];
            }
            
            
        } else if (RecFrameData.DataType == OUTPUT) {
            if((RecFrameData.DataLen == OUT_LEN)
               &&(RecFrameData.ChannelID == (Output_CH_MAX-1))){
                //表示已读取过通道数据
                //                DataCManager.UpdataAduanceData=true;
            }
            if(!BOOL_ReadMacData){
                if(RecFrameData.DataLen == OUT_LEN){
                    [self FillRecDataStruct:OUTPUT withChannelID:RecFrameData.ChannelID];
                }
                //检测数据是否出错
                if(RecFrameData.ChannelID == (Output_CH_MAX - 1)){
                    if(U0SynDataError){
                        if(BOOL_RESET_GROUP_DATA){
                            //发送消息操作整机数据
                            NSMutableDictionary *State = [NSMutableDictionary dictionary];
                            State[@"State"] = @"YES";
                            //创建一个消息对象
                            NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_ShowResetSEFFData object:nil userInfo:State];
                            [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                            
                        }
                    }
                }
            }else{
                for(int cnt=0;cnt<OUT_LEN;cnt++){
                    JsonMacData.Data[RecFrameData.UserID].JOUT.OutputJ[RecFrameData.ChannelID][cnt]=RecFrameData.DataBuf[cnt+10];
                }
                
                if((RecFrameData.UserID == MAX_USE_GROUP)&&(RecFrameData.ChannelID == Output_CH_MAX-1)){
                    BOOL_ReadMacData = false;
                    NSLog(@"##-ReadMacData Done!!");
                    //把当前组加进整机数据中
                    if(BOOL_USE_INS){
                        for(int i=0;i<IN_CH_MAX;i++){
                            FillSedDataStructCHBuf(MUSIC, i);
                            for(int j=0;j<INS_LEN;j++){
                                JsonMacData.Data[0].JIN.MusicJ[i][j]=ChannelBuf[j];
                            }
                        }
                    }else{
                        for(int i=0;i<IN_CH_MAX;i++){
                            FillSedDataStructCHBuf(MUSIC, i);
                            for(int j=0;j<IN_LEN;j++){
                                JsonMacData.Data[0].JIN.MusicJ[i][j]=ChannelBuf[j];
                            }
                        }
                    }
                    for(int i=0;i<Output_CH_MAX;i++){
                        FillSedDataStructCHBuf(OUTPUT, i);
                        for(int j=0;j<OUT_LEN;j++){
                            JsonMacData.Data[0].JOUT.OutputJ[i][j]=ChannelBuf[j];
                        }
                    }
                    //发送消息操作整机数据
                    NSMutableDictionary *State = [NSMutableDictionary dictionary];
                    State[@"State"] = @"YES";
                    //创建一个消息对象
                    NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_ReadMacData object:nil userInfo:State];
                    [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                    
                }
            }
        } else if (RecFrameData.DataType == SYSTEM) {
            switch (RecFrameData.ChannelID) {
                case GROUP_NAME:
                    if(!BOOL_ReadMacData){
                        for (int i = 0; i < 16; i++){
                            RecStructData.USER[RecFrameData.UserID].name[i] = RecFrameData.DataBuf[10 + i]; // 接收用户名
                        }
                    }else{
                        for (int i = 0; i < 16; i++){
                            JsonMacData.Data[RecFrameData.UserID].GroupName[i]=RecFrameData.DataBuf[10 + i];// 接收用户名
                        }
                        
                    }
                    break;
                    
                case PC_SOURCE_SET:
                    RecStructData.System.input_source = RecFrameData.DataBuf[10];
                    RecStructData.System.mixer_source = RecFrameData.DataBuf[11]; // 低电平模式
                    for (int i=0; i<5; i++) {
                        RecStructData.System.InSwitch[i]=RecFrameData.DataBuf[12+i];
                    }
                    RecStructData.System.none1=RecFrameData.DataBuf[17];
                   
                    break;
                    
                case MCU_BUSY:
                    // U0BusyFlg = YES;
                    break;
                    
                case SYSTEM_DATA:
                    NSLog(@"%d-----%d",RecFrameData.DataBuf[10],RecStructData.DataBuf[11]);
                    RecStructData.System.main_vol = RecFrameData.DataBuf[10]
                    + RecStructData.DataBuf[11] * 256;
                    RecStructData.System.high_mode = RecFrameData.DataBuf[12];

                    RecStructData.System.aux_mode = RecFrameData.DataBuf[13];
                    RecStructData.System.out_mode = RecFrameData.DataBuf[14];
                    RecStructData.System.mixer_SourcedB = RecFrameData.DataBuf[15];
                    RecStructData.System.MainvolMuteFlg = RecFrameData.DataBuf[16];
                    RecStructData.System.theme = RecFrameData.DataBuf[17];// 保留
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:MyNotification_updateVol object:nil];
                    
                    
                    break;
                case SYSTEM_SPK_TYPE:
//                    for (int i=0; i<8; i++) {
//                        RecStructData.System.none[i]=RecFrameData.DataBuf[10+i];
//                    }
                    RecStructData.System.HiInputChNum=RecFrameData.DataBuf[10];
                    RecStructData.System.AuxInputChNum=RecFrameData.DataBuf[11];
                    RecStructData.System.OutputChNum=RecFrameData.DataBuf[12];
                    RecStructData.System.IsRTA_outch=RecFrameData.DataBuf[13];
                    RecStructData.System.InSignelThreshold=RecFrameData.DataBuf[14];
                    RecStructData.System.OffTime=RecFrameData.DataBuf[15];
                    RecStructData.System.none[0]=RecFrameData.DataBuf[16];
                    RecStructData.System.none[1]=RecFrameData.DataBuf[17];
                    
                    for (int i=0; i<8; i++) {
                        RecStructData.System.high_Low_Set[i]=RecFrameData.DataBuf[18+i];
                    }
                    for (int i=0; i<16; i++) {
                        RecStructData.System.in_spk_type[i]=RecFrameData.DataBuf[26+i];
                    }
                    for (int i=0; i<16; i++) {
                        RecStructData.System.out_spk_type[i]=RecFrameData.DataBuf[42+i];
                    }
                    break;
                case SYSTEM_ALL:
                    RecStructData.System.input_source = RecFrameData.DataBuf[10];
                    RecStructData.System.mixer_source = RecFrameData.DataBuf[11]; // 低电平模式
                    for (int i=0; i<5; i++) {
                        RecStructData.System.InSwitch[i]=RecFrameData.DataBuf[12+i];
                    }
                    RecStructData.System.none1=RecFrameData.DataBuf[17];
                    /////
                    RecStructData.System.main_vol = RecFrameData.DataBuf[18]
                    + RecStructData.DataBuf[19] * 256;
                    RecStructData.System.high_mode = RecFrameData.DataBuf[20];
                    
                    RecStructData.System.aux_mode = RecFrameData.DataBuf[21];
                    RecStructData.System.out_mode = RecFrameData.DataBuf[22];
                    RecStructData.System.mixer_SourcedB = RecFrameData.DataBuf[23];
                    RecStructData.System.MainvolMuteFlg = RecFrameData.DataBuf[24];
                    RecStructData.System.theme = RecFrameData.DataBuf[25];// 保留
                    /////////
                    RecStructData.System.HiInputChNum=RecFrameData.DataBuf[26];
                    RecStructData.System.AuxInputChNum=RecFrameData.DataBuf[27];
                    RecStructData.System.OutputChNum=RecFrameData.DataBuf[28];
                    RecStructData.System.IsRTA_outch=RecFrameData.DataBuf[29];
                    RecStructData.System.InSignelThreshold=RecFrameData.DataBuf[30];
                    RecStructData.System.OffTime=RecFrameData.DataBuf[31];
                    RecStructData.System.none[0]=RecFrameData.DataBuf[32];
                    RecStructData.System.none[1]=RecFrameData.DataBuf[33];
                    
                    for (int i=0; i<8; i++) {
                        RecStructData.System.high_Low_Set[i]=RecFrameData.DataBuf[34+i];
                    }
                    for (int i=0; i<16; i++) {
                        RecStructData.System.in_spk_type[i]=RecFrameData.DataBuf[42+i];
                    }
                    for (int i=0; i<16; i++) {
                        RecStructData.System.out_spk_type[i]=RecFrameData.DataBuf[58+i];
                    }
                    break;
                case LED_DATA:
                    //数据共52字节，前31为RTA数据，中间20为信号 76~127属于有信号 小于76灯灭  后1个字节为当前最新信号源数据 光纤同轴各一个 蓝牙两个
                    if(RecStructData.System.input_source_temp != RecFrameData.DataBuf[10 + 31+20]){
                        RecStructData.System.input_source_temp = RecFrameData.DataBuf[10 + 31+20];
                        if(RecStructData.System.input_source_temp != RecStructData.System.input_source){
                            NSLog(@"收到的音源为 %d",RecFrameData.DataBuf[10 + 31+20]);
                            RecStructData.System.input_source = RecStructData.System.input_source_temp;
                            SendStructData.System.input_source=RecStructData.System.input_source;
                            //连接状态
                            NSMutableDictionary *State = [NSMutableDictionary dictionary];
                            State[@"ConnectState"] = @"YES";
                            //创建一个消息对象
                            NSNotification * noticeConnectState = [NSNotification notificationWithName:MyNotification_FlashInputSource object:nil userInfo:State];
                            [[NSNotificationCenter defaultCenter] postNotification:noticeConnectState];
                        }
                    }
                    
                    
                    break;
                case CUR_PROGRAM_INFO:
                    RecStructData.CurProID = RecFrameData.DataBuf[10];// 当前用户组ID
                    break;
                case SOUND_FIELD_INFO:
                    for(int i = 0; i < 50; i++){
                        RecStructData.SoundFieldSystem.SoundDelayField[i] = RecFrameData.DataBuf[10 + i];
                    }
                    FillDelayDataBySystemChannel();
                    break;
                case SOFTWARE_VERSION:
                {
                    databuf[11] = 0;
                    for (int i = 0; i < 11; i++) {
                        databuf[i] = (char) RecFrameData.DataBuf[10 + i];
                    }
                    
                    NSString *strVersionMCU = [[NSString alloc] initWithBytes:databuf length:9 encoding:NSUTF8StringEncoding];
                    NSString *str = [[NSString alloc] initWithBytes:databuf length:11 encoding:NSUTF8StringEncoding];
                    //DeviceVerErrorFlg = [strVersionMCU isEqualToString: MCU_Versions];
                    DeviceVerString = str;
                    
                    
                    if([strVersionMCU isEqualToString: MCU_Versions]){
                        DeviceVerErrorFlg = true;
                        BOOL_MAC_Change = false;
                    }else if([strVersionMCU isEqualToString: MCU_Versions_I]){
                        DeviceVerErrorFlg = true;
                        BOOL_MAC_Change = true;
                    }else {
                        DeviceVerErrorFlg = false;
                    }
                    
                    
                    if(!DeviceVerErrorFlg){//发送版本错误消息
                        NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
                        ConnectState[@"ConnectState"] = @"DER";
                        NSLog(@"========版本错误");
                        //创建一个消息对象
                        NSNotification * notice = [NSNotification notificationWithName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
                        //发送消息
                        [[NSNotificationCenter defaultCenter] postNotification:notice];
                        
                    }
                }
                    break;
                default:
                    break;
            }
        } else {
            ;
        }
        gConnectState = true;
        U0RcvFrameFlg = true; // rcv one frame end
    } else if (RecFrameData.FrameType == ERROR_ACK){ // 错误回应
        SendAgainFlg=true;
    } else if (RecFrameData.FrameType == RIGHT_ACK){ // 正确回应
        U0RcvFrameFlg = true; // rcv one frame end
        gConnectState = true;
    }
    
    if(gConnectState != gOldConnectState){
        gOldConnectState = gConnectState;
        if(gConnectState){
            NSMutableDictionary *ConnectState = [NSMutableDictionary dictionary];
            ConnectState[@"ConnectState"] = @"YES";
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:MyNotification_ConnectSuccess object:nil userInfo:ConnectState];
            //发送消息
            [[NSNotificationCenter defaultCenter] postNotification:notice];
        }
    }
}

#pragma mark ---解析收到的数据
// 接收数据，检包
- (void) ReceiveDataFromDevice:(uint8) data :(uint8) type {
    
    //判断包头，起始符，贞头
    //NSLog(@"##-ReceiveDataFromDevice-U0HeadFlg");
    if (!U0HeadFlg) {// U0HeadFlg=NO,rcv head data
        if((data == HEAD_DATA)&&(U0HeadCnt == 0)) {
            U0HeadCnt++;
        }else if((data == HEAD_DATA)&&(U0HeadCnt == 1)) {
            U0HeadCnt++;
        }else if((data == HEAD_DATA)&&(U0HeadCnt == 2)) {
            U0HeadCnt++;
        }else if (data == FRAME_STA && U0HeadCnt == 3){// Have rcv // 0xff,0xff,0xff,0xb1
            U0HeadFlg = true;
            U0HeadCnt = 0;
        } else {
            U0HeadCnt = 0;
        }
        U0DataCnt = 0; // Ready rcv data, rcv cnt set 0
    }
    //有效包
    else if (U0HeadFlg) {
        U0HeadCnt = 0;
        if (U0DataCnt>=U0DataLen) {
            U0HeadFlg = false; // start rcv new head flag
            U0DataCnt = 0;  // rcv counter set 0
            
            return;
        }
        RecFrameData.DataBuf[U0DataCnt] = data;
        U0DataCnt++;
        if (U0DataCnt >= (RecFrameData.DataBuf[8]
                          + RecFrameData.DataBuf[9] * 256 + CMD_LENGHT - 4))
        {
            RecFrameData.FrameType = RecFrameData.DataBuf[0];
            RecFrameData.DeviceID  = RecFrameData.DataBuf[1];
            RecFrameData.UserID    = RecFrameData.DataBuf[2];
            RecFrameData.DataType  = RecFrameData.DataBuf[3];
            RecFrameData.ChannelID = RecFrameData.DataBuf[4];
            RecFrameData.DataID    = RecFrameData.DataBuf[5];
            RecFrameData.PCFadeInFadeOutFlg = RecFrameData.DataBuf[6];
            RecFrameData.PcCustom  = RecFrameData.DataBuf[7];
            RecFrameData.DataLen   = RecFrameData.DataBuf[8]
            + RecFrameData.DataBuf[9] * 256;
            RecFrameData.CheckSum  = RecFrameData.DataBuf[RecFrameData.DataLen
                                                          + CMD_LENGHT - 6];
            RecFrameData.FrameEnd  = RecFrameData.DataBuf[RecFrameData.DataLen
                                                          + CMD_LENGHT - 5];
            
            U0HeadFlg = false; // start rcv new head flag
            U0DataCnt = 0;  // rcv counter set 0
            
            if (RecFrameData.FrameEnd == FRAME_END){ // 判断包尾是否正确
                int sum = 0;
                for (int i = 0; i < (RecFrameData.DataLen
                                     + CMD_LENGHT - 6); i++) {
                    sum ^= RecFrameData.DataBuf[i];
                }
                
                if (sum == RecFrameData.CheckSum){ // 通过校验
//                    NSLog(@"###########################################-Rec One Frame");
                    //U0RcvFrameFlg = true;
                    [self ProcessRecFrameData];
                }
            }
        }
    }
}

// 发送一个数据包到设备
// sendorinsert = true 直接发送出去，否则插入发送队列
- (void) SendDataToDevice:(BOOL) sendorinsert {
    for(int i=0;i<(U0DataLen + CMD_LENGHT);i++){
        FrameDataBuf[i] = (0x00);
    }
    FrameDataSUM = 0;
    
    //NSLog(@"##-SendFrameData.FrameType=%d",SendFrameData.FrameType);
    //NSLog(@"##-SendFrameData.UserID=%d",SendFrameData.UserID);
    //NSLog(@"##-SendFrameData.DataType=%d",SendFrameData.DataType);
    //NSLog(@"##-SendFrameData.ChannelID=%d",SendFrameData.ChannelID);
    //NSLog(@"##-SendFrameData.DataLen=%d",SendFrameData.DataLen);
    
    if (SendFrameData.FrameType == 0xa2){ // 从设备读取数据，无需填充内容
        SendFrameData.DataLen = 0;
    }
    
    FrameDataBuf[0] = (HEAD_DATA & 0xff); // 包头
    FrameDataBuf[1] = (HEAD_DATA & 0xff); // 包头
    FrameDataBuf[2] = (HEAD_DATA & 0xff); // 包头
    FrameDataBuf[3] = (FRAME_STA & 0xff); // 起始字符
    
    FrameDataBuf[4] = (SendFrameData.FrameType & 0xff); // 帧类型 读/写 写:0xa1
    // 读:0xa2
    FrameDataBuf[5] = (SendFrameData.DeviceID & 0xff);  // 设备ID
    FrameDataBuf[6] = (SendFrameData.UserID & 0xff);    // 用户ID
    FrameDataBuf[7] = (SendFrameData.DataType & 0xff);  // 数据类型 输入 输出 系统等
    FrameDataBuf[8] = (SendFrameData.ChannelID & 0xff); // 通道ID
    FrameDataBuf[9] = (SendFrameData.DataID & 0xff);    // 数据ID
    FrameDataBuf[10] = (SendFrameData.PCFadeInFadeOutFlg & 0xff); // 淡入淡出标志.对OUTPUT，System.SOUND_FIELD_INFO有效
    FrameDataBuf[11] = (SendFrameData.PcCustom & 0xff); // 自定义字符，发什么下去，返回什么
    FrameDataBuf[12] = (SendFrameData.DataLen & 0xff);  // 数据长度低字节
    FrameDataBuf[13] = ((SendFrameData.DataLen >> 8) & 0xff); // 数据长度高字节
    
    FrameDataSUM  = (SendFrameData.FrameType & 0xff);
    FrameDataSUM ^= (SendFrameData.DeviceID & 0xff);
    FrameDataSUM ^= (SendFrameData.UserID & 0xff);
    FrameDataSUM ^= (SendFrameData.DataType & 0xff);
    FrameDataSUM ^= (SendFrameData.ChannelID & 0xff);
    FrameDataSUM ^= (SendFrameData.DataID & 0xff);
    FrameDataSUM ^= (SendFrameData.PCFadeInFadeOutFlg & 0xff);
    FrameDataSUM ^= (SendFrameData.PcCustom & 0xff);
    FrameDataSUM ^= (SendFrameData.DataLen & 0xff);
    FrameDataSUM ^= ((SendFrameData.DataLen >> 8) & 0xff);
    
    if (SendFrameData.FrameType == 0xa1) // 写数据到设备
    {
        if (SendFrameData.DataType == MUSIC) {
            /*写当前组*/
            if(SendFrameData.UserID == 0){
                if(BOOL_USE_INS){
                    if(SendFrameData.DataLen == INS_LEN){
                        for(int i=0; i<INS_LEN; i++){
                            FrameDataBuf[14+i] = SendFrameData.Buf[i];
                        }
                    }else{
                        if(SendFrameData.DataID <= INS_ID_MAX){
                            switch (SendFrameData.DataID) {
                                case INS_MISC_ID:
                                    FrameDataBuf[14] = (SendStructData.INS_CH[0].feedback & 0xff);
                                    FrameDataBuf[15] = (SendStructData.INS_CH[0].polar & 0xff);
                                    FrameDataBuf[16] = (SendStructData.INS_CH[0].eq_mode & 0xff);
                                    FrameDataBuf[17] = (SendStructData.INS_CH[0].mute & 0xff);
                                    FrameDataBuf[18] = (SendStructData.INS_CH[0].delay & 0xff);
                                    FrameDataBuf[19] = ((SendStructData.INS_CH[0].delay >> 8) & 0xff);
                                    FrameDataBuf[20] = (SendStructData.INS_CH[0].Valume & 0xff);
                                    FrameDataBuf[21] = ((SendStructData.INS_CH[0].Valume >> 8) & 0xff);
                                    
                                    break;
                                case INS_XOVER_ID:
                                    FrameDataBuf[14] = (SendStructData.INS_CH[SendFrameData.ChannelID].h_freq & 0xff);
                                    FrameDataBuf[15] = ((SendStructData.INS_CH[SendFrameData.ChannelID].h_freq >> 8) & 0xff);
                                    FrameDataBuf[16] = (SendStructData.INS_CH[SendFrameData.ChannelID].h_filter & 0xff);
                                    FrameDataBuf[17] = (SendStructData.INS_CH[SendFrameData.ChannelID].h_level & 0xff);
                                    FrameDataBuf[18] = (SendStructData.INS_CH[SendFrameData.ChannelID].l_freq & 0xff);
                                    FrameDataBuf[19] = ((SendStructData.INS_CH[SendFrameData.ChannelID].l_freq >> 8) & 0xff);
                                    FrameDataBuf[20] = (SendStructData.INS_CH[SendFrameData.ChannelID].l_filter & 0xff);
                                    FrameDataBuf[21] = (SendStructData.INS_CH[SendFrameData.ChannelID].l_level & 0xff);
                                    
                                    break;
                                default:
                                    break;
                            }
                        }else{
                            FrameDataBuf[14] = (SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].freq & 0xff);
                            FrameDataBuf[15] = ((SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].freq >> 8) & 0xff);
                            FrameDataBuf[16] = (SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].level & 0xff);
                            FrameDataBuf[17] = ((SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].level >> 8) & 0xff);
                            FrameDataBuf[18] = (SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].bw & 0xff);
                            FrameDataBuf[19] = ((SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].bw >> 8) & 0xff);
                            FrameDataBuf[20] = (SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].shf_db & 0xff);
                            FrameDataBuf[21] = (SendStructData.INS_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID-INS_ID_MAX-1].type & 0xff);
                            
                        }
                    }
                }else{
                    if(SendFrameData.DataLen == IN_LEN){
                        for(int i=0; i<IN_LEN; i++){
                            FrameDataBuf[14+i] = SendFrameData.Buf[i];
                        }
                    }else{
                        if(SendFrameData.DataID<IN_EQMAX_ID){
                            FrameDataBuf[14] = (SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].freq & 0xff);
                            FrameDataBuf[15] = ((SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].freq >> 8) & 0xff);
                            FrameDataBuf[16] = (SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].level & 0xff);
                            FrameDataBuf[17] = ((SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].level >> 8) & 0xff);
                            FrameDataBuf[18] = (SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].bw & 0xff);
                            FrameDataBuf[19] = ((SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].bw >> 8) & 0xff);
                            FrameDataBuf[20] = (SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].shf_db & 0xff);
                            FrameDataBuf[21] = (SendStructData.IN_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].type & 0xff);
                        }else{
                            switch (SendFrameData.DataID) {
                                case IN_MISC_ID:
                                    FrameDataBuf[14] = (SendStructData.IN_CH[SendFrameData.ChannelID].mute & 0xff);
                                    FrameDataBuf[15] = (SendStructData.IN_CH[SendFrameData.ChannelID].polar & 0xff);
                                    FrameDataBuf[16] = (SendStructData.IN_CH[SendFrameData.ChannelID].gain & 0xff);
                                    FrameDataBuf[17] = ((SendStructData.IN_CH[SendFrameData.ChannelID].gain >> 8) & 0xff);
                                    FrameDataBuf[18] = (SendStructData.IN_CH[SendFrameData.ChannelID].delay & 0xff);
                                    FrameDataBuf[19] = ((SendStructData.IN_CH[SendFrameData.ChannelID].delay >> 8) & 0xff);
                                    FrameDataBuf[20] = (SendStructData.IN_CH[SendFrameData.ChannelID].eq_mode & 0xff);
                                    FrameDataBuf[21] = (SendStructData.IN_CH[SendFrameData.ChannelID].LinkFlag & 0xff);
                                    
                                    break;
                                case IN_XOVER_ID:
                                    FrameDataBuf[14] = (SendStructData.IN_CH[SendFrameData.ChannelID].h_freq & 0xff);
                                    FrameDataBuf[15] = ((SendStructData.IN_CH[SendFrameData.ChannelID].h_freq >>8) & 0xff);
                                    FrameDataBuf[16] = (SendStructData.IN_CH[SendFrameData.ChannelID].h_filter & 0xff);
                                    FrameDataBuf[17] = (SendStructData.IN_CH[SendFrameData.ChannelID].h_level & 0xff);
                                    FrameDataBuf[18] = (SendStructData.IN_CH[SendFrameData.ChannelID].l_freq & 0xff);
                                    FrameDataBuf[19] = ((SendStructData.IN_CH[SendFrameData.ChannelID].l_freq >> 8) & 0xff);
                                    FrameDataBuf[20] = (SendStructData.IN_CH[SendFrameData.ChannelID].l_filter & 0xff);
                                    FrameDataBuf[21] = (SendStructData.IN_CH[SendFrameData.ChannelID].l_level & 0xff);
                                    break;
                                case IN_NOISEGATE_ID:
                                    FrameDataBuf[14] = (SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_t & 0xff);
                                    FrameDataBuf[15] = (SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_a & 0xff);
                                    FrameDataBuf[16] = (SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_k & 0xff);
                                    FrameDataBuf[17] = ((SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_k >> 8) & 0xff);
                                    FrameDataBuf[18] = (SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_r & 0xff);
                                    FrameDataBuf[19] = ((SendStructData.IN_CH[SendFrameData.ChannelID].noisegate_r >> 8) & 0xff);
                                    FrameDataBuf[20] = (SendStructData.IN_CH[SendFrameData.ChannelID].noise_config & 0xff);
                                    FrameDataBuf[21] = ((SendStructData.IN_CH[SendFrameData.ChannelID].noise_config >> 8) & 0xff);
                                    
                                    break;
                                case IN_NAME_ID:
                                    for (int i=0; i<8; i++) {
                                    FrameDataBuf[14+i]=SendStructData.IN_CH[SendFrameData.ChannelID].name[i];
                                    }
                                    break;
                                default:
                                    break;
                            }
                        }
                        
                    }
                }
            }
            /*写其他组的数据，1个组的数据通道*/
            else if((SendFrameData.UserID >= 1)&&(SendFrameData.UserID <= MAX_USE_GROUP)){
                
                if(BOOL_USE_INS){
                    for(int i=0;i<INS_LEN;i++){
                        FrameDataBuf[14+i] = SendFrameData.Buf[i];
                    }
                }else{
                    for(int i=0;i<IN_LEN;i++){
                        FrameDataBuf[14+i] = SendFrameData.Buf[i];
                    }
                }
            }
        } else if (SendFrameData.DataType == OUTPUT) {
            /*写当前组*/
            if(SendFrameData.UserID == 0){
                if(SendFrameData.DataLen == OUT_LEN){//写一通道的当前数据
                    /*
                     if(BOOL_EncryptionFlag){//加密
                     for(int i=0;i<OUT_LEN;i++){
                     FrameDataBuf[14+i] = (SendFrameData.Buf[i]^Encrypt_DATA);
                     }
                     if(SendFrameData.ChannelID==0){
                     FrameDataBuf[14+OUT_LEN-8] = (EncryptionFlag & 0xff);
                     for(int i=0;i<6;i++){
                     FrameDataBuf[14+OUT_LEN-6+i]=(Encryption_PasswordBuf[i]^Encrypt_DATA);
                     }
                     }
                     }else if(!BOOL_EncryptionFlag){//非加密
                     for(int i=0;i<OUT_LEN;i++){
                     FrameDataBuf[14+i] = SendFrameData.Buf[i];
                     }
                     FrameDataBuf[14+OUT_LEN-8] = DecipheringFlag;
                     }
                     */
                    
                    for(int i=0;i<OUT_LEN;i++){
                        FrameDataBuf[14+i] = SendFrameData.Buf[i];
                    }
                }else {
                    if(SendFrameData.DataID < OUT_CH_EQ_MAX){
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].freq & 0xff);
                        FrameDataBuf[15] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].freq >> 8) & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].level & 0xff);
                        FrameDataBuf[17] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].level >> 8) & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].bw & 0xff);
                        FrameDataBuf[19] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].bw >> 8) & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].shf_db & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].EQ[SendFrameData.DataID].type & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }else if (SendFrameData.DataID == OUT_MISC_ID) {
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].mute & 0xff);
                        FrameDataBuf[15] = (SendStructData.OUT_CH[SendFrameData.ChannelID].polar & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].gain & 0xff);
                        FrameDataBuf[17] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].gain >> 8) & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].delay & 0xff);
                        FrameDataBuf[19] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].delay >> 8) & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].eq_mode & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].LinkFlag & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }else if(SendFrameData.DataID == OUT_XOVER_ID) {
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].h_freq & 0xff);
                        FrameDataBuf[15] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].h_freq >> 8) & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].h_filter & 0xff);
                        FrameDataBuf[17] = (SendStructData.OUT_CH[SendFrameData.ChannelID].h_level & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].l_freq & 0xff);
                        FrameDataBuf[19] = ((SendStructData.OUT_CH[SendFrameData.ChannelID].l_freq >> 8) & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].l_filter & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].l_level & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i] ^ Encrypt_DATA);
                            }
                        }
                    }else if(SendFrameData.DataID == OUT_Valume_ID) {// id = 33        混合比例
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN1_Vol & 0xff);
                        FrameDataBuf[15] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN2_Vol & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN3_Vol & 0xff);
                        FrameDataBuf[17] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN4_Vol & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN5_Vol & 0xff);
                        FrameDataBuf[19] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN6_Vol & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN7_Vol & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN8_Vol & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }else if(SendFrameData.DataID == OUT_MIX_ID) {// id = 34        保留
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN9_Vol & 0xff);
                        FrameDataBuf[15] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN10_Vol & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN11_Vol & 0xff);
                        FrameDataBuf[17] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN12_Vol & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN13_Vol & 0xff);
                        FrameDataBuf[19] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN14_Vol & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN15_Vol & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN16_Vol & 0xff);
                        //FrameDataBuf[20] = (byte) (SendStructData.OUT_CH[SendStructData.ChannelID].IN_polar & 0xff);
                        //FrameDataBuf[21] = (byte)((SendStructData.OUT_CH[SendStructData.ChannelID].IN_polar >> 8) & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i]=(FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }else if(SendFrameData.DataID == OUT_LIMIT_ID) {// id = 35        压限
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN17_Vol & 0xff);
                        FrameDataBuf[15] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN18_Vol & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN19_Vol & 0xff);
                        FrameDataBuf[17] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN20_Vol & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN21_Vol & 0xff);
                        FrameDataBuf[19] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN22_Vol & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN23_Vol & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].IN24_Vol & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=0;i<8;i++){
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }else if(SendFrameData.DataID == OUT_NAME_ID) {// id = 36
                        FrameDataBuf[14] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[0] & 0xff);
                        FrameDataBuf[15] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[1] & 0xff);
                        FrameDataBuf[16] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[2] & 0xff);
                        FrameDataBuf[17] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[3] & 0xff);
                        FrameDataBuf[18] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[4] & 0xff);
                        FrameDataBuf[19] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[5] & 0xff);
                        FrameDataBuf[20] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[6] & 0xff);
                        FrameDataBuf[21] = (SendStructData.OUT_CH[SendFrameData.ChannelID].name[7] & 0xff);
                        if(BOOL_EncryptionFlag){//加密
                            for(int i=2;i<8;i++){//加密标志,联调标志不加密
                                FrameDataBuf[14+i] = (FrameDataBuf[14+i]^Encrypt_DATA);
                            }
                        }
                    }
                }
            }
            /*写其他组的数据，1个组的数据通道*/
            else if((SendFrameData.UserID >= 1)&&(SendFrameData.UserID <= MAX_USE_GROUP)&&
                    (SendFrameData.DataLen == OUT_LEN)){
                /*
                 if(BOOL_EncryptionFlag){//加密
                 for(int i=0;i<OUT_LEN;i++){
                 FrameDataBuf[14+i] = (SendFrameData.Buf[i]^Encrypt_DATA);
                 }
                 if(SendFrameData.ChannelID==0){
                 FrameDataBuf[14+OUT_LEN-8] = EncryptionFlag;
                 for(int i=0;i<6;i++){
                 FrameDataBuf[14+OUT_LEN-6+i] = (Encryption_PasswordBuf[i]^Encrypt_DATA);
                 }
                 }
                 }else if(!BOOL_EncryptionFlag){//非加密
                 for(int i=0;i<OUT_LEN;i++){
                 FrameDataBuf[14+i]=(SendFrameData.Buf[i] & 0xff);
                 }
                 FrameDataBuf[14+OUT_LEN-8]=DecipheringFlag;
                 }
                 */
                for(int i=0;i<OUT_LEN;i++){
                    FrameDataBuf[14+i]=(SendFrameData.Buf[i] & 0xff);
                }
            }
        } else if (SendFrameData.DataType == SYSTEM) {
            switch (SendFrameData.ChannelID) {
                case PC_SOURCE_SET:
                    FrameDataBuf[14] = (SendStructData.System.input_source & 0xff); // 输入源(之前系统中的输入源)
                    // 高
                    // 低
                    // AUX
                    // 蓝牙
                    // 光纤
                    FrameDataBuf[15] = (SendStructData.System.mixer_source & 0xff); // 低电平模式
                    // 有3种
                    // 0:4个AUX
                    // 1:..................
                    FrameDataBuf[16] = (SendStructData.System.InSwitch[0] & 0xff); // 本字节第二位0x02
                    // 代表有数字音源输入，字节第一位0x01代表有蓝牙输入，否则没有该模块，PC不能切换至此音源
                    FrameDataBuf[17] = (SendStructData.System.InSwitch[1] & 0xff);
                    FrameDataBuf[18] = (SendStructData.System.InSwitch[2] & 0xff);
                    FrameDataBuf[19] = (SendStructData.System.InSwitch[3] & 0xff);
                    FrameDataBuf[20] = (SendStructData.System.InSwitch[4] & 0xff);
                    FrameDataBuf[21] = (SendStructData.System.none1 & 0xff);
                    
                    
                    //System.out.println("##17:"+(int)FrameDataBuf[17]+",18:"+(int)FrameDataBuf[18]+",19:"+(int)FrameDataBuf[19]);
                    
                    break;
                    
                case SYSTEM_DATA:
                    FrameDataBuf[14] = (SendStructData.System.main_vol & 0xff); // 输出总音量(之前输入结构中的总音量)
                    // -60~0dB
                    // 低字节
                    FrameDataBuf[15] = ((SendStructData.System.main_vol >> 8) & 0xff); // 输出总音量(之前输入结构中的总音量)
                    // -60~0dB
                    // 高字节
                    FrameDataBuf[16] = (SendStructData.System.high_mode & 0xff);
                    FrameDataBuf[17] = (SendStructData.System.aux_mode & 0xff);
                    FrameDataBuf[18] = (SendStructData.System.out_mode & 0xff);
                    FrameDataBuf[19] = (SendStructData.System.mixer_SourcedB & 0xff);
                    FrameDataBuf[20] = (SendStructData.System.MainvolMuteFlg & 0xff);// 静音临时标志，这个标志关机不保存，注意特别处理
                    FrameDataBuf[21] = (SendStructData.System.theme & 0xff);
                    
                    break;
                case SYSTEM_SPK_TYPE:
//                    for (int i=0; i<8; i++) {
//                        FrameDataBuf[14+i]=(SendStructData.System.none[i]& 0xff);
//                    }
                    FrameDataBuf[14] = SendStructData.System.HiInputChNum;
                    FrameDataBuf[15] = SendStructData.System.AuxInputChNum;
                    FrameDataBuf[16] = SendStructData.System.OutputChNum;
                    FrameDataBuf[17] = SendStructData.System.IsRTA_outch;
                    FrameDataBuf[18] = SendStructData.System.InSignelThreshold;
                    FrameDataBuf[19] = SendStructData.System.OffTime;
                    FrameDataBuf[20] = SendStructData.System.none[0];
                    FrameDataBuf[21] = SendStructData.System.none[1];
                    for (int i=0; i<8; i++) {
                        FrameDataBuf[22+i]=(SendStructData.System.high_Low_Set[i]& 0xff);
                    }
                    for (int i=0; i<16; i++) {
                         FrameDataBuf[30+i]=(SendStructData.System.in_spk_type[i]& 0xff);
                    }
                    for (int i=0; i<46; i++) {
                         FrameDataBuf[36+i]=(SendStructData.System.out_spk_type[i]& 0xff);
                    }
                  
                    break;
                case SYSTEM_ALL:
//                    FrameDataBuf[14] =  (SendStructData.System.out9_spk_type & 0xff);
//                    FrameDataBuf[15] =  (SendStructData.System.out10_spk_type & 0xff);
//                    FrameDataBuf[16] =  (SendStructData.System.out11_spk_type & 0xff);
//                    FrameDataBuf[17] =  (SendStructData.System.out12_spk_type & 0xff);
//                    FrameDataBuf[18] =  (SendStructData.System.out13_spk_type & 0xff);
//                    FrameDataBuf[19] =  (SendStructData.System.out14_spk_type & 0xff);
//                    FrameDataBuf[20] =  (SendStructData.System.out15_spk_type & 0xff);
//                    FrameDataBuf[21] =  (SendStructData.System.out16_spk_type & 0xff);
                    
                    break;
                case SOUND_FIELD_INFO:
                    for(int i=0;i<50;i++){
                        FrameDataBuf[14+i] = SendStructData.SoundFieldSystem.SoundDelayField[i];
                    }
                    break;
                case GROUP_NAME:
                    for(int j=0;j<16;j++){
                        FrameDataBuf[14+j] = SendStructData.USER[SendFrameData.UserID].name[j];
                    }
                    break;
                case SYSTEM_TRANSMITTAL://数据传输标志
                    for(int i=0;i<8;i++){
                        FrameDataBuf[14+i] = SendStructData.TRANSMITTAL[i];
                    }
                    break;
                case SYSTEM_RESET_MCU://复位MUC
                    for(int i=0;i<8;i++){
                        FrameDataBuf[14+i]=SendStructData.RESET_MCU[i];
                    }
                    break;
                case SYSTEM_RESET_GROUP_DATA://复位MUC
                    for(int i=0;i<8;i++){
                        FrameDataBuf[14+i]=SendStructData.RESET_GROUP_DATA[i];
                    }
                    break;
                default:
                    break;
            }
        } else {
            ;
        }
    }
    for (int i = 0; i < SendFrameData.DataLen; i++) {
        FrameDataSUM ^= FrameDataBuf[i + 14];
    }
    FrameDataBuf[SendFrameData.DataLen + CMD_LENGHT - 2] = FrameDataSUM; // 校验和
    FrameDataBuf[SendFrameData.DataLen + CMD_LENGHT - 1] = FRAME_END; // 包尾
    
    NSMutableArray *tempbuffer = [NSMutableArray new];
    for (int i = 0; i < SendFrameData.DataLen + CMD_LENGHT; i++) {
        NSNumber *obj = [[NSNumber alloc] initWithInt:FrameDataBuf[i]];
        [tempbuffer addObject:obj];
    }
    
    if (sendorinsert == true) {
        //直接发送
        //创建动态buf发送
        [self BT_SendPack:tempbuffer withSize:(SendFrameData.DataLen + CMD_LENGHT) ];
        
    } else {
        [SendbufferList addObject:tempbuffer];
        
        SendStructData.System.aux_mode = RecStructData.System.aux_mode;
    }
}


- (void)ComparedToSendData:(BOOL)uptodevice {
    
    // 比较音源数据
    if (SendStructData.System.input_source != RecStructData.System.input_source
        || SendStructData.System.mixer_source != RecStructData.System.mixer_source
        || SendStructData.System.InSwitch[0] != RecStructData.System.InSwitch[0]
        || SendStructData.System.InSwitch[1] != RecStructData.System.InSwitch[1]
        || SendStructData.System.InSwitch[2] != RecStructData.System.InSwitch[2]
        || SendStructData.System.InSwitch[3] != RecStructData.System.InSwitch[3]
        || SendStructData.System.InSwitch[4] != RecStructData.System.InSwitch[4]
        || SendStructData.System.none1 != RecStructData.System.none1) {
        SendStructData.System.input_source = RecStructData.System.input_source;
        SendStructData.System.mixer_source = RecStructData.System.mixer_source;
        for (int i=0; i<5; i++) {
            SendStructData.System.InSwitch[i]=RecStructData.System.InSwitch[i];
        }
        SendStructData.System.none1 = RecStructData.System.none1;
        
        if (uptodevice == true) {
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = SYSTEM;
            SendFrameData.ChannelID = PC_SOURCE_SET;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;
            SendFrameData.DataLen = 8;
            
            U0SendFrameFlg = YES;
            [self SendDataToDevice:FALSE];
        }
        
    }
    
    // 比较系统配置数据
    if (SendStructData.System.main_vol != RecStructData.System.main_vol ||
        //680通过系统设置控制总音量，461通过Input.2.MUSIC.控制总音量
        SendStructData.System.high_mode != RecStructData.System.high_mode
        || SendStructData.System.aux_mode != RecStructData.System.aux_mode
        || SendStructData.System.out_mode != RecStructData.System.out_mode
        || SendStructData.System.mixer_SourcedB != RecStructData.System.mixer_SourcedB
        || SendStructData.System.MainvolMuteFlg != RecStructData.System.MainvolMuteFlg
        || SendStructData.System.theme != RecStructData.System.theme) {
        SendStructData.System.main_vol = RecStructData.System.main_vol;
        SendStructData.System.high_mode = RecStructData.System.high_mode;
        SendStructData.System.aux_mode = RecStructData.System.aux_mode;
        SendStructData.System.out_mode = RecStructData.System.out_mode;
        SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB;
        SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg;
        SendStructData.System.theme = RecStructData.System.theme;
        
        if (uptodevice == true) {
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = SYSTEM;
            SendFrameData.ChannelID = SYSTEM_DATA;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;
            SendFrameData.DataLen = 8;
            
            U0SendFrameFlg = YES;
            [self SendDataToDevice:FALSE];
        }
    }
    // 比较系统通道输出类型配置数据
    BOOL sendSystemId6=NO;
    
    if (SendStructData.System.HiInputChNum !=RecStructData.System.HiInputChNum||
        SendStructData.System.AuxInputChNum !=RecStructData.System.AuxInputChNum||
        SendStructData.System.OutputChNum != RecStructData.System.OutputChNum||
        SendStructData.System.IsRTA_outch !=RecStructData.System.IsRTA_outch||
        SendStructData.System.InSignelThreshold !=RecStructData.System.InSignelThreshold||
        SendStructData.System.OffTime != RecStructData.System.OffTime||
        SendStructData.System.none[0] != RecStructData.System.none[0]||
        SendStructData.System.none[1] != RecStructData.System.none[1]) {
           SendStructData.System.HiInputChNum =RecStructData.System.HiInputChNum;
           SendStructData.System.AuxInputChNum =RecStructData.System.AuxInputChNum;
           SendStructData.System.OutputChNum = RecStructData.System.OutputChNum;
           SendStructData.System.IsRTA_outch =RecStructData.System.IsRTA_outch;
           SendStructData.System.InSignelThreshold =RecStructData.System.InSignelThreshold;
           SendStructData.System.OffTime = RecStructData.System.OffTime;
           SendStructData.System.none[0] = RecStructData.System.none[0];
           SendStructData.System.none[1] = RecStructData.System.none[1];
            
            sendSystemId6=YES;
        }
    
    for (int i=0; i<8; i++) {
        if ((SendStructData.System.high_Low_Set[i])!=(RecStructData.System.high_Low_Set[i])) {
            SendStructData.System.high_Low_Set[i]=RecStructData.System.high_Low_Set[i];
            sendSystemId6=YES;
        }
    }
    for (int i=0; i<16; i++) {
        if ((SendStructData.System.in_spk_type[i])!=(RecStructData.System.in_spk_type[i])) {
            SendStructData.System.in_spk_type[i]=RecStructData.System.in_spk_type[i];
            sendSystemId6=YES;
        }
    }
    for (int i=0; i<16; i++) {
        if ((SendStructData.System.out_spk_type[i])!=(RecStructData.System.out_spk_type[i])) {
            SendStructData.System.out_spk_type[i]=RecStructData.System.out_spk_type[i];
            sendSystemId6=YES;
        }
    }
    if (sendSystemId6) {

        if (uptodevice == true) {
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = SYSTEM;
            SendFrameData.ChannelID = SYSTEM_SPK_TYPE;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;
            SendFrameData.DataLen = 48;
            
            U0SendFrameFlg = YES;
            [self SendDataToDevice:FALSE];
        }
    }
    // 比较系统通道输出类型配置数据
//    if (   SendStructData.System.out9_spk_type != RecStructData.System.out9_spk_type
//        || SendStructData.System.out10_spk_type != RecStructData.System.out10_spk_type
//        || SendStructData.System.out11_spk_type != RecStructData.System.out11_spk_type
//        || SendStructData.System.out12_spk_type != RecStructData.System.out12_spk_type
//        || SendStructData.System.out13_spk_type != RecStructData.System.out13_spk_type
//        || SendStructData.System.out14_spk_type != RecStructData.System.out14_spk_type
//        || SendStructData.System.out15_spk_type != RecStructData.System.out15_spk_type
//        || SendStructData.System.out16_spk_type != RecStructData.System.out16_spk_type) {
//
//        SendStructData.System.out9_spk_type = RecStructData.System.out9_spk_type;
//        SendStructData.System.out10_spk_type = RecStructData.System.out10_spk_type;
//        SendStructData.System.out11_spk_type = RecStructData.System.out11_spk_type;
//        SendStructData.System.out12_spk_type = RecStructData.System.out12_spk_type;
//        SendStructData.System.out13_spk_type = RecStructData.System.out13_spk_type;
//        SendStructData.System.out14_spk_type = RecStructData.System.out14_spk_type;
//        SendStructData.System.out15_spk_type = RecStructData.System.out15_spk_type;
//        SendStructData.System.out16_spk_type = RecStructData.System.out16_spk_type;
//
//        if (uptodevice == true) {
//            SendFrameData.FrameType = WRITE_CMD;
//            SendFrameData.DeviceID = 0x01;
//            SendFrameData.UserID = 0x00;
//            SendFrameData.DataType = SYSTEM;
//            SendFrameData.ChannelID = SYSTEM_SPK_TYPEB;
//            SendFrameData.DataID = 0x00;
//            SendFrameData.PCFadeInFadeOutFlg = 0x00;
//            SendFrameData.PcCustom = 0x00;
//            SendFrameData.DataLen = 8;
//
//            U0SendFrameFlg = YES;
//            [self SendDataToDevice:FALSE];
//        }
//    }
    /**************************   input page   *******************************/
    if(BOOL_USE_INS){
    for(int i=0;i<INS_CH_MAX;i++){
        //---id = 0        杂项
        if (SendStructData.INS_CH[i].feedback != RecStructData.INS_CH[i].feedback
            || SendStructData.INS_CH[i].polar    != RecStructData.INS_CH[i].polar
            || SendStructData.INS_CH[i].eq_mode  != RecStructData.INS_CH[i].eq_mode
            || SendStructData.INS_CH[i].mute     != RecStructData.INS_CH[i].mute
            || SendStructData.INS_CH[i].delay    != RecStructData.INS_CH[i].delay
            || SendStructData.INS_CH[i].Valume   != RecStructData.INS_CH[i].Valume) {
            
            SendStructData.INS_CH[i].feedback  = RecStructData.INS_CH[i].feedback;
            SendStructData.INS_CH[i].polar     = RecStructData.INS_CH[i].polar;
            SendStructData.INS_CH[i].eq_mode   = RecStructData.INS_CH[i].eq_mode;
            SendStructData.INS_CH[i].mute      = RecStructData.INS_CH[i].mute;
            SendStructData.INS_CH[i].delay     = RecStructData.INS_CH[i].delay;
            SendStructData.INS_CH[i].Valume    = RecStructData.INS_CH[i].Valume;
            
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = INS_MISC_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;//
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        
        if((SendStructData.INS_CH[i].h_freq  != RecStructData.INS_CH[i].h_freq)  ||
           (SendStructData.INS_CH[i].h_filter!= RecStructData.INS_CH[i].h_filter)||
           (SendStructData.INS_CH[i].h_level != RecStructData.INS_CH[i].h_level) ||
           (SendStructData.INS_CH[i].l_freq  != RecStructData.INS_CH[i].l_freq)  ||
           (SendStructData.INS_CH[i].l_filter!= RecStructData.INS_CH[i].l_filter)||
           (SendStructData.INS_CH[i].l_level != RecStructData.INS_CH[i].l_level)){
            
            SendStructData.INS_CH[i].h_freq   = RecStructData.INS_CH[i].h_freq;
            SendStructData.INS_CH[i].h_filter = RecStructData.INS_CH[i].h_filter;
            SendStructData.INS_CH[i].h_level  = RecStructData.INS_CH[i].h_level;
            SendStructData.INS_CH[i].l_freq   = RecStructData.INS_CH[i].l_freq;
            SendStructData.INS_CH[i].l_filter = RecStructData.INS_CH[i].l_filter;
            SendStructData.INS_CH[i].l_level  = RecStructData.INS_CH[i].l_level;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = INS_XOVER_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        
        for(int j=0;j<=INS_CH_EQ_MAX_USE;j++){
            if((SendStructData.INS_CH[i].EQ[j].freq != RecStructData.INS_CH[i].EQ[j].freq) ||
               (SendStructData.INS_CH[i].EQ[j].level   != RecStructData.INS_CH[i].EQ[j].level) ||
               (SendStructData.INS_CH[i].EQ[j].bw      != RecStructData.INS_CH[i].EQ[j].bw) ||
               (SendStructData.INS_CH[i].EQ[j].shf_db  != RecStructData.INS_CH[i].EQ[j].shf_db) ||
               (SendStructData.INS_CH[i].EQ[j].type    != RecStructData.INS_CH[i].EQ[j].type)){
                
                SendStructData.INS_CH[i].EQ[j].freq  = RecStructData.INS_CH[i].EQ[j].freq;
                SendStructData.INS_CH[i].EQ[j].level = RecStructData.INS_CH[i].EQ[j].level;
                SendStructData.INS_CH[i].EQ[j].bw    = RecStructData.INS_CH[i].EQ[j].bw;
                SendStructData.INS_CH[i].EQ[j].shf_db= RecStructData.INS_CH[i].EQ[j].shf_db;
                SendStructData.INS_CH[i].EQ[j].type  = RecStructData.INS_CH[i].EQ[j].type;
                if (uptodevice == true) {
                    SendFrameData.FrameType = WRITE_CMD;
                    SendFrameData.DeviceID = 0x01;
                    SendFrameData.UserID = 0x00;
                    SendFrameData.DataType = MUSIC;
                    SendFrameData.ChannelID = i;
                    SendFrameData.DataID = (j+INS_ID_MAX+1);
                    SendFrameData.PCFadeInFadeOutFlg = 0x00;
                    SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                    SendFrameData.DataLen = 8;
                    
                    U0SendFrameFlg = YES;
                    [self SendDataToDevice:FALSE];
                }
            }
        }
    }
    }
    /* 比较MUSIC InputData数据  主要是总音量,静音,这里只有1通道 */
    for(int i=0;i<Input_CH_MAX;i++){
        //---id = 10        杂项
        if (SendStructData.IN_CH[i].mute    != RecStructData.IN_CH[i].mute
            || SendStructData.IN_CH[i].polar    != RecStructData.IN_CH[i].polar
            || SendStructData.IN_CH[i].gain  != RecStructData.IN_CH[i].gain
            || SendStructData.IN_CH[i].delay     != RecStructData.IN_CH[i].delay
            || SendStructData.IN_CH[i].eq_mode    != RecStructData.IN_CH[i].eq_mode
            || SendStructData.IN_CH[i].LinkFlag    != RecStructData.IN_CH[i].LinkFlag) {
            
            SendStructData.IN_CH[i].mute  = RecStructData.IN_CH[i].mute;
            SendStructData.IN_CH[i].polar     = RecStructData.IN_CH[i].polar;
            SendStructData.IN_CH[i].gain   = RecStructData.IN_CH[i].gain;
            SendStructData.IN_CH[i].delay      = RecStructData.IN_CH[i].delay;
            SendStructData.IN_CH[i].eq_mode     = RecStructData.IN_CH[i].eq_mode;
            SendStructData.IN_CH[i].LinkFlag    = RecStructData.IN_CH[i].LinkFlag;
            
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = i;//MUSIC 固定2
                SendFrameData.DataID = IN_MISC_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;//
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                /*if(DEBUG) System.out.println("##feedback:"+SendStructData.IN_CH[0].feedback);
                 if(DEBUG) System.out.println("##polar:"+SendStructData.IN_CH[0].polar);
                 if(DEBUG) System.out.println("##mode:"+SendStructData.IN_CH[0].mode);
                 if(DEBUG) System.out.println("##mute:"+SendStructData.IN_CH[0].mute);
                 if(DEBUG) System.out.println("##delay:"+SendStructData.IN_CH[0].delay);
                 if(DEBUG) System.out.println("##Valume:"+SendStructData.IN_CH[0].Valume);*/
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        if(SendStructData.IN_CH[i].h_freq    != RecStructData.IN_CH[i].h_freq
           || SendStructData.IN_CH[i].h_filter    != RecStructData.IN_CH[i].h_filter
           || SendStructData.IN_CH[i].h_level  != RecStructData.IN_CH[i].h_level
           || SendStructData.IN_CH[i].l_freq     != RecStructData.IN_CH[i].l_freq
           || SendStructData.IN_CH[i].l_filter    != RecStructData.IN_CH[i].l_filter
           || SendStructData.IN_CH[i].l_level    != RecStructData.IN_CH[i].l_level){
            SendStructData.IN_CH[i].h_freq    = RecStructData.IN_CH[i].h_freq;
            SendStructData.IN_CH[i].h_filter  = RecStructData.IN_CH[i].h_filter;
            SendStructData.IN_CH[i].h_level   = RecStructData.IN_CH[i].h_level;
            SendStructData.IN_CH[i].l_freq    = RecStructData.IN_CH[i].l_freq;
            SendStructData.IN_CH[i].l_filter  = RecStructData.IN_CH[i].l_filter;
            SendStructData.IN_CH[i].l_level   = RecStructData.IN_CH[i].l_level;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = i;//MUSIC 固定2
                SendFrameData.DataID = IN_XOVER_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        //噪声门 ,ID = 12
        if (SendStructData.IN_CH[i].noisegate_t != RecStructData.IN_CH[i].noisegate_t
            || SendStructData.IN_CH[i].noisegate_a != RecStructData.IN_CH[i].noisegate_a
            || SendStructData.IN_CH[i].noisegate_k != RecStructData.IN_CH[i].noisegate_k
            || SendStructData.IN_CH[i].noisegate_r != RecStructData.IN_CH[i].noisegate_r
            || SendStructData.IN_CH[i].noise_config!= RecStructData.IN_CH[i].noise_config) {
            
            SendStructData.IN_CH[i].noisegate_t = RecStructData.IN_CH[i].noisegate_t;
            SendStructData.IN_CH[i].noisegate_a = RecStructData.IN_CH[i].noisegate_a;
            SendStructData.IN_CH[i].noisegate_k = RecStructData.IN_CH[i].noisegate_k;
            SendStructData.IN_CH[i].noisegate_r = RecStructData.IN_CH[i].noisegate_r;
            SendStructData.IN_CH[i].noise_config= RecStructData.IN_CH[i].noise_config;
            
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = i;//MUSIC 固定2
                SendFrameData.DataID = IN_NOISEGATE_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        for(int j=0;j<IN_CH_EQ_MAX_USE;j++){
            if((SendStructData.IN_CH[i].EQ[j].freq != RecStructData.IN_CH[i].EQ[j].freq) ||
               (SendStructData.IN_CH[i].EQ[j].level   != RecStructData.IN_CH[i].EQ[j].level) ||
               (SendStructData.IN_CH[i].EQ[j].bw      != RecStructData.IN_CH[i].EQ[j].bw) ||
               (SendStructData.IN_CH[i].EQ[j].shf_db  != RecStructData.IN_CH[i].EQ[j].shf_db) ||
               (SendStructData.IN_CH[i].EQ[j].type    != RecStructData.IN_CH[i].EQ[j].type)){

                SendStructData.IN_CH[i].EQ[j].freq  = RecStructData.IN_CH[i].EQ[j].freq;
                SendStructData.IN_CH[i].EQ[j].level = RecStructData.IN_CH[i].EQ[j].level;
                SendStructData.IN_CH[i].EQ[j].bw    = RecStructData.IN_CH[i].EQ[j].bw;
                SendStructData.IN_CH[i].EQ[j].shf_db= RecStructData.IN_CH[i].EQ[j].shf_db;
                SendStructData.IN_CH[i].EQ[j].type  = RecStructData.IN_CH[i].EQ[j].type;
                if (uptodevice == true) {
                    SendFrameData.FrameType = WRITE_CMD;
                    SendFrameData.DeviceID = 0x01;
                    SendFrameData.UserID = 0x00;
                    SendFrameData.DataType = MUSIC;
                    SendFrameData.ChannelID = i;
                    SendFrameData.DataID = j;
                    SendFrameData.PCFadeInFadeOutFlg = 0x00;
                    SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                    SendFrameData.DataLen = 8;

                    U0SendFrameFlg = YES;
                    [self SendDataToDevice:FALSE];
                }
            }
        }
    }
    
    
    /**************************   比较输出延时     通过System通道   *******************************/
    
    if(DELAY_DATA_TRANSFER==1){
        if((SendStructData.SoundFieldSystem.SoundDelayField[0] !=  (RecStructData.OUT_CH[0].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[1] != ((RecStructData.OUT_CH[0].delay >> 8) & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[2] !=  (RecStructData.OUT_CH[1].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[3] != ((RecStructData.OUT_CH[1].delay >> 8) & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[4] !=  (RecStructData.OUT_CH[2].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[5] != ((RecStructData.OUT_CH[2].delay >> 8) & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[6] !=  (RecStructData.OUT_CH[3].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[7] != ((RecStructData.OUT_CH[3].delay >> 8) & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[8] !=  (RecStructData.OUT_CH[4].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[9] != ((RecStructData.OUT_CH[4].delay >> 8) & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[10]!=  (RecStructData.OUT_CH[5].delay & 0xff))||
           (SendStructData.SoundFieldSystem.SoundDelayField[11]!= ((RecStructData.OUT_CH[5].delay >> 8) & 0xff))){
            
            
            
            SendDelayDatabySystemChannel();
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = SYSTEM;
                SendFrameData.ChannelID = SOUND_FIELD_INFO;
                SendFrameData.DataID = 0x00;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;//
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 50;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
    }
    
    
    /**************************   比较XOver和Output的杂项 *******************************/
    //EQ
    for(int i=0;i<Output_CH_MAX;i++){
        for(int j=0;j<OUT_CH_EQ_MAX;j++){
            if((SendStructData.OUT_CH[i].EQ[j].freq != RecStructData.OUT_CH[i].EQ[j].freq) ||
               (SendStructData.OUT_CH[i].EQ[j].level != RecStructData.OUT_CH[i].EQ[j].level) ||
               (SendStructData.OUT_CH[i].EQ[j].bw != RecStructData.OUT_CH[i].EQ[j].bw) ||
               (SendStructData.OUT_CH[i].EQ[j].shf_db != RecStructData.OUT_CH[i].EQ[j].shf_db) ||
               (SendStructData.OUT_CH[i].EQ[j].type != RecStructData.OUT_CH[i].EQ[j].type)){
                
                SendStructData.OUT_CH[i].EQ[j].freq = RecStructData.OUT_CH[i].EQ[j].freq;
                SendStructData.OUT_CH[i].EQ[j].level = RecStructData.OUT_CH[i].EQ[j].level;
                SendStructData.OUT_CH[i].EQ[j].bw = RecStructData.OUT_CH[i].EQ[j].bw;
                SendStructData.OUT_CH[i].EQ[j].shf_db = RecStructData.OUT_CH[i].EQ[j].shf_db;
                SendStructData.OUT_CH[i].EQ[j].type = RecStructData.OUT_CH[i].EQ[j].type;
                if (uptodevice == true) {
                    SendFrameData.FrameType = WRITE_CMD;
                    SendFrameData.DeviceID = 0x01;
                    SendFrameData.UserID = 0x00;
                    SendFrameData.DataType = OUTPUT;
                    SendFrameData.ChannelID = (Byte)i;
                    SendFrameData.DataID = (Byte)j;
                    SendFrameData.PCFadeInFadeOutFlg = 0x00;
                    SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                    SendFrameData.DataLen = 8;
                    
                    U0SendFrameFlg = YES;
                    [self SendDataToDevice:FALSE];
                }
            }
        }
    }
    
    for(int i=0;i<Output_CH_MAX;i++){
        //id = 31        杂项
        if((SendStructData.OUT_CH[i].mute != RecStructData.OUT_CH[i].mute) ||
           (SendStructData.OUT_CH[i].polar!= RecStructData.OUT_CH[i].polar)||
           (SendStructData.OUT_CH[i].gain != RecStructData.OUT_CH[i].gain) ||
           (SendStructData.OUT_CH[i].delay!= RecStructData.OUT_CH[i].delay)||
           (SendStructData.OUT_CH[i].eq_mode!= RecStructData.OUT_CH[i].eq_mode)||
           (SendStructData.OUT_CH[i].LinkFlag != RecStructData.OUT_CH[i].LinkFlag)){
            
            SendStructData.OUT_CH[i].mute  = RecStructData.OUT_CH[i].mute;
            SendStructData.OUT_CH[i].polar = RecStructData.OUT_CH[i].polar;
            SendStructData.OUT_CH[i].gain  = RecStructData.OUT_CH[i].gain;
            SendStructData.OUT_CH[i].delay = RecStructData.OUT_CH[i].delay;
            SendStructData.OUT_CH[i].eq_mode = RecStructData.OUT_CH[i].eq_mode;
            SendStructData.OUT_CH[i].LinkFlag  = RecStructData.OUT_CH[i].LinkFlag;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = (Byte)i;
                SendFrameData.DataID = OUT_MISC_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
        //高低通 ,ID = 32    (xover限MIC)
        if((SendStructData.OUT_CH[i].h_freq  != RecStructData.OUT_CH[i].h_freq)  ||
           (SendStructData.OUT_CH[i].h_filter!= RecStructData.OUT_CH[i].h_filter)||
           (SendStructData.OUT_CH[i].h_level != RecStructData.OUT_CH[i].h_level) ||
           (SendStructData.OUT_CH[i].l_freq  != RecStructData.OUT_CH[i].l_freq)  ||
           (SendStructData.OUT_CH[i].l_filter!= RecStructData.OUT_CH[i].l_filter)||
           (SendStructData.OUT_CH[i].l_level != RecStructData.OUT_CH[i].l_level)){
            
            SendStructData.OUT_CH[i].h_freq   = RecStructData.OUT_CH[i].h_freq;
            SendStructData.OUT_CH[i].h_filter = RecStructData.OUT_CH[i].h_filter;
            SendStructData.OUT_CH[i].h_level  = RecStructData.OUT_CH[i].h_level;
            SendStructData.OUT_CH[i].l_freq   = RecStructData.OUT_CH[i].l_freq;
            SendStructData.OUT_CH[i].l_filter = RecStructData.OUT_CH[i].l_filter;
            SendStructData.OUT_CH[i].l_level  = RecStructData.OUT_CH[i].l_level;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = (Byte)i;
                SendFrameData.DataID = OUT_XOVER_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:FALSE];
            }
        }
    }
    
    //id = 33        混合比例
    for(int i=0;i<Output_CH_MAX;i++){
        if((SendStructData.OUT_CH[i].IN1_Vol != RecStructData.OUT_CH[i].IN1_Vol) ||
           (SendStructData.OUT_CH[i].IN2_Vol != RecStructData.OUT_CH[i].IN2_Vol)||
           (SendStructData.OUT_CH[i].IN3_Vol != RecStructData.OUT_CH[i].IN3_Vol) ||
           (SendStructData.OUT_CH[i].IN4_Vol != RecStructData.OUT_CH[i].IN4_Vol)||
           (SendStructData.OUT_CH[i].IN5_Vol != RecStructData.OUT_CH[i].IN5_Vol)||
           (SendStructData.OUT_CH[i].IN6_Vol != RecStructData.OUT_CH[i].IN6_Vol)||
           (SendStructData.OUT_CH[i].IN7_Vol != RecStructData.OUT_CH[i].IN7_Vol)||
           (SendStructData.OUT_CH[i].IN8_Vol != RecStructData.OUT_CH[i].IN8_Vol)
           
           ){
            
            SendStructData.OUT_CH[i].IN1_Vol  = RecStructData.OUT_CH[i].IN1_Vol;
            SendStructData.OUT_CH[i].IN2_Vol  = RecStructData.OUT_CH[i].IN2_Vol;
            SendStructData.OUT_CH[i].IN3_Vol  = RecStructData.OUT_CH[i].IN3_Vol;
            SendStructData.OUT_CH[i].IN4_Vol  = RecStructData.OUT_CH[i].IN4_Vol;
            SendStructData.OUT_CH[i].IN5_Vol  = RecStructData.OUT_CH[i].IN5_Vol;
            SendStructData.OUT_CH[i].IN6_Vol  = RecStructData.OUT_CH[i].IN6_Vol;
            SendStructData.OUT_CH[i].IN7_Vol  = RecStructData.OUT_CH[i].IN7_Vol;
            SendStructData.OUT_CH[i].IN8_Vol  = RecStructData.OUT_CH[i].IN8_Vol;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = OUT_Valume_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:false];
            }
        }
    }
    //id = 34        混合比例
    for(int i=0;i<Output_CH_MAX;i++){
        if((SendStructData.OUT_CH[i].IN9_Vol != RecStructData.OUT_CH[i].IN9_Vol)||
           (SendStructData.OUT_CH[i].IN10_Vol != RecStructData.OUT_CH[i].IN10_Vol)||
           (SendStructData.OUT_CH[i].IN11_Vol != RecStructData.OUT_CH[i].IN11_Vol)||
           (SendStructData.OUT_CH[i].IN12_Vol != RecStructData.OUT_CH[i].IN12_Vol)||
           (SendStructData.OUT_CH[i].IN13_Vol != RecStructData.OUT_CH[i].IN13_Vol)||
           (SendStructData.OUT_CH[i].IN14_Vol != RecStructData.OUT_CH[i].IN14_Vol)||
           (SendStructData.OUT_CH[i].IN15_Vol != RecStructData.OUT_CH[i].IN15_Vol)||
           (SendStructData.OUT_CH[i].IN16_Vol != RecStructData.OUT_CH[i].IN16_Vol)
           //(SendStructData.OUT_CH[i].IN_polar != RecStructData.OUT_CH[i].IN_polar)
           
           ){
            
            SendStructData.OUT_CH[i].IN9_Vol  = RecStructData.OUT_CH[i].IN9_Vol;
            SendStructData.OUT_CH[i].IN10_Vol  = RecStructData.OUT_CH[i].IN10_Vol;
            SendStructData.OUT_CH[i].IN11_Vol  = RecStructData.OUT_CH[i].IN11_Vol;
            SendStructData.OUT_CH[i].IN12_Vol  = RecStructData.OUT_CH[i].IN12_Vol;
            SendStructData.OUT_CH[i].IN13_Vol  = RecStructData.OUT_CH[i].IN13_Vol;
            SendStructData.OUT_CH[i].IN14_Vol  = RecStructData.OUT_CH[i].IN14_Vol;
            SendStructData.OUT_CH[i].IN15_Vol  = RecStructData.OUT_CH[i].IN15_Vol;
            SendStructData.OUT_CH[i].IN16_Vol  = RecStructData.OUT_CH[i].IN16_Vol;
            //SendStructData.OUT_CH[i].IN_polar  = RecStructData.OUT_CH[i].IN_polar;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = OUT_MIX_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:false];
            }
        }
    }
    
    //id = id = 35        压限
    for(int i=0;i<Output_CH_MAX;i++){
        if((SendStructData.OUT_CH[i].IN17_Vol != RecStructData.OUT_CH[i].IN17_Vol)||
           (SendStructData.OUT_CH[i].IN18_Vol != RecStructData.OUT_CH[i].IN18_Vol)||
           (SendStructData.OUT_CH[i].IN19_Vol != RecStructData.OUT_CH[i].IN19_Vol)||
           (SendStructData.OUT_CH[i].IN20_Vol != RecStructData.OUT_CH[i].IN20_Vol)||
           (SendStructData.OUT_CH[i].IN21_Vol != RecStructData.OUT_CH[i].IN21_Vol)||
           (SendStructData.OUT_CH[i].IN22_Vol != RecStructData.OUT_CH[i].IN22_Vol)||
           (SendStructData.OUT_CH[i].IN23_Vol != RecStructData.OUT_CH[i].IN23_Vol)||
           (SendStructData.OUT_CH[i].IN24_Vol != RecStructData.OUT_CH[i].IN24_Vol)
           
           ){
            
            SendStructData.OUT_CH[i].IN17_Vol  = RecStructData.OUT_CH[i].IN17_Vol;
            SendStructData.OUT_CH[i].IN18_Vol  = RecStructData.OUT_CH[i].IN18_Vol;
            SendStructData.OUT_CH[i].IN19_Vol  = RecStructData.OUT_CH[i].IN19_Vol;
            SendStructData.OUT_CH[i].IN20_Vol  = RecStructData.OUT_CH[i].IN20_Vol;
            SendStructData.OUT_CH[i].IN21_Vol  = RecStructData.OUT_CH[i].IN21_Vol;
            SendStructData.OUT_CH[i].IN22_Vol  = RecStructData.OUT_CH[i].IN22_Vol;
            SendStructData.OUT_CH[i].IN23_Vol  = RecStructData.OUT_CH[i].IN23_Vol;
            SendStructData.OUT_CH[i].IN24_Vol  = RecStructData.OUT_CH[i].IN24_Vol;
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = OUT_LIMIT_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:false];
            }
        }
    }
    //id = id = 36
    for(int i=0;i<Output_CH_MAX;i++){
        if((SendStructData.OUT_CH[i].name[0] != RecStructData.OUT_CH[i].name[0])||
           (SendStructData.OUT_CH[i].name[1] != RecStructData.OUT_CH[i].name[1])||
           (SendStructData.OUT_CH[i].name[2] != RecStructData.OUT_CH[i].name[2])||
           (SendStructData.OUT_CH[i].name[3] != RecStructData.OUT_CH[i].name[3])||
           (SendStructData.OUT_CH[i].name[4] != RecStructData.OUT_CH[i].name[4])||
           (SendStructData.OUT_CH[i].name[5] != RecStructData.OUT_CH[i].name[5])||
           (SendStructData.OUT_CH[i].name[6] != RecStructData.OUT_CH[i].name[6])||
           (SendStructData.OUT_CH[i].name[7] != RecStructData.OUT_CH[i].name[7])
           
           ){
            
            SendStructData.OUT_CH[i].name[0]  = RecStructData.OUT_CH[i].name[0];
            SendStructData.OUT_CH[i].name[1]  = RecStructData.OUT_CH[i].name[1];
            SendStructData.OUT_CH[i].name[2]  = RecStructData.OUT_CH[i].name[2];
            SendStructData.OUT_CH[i].name[3]  = RecStructData.OUT_CH[i].name[3];
            SendStructData.OUT_CH[i].name[4]  = RecStructData.OUT_CH[i].name[4];
            SendStructData.OUT_CH[i].name[5]  = RecStructData.OUT_CH[i].name[5];
            SendStructData.OUT_CH[i].name[6]  = RecStructData.OUT_CH[i].name[6];
            SendStructData.OUT_CH[i].name[7]  = RecStructData.OUT_CH[i].name[7];
            if (uptodevice == true) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = 0x00;
                SendFrameData.DataType = OUTPUT;
                SendFrameData.ChannelID = i;
                SendFrameData.DataID = OUT_NAME_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 8;
                
                U0SendFrameFlg = YES;
                [self SendDataToDevice:false];
            }
        }
    }
}

#pragma mark --------------发送数据
- (BOOL)InitLoad {
    
    DeviceVerErrorFlg = false;
    U0SynDataSucessFlg = false;
    
    SendFrameData.FrameType = READ_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SOFTWARE_VERSION;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 0x00;
    
    [SendbufferList removeAllObjects];
    
    [self SendDataToDevice:FALSE];
    
    SendFrameData.ChannelID = CUR_PROGRAM_INFO; // 当前用户组ID
    [self SendDataToDevice:FALSE];
    
    
    
    /*获取用户名字*/
    
    for (int i = 1; i <= MAX_USE_GROUP; i++) {
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = i;
        SendFrameData.DataType = SYSTEM;
        SendFrameData.ChannelID = GROUP_NAME;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;
        SendFrameData.DataLen = 0x00;
        [self SendDataToDevice:FALSE];
    }
    if(BOOL_USE_INS){
        /*增加读取Input数据，获取音量 0x77*/
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = 0x00;
        SendFrameData.DataType = MUSIC;
        SendFrameData.ChannelID = 0x0;
        SendFrameData.DataID = 0;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = 0x00;
        [self SendDataToDevice:FALSE];
    }else{
        for(int i=0;i<Input_CH_MAX;i++){
            SendFrameData.FrameType = READ_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = MUSIC;
            SendFrameData.ChannelID = i;
            SendFrameData.DataID = 0x77;//读当前组的数据
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = 8;//IN_LEN;
            [self SendDataToDevice:FALSE];
        }

    }

   
    
    //读取通道输出类型配置
//    SendFrameData.FrameType = READ_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_SPK_TYPE;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 0x00;
//    [self SendDataToDevice:FALSE];
    SendFrameData.FrameType = READ_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_ALL;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 0x00;
    [self SendDataToDevice:FALSE];
    
    
    for (int i = 0; i < Output_CH_MAX; i++) {
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = 0x00;
        SendFrameData.DataType = OUTPUT;
        SendFrameData.ChannelID = i;
        SendFrameData.DataID = 0x77;//读当前组的数据
        SendFrameData.PCFadeInFadeOutFlg = 0x00;//
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = 8;//IN_LEN;
        [self SendDataToDevice:FALSE];
    }
    
    
    
    
    
    return true; // 插入数据完成
}

-(void)sendGetSystemDataCMD{
    /*读取音量*/
    //    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_SYSTEM){
    SendFrameData.FrameType = READ_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 0x00;
    [self SendDataToDevice:FALSE];
    //    }
}
//蓝牙发大包发送数据，分每20字节一个小包
- (void)BT_SendPack:(NSMutableArray *)dataArray withSize:(unsigned long)packsize {
    
    //U0RcvFrameFlg=true;
    uint16 temp1=0,temp2=0;
    if([dataArray count]==0){
        return;
    }
    for (int i=0; i<packsize; i++) {
        SendDataBuf[i] = [[dataArray objectAtIndex:i] unsignedCharValue];
    }
    
    Byte BTSendBuf20[20];
    //if([BLEManager shareBLEManager].baby.centralManager.state == CBCentralManagerStatePoweredOn){
    if(COM_BLE_DEVICECONNECTED){
        temp1 = packsize/BT_SEND_DATA_PACK_SIZE;
        //NSLog(@"BT_SendPack 20.size=%d",temp1);
        if(temp1 > 0){
            for (int i=0;i<temp1;i++){
                for(int j=0;j<BT_SEND_DATA_PACK_SIZE;j++){
                    BTSendBuf20[j] = SendDataBuf[i*BT_SEND_DATA_PACK_SIZE + j];
                }
                
                if ([self.delegate respondsToSelector:@selector(sendData:withSendMode:)]) {
                    [self.delegate sendData:BTSendBuf20 withSendMode:COM_WITH_BLE];
                }
            }
        }
        
        temp2 = packsize % BT_SEND_DATA_PACK_SIZE;
        for(int i=0;i<20;i++){//清0
            BTSendBuf20[i] = 0x00;
        }
        
        if(temp2 > 0){
            for (int i=0;i<temp2;i++){
                BTSendBuf20[i] = SendDataBuf[temp1*BT_SEND_DATA_PACK_SIZE + i];
            }
            
            if ([self.delegate respondsToSelector:@selector(sendData:withSendMode:)]) {
                [self.delegate sendData:BTSendBuf20 withSendMode:COM_WITH_BLE];
            }
        }
    }
}


- (int) GetSendbufferListCount{
    return (int)SendbufferList.count;
}

//代理
/*
 - (void)SetDataCommunicationStates:(int)Event WithState:(BOOL)State WithData:(int)Data WithMsg:(NSString*)Msg{
 if ([self.delegate respondsToSelector:@selector(DataCommunicationStatus:WithState:WithData:WithMsg:)]) {
 [self.delegate DataCommunicationStatus:Event WithState:State WithData:Data WithMsg:Msg];
 }
 }
 */





/* 把要发送的数据转化为帧数据
 * @param DataStruchID:要初始化的数据ID
 * @param ChannelID:要初始化的数据通道ID
 * @param initData：赋值的数据
 * @param dataSize：赋值的数据的大小
 */
-(void) FillSedDataStructCH:(int) DataStruchID DataWithCh:(int) ChannelID {
    int ChCnt=0;
    /*初始化数据结构的ID*/
    if(DataStruchID == EFF){
        
    }else if(DataStruchID == MUSIC){
        if(BOOL_USE_INS){
            for(int ch=0;ch<INS_CH_MAX;ch++){
                //---id = 9        杂项
                SendFrameData.Buf[ChCnt]  = (RecStructData.INS_CH[ch].feedback & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].polar & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].eq_mode & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].mute & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].delay & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].delay >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].Valume & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].Valume >> 8) & 0xff);
                //高低通 ,ID = 10
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].h_freq & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].h_freq >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].h_filter & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].h_level & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].l_freq & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].l_freq >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].l_filter & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].l_level & 0xff);
                //EQ
                for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
                    SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].freq & 0xff);
                    SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].freq >> 8) & 0xff);
                    SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].level & 0xff);
                    SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].level >> 8) & 0xff);
                    SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].bw & 0xff);
                    SendFrameData.Buf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].bw >> 8) & 0xff);
                    SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].shf_db & 0xff);
                    SendFrameData.Buf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].type& 0xff);
                }
                ++ChCnt;
            }
            
            ++ChCnt;
        }else{
            //EQ
            for(int i = 0; i < IN_CH_EQ_MAX;i++){
                SendFrameData.Buf[ChCnt]  = (RecStructData.IN_CH[ChannelID].EQ[i].freq & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].freq >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].level & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].level >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].bw & 0xff);
                SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].bw >> 8) & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].shf_db & 0xff);
                SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].type& 0xff);
                ++ChCnt;
            }
            //---id = 10        杂项
            SendFrameData.Buf[ChCnt]  = (RecStructData.IN_CH[ChannelID].mute & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].polar & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].gain & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].gain >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].delay & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].delay >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].eq_mode & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].LinkFlag & 0xff);
            //高低通 ,ID = 11
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_freq & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].h_freq >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_filter & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_level & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_freq & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].l_freq >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_filter & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_level & 0xff);
            //噪声门 ,ID = 12
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_t & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_a & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_k & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noisegate_k >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_r & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noisegate_r >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noise_config & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noise_config >> 8) & 0xff);
            //压限 ,ID = 12
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN17_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]=((RecStructData.IN_CH[ChannelID].IN17_Vol >> 8) & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN18_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN19_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN20_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN21_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].IN22_Vol & 0xff);
//            SendFrameData.Buf[++ChCnt]= (RecStructData.IN_CH[ChannelID].comp_swi & 0xff);
            //name[8] ID = 13
            for(int i=0;i<8;i++){
                SendFrameData.Buf[++ChCnt]=RecStructData.IN_CH[ChannelID].name[i];
            }
        }
        
    }else if(DataStruchID == OUTPUT){
        for(int i = 0; i < OUT_CH_EQ_MAX; i++){
            SendFrameData.Buf[ChCnt]  = (RecStructData.OUT_CH[ChannelID].EQ[i].freq & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].freq >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].level & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].level >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].bw & 0xff);
            SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].bw >> 8) & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].shf_db & 0xff);
            SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].type& 0xff);
            ++ChCnt;
        }
        //id = 31        杂项
        SendFrameData.Buf[ChCnt]  = (RecStructData.OUT_CH[ChannelID].mute & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].polar & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].gain & 0xff);
        SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].gain >> 8) & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].delay & 0xff);
        SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].delay >> 8) & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].eq_mode & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].LinkFlag & 0xff);
        //高低通 ,ID = 32    (xover限MIC)
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_freq & 0xff);
        SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].h_freq >> 8) & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_filter & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_level & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_freq & 0xff);
        SendFrameData.Buf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].l_freq >> 8) & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_filter & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_level & 0xff);
        // id = 33        混合比例
        //高低通 ,ID = 32    (xover限MIC)
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN1_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN2_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN3_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN4_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN5_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN6_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN7_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN8_Vol & 0xff);
        // id = 34        保留
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN9_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN10_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN11_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN12_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN13_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN14_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN15_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN16_Vol & 0xff);
        //ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN_polar & 0xff);
        //ChannelBuf[++ChCnt]= ((RecStructData.OUT_CH[ChannelID].IN_polar >> 8) & 0xff);
        // id = 35        压限
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN17_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN18_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN19_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN20_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN21_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN22_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN23_Vol & 0xff);
        SendFrameData.Buf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN24_Vol & 0xff);
        //name[8]  ID = 36
        for(int i=0;i<8;i++){
            SendFrameData.Buf[++ChCnt]=RecStructData.OUT_CH[ChannelID].name[i];
        }
        
        if(BOOL_ENCRYPTION){
            //NSLog(@"BOOL_EncryptionFlag == %d",BOOL_EncryptionFlag);
            if(BOOL_EncryptionFlag){//加密
                NSLog(@"BOOL_EncryptionFlag!!");
                for(int i=0;i<OUT_LEN;i++){
                    SendFrameData.Buf[i] = (SendFrameData.Buf[i]^Encrypt_DATA);
                }
                if(ChannelID==0){
                    SendFrameData.Buf[OUT_LEN-8] = EncryptionFlag;
                    SendFrameData.Buf[OUT_LEN-7] = RecStructData.OUT_CH[0].name[1];
                    for(int i=0;i<6;i++){
                        SendFrameData.Buf[OUT_LEN-6+i] = (Encryption_PasswordBuf[i]^Encrypt_DATA);
                    }
                }
            }else if(!BOOL_EncryptionFlag){//非加密
                for(int i=0;i<OUT_LEN;i++){
                    SendFrameData.Buf[i]=(SendFrameData.Buf[i] & 0xff);
                }
                SendFrameData.Buf[OUT_LEN-8]=DecipheringFlag;
            }
        }
    }
}

-(void) FillRecDataStruct:(uint8) DataStruchID withChannelID:(uint8) ChannelID {
    uint16 initDataCnt = 10;
    /*从下面机器读取的要去通信字*/
    if(BOOL_ENCRYPTION){
        //第一通判断数据是否加密，298=296+10-8
        if((ChannelID == 0) && (DataStruchID == OUTPUT)){
            NSLog(@"Encryption Flag=@%d",RecFrameData.DataBuf[298]);
            if(RecFrameData.DataBuf[298] != EncryptionFlag){//非加密
                BOOL_EncryptionFlag = false;
            }else if(RecFrameData.DataBuf[298] == EncryptionFlag){//加密
                BOOL_EncryptionFlag = true;
                for(int i = 10;i < (OUT_LEN + 10);i++){
                    if(i!=298){
                        if(i!=299){//联调标志
                            RecFrameData.DataBuf[i]=RecFrameData.DataBuf[i]^Encrypt_DATA;
                        }
                    }
                }
            }
        }
        //若第一通判断数据加密，其他通道也加密
        if((ChannelID > 0)&&(BOOL_EncryptionFlag)&&(DataStruchID == OUTPUT)){
            for(int i=10;i<(OUT_LEN+10);i++){
                if(i!=298){
                    RecFrameData.DataBuf[i]=RecFrameData.DataBuf[i]^Encrypt_DATA;
                }
            }
        }
    }
    /*初始化数据结构的ID*/
    if(DataStruchID == EFF){
        
    }else if(DataStruchID == MUSIC){
        if(BOOL_USE_INS){
            for(int ch=0;ch<INS_CH_MAX;ch++){
                //---id = 9        杂项
                RecStructData.INS_CH[ch].feedback = RecFrameData.DataBuf[initDataCnt];
                RecStructData.INS_CH[ch].polar    = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].eq_mode  = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].mute     = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].delay    = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].delay    +=RecFrameData.DataBuf[++initDataCnt]*256;
                RecStructData.INS_CH[ch].Valume   = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].Valume   +=RecFrameData.DataBuf[++initDataCnt]*256;
                //高低通 ,ID = 10
                RecStructData.INS_CH[ch].h_freq   = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].h_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
                RecStructData.INS_CH[ch].h_filter = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].h_level  = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].l_freq   = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].l_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
                RecStructData.INS_CH[ch].l_filter = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.INS_CH[ch].l_level  = RecFrameData.DataBuf[++initDataCnt];
                //                NSLog(@"------------------------------------------------@%d",ch);
                //EQ
                for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
                    RecStructData.INS_CH[ch].EQ[i].freq  = RecFrameData.DataBuf[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].freq  +=RecFrameData.DataBuf[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].level = RecFrameData.DataBuf[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].level +=RecFrameData.DataBuf[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].bw    = RecFrameData.DataBuf[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].bw    +=RecFrameData.DataBuf[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].shf_db= RecFrameData.DataBuf[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].type  = RecFrameData.DataBuf[++initDataCnt];
                    
                    //                    NSLog(@"Encryption INS_CH[@%d].EQ[@%d].level=@%d",ch,i,RecStructData.INS_CH[ch].EQ[i].level);
                }
                ++initDataCnt;
            }
            
        }else{
            //EQ
            for(int i = 0;i< IN_CH_EQ_MAX;i++){
                RecStructData.IN_CH[ChannelID].EQ[i].freq  = RecFrameData.DataBuf[initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].freq  +=(RecFrameData.DataBuf[++initDataCnt])*256;
                RecStructData.IN_CH[ChannelID].EQ[i].level = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].level +=RecFrameData.DataBuf[++initDataCnt]*256;
                RecStructData.IN_CH[ChannelID].EQ[i].bw    = RecFrameData.DataBuf[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].bw    +=RecFrameData.DataBuf[++initDataCnt]*256;
                RecStructData.IN_CH[ChannelID].EQ[i].shf_db= RecFrameData.DataBuf[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].type  = RecFrameData.DataBuf[++initDataCnt];
                ++initDataCnt;
            }
            //---id = 10        杂项
            RecStructData.IN_CH[ChannelID].mute = RecFrameData.DataBuf[initDataCnt];
            RecStructData.IN_CH[ChannelID].polar    = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].gain    = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].gain    +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].delay   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].delay   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].eq_mode  = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].LinkFlag     = RecFrameData.DataBuf[++initDataCnt];
            //高低通 ,ID = 11
            RecStructData.IN_CH[ChannelID].h_freq   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].h_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].h_filter = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].h_level  = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_freq   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].l_filter = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_level  = RecFrameData.DataBuf[++initDataCnt];
            //噪声门 ,ID = 12
            RecStructData.IN_CH[ChannelID].noisegate_t   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_a   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_k   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_k   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].noisegate_r   = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_r   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].noise_config  = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noise_config  +=RecFrameData.DataBuf[++initDataCnt]*256;
            //压限 ,ID = 12
//            RecStructData.IN_CH[ChannelID].IN17_Vol    = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN17_Vol    +=RecFrameData.DataBuf[++initDataCnt]*256;
//            RecStructData.IN_CH[ChannelID].IN18_Vol    = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN19_Vol    = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN20_Vol  = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN21_Vol = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN22_Vol = RecFrameData.DataBuf[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].comp_swi = RecFrameData.DataBuf[++initDataCnt];
            //name[8] ID = 13
            for(int i=0;i<8;i++){
                RecStructData.IN_CH[ChannelID].name[i] = RecFrameData.DataBuf[++initDataCnt];
            }
        }
        
    }else if(DataStruchID == OUTPUT){
        //EQ
        for(int i = 0; i < OUT_CH_EQ_MAX; i++){
            RecStructData.OUT_CH[ChannelID].EQ[i].freq   = RecFrameData.DataBuf[initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].level  = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].level  +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].bw     = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].bw     +=RecFrameData.DataBuf[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].shf_db = RecFrameData.DataBuf[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].type   = RecFrameData.DataBuf[++initDataCnt];
            ++initDataCnt;
            //检测数据是否异常
            if((RecStructData.OUT_CH[ChannelID].EQ[i].level < EQ_LEVEL_MIN)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].level > EQ_LEVEL_MAX)){
                
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].EQ[%d].level=%d",ChannelID,i,RecStructData.OUT_CH[ChannelID].EQ[i].level);
                U0SynDataError = true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].EQ[i].bw < 0)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].bw > EQ_BW_MAX)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].EQ[%d].bw=%d",ChannelID,i,RecStructData.OUT_CH[ChannelID].EQ[i].bw);
                U0SynDataError=true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].EQ[i].freq<20)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].freq>20000)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].EQ[%d].freq=%d",ChannelID,i,RecStructData.OUT_CH[ChannelID].EQ[i].freq);
                U0SynDataError=true;
            }
        }
        //id = 31        杂项
        RecStructData.OUT_CH[ChannelID].mute  = RecFrameData.DataBuf[initDataCnt];
        RecStructData.OUT_CH[ChannelID].polar = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].gain  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].gain  +=RecFrameData.DataBuf[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].delay = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].delay +=RecFrameData.DataBuf[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].eq_mode = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].LinkFlag = RecFrameData.DataBuf[++initDataCnt];
        //检测数据是否异常
        if((RecStructData.OUT_CH[ChannelID].gain < 0)
           ||(RecStructData.OUT_CH[ChannelID].gain > Output_Volume_MAX)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].gain=%d",ChannelID,RecStructData.OUT_CH[ChannelID].gain);
            U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].delay < 0)
           ||(RecStructData.OUT_CH[ChannelID].delay > DELAY_SETTINGS_MAX)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].delay=%d",ChannelID,RecStructData.OUT_CH[ChannelID].delay);
            U0SynDataError=true;
        }
        //高低通 ,ID = 32    (xover限MIC)
        RecStructData.OUT_CH[ChannelID].h_freq   = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].h_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].h_filter = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].h_level  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_freq   = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_freq   +=RecFrameData.DataBuf[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].l_filter = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_level  = RecFrameData.DataBuf[++initDataCnt];
        //检测数据是否异常
        if((RecStructData.OUT_CH[ChannelID].h_freq < 0)
           ||(RecStructData.OUT_CH[ChannelID].h_freq > 20000)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].h_freq=%d",ChannelID,RecStructData.OUT_CH[ChannelID].h_freq);
            U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].h_filter < 0)
           ||(RecStructData.OUT_CH[ChannelID].h_filter > 2)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].h_filter=%d",ChannelID,RecStructData.OUT_CH[ChannelID].h_filter);
            U0SynDataError=true;
        }
        if(ChannelID <= 3){
            if((RecStructData.OUT_CH[ChannelID].h_level < 0)
               ||(RecStructData.OUT_CH[ChannelID].h_level > XOVER_OCT_MAXL)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].h_level=%d",ChannelID,RecStructData.OUT_CH[ChannelID].h_level);
                U0SynDataError=true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].l_level < 0)
               ||(RecStructData.OUT_CH[ChannelID].l_level > XOVER_OCT_MAXL)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].l_level=%d",ChannelID,RecStructData.OUT_CH[ChannelID].l_level);
                U0SynDataError=true;
            }
        }else{
            if((RecStructData.OUT_CH[ChannelID].h_level < 0)
               ||(RecStructData.OUT_CH[ChannelID].h_level > XOVER_OCT_MAXH)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].h_level=%d",ChannelID,RecStructData.OUT_CH[ChannelID].h_level);
                U0SynDataError=true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].l_level < 0)
               ||(RecStructData.OUT_CH[ChannelID].l_level > XOVER_OCT_MAXH)){
                NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].l_level=%d",ChannelID,RecStructData.OUT_CH[ChannelID].l_level);
                U0SynDataError=true;
            }
        }
        
        
        if((RecStructData.OUT_CH[ChannelID].l_freq < 0)
           ||(RecStructData.OUT_CH[ChannelID].l_freq > 20000)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].l_freq=%d",ChannelID,RecStructData.OUT_CH[ChannelID].l_freq);
            U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].l_filter < 0)
           ||(RecStructData.OUT_CH[ChannelID].l_filter > 2)){
            NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].l_filter=%d",ChannelID,RecStructData.OUT_CH[ChannelID].l_filter);
            U0SynDataError=true;
        }
        
        
        
        // id = 33        混合比例
        RecStructData.OUT_CH[ChannelID].IN1_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN2_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN3_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN4_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN5_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN6_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN7_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN8_Vol  = RecFrameData.DataBuf[++initDataCnt];
        // id = 34        保留
        RecStructData.OUT_CH[ChannelID].IN9_Vol     = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN10_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN11_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN12_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN13_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN14_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN15_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN16_Vol    = RecFrameData.DataBuf[++initDataCnt];
        //RecStructData.OUT_CH[ChannelID].IN_polar   = RecFrameData.DataBuf[++initDataCnt]+initData[++initDataCnt]*256;
        //RecStructData.OUT_CH[ChannelID].none11   = RecFrameData.DataBuf[++initDataCnt];
        //检测数据是否异常
        if(BOOL_Mixer){
            if(true){
                if((RecStructData.OUT_CH[ChannelID].IN1_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN1_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN1_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN1_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN2_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN2_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN2_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN2_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN3_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN3_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN3_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN3_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN4_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN4_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN4_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN4_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN5_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN5_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN5_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN5_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN6_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN6_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN6_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN6_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN7_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN7_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN7_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN7_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN8_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN8_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN8_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN8_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN9_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN9_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN9_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN9_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN10_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN10_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN10_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN10_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN11_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN11_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN11_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN11_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN12_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN12_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN12_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN12_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN13_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN13_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN13_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN13_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN14_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN14_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN14_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN14_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN15_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN15_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN15_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN15_Vol);
                    U0SynDataError=true;
                }
                if((RecStructData.OUT_CH[ChannelID].IN16_Vol < 0)
                   ||(RecStructData.OUT_CH[ChannelID].IN16_Vol > Mixer_Volume_MAX)){
                    NSLog(@"U0SynDataError RecStructData.OUT_CH[%d].IN16_Vol=%d",ChannelID,RecStructData.OUT_CH[ChannelID].IN16_Vol);
                    U0SynDataError=true;
                }
            }
        }
        
        // id = 35        压限
        RecStructData.OUT_CH[ChannelID].IN17_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN18_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN19_Vol    = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN20_Vol  = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN21_Vol = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN22_Vol = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN23_Vol = RecFrameData.DataBuf[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN24_Vol = RecFrameData.DataBuf[++initDataCnt];
        //name[8]  ID = 36
        for(int i=0;i<8;i++){
            RecStructData.OUT_CH[ChannelID].name[i] = RecFrameData.DataBuf[++initDataCnt];
        }
        //保存密码
        
        if(BOOL_ENCRYPTION){
            if((ChannelID == 0)&&(BOOL_EncryptionFlag)){
                for(int i = 0; i < 6; i++){
                    Encryption_PasswordBuf[i]=RecStructData.OUT_CH[ChannelID].name[2+i];
                }
            }
        }
        
    }
}
#pragma 操作函数

//恢复出厂设置
- (void)sendResetGroupData:(int)ReadUserGroup{
    SendStructData.RESET_GROUP_DATA[0] = ReadUserGroup;
    for (int i = 1; i < 8; i++) {
        SendStructData.RESET_GROUP_DATA[i] = 0;;
    }
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_RESET_GROUP_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    
    [self SendDataToDevice:false];
}
//读取整机数据；
- (void)readMacData{
    BOOL_ReadMacData = true;
    
    [SendbufferList removeAllObjects];
    
//    //插入静音包
//    SendStructData.System.main_vol = 0;
//    SendStructData.System.alldelay = RecStructData.System.alldelay;
//    SendStructData.System.noisegate_t = RecStructData.System.noisegate_t;
//    SendStructData.System.AutoSource = RecStructData.System.AutoSource;
//    SendStructData.System.AutoSourcedB = RecStructData.System.AutoSourcedB;
//    SendStructData.System.MainvolMuteFlg = 0;
//    SendStructData.System.none6 = RecStructData.System.none6;
//
//    SendFrameData.FrameType = WRITE_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_DATA;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 8;
//    [self SendDataToDevice:false];
    
    
    
    /*获取用户名字*/
    for (int usr = 1; usr <= MAX_USE_GROUP; usr++) {
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = usr;
        SendFrameData.DataType = SYSTEM;
        SendFrameData.ChannelID = GROUP_NAME;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;
        SendFrameData.DataLen = 0x00;
        [self SendDataToDevice:FALSE];
    }
    
    for (int usr = 1; usr <= MAX_USE_GROUP; usr++) {
        if(BOOL_USE_INS){
            /*增加读取Input数据，获取音量 0x77*/
            SendFrameData.FrameType = READ_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = usr;
            SendFrameData.DataType = MUSIC;
            SendFrameData.ChannelID = 0x0;
            SendFrameData.DataID = 0;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = 0x00;
            [self SendDataToDevice:FALSE];
        }else{
            if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
                /*增加读取Input数据，获取音量 0x77*/
                SendFrameData.FrameType = READ_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = usr;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = 0x02;//MUSIC 固定2
                SendFrameData.DataID = 0x77;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;//
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = 0;
                [self SendDataToDevice:FALSE];
            }
        }
    }
    
    for(int usr=1;usr<=MAX_USE_GROUP;usr++){
        /*增加读取全部通道的输出数据*/
        for (int i = 0; i < Output_CH_MAX; i++) {
            SendFrameData.FrameType = READ_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = usr;
            SendFrameData.DataType = OUTPUT;
            SendFrameData.ChannelID = i;
            SendFrameData.DataID = 0x77;/*读当前组的数据*/
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = 0;//
            [self SendDataToDevice:FALSE];
        }
    }
    
//    //插入静音包
//    SendStructData.System.main_vol = RecStructData.System.main_vol;
//    SendStructData.System.alldelay = RecStructData.System.alldelay;
//    SendStructData.System.noisegate_t = RecStructData.System.noisegate_t;
//    SendStructData.System.AutoSource = RecStructData.System.AutoSource;
//    SendStructData.System.AutoSourcedB = RecStructData.System.AutoSourcedB;
//    SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg;
//    SendStructData.System.none6 = RecStructData.System.none6;
//
//    SendFrameData.FrameType = WRITE_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_DATA;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 8;
//    [self SendDataToDevice:false];
    
    
    //发送消息
    NSMutableDictionary *State = [NSMutableDictionary dictionary];
    State[@"State"] = ShowProgressCall;
    //创建一个消息对象
    NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_ShowProgress object:nil userInfo:State];
    [[NSNotificationCenter defaultCenter] postNotification:noticeState];
    
}


-(void)setInputSourceNow{
    
    if(!gConnectState){
        return;
    }
    
    SendStructData.System.input_source = RecStructData.System.input_source;
    SendStructData.System.mixer_source = RecStructData.System.mixer_source;
    for (int i=0; i<5; i++) {
        SendStructData.System.InSwitch[i]=RecStructData.System.InSwitch[i];
    }
    
    SendStructData.System.none1 = RecStructData.System.none1;
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = PC_SOURCE_SET;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    
    //U0SendFrameFlg = YES;
    [self SendDataToDevice:false];}

- (void)SEFF_Call:(int)mGroup {
    if(!gConnectState){
        return;
    }
    BOOL_SeffOpt=true;
    //插入静音包
    SendStructData.System.main_vol = 0;
    SendStructData.System.high_mode = RecStructData.System.high_mode;
    SendStructData.System.aux_mode = RecStructData.System.aux_mode;
    SendStructData.System.out_mode = RecStructData.System.out_mode;
    SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB;
    SendStructData.System.MainvolMuteFlg = 0;
    SendStructData.System.theme = RecStructData.System.theme;
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    
    [self SendDataToDevice:false];
    
    if(BOOL_USE_INS){
        /*增加读取Input数据，获取音量 0x77*/
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = mGroup;
        SendFrameData.DataType = MUSIC;
        SendFrameData.ChannelID = 0x0;
        SendFrameData.DataID = 0;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = 0x00;
        [self SendDataToDevice:FALSE];
    }else{
        for(int i=0;i<Input_CH_MAX;i++){
            SendFrameData.FrameType = READ_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = MUSIC;
            SendFrameData.ChannelID = i;
            SendFrameData.DataID = 0x77;//读当前组的数据
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = 8;//IN_LEN;
            [self SendDataToDevice:FALSE];
        }
    }
    
    /*增加读取全部通道的输出数据*/
    for (uint8 i = 0; i < Output_CH_MAX; i++) {
        SendFrameData.FrameType = READ_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = mGroup;
        SendFrameData.DataType = OUTPUT;
        SendFrameData.ChannelID = i;
        SendFrameData.DataID = 0x00;/*读某一组的数据，下位机并把此组数据复制到当前组中*/
        SendFrameData.PCFadeInFadeOutFlg = 0x00;//
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = 0x00;//IN_LEN;
        
        [self SendDataToDevice:false];
    }
    
    /*增加读取通道延时,要放到最后（读取全部通道的输出数据）读取，若条件成立，会覆盖OUTPUT通道里的数据*/
    
    //插入静音包
    SendStructData.System.main_vol = RecStructData.System.main_vol;
    SendStructData.System.high_mode = RecStructData.System.high_mode;
    SendStructData.System.aux_mode = RecStructData.System.aux_mode;
    SendStructData.System.out_mode = RecStructData.System.out_mode;
    SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB;
    SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg;
    SendStructData.System.theme = RecStructData.System.theme;
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    
    [self SendDataToDevice:false];
    
    
    //发送消息
    NSMutableDictionary *State = [NSMutableDictionary dictionary];
    State[@"State"] = ShowProgressCall;
    //创建一个消息对象
    NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_ShowProgress object:nil userInfo:State];
    [[NSNotificationCenter defaultCenter] postNotification:noticeState];
}
- (void)SEFF_Delete:(int)mGroup  {
    if(!gConnectState){
        return;
    }
    for (uint8 i = 0; i < 16; i++){
        RecStructData.USER[mGroup].name[i] = 0;
        SendStructData.USER[mGroup].name[i] = 0;
    }
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = mGroup;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = GROUP_NAME;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 0x10;
    
    [self SendDataToDevice:false];
}

- (void)SEFF_Save:(int)mGroup {
    if(!gConnectState){
        return;
    }
    
    NSLog(@"SEFF_Save mGroup=@%d",mGroup);
    if(mGroup != 0){
        [self SetSEFF_GroupName:mGroup];
    }
//    //插入静音包
//    SendStructData.System.main_vol = 0;
//    SendStructData.System.alldelay = RecStructData.System.alldelay;
//    SendStructData.System.noisegate_t = RecStructData.System.noisegate_t;
//    SendStructData.System.AutoSource = RecStructData.System.AutoSource;
//    SendStructData.System.AutoSourcedB = RecStructData.System.AutoSourcedB;
//    SendStructData.System.MainvolMuteFlg = 0;
//    SendStructData.System.none6 = RecStructData.System.none6;
//
//    SendFrameData.FrameType = WRITE_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_DATA;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 8;
//    [self SendDataToDevice:false];
    
    //增加保存数据标志
    if(BOOL_TRANSMITTAL){
        SendFrameData.FrameType = WRITE_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = 0x00;
        SendFrameData.DataType = SYSTEM;
        SendFrameData.ChannelID = SYSTEM_TRANSMITTAL;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;
        SendFrameData.DataLen = 8;
        
        SendStructData.TRANSMITTAL[0]=1;//开始传输
        SendStructData.TRANSMITTAL[1]=(mGroup&0xff);
        for(int i=2;i<8;i++){
            SendStructData.TRANSMITTAL[i]=0;
        }
        [self SendDataToDevice:false];
    }
    
    if(BOOL_USE_INS){
        SendFrameData.FrameType = WRITE_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID =  mGroup;
        SendFrameData.DataType = MUSIC;
        SendFrameData.ChannelID = 0x00;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;//
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = INS_LEN;
        [self FillSedDataStructCH:MUSIC DataWithCh:0];
        [self SendDataToDevice:FALSE];
        
    }else{
        for (uint8 i = 0; i < Input_CH_MAX; i++) {
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = mGroup;
            SendFrameData.DataType = MUSIC;
            SendFrameData.ChannelID = i;
            SendFrameData.DataID = 0x00;//IN_MISC_ID;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = IN_LEN;//IN_LEN;
            [self FillSedDataStructCH:MUSIC DataWithCh:i];
            [self SendDataToDevice:false];
        }
    }
    
    //保存输出通道的输出数据
    for (uint8 i = 0; i < Output_CH_MAX; i++) {
        SendFrameData.FrameType = WRITE_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = mGroup;
        SendFrameData.DataType = OUTPUT;
        SendFrameData.ChannelID = i;
        SendFrameData.DataID = 0x00;//IN_MISC_ID;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;//
        SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
        SendFrameData.DataLen = OUT_LEN;//IN_LEN;
        [self FillSedDataStructCH:OUTPUT DataWithCh:i];
        [self SendDataToDevice:false];
    }
    
    //增加保存数据标志
    if(BOOL_TRANSMITTAL){
        SendFrameData.FrameType = WRITE_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = 0x00;
        SendFrameData.DataType = SYSTEM;
        SendFrameData.ChannelID = SYSTEM_TRANSMITTAL;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;
        SendFrameData.DataLen = 8;
        
        SendStructData.TRANSMITTAL[0]=0;//开始传输
        SendStructData.TRANSMITTAL[1]=(mGroup&0xff);
        for(int i=2;i<8;i++){
            SendStructData.TRANSMITTAL[i]=0;
        }
        [self SendDataToDevice:false];
    }
    
    
//    //插入静音包
//    SendStructData.System.main_vol = RecStructData.System.main_vol;
//    SendStructData.System.alldelay = RecStructData.System.alldelay;
//    SendStructData.System.noisegate_t = RecStructData.System.noisegate_t;
//    SendStructData.System.AutoSource = RecStructData.System.AutoSource;
//    SendStructData.System.AutoSourcedB = RecStructData.System.AutoSourcedB;
//    SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg;
//    SendStructData.System.none6 = RecStructData.System.none6;
//    
//    SendFrameData.FrameType = WRITE_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_DATA;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 8;
//    [self SendDataToDevice:false];
//    
    //发送消息
    NSMutableDictionary *State = [NSMutableDictionary dictionary];
    State[@"State"] = ShowProgressSave;
    //创建一个消息对象
    NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_ShowProgress object:nil userInfo:State];
    [[NSNotificationCenter defaultCenter] postNotification:noticeState];
    
    
}

- (void)syncMCUSystemData{
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        return;
    }

    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = PC_SOURCE_SET;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    [self SendDataToDevice:FALSE];
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    [self SendDataToDevice:FALSE];
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_SPK_TYPE;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 48;
    [self SendDataToDevice:FALSE];
    
    
//    SendFrameData.FrameType = WRITE_CMD;
//    SendFrameData.DeviceID = 0x01;
//    SendFrameData.UserID = 0x00;
//    SendFrameData.DataType = SYSTEM;
//    SendFrameData.ChannelID = SYSTEM_SPK_TYPEB;
//    SendFrameData.DataID = 0x00;
//    SendFrameData.PCFadeInFadeOutFlg = 0x00;
//    SendFrameData.PcCustom = 0x00;
//    SendFrameData.DataLen = 8;
//    [self SendDataToDevice:FALSE];
    
}


- (void)SEFF_EncryptClean {
    for(int i=0;i<Output_CH_MAX;i++){
        RecStructData.OUT_CH[i] = DefaultStructData.OUT_CH[i];
        [self ComparedToSendData:FALSE];
    }
    [self SEFF_Save:0];
}

-(void)SetSEFF_GroupName:(int)mGroup{
    BOOL haveName=false;
    for(int i=0;i<MAX_SEFFGroupName_Size;i++){
        if(RecStructData.USER[mGroup].name[i] !=0x00){
            haveName=true;
            
        }
    }
    if(!haveName){
        RecStructData.USER[mGroup].name[0]=(0x30+mGroup);
        for(int i=1;i<MAX_SEFFGroupName_Size;i++){
            RecStructData.USER[mGroup].name[i]=0x00;
        }
    }
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = mGroup;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = GROUP_NAME;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 0x10;
    [self SendDataToDevice:false];
}


- (void)saveMCUSEFFData{
    //插入静音包
    SendStructData.System.main_vol =0;
    SendStructData.System.high_mode = RecStructData.System.high_mode;
    SendStructData.System.aux_mode = RecStructData.System.aux_mode;
    SendStructData.System.out_mode = RecStructData.System.out_mode;
    SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB;
    SendStructData.System.MainvolMuteFlg = 0;
    SendStructData.System.theme = RecStructData.System.theme;
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    [self SendDataToDevice:false];
    
    
    //同步系统数据
    [self syncMCUSystemData];
    
    //同步名字
    for(uint8 i=1;i<=MAX_USE_GROUP;i++){
        SendFrameData.FrameType = WRITE_CMD;
        SendFrameData.DeviceID = 0x01;
        SendFrameData.UserID = i;
        SendFrameData.DataType = SYSTEM;
        SendFrameData.ChannelID = GROUP_NAME;
        SendFrameData.DataID = 0x00;
        SendFrameData.PCFadeInFadeOutFlg = 0x00;
        SendFrameData.PcCustom = 0x00;
        SendFrameData.DataLen = 0x10;
        [self SendDataToDevice:false];
    }
    
    
    //同步MUSIC数据
    for(uint8 user=0;user<=MAX_USE_GROUP;user++){
        
        if(BOOL_USE_INS){
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID =  user;
            SendFrameData.DataType = MUSIC;
            SendFrameData.ChannelID = 0x00;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = INS_LEN;
            
            int c = 0;
            for(int ch=0;ch<INS_CH_MAX;ch++){
                for(int cnt=0;cnt<INS_S_LEN;cnt++){
                    SendFrameData.Buf[c++]=JsonMacData.Data[user].JIN.MusicJ[ch][cnt];
                }
            }
            
            [self SendDataToDevice:false];
        }else{
            if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
                //for (uint8 i = 0; i < IN_CH_MAX; i++) {
                SendFrameData.FrameType = WRITE_CMD;
                SendFrameData.DeviceID = 0x01;
                SendFrameData.UserID = user;
                SendFrameData.DataType = MUSIC;
                SendFrameData.ChannelID = 2;
                SendFrameData.DataID = 0x00;//IN_MISC_ID;
                SendFrameData.PCFadeInFadeOutFlg = 0x00;//
                SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
                SendFrameData.DataLen = INS_LEN;//IN_LEN;
                for(int cnt=0;cnt<INS_LEN;cnt++){
                    SendFrameData.Buf[cnt]=JsonMacData.Data[user].JIN.MusicJ[0][cnt];
                }
                [self SendDataToDevice:false];
                //}
            }
        }
    }
    //同步Output数据
    for(uint8 user=0;user<=MAX_USE_GROUP;user++){
        //增加保存数据标志
        if(BOOL_TRANSMITTAL){
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = SYSTEM;
            SendFrameData.ChannelID = SYSTEM_TRANSMITTAL;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;
            SendFrameData.DataLen = 8;
            
            SendStructData.TRANSMITTAL[0]=1;//开始传输
            SendStructData.TRANSMITTAL[1]=(user&0xff);
            for(int i=2;i<8;i++){
                SendStructData.TRANSMITTAL[i]=0;
            }
            [self SendDataToDevice:false];
        }
        
        
        for (uint8 i = 0; i < Output_CH_MAX; i++) {
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = user;
            SendFrameData.DataType = OUTPUT;
            SendFrameData.ChannelID = i;
            SendFrameData.DataID = 0x00;//IN_MISC_ID;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;//
            SendFrameData.PcCustom = 0x00;// 自定义字符，发什么下去，返回什么
            SendFrameData.DataLen = OUT_LEN;//IN_LEN;
            for(int cnt=0;cnt<OUT_LEN;cnt++){
                SendFrameData.Buf[cnt]=JsonMacData.Data[user].JOUT.OutputJ[i][cnt];
            }
            [self SendDataToDevice:false];
        }
        
        //增加保存数据标志
        if(BOOL_TRANSMITTAL){
            SendFrameData.FrameType = WRITE_CMD;
            SendFrameData.DeviceID = 0x01;
            SendFrameData.UserID = 0x00;
            SendFrameData.DataType = SYSTEM;
            SendFrameData.ChannelID = SYSTEM_TRANSMITTAL;
            SendFrameData.DataID = 0x00;
            SendFrameData.PCFadeInFadeOutFlg = 0x00;
            SendFrameData.PcCustom = 0x00;
            SendFrameData.DataLen = 8;
            
            SendStructData.TRANSMITTAL[0]=0;//开始传输
            SendStructData.TRANSMITTAL[1]=(user&0xff);
            for(int i=2;i<8;i++){
                SendStructData.TRANSMITTAL[i]=0;
            }
            [self SendDataToDevice:false];
        }
        
    }
    
    //插入静音包
    SendStructData.System.main_vol = RecStructData.System.main_vol;
    SendStructData.System.high_mode = RecStructData.System.high_mode;
    SendStructData.System.aux_mode = RecStructData.System.aux_mode;
    SendStructData.System.out_mode = RecStructData.System.out_mode;
    SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB;
    SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg;
    SendStructData.System.theme = RecStructData.System.theme;
    
    SendFrameData.FrameType = WRITE_CMD;
    SendFrameData.DeviceID = 0x01;
    SendFrameData.UserID = 0x00;
    SendFrameData.DataType = SYSTEM;
    SendFrameData.ChannelID = SYSTEM_DATA;
    SendFrameData.DataID = 0x00;
    SendFrameData.PCFadeInFadeOutFlg = 0x00;
    SendFrameData.PcCustom = 0x00;
    SendFrameData.DataLen = 8;
    [self SendDataToDevice:false];
    //发送消息
    NSMutableDictionary *State = [NSMutableDictionary dictionary];
    State[@"State"] = ShowProgressSave;
    //创建一个消息对象
    NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_ShowProgress object:nil userInfo:State];
    [[NSNotificationCenter defaultCenter] postNotification:noticeState];
    
}

//根據通道類型設置濾波器頻率
void setXOverFreqWithOutputSpkType(int channel){
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    //根据名字设置Xover频率
    //高频
    for(int i=0;i<6;i++){
        if(HighFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==HighFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=HighFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=HighFreq_LPFreq;
            }
        }
    }
    //中频
    for(int i=0;i<3;i++){
        if(MidFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==MidFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=MidFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=MidFreq_LPFreq;
            }
        }
    }
    //低频
    for(int i=0;i<6;i++){
        if(LowFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==LowFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=LowFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=LowFreq_LPFreq;
            }
        }
    }
    //中高
    for(int i=0;i<3;i++){
        if(MidHighFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==MidHighFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=MidHighFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=MidHighFreq_LPFreq;
            }
        }
    }
    //中低
    for(int i=0;i<3;i++){
        if(MidLowFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==MidLowFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=MidLowFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=MidLowFreq_LPFreq;
            }
        }
    }
    //超低
    for(int i=0;i<4;i++){
        if(SupperLowFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==SupperLowFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=SupperLowFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=SupperLowFreq_LPFreq;
            }
        }
    }
    
    //全频
    for(int i=0;i<7;i++){
        if(AllFreq[i]!=EndFlag){
            if(ChannelNumBuf[channel]==AllFreq[i]){
                RecStructData.OUT_CH[channel].h_freq=AllFreq_HPFreq;
                RecStructData.OUT_CH[channel].l_freq=AllFreq_LPFreq;
            }
        }
    }
    
    if(ChannelNumBuf[channel]==0){
        RecStructData.OUT_CH[channel].h_filter=DefaultStructData.OUT_CH[channel].h_filter;
        RecStructData.OUT_CH[channel].l_filter=DefaultStructData.OUT_CH[channel].l_filter;
        RecStructData.OUT_CH[channel].h_level =DefaultStructData.OUT_CH[channel].h_level;
        RecStructData.OUT_CH[channel].l_level =DefaultStructData.OUT_CH[channel].l_level;
        RecStructData.OUT_CH[channel].h_freq  =AllFreq_HPFreq;
        RecStructData.OUT_CH[channel].l_freq  =AllFreq_LPFreq;
    }
    
}
void setMixerVolWithOutputSpk(int chsel){
    int spk_type=0;
    spk_type=RecStructData.System.out_spk_type[chsel];
    
    switch (spk_type) {
        case 0://空
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
            break;
        case 1://前置左
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
            break;
            
        case 7://前置 右
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol =100;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
            break;
        case 13://后置左
        case 14:
        case 15:
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
            RecStructData.OUT_CH[chsel].IN3_Vol = 100;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
            RecStructData.OUT_CH[chsel].IN11_Vol = 100;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
            break;
        case 16://后置右
        case 17:
        case 18:
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 100;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 100;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
            break;
        case 19://中置
        case 20:
        case 21:
            RecStructData.OUT_CH[chsel].IN1_Vol = 50;
            RecStructData.OUT_CH[chsel].IN2_Vol = 50;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 50;
            RecStructData.OUT_CH[chsel].IN10_Vol = 50;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
            break;
        case 22://左超低
            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
            RecStructData.OUT_CH[chsel].IN3_Vol = 100;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
            RecStructData.OUT_CH[chsel].IN11_Vol = 100;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
            break;
        case 23://右超低
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 100;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 100;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
            break;
        case 24://超低
            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
            break;
        default:
            break;
    }
}

//- (void) setMixerVolWithOutputSpk:(int) chsel{
//    int spk_type=0;
//    switch (chsel) {
//        case 0: spk_type = RecStructData.System.out1_spk_type;break;
//        case 1: spk_type = RecStructData.System.out2_spk_type;break;
//        case 2: spk_type = RecStructData.System.out3_spk_type;break;
//        case 3: spk_type = RecStructData.System.out4_spk_type;break;
//        case 4: spk_type = RecStructData.System.out5_spk_type;break;
//        case 5: spk_type = RecStructData.System.out6_spk_type;break;
//        case 6: spk_type = RecStructData.System.out7_spk_type;break;
//        case 7: spk_type = RecStructData.System.out8_spk_type;break;
//
//        case 8: spk_type = RecStructData.System.out9_spk_type;break;
//        case 9: spk_type = RecStructData.System.out10_spk_type;break;
//        case 10: spk_type = RecStructData.System.out11_spk_type;break;
//        case 11: spk_type = RecStructData.System.out12_spk_type;break;
//        case 12: spk_type = RecStructData.System.out13_spk_type;break;
//        case 13: spk_type = RecStructData.System.out14_spk_type;break;
//        case 14: spk_type = RecStructData.System.out15_spk_type;break;
//        case 15: spk_type = RecStructData.System.out16_spk_type;break;
//        default:
//            break;
//    }
//
//    switch (spk_type) {
//        case 0://空
//            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
//            break;
//        case 1://前置左
//        case 2:
//        case 3:
//        case 4:
//        case 5:
//        case 6:
//            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
//            break;
//
//        case 7://前置 右
//        case 8:
//        case 9:
//        case 10:
//        case 11:
//        case 12:
//            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
//            break;
//        case 13://后置左
//        case 14:
//        case 15:
//            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
//            break;
//        case 16://后置右
//        case 17:
//        case 18:
//            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 100;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 100;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
//            break;
//        case 19://中置
//        case 20:
//        case 21:
//            RecStructData.OUT_CH[chsel].IN1_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 50;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 50;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 50;
//            break;
//        case 22://左超低
//            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
//            break;
//        case 23://右超低
//            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 100;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
//            break;
//        case 24://超低
//            RecStructData.OUT_CH[chsel].IN1_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN8_Vol = 0 ;
//
//            RecStructData.OUT_CH[chsel].IN9_Vol  = 100;
//            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
//            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
//
//            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
//            RecStructData.OUT_CH[chsel].IN16_Vol = 100;
//            break;
//        default:
//            break;
//    }
//}
#pragma 联调
void syncLinkData(int ui){
    UI_Type=ui;
    
    //前声场，后声场，超低的联调，单独分开
    if(LinkMODE == LINKMODE_FRS){
        LINK_MODE_FRS();
    }
    //前声场，后声场，超低的联调，一起联调
    else if(LinkMODE == LINKMODE_FRS_A){
        LINK_MODE_FRS_A();
    }
    //前声场，后声场，单独分开
    else if(LinkMODE == LINKMODE_FR){
        LINK_MODE_FR();
    }
    //前声场，后声场，中置超低的联调，一起联调
    else if(LinkMODE == LINKMODE_FR_A){
        LINK_MODE_FR_A();
    }
    //设置通道输出类型后的联调
    else if(LinkMODE == LINKMODE_SPKTYPE){
        LINK_MODE_SPKTYPE_S();
    }
    //设置通道输出类型后的联调，可联机保存
    else if(LinkMODE == LINKMODE_SPKTYPE_S){
        LINK_MODE_SPKTYPE_S();
    }
    //任意联调，每个通道可以单独联调，可联机保存
    else if(LinkMODE == LINKMODE_AUTO){
        LINK_MODE_AUTO();
    }
    //固定两两通道联调
    else if(LinkMODE == LINKMODE_LEFTRIGHT){
        LINK_MODE_LEFTRIGHT();
    }
    //前声场，后声场，一起两两联调
    else if(LinkMODE == LINKMODE_FR2A){
        LINK_MODE_FR2A();
    }else if(LinkMODE==LINKMODE_AUTOTAG){
//        LINK_MODE_AUTOTAG();
    }
    
    
}
//标识相同联调
void LINK_MODE_AUTOTAG_IN(int ui){
    if (RecStructData.IN_CH[input_channel_sel].LinkFlag==0) {
        return;
    }
    int Dfrom=input_channel_sel;
    int allChannel=0;
    if (RecStructData.System.InSwitch[3]!=0) {
        allChannel=RecStructData.System.HiInputChNum;
    }
    if (RecStructData.System.InSwitch[4]!=0) {
        allChannel=allChannel+RecStructData.System.AuxInputChNum;
    }
    for (int i=3; i<allChannel; i++) {
        if ((i!=Dfrom)&&(RecStructData.IN_CH[Dfrom].LinkFlag==RecStructData.IN_CH[i].LinkFlag)) {
            if(ui == UI_HFilter){
        
                RecStructData.IN_CH[i].h_filter=RecStructData.IN_CH[input_channel_sel].h_filter;
                
            }else if (ui == UI_HOct){
                
                RecStructData.IN_CH[i].h_level=RecStructData.IN_CH[input_channel_sel].h_level;
                
            }else if (ui == UI_HFreq){
                RecStructData.IN_CH[i].h_freq=RecStructData.IN_CH[i].h_freq+AutoLinkValue;
                if (RecStructData.IN_CH[i].h_freq<20) {
                    RecStructData.IN_CH[i].h_freq=20;
                }else if (RecStructData.IN_CH[i].h_freq>RecStructData.IN_CH[i].l_freq){
                    RecStructData.IN_CH[i].h_freq=RecStructData.IN_CH[i].l_freq;
                }else if (RecStructData.IN_CH[i].h_freq>20000){
                    RecStructData.IN_CH[i].h_freq=20000;
                }
            }else if (ui == UI_LFilter){
                RecStructData.IN_CH[i].l_filter=RecStructData.IN_CH[Dfrom].l_filter;
            }else if (ui == UI_LOct){
                RecStructData.IN_CH[i].l_level=RecStructData.IN_CH[Dfrom].l_level;
            }else if (ui == UI_LFreq){
                RecStructData.IN_CH[i].l_freq=RecStructData.IN_CH[Dfrom].l_freq;
                RecStructData.IN_CH[i].l_freq=RecStructData.IN_CH[i].l_freq+AutoLinkValue;
                if (RecStructData.IN_CH[i].l_freq<20) {
                    RecStructData.IN_CH[i].l_freq=20;
                }else if (RecStructData.IN_CH[i].h_freq>RecStructData.IN_CH[i].l_freq){
                    RecStructData.IN_CH[i].l_freq=RecStructData.IN_CH[i].h_freq;
                }else if (RecStructData.IN_CH[i].l_freq>20000){
                    RecStructData.IN_CH[i].l_freq=20000;
                }
            }else if (ui == UI_OutVal){
                
                RecStructData.IN_CH[i].gain=RecStructData.IN_CH[i].gain+AutoLinkValue;
                if (RecStructData.IN_CH[i].gain<0) {
                    RecStructData.IN_CH[i].gain=0;
                }else if (RecStructData.IN_CH[i].gain>Output_Volume_MAX){
                    RecStructData.IN_CH[i].gain=Output_Volume_MAX;
                }
            }else if (ui == UI_OutMute){
                
            }else if (ui == UI_OutPolar){
                 RecStructData.IN_CH[i].polar = RecStructData.IN_CH[Dfrom].polar;
            }else if (ui == UI_EQ_BW){
                RecStructData.IN_CH[i].EQ[eqIndex].bw=RecStructData.IN_CH[Dfrom].EQ[eqIndex].bw;
            }else if (ui == UI_EQ_Freq){
                 RecStructData.IN_CH[i].EQ[eqIndex].freq=RecStructData.IN_CH[Dfrom].EQ[eqIndex].freq;
            }else if (ui == UI_EQ_Level){
                RecStructData.IN_CH[i].EQ[eqIndex].level=RecStructData.IN_CH[i].EQ[eqIndex].level+AutoLinkValue;
                if (RecStructData.IN_CH[i].EQ[eqIndex].level<EQ_LEVEL_MIN) {
                    RecStructData.IN_CH[i].EQ[eqIndex].level=EQ_LEVEL_MIN;
                }else if (RecStructData.IN_CH[i].EQ[eqIndex].level>EQ_LEVEL_MAX){
                    RecStructData.IN_CH[i].EQ[eqIndex].level=EQ_LEVEL_MAX;
                }
            }else if (ui == UI_EQ_G_P_MODE_EQ){
                RecStructData.IN_CH[i].eq_mode=RecStructData.IN_CH[Dfrom].eq_mode;
            }else if (ui == UI_EQ_ALL){
                for(int j=0;j<IN_CH_EQ_MAX;j++){
                RecStructData.IN_CH[i].EQ[j].freq  =RecStructData.IN_CH[Dfrom].EQ[j].freq;
                RecStructData.IN_CH[i].EQ[j].level =RecStructData.IN_CH[Dfrom].EQ[j].level;
                RecStructData.IN_CH[i].EQ[j].bw    =RecStructData.IN_CH[Dfrom].EQ[j].bw;
                RecStructData.IN_CH[i].EQ[j].shf_db=RecStructData.IN_CH[Dfrom].EQ[j].shf_db;
                RecStructData.IN_CH[i].EQ[j].type  =RecStructData.IN_CH[Dfrom].EQ[j].type;
                }
            }else if (ui == UI_Delay){
                
            }
        }
    }
}
void LINK_MODE_AUTOTAG_OUT(int ui){
    if (RecStructData.OUT_CH[output_channel_sel].LinkFlag==0) {
        return;
    }
    int Dfrom=output_channel_sel;
    for (int i=0; i<RecStructData.System.OutputChNum; i++) {
        if ((i!=Dfrom)&&(RecStructData.OUT_CH[Dfrom].LinkFlag==RecStructData.OUT_CH[i].LinkFlag)) {
            if(ui==UI_HFilter){
                RecStructData.OUT_CH[i].h_filter=RecStructData.OUT_CH[Dfrom].h_filter;
            }else if(ui==UI_HOct){
                RecStructData.OUT_CH[i].h_level=RecStructData.OUT_CH[Dfrom].h_level;
            }else if(ui==UI_HFreq){
                //                RecStructData.OUT_CH[i].h_freq=RecStructData.OUT_CH[Dfrom].h_freq;
                RecStructData.OUT_CH[i].h_freq=RecStructData.OUT_CH[i].h_freq+AutoLinkValue;
                if (RecStructData.OUT_CH[i].h_freq<20) {
                    RecStructData.OUT_CH[i].h_freq=20;
                }else if (RecStructData.OUT_CH[i].h_freq>RecStructData.OUT_CH[i].l_freq){
                    RecStructData.OUT_CH[i].h_freq=RecStructData.OUT_CH[i].l_freq;
                }else if (RecStructData.OUT_CH[i].h_freq>20000){
                    RecStructData.OUT_CH[i].h_freq=20000;
                }
            }else if(ui==UI_LFilter){
                RecStructData.OUT_CH[i].l_filter=RecStructData.OUT_CH[Dfrom].l_filter;
                
            }else if(ui==UI_LOct){
                RecStructData.OUT_CH[i].l_level=RecStructData.OUT_CH[Dfrom].l_level;
            }else if(ui==UI_LFreq){
                //                RecStructData.OUT_CH[i].l_freq=RecStructData.OUT_CH[Dfrom].l_freq;
                RecStructData.OUT_CH[i].l_freq=RecStructData.OUT_CH[i].l_freq+AutoLinkValue;
                if (RecStructData.OUT_CH[i].l_freq<20) {
                    RecStructData.OUT_CH[i].l_freq=20;
                }else if (RecStructData.OUT_CH[i].h_freq>RecStructData.OUT_CH[i].l_freq){
                    RecStructData.OUT_CH[i].l_freq=RecStructData.OUT_CH[i].h_freq;
                }else if (RecStructData.OUT_CH[i].l_freq>20000){
                    RecStructData.OUT_CH[i].l_freq=20000;
                }
            }else if(ui==UI_OutVal){
                
                RecStructData.OUT_CH[i].gain=RecStructData.OUT_CH[i].gain+AutoLinkValue;
                if (RecStructData.OUT_CH[i].gain<0) {
                    RecStructData.OUT_CH[i].gain=0;
                }else if (RecStructData.OUT_CH[i].gain>Output_Volume_MAX){
                    RecStructData.OUT_CH[i].gain=Output_Volume_MAX;
                }
            }else if(ui==UI_OutMute){
                
            }else if(ui==UI_OutPolar){
                /*由反相到正相*/
                RecStructData.OUT_CH[i].polar = RecStructData.OUT_CH[Dfrom].polar;
            }else if(ui==UI_EQ_BW){
                RecStructData.OUT_CH[i].EQ[eqIndex].bw=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].bw;
            }else if(ui==UI_EQ_Freq){
                RecStructData.OUT_CH[i].EQ[eqIndex].freq=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].freq;
            }else if(ui==UI_EQ_Level){
                //                RecStructData.OUT_CH[i].EQ[eqIndex].level=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].level;
                RecStructData.OUT_CH[i].EQ[eqIndex].level=RecStructData.OUT_CH[i].EQ[eqIndex].level+AutoLinkValue;
                if (RecStructData.OUT_CH[i].EQ[eqIndex].level<EQ_LEVEL_MIN) {
                    RecStructData.OUT_CH[i].EQ[eqIndex].level=EQ_LEVEL_MIN;
                }else if (RecStructData.OUT_CH[i].EQ[eqIndex].level>EQ_LEVEL_MAX){
                    RecStructData.OUT_CH[i].EQ[eqIndex].level=EQ_LEVEL_MAX;
                }
            }else if(ui==UI_EQ_G_P_MODE_EQ){
                RecStructData.OUT_CH[i].eq_mode=RecStructData.OUT_CH[Dfrom].eq_mode;
            }else if(ui==UI_EQ_ALL){
                for(int j=0;j<OUT_CH_EQ_MAX;j++){
                    RecStructData.OUT_CH[i].EQ[j].freq  =RecStructData.OUT_CH[Dfrom].EQ[j].freq;
                    RecStructData.OUT_CH[i].EQ[j].level =RecStructData.OUT_CH[Dfrom].EQ[j].level;
                    RecStructData.OUT_CH[i].EQ[j].bw    =RecStructData.OUT_CH[Dfrom].EQ[j].bw;
                    RecStructData.OUT_CH[i].EQ[j].shf_db=RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
                    RecStructData.OUT_CH[i].EQ[j].type  =RecStructData.OUT_CH[Dfrom].EQ[j].type;
                }
            }else if (ui==UI_Delay){
                RecStructData.OUT_CH[i].delay=RecStructData.OUT_CH[i].delay+AutoLinkValue;
                if (RecStructData.OUT_CH[i].delay<0) {
                    RecStructData.OUT_CH[i].delay=0;
                }else if(RecStructData.OUT_CH[i].delay>DELAY_SETTINGS_MAX){
                    RecStructData.OUT_CH[i].delay=DELAY_SETTINGS_MAX;
                }
            }
        }
    }
}
//前声场，后声场，超低的联调，单独分开
void LINK_MODE_FRS(){
    int Dfrom=output_channel_sel;
    int Dto=0xff;
    
    int chLinkValume=0;
    //同时刷新连接状态
    if((ChannelConFLR==0)&&(ChannelConRLR==0)&&(ChannelConSLR==0)){
        return;//没有联调
    }
    
    if((ChannelConFLR==1)&&(ChannelConRLR==0)&&(ChannelConSLR==0)){
        chLinkValume=1;
    }else if((ChannelConFLR==0)&&(ChannelConRLR==1)&&(ChannelConSLR==0)){
        chLinkValume=2;
    }else if((ChannelConFLR==1)&&(ChannelConRLR==1)&&(ChannelConSLR==0)){
        chLinkValume=3;
    }else if((ChannelConFLR==0)&&(ChannelConRLR==0)&&(ChannelConSLR==1)){
        chLinkValume=4;
    }else if((ChannelConFLR==1)&&(ChannelConRLR==0)&&(ChannelConSLR==1)){
        chLinkValume=5;
    }else if((ChannelConFLR==0)&&(ChannelConRLR==1)&&(ChannelConSLR==1)){
        chLinkValume=6;
    }else if((ChannelConFLR==1)&&(ChannelConRLR==1)&&(ChannelConSLR==1)){
        chLinkValume=7;
    }
    
    switch (chLinkValume) {
        case 1://0-1
            if (Dfrom == 0) {
                Dto = 1;
            } else if (Dfrom == 1) {
                Dto = 0;
            }
            break;
        case 2://2-3
            if (Dfrom == 2) {
                Dto = 3;
            } else if (Dfrom == 3) {
                Dto = 2;
            }
            break;
        case 4://4-5
            if (Dfrom == 4) {
                Dto = 5;
            } else if (Dfrom == 5) {
                Dto = 4;
            }
            break;
        case 3://0-1 //2-3
            if (Dfrom == 0) {
                Dto = 1;
            } else if (Dfrom == 1) {
                Dto = 0;
            } else if (Dfrom == 2) {
                Dto = 3;
            } else if (Dfrom == 3) {
                Dto = 2;
            }
            break;
        case 5://0-1 //4-5
            if (Dfrom == 0) {
                Dto = 1;
            } else if (Dfrom == 1) {
                Dto = 0;
            } else if (Dfrom == 4) {
                Dto = 5;
            } else if (Dfrom == 5) {
                Dto = 4;
            }
            break;
        case 6:////2-3 //4-5
            if (Dfrom == 2) {
                Dto = 3;
            } else if (Dfrom == 3) {
                Dto = 2;
            } else if (Dfrom == 4) {
                Dto = 5;
            } else if (Dfrom == 5) {
                Dto = 4;
            }
            break;
        case 7://0-1 //2-3 //4-5
            if (Dfrom == 0) {
                Dto = 1;
            } else if (Dfrom == 1) {
                Dto = 0;
            } else if (Dfrom == 2) {
                Dto = 3;
            } else if (Dfrom == 3) {
                Dto = 2;
            } else if (Dfrom == 4) {
                Dto = 5;
            } else if (Dfrom == 5) {
                Dto = 4;
            }
            break;
        default:
            break;
    }
    
    if(Dto < Output_CH_MAX){
        
        if(UI_Type==UI_HFilter){
            RecStructData.OUT_CH[Dto].h_filter=RecStructData.OUT_CH[Dfrom].h_filter;
        }else if(UI_Type==UI_HOct){
            RecStructData.OUT_CH[Dto].h_level=RecStructData.OUT_CH[Dfrom].h_level;
        }else if(UI_Type==UI_HFreq){
            RecStructData.OUT_CH[Dto].h_freq=RecStructData.OUT_CH[Dfrom].h_freq;
        }else if(UI_Type==UI_LFilter){
            RecStructData.OUT_CH[Dto].l_filter=RecStructData.OUT_CH[Dfrom].l_filter;
        }else if(UI_Type==UI_LOct){
            RecStructData.OUT_CH[Dto].l_level=RecStructData.OUT_CH[Dfrom].l_level;
        }else if(UI_Type==UI_LFreq){
            RecStructData.OUT_CH[Dto].l_freq=RecStructData.OUT_CH[Dfrom].l_freq;
        }else if(UI_Type==UI_OutVal){
            RecStructData.OUT_CH[Dto].gain=RecStructData.OUT_CH[Dfrom].gain;
        }else if(UI_Type==UI_OutMute){
            
        }else if(UI_Type==UI_OutPolar){
            if(BOOL_LinkPolar){
                RecStructData.OUT_CH[Dto].polar=RecStructData.OUT_CH[Dfrom].polar;
            }
        }else if(UI_Type==UI_EQ_BW){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].bw
            =RecStructData.OUT_CH[Dfrom].EQ[eqIndex].bw;
        }else if(UI_Type==UI_EQ_Freq){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].freq
            =RecStructData.OUT_CH[Dfrom].EQ[eqIndex].freq;
        }else if(UI_Type==UI_EQ_Level){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].level
            =RecStructData.OUT_CH[Dfrom].EQ[eqIndex].level;
        }else if(UI_Type==UI_EQ_G_P_MODE_EQ){
            RecStructData.OUT_CH[Dto].eq_mode
            =RecStructData.OUT_CH[Dfrom].eq_mode;
        }else if(UI_Type==UI_EQ_ALL){
            for(int j=0;j<OUT_CH_EQ_MAX;j++){
                RecStructData.OUT_CH[Dto].EQ[j].freq=RecStructData.OUT_CH[Dfrom].EQ[j].freq;
                RecStructData.OUT_CH[Dto].EQ[j].level=RecStructData.OUT_CH[Dfrom].EQ[j].level;
                RecStructData.OUT_CH[Dto].EQ[j].bw=RecStructData.OUT_CH[Dfrom].EQ[j].bw;
                RecStructData.OUT_CH[Dto].EQ[j].shf_db=RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
                RecStructData.OUT_CH[Dto].EQ[j].type=RecStructData.OUT_CH[Dfrom].EQ[j].type;
            }
        }
        
    }
}

//前声场，后声场，超低的联调，一起联调
void LINK_MODE_FRS_A(){
    
}
//前声场，后声场，单独分开
void LINK_MODE_FR(){
    
}

//前声场，后声场，中置超低的联调，一起联调
void LINK_MODE_FR_A(){
    
}

//设置通道输出类型后的联调
void LINK_MODE_SPKTYPE(){
    
}
//前声场，后声场，一起两两联调
void LINK_MODE_FR2A(){
    
}
//设置通道输出类型后的联调，可联机保存
void LINK_MODE_SPKTYPE_S(){
    int Dfrom=output_channel_sel;
    int Dto=0xff;
    //同时刷新连接状态
    if((!BOOL_LOCK)||(ChannelLinkCnt==0)){
        return;//没有联调
    }
    Dfrom = output_channel_sel;
    for(int i=0;i<ChannelLinkCnt;i++){
        if(ChannelLinkBuf[i][0]==output_channel_sel){
            Dto=ChannelLinkBuf[i][1];
        }else if(ChannelLinkBuf[i][1]==output_channel_sel){
            Dto=ChannelLinkBuf[i][0];
        }
    }
    if(Dto < Output_CH_MAX){
        
        if(UI_Type==UI_HFilter){
            RecStructData.OUT_CH[Dto].h_filter=RecStructData.OUT_CH[Dfrom].h_filter;
        }else if(UI_Type==UI_HOct){
            RecStructData.OUT_CH[Dto].h_level=RecStructData.OUT_CH[Dfrom].h_level;
        }else if(UI_Type==UI_HFreq){
            RecStructData.OUT_CH[Dto].h_freq=RecStructData.OUT_CH[Dfrom].h_freq;
        }else if(UI_Type==UI_LFilter){
            RecStructData.OUT_CH[Dto].l_filter=RecStructData.OUT_CH[Dfrom].l_filter;
        }else if(UI_Type==UI_LOct){
            RecStructData.OUT_CH[Dto].l_level=RecStructData.OUT_CH[Dfrom].l_level;
        }else if(UI_Type==UI_LFreq){
            RecStructData.OUT_CH[Dto].l_freq=RecStructData.OUT_CH[Dfrom].l_freq;
        }else if(UI_Type==UI_OutVal){
            RecStructData.OUT_CH[Dto].gain = RecStructData.OUT_CH[Dfrom].gain;
        }else if(UI_Type==UI_OutMute){
            
        }else if(UI_Type==UI_OutPolar){
            if(BOOL_LinkPolar){
                RecStructData.OUT_CH[Dto].polar=RecStructData.OUT_CH[Dfrom].polar;
            }
        }else if(UI_Type==UI_EQ_BW){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].bw=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].bw;
        }else if(UI_Type==UI_EQ_Freq){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].freq=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].freq;
        }else if(UI_Type==UI_EQ_Level){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].level=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].level;
        }else if(UI_Type==UI_EQ_G_P_MODE_EQ){
            RecStructData.OUT_CH[Dto].eq_mode=RecStructData.OUT_CH[Dfrom].eq_mode;
        }else if(UI_Type==UI_EQ_ALL){
            for(int j=0;j<OUT_CH_EQ_MAX;j++){
                RecStructData.OUT_CH[Dto].EQ[j].freq  =RecStructData.OUT_CH[Dfrom].EQ[j].freq;
                RecStructData.OUT_CH[Dto].EQ[j].level =RecStructData.OUT_CH[Dfrom].EQ[j].level;
                RecStructData.OUT_CH[Dto].EQ[j].bw    =RecStructData.OUT_CH[Dfrom].EQ[j].bw;
                RecStructData.OUT_CH[Dto].EQ[j].shf_db=RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
                RecStructData.OUT_CH[Dto].EQ[j].type  =RecStructData.OUT_CH[Dfrom].EQ[j].type;
            }
        }else if(UI_Type==UI_Delay){
            RecStructData.OUT_CH[Dto].delay = RecStructData.OUT_CH[Dfrom].delay;
        }
    }
}

//任意联调，每个通道可以单独联调，可联机保存
//任意联调，每个通道可以单独联调，可联机保存
void LINK_MODE_AUTO(){
    int sumGL=0;
    for(int i=0;i<Output_CH_MAX_USE;i++){
        sumGL += RecStructData.OUT_CH[i].IN23_Vol;
    }
    if(sumGL==0){
        return;//没有联调
    }
    int GL_NUM=RecStructData.OUT_CH[output_channel_sel].IN23_Vol;
    if(GL_NUM <= 0){
        return;
    }
    if(LG.Data[GL_NUM].cnt <= 1){
        return;//此联调组只有一个成员或者是没有成员，则返回
    }
    NSLog(@"---------------------");
    for(int i=0;i<LG.Data[GL_NUM].cnt;i++){
        NSLog(@"--=%d",LG.Data[GL_NUM].group[i]);
    }
    //计算联调组有多少个成员
    int gmem=LG.Data[GL_NUM].cnt;
    int Dfrom = output_channel_sel;
    if(UI_Type == UI_HFilter){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].h_filter=RecStructData.OUT_CH[Dfrom].h_filter;
        }
    }else if(UI_Type == UI_HOct){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].h_level=RecStructData.OUT_CH[Dfrom].h_level;
        }
        
    }else if(UI_Type == UI_HFreq){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].h_freq=RecStructData.OUT_CH[Dfrom].h_freq;
        }
    }else if(UI_Type == UI_LFilter){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].l_filter=RecStructData.OUT_CH[Dfrom].l_filter;
        }
        
    }else if(UI_Type == UI_LOct){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].l_level=RecStructData.OUT_CH[Dfrom].l_level;
        }
    }else if(UI_Type == UI_LFreq){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].l_freq=RecStructData.OUT_CH[Dfrom].l_freq;
        }
        
    }else if(UI_Type == UI_OutVal){
        int DfromGain =RecStructData.OUT_CH[Dfrom].gain;
        for(int i=0;i<gmem;i++){
            int value=RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].gain+AutoLinkValue;
            if (value>Output_Volume_MAX) {
                value=Output_Volume_MAX;
            }else if(value<0){
                value=0;
            }
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].gain =value;
        }
        RecStructData.OUT_CH[Dfrom].gain=DfromGain;
    }else if(UI_Type == UI_OutMute){
        if(BOOL_LinkMute){
            for(int i=0;i<gmem;i++){
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].mute = RecStructData.OUT_CH[Dfrom].mute;
            }
        }
    }else if(UI_Type == UI_OutPolar){
        if(BOOL_LinkPolar){
            for(int i=0;i<gmem;i++){
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].polar = RecStructData.OUT_CH[Dfrom].polar;
            }
        }
    }else if(UI_Type == UI_EQ_BW){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[eqIndex].bw=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].bw;
        }
    }else if(UI_Type == UI_EQ_Freq){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[eqIndex].freq=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].freq;
        }
    }else if(UI_Type == UI_EQ_Level){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[eqIndex].level=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].level;
        }
    }else if(UI_Type == UI_EQ_G_P_MODE_EQ){
        for(int i=0;i<gmem;i++){
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].eq_mode=RecStructData.OUT_CH[Dfrom].eq_mode;
        }
    }else if(UI_Type == UI_EQ_ALL){
        for(int i=0;i<gmem;i++){
            for(int j=0;j<Output_CH_MAX_USE;j++){
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[j].freq=RecStructData.OUT_CH[Dfrom].EQ[j].freq;
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[j].level=RecStructData.OUT_CH[Dfrom].EQ[j].level;
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[j].bw=RecStructData.OUT_CH[Dfrom].EQ[j].bw;
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[j].shf_db=RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].EQ[j].type=RecStructData.OUT_CH[Dfrom].EQ[j].type;
            }
        }
    }else if(UI_Type==UI_Delay){
        int dfromDelay=RecStructData.OUT_CH[Dfrom].delay;
        for(int i=0;i<gmem;i++){
            
            RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay=RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay+AutoLinkValue;
            if (RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay>DELAY_SETTINGS_MAX) {
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay=DELAY_SETTINGS_MAX;
            }else if(RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay<0){
                RecStructData.OUT_CH[LG.Data[GL_NUM].group[i]].delay=0;
            }
        }
        RecStructData.OUT_CH[Dfrom].delay=dfromDelay;
    }
}


//固定两两通道联调
void LINK_MODE_LEFTRIGHT(){
    int Dfrom=output_channel_sel;
    int Dto=0xff;
    //同时刷新连接状态
    if(!BOOL_LOCK){
        return;//没有联调
    }
    Dfrom = output_channel_sel;
    for(int i=0;i<Output_CH_MAX/2;i++){
        if(i*2==output_channel_sel){
            Dto=i*2 + 1;
            break;
        }else if((i*2+1)==output_channel_sel){
            Dto=i*2;
            break;
        }
    }
    if(Dto < Output_CH_MAX){
        if(UI_Type==UI_HFilter){
            RecStructData.OUT_CH[Dto].h_filter=RecStructData.OUT_CH[Dfrom].h_filter;
        }else if(UI_Type==UI_HOct){
            RecStructData.OUT_CH[Dto].h_level=RecStructData.OUT_CH[Dfrom].h_level;
        }else if(UI_Type==UI_HFreq){
            RecStructData.OUT_CH[Dto].h_freq=RecStructData.OUT_CH[Dfrom].h_freq;
        }else if(UI_Type==UI_LFilter){
            RecStructData.OUT_CH[Dto].l_filter=RecStructData.OUT_CH[Dfrom].l_filter;
        }else if(UI_Type==UI_LOct){
            RecStructData.OUT_CH[Dto].l_level=RecStructData.OUT_CH[Dfrom].l_level;
        }else if(UI_Type==UI_LFreq){
            RecStructData.OUT_CH[Dto].l_freq=RecStructData.OUT_CH[Dfrom].l_freq;
        }else if(UI_Type==UI_OutVal){
            RecStructData.OUT_CH[Dto].gain = RecStructData.OUT_CH[Dfrom].gain;
        }else if(UI_Type==UI_OutMute){
            
        }else if(UI_Type==UI_OutPolar){
            if(BOOL_LinkPolar){
                RecStructData.OUT_CH[Dto].polar=RecStructData.OUT_CH[Dfrom].polar;
            }
        }else if(UI_Type==UI_EQ_BW){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].bw=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].bw;
        }else if(UI_Type==UI_EQ_Freq){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].freq=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].freq;
        }else if(UI_Type==UI_EQ_Level){
            RecStructData.OUT_CH[Dto].EQ[eqIndex].level=RecStructData.OUT_CH[Dfrom].EQ[eqIndex].level;
        }else if(UI_Type==UI_EQ_G_P_MODE_EQ){
            RecStructData.OUT_CH[Dto].eq_mode=RecStructData.OUT_CH[Dfrom].eq_mode;
        }else if(UI_Type==UI_EQ_ALL){
            for(int j=0;j<OUT_CH_EQ_MAX;j++){
                RecStructData.OUT_CH[Dto].EQ[j].freq  =RecStructData.OUT_CH[Dfrom].EQ[j].freq;
                RecStructData.OUT_CH[Dto].EQ[j].level =RecStructData.OUT_CH[Dfrom].EQ[j].level;
                RecStructData.OUT_CH[Dto].EQ[j].bw    =RecStructData.OUT_CH[Dfrom].EQ[j].bw;
                RecStructData.OUT_CH[Dto].EQ[j].shf_db=RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
                RecStructData.OUT_CH[Dto].EQ[j].type  =RecStructData.OUT_CH[Dfrom].EQ[j].type;
            }
        }
    }
}

void copyGroupData(int Dfrom, int Dto){
    for(int j=0;j<Output_CH_EQ_MAX_USE;j++){
        RecStructData.OUT_CH[Dto].EQ[j].freq   = RecStructData.OUT_CH[Dfrom].EQ[j].freq;
        RecStructData.OUT_CH[Dto].EQ[j].bw     = RecStructData.OUT_CH[Dfrom].EQ[j].bw;
        RecStructData.OUT_CH[Dto].EQ[j].shf_db = RecStructData.OUT_CH[Dfrom].EQ[j].shf_db;
        RecStructData.OUT_CH[Dto].EQ[j].type   = RecStructData.OUT_CH[Dfrom].EQ[j].type;
    }
    //id = 31    杂项  （静音，延时,spk_type不联调）
    RecStructData.OUT_CH[Dto].polar=RecStructData.OUT_CH[Dfrom].polar;
    RecStructData.OUT_CH[Dto].eq_mode=RecStructData.OUT_CH[Dfrom].eq_mode;
    //高低通 ,ID = 32    (xover限MIC)

    RecStructData.OUT_CH[Dto].h_filter = RecStructData.OUT_CH[Dfrom].h_filter;
    RecStructData.OUT_CH[Dto].h_level  = RecStructData.OUT_CH[Dfrom].h_level;
    RecStructData.OUT_CH[Dto].l_filter = RecStructData.OUT_CH[Dfrom].l_filter;
    RecStructData.OUT_CH[Dto].l_level  = RecStructData.OUT_CH[Dfrom].l_level;
}
void copyGroupData_IN(int Dfrom, int Dto){
    for(int j=0;j<IN_CH_EQ_MAX_USE;j++){
        RecStructData.IN_CH[Dto].EQ[j].freq   = RecStructData.IN_CH[Dfrom].EQ[j].freq;
        RecStructData.IN_CH[Dto].EQ[j].bw     = RecStructData.IN_CH[Dfrom].EQ[j].bw;
        RecStructData.IN_CH[Dto].EQ[j].shf_db = RecStructData.IN_CH[Dfrom].EQ[j].shf_db;
        RecStructData.IN_CH[Dto].EQ[j].type   = RecStructData.IN_CH[Dfrom].EQ[j].type;
    }
    //id = 31    杂项  （静音，延时,spk_type不联调）
 
    RecStructData.IN_CH[Dto].polar=RecStructData.IN_CH[Dfrom].polar;
    RecStructData.IN_CH[Dto].eq_mode=RecStructData.IN_CH[Dfrom].eq_mode;
    
    //高低通 ,ID = 32    (xover限MIC)
    RecStructData.IN_CH[Dto].h_filter = RecStructData.IN_CH[Dfrom].h_filter;
    RecStructData.IN_CH[Dto].h_level  = RecStructData.IN_CH[Dfrom].h_level;
    RecStructData.IN_CH[Dto].l_filter = RecStructData.IN_CH[Dfrom].l_filter;
    RecStructData.IN_CH[Dto].l_level  = RecStructData.IN_CH[Dfrom].l_level;
}
void setDataSyncLink(void){
    //前声场，后声场，超低的联调，单独分开
    if(LinkMODE == LINKMODE_FRS){
        
    }
    //前声场，后声场，超低的联调，一起联调
    else if(LinkMODE == LINKMODE_FRS_A){
        
    }
    //前声场，后声场，单独分开
    else if(LinkMODE == LINKMODE_FR){
        
    }
    //前声场，后声场，中置超低的联调，一起联调
    else if(LinkMODE == LINKMODE_FR_A){
        
    }
    //设置通道输出类型后的联调
    else if(LinkMODE == LINKMODE_SPKTYPE){
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        
        for(int i=0;i<ChannelLinkCnt;i++){
            
            if(BOOL_LeftCyRight){
                copyGroupData(ChannelLinkBuf[i][0], ChannelLinkBuf[i][1]);
            }else{
                copyGroupData(ChannelLinkBuf[i][1], ChannelLinkBuf[i][0]);
            }
        }
    }
    //设置通道输出类型后的联调，可联机保存
    else if(LinkMODE == LINKMODE_SPKTYPE_S){
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        
        for(int i=0;i<ChannelLinkCnt;i++){
            
            if(BOOL_LeftCyRight){
                copyGroupData(ChannelLinkBuf[i][0], ChannelLinkBuf[i][1]);
            }else{
                copyGroupData(ChannelLinkBuf[i][1], ChannelLinkBuf[i][0]);
            }
        }
    }
    //任意联调，每个通道可以单独联调，可联机保存
    else if(LinkMODE == LINKMODE_AUTO){
        LINK_MODE_AUTO();
    }
    //固定两两通道联调
    else if(LinkMODE == LINKMODE_LEFTRIGHT){
        if(BOOL_LeftCyRight){
            for(int i=0;i<Output_CH_MAX/2;i++){
                copyGroupData(i*2,1+i*2);
            }
        }else{
            for(int i=0;i<Output_CH_MAX/2;i++){
                copyGroupData(1+i*2,i*2);
            }
        }
    }
    //前声场，后声场，一起两两联调
    else if(LinkMODE == LINKMODE_FR2A){
        
    }
}

void INS_DataCopy(int Dfrom, int Dto){
    for(int j=0;j<INS_CH_EQ_MAX_USE;j++){
        RecStructData.INS_CH[Dto].EQ[j].freq   = RecStructData.INS_CH[Dfrom].EQ[j].freq;
        RecStructData.INS_CH[Dto].EQ[j].level  = RecStructData.INS_CH[Dfrom].EQ[j].level;
        RecStructData.INS_CH[Dto].EQ[j].bw     = RecStructData.INS_CH[Dfrom].EQ[j].bw;
        RecStructData.INS_CH[Dto].EQ[j].shf_db = RecStructData.INS_CH[Dfrom].EQ[j].shf_db;
        RecStructData.INS_CH[Dto].EQ[j].type   = RecStructData.INS_CH[Dfrom].EQ[j].type;
    }
    //杂项  （静音，延时,spk_type不联调）
    RecStructData.INS_CH[Dto].feedback= RecStructData.INS_CH[Dfrom].feedback;
    RecStructData.INS_CH[Dto].polar   = RecStructData.INS_CH[Dfrom].polar;
    RecStructData.INS_CH[Dto].eq_mode = RecStructData.INS_CH[Dfrom].eq_mode;
    RecStructData.INS_CH[Dto].mute    = RecStructData.INS_CH[Dfrom].mute;
    RecStructData.INS_CH[Dto].delay   = RecStructData.INS_CH[Dfrom].delay;
    RecStructData.INS_CH[Dto].Valume  = RecStructData.INS_CH[Dfrom].Valume;
    //高低通 (xover限MIC)
    RecStructData.INS_CH[Dto].h_freq   = RecStructData.INS_CH[Dfrom].h_freq;
    RecStructData.INS_CH[Dto].h_filter = RecStructData.INS_CH[Dfrom].h_filter;
    RecStructData.INS_CH[Dto].h_level  = RecStructData.INS_CH[Dfrom].h_level;
    RecStructData.INS_CH[Dto].l_freq   = RecStructData.INS_CH[Dfrom].l_freq;
    RecStructData.INS_CH[Dto].l_filter = RecStructData.INS_CH[Dfrom].l_filter;
    RecStructData.INS_CH[Dto].l_level  = RecStructData.INS_CH[Dfrom].l_level;
}
#pragma 外部函数
void FillRecDataStruct_INS_FromArray(uint8 ch, uint8 initData[]){
    uint16 initDataCnt = 0;
    //---id = 9        杂项
    RecStructData.INS_CH[ch].feedback = initData[initDataCnt];
    RecStructData.INS_CH[ch].polar    = initData[++initDataCnt];
    RecStructData.INS_CH[ch].eq_mode  = initData[++initDataCnt];
    RecStructData.INS_CH[ch].mute     = initData[++initDataCnt];
    RecStructData.INS_CH[ch].delay    = initData[++initDataCnt];
    RecStructData.INS_CH[ch].delay    +=initData[++initDataCnt]*256;
    RecStructData.INS_CH[ch].Valume   = initData[++initDataCnt];
    RecStructData.INS_CH[ch].Valume   +=initData[++initDataCnt]*256;
    //高低通 ,ID = 10
    RecStructData.INS_CH[ch].h_freq   = initData[++initDataCnt];
    RecStructData.INS_CH[ch].h_freq   +=initData[++initDataCnt]*256;
    RecStructData.INS_CH[ch].h_filter = initData[++initDataCnt];
    RecStructData.INS_CH[ch].h_level  = initData[++initDataCnt];
    RecStructData.INS_CH[ch].l_freq   = initData[++initDataCnt];
    RecStructData.INS_CH[ch].l_freq   +=initData[++initDataCnt]*256;
    RecStructData.INS_CH[ch].l_filter = initData[++initDataCnt];
    RecStructData.INS_CH[ch].l_level  = initData[++initDataCnt];
    //NSLog(@"------------------------------------------------");
    //EQ
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        RecStructData.INS_CH[ch].EQ[i].freq  = initData[++initDataCnt];
        RecStructData.INS_CH[ch].EQ[i].freq  +=initData[++initDataCnt]*256;
        RecStructData.INS_CH[ch].EQ[i].level = initData[++initDataCnt];
        RecStructData.INS_CH[ch].EQ[i].level +=initData[++initDataCnt]*256;
        RecStructData.INS_CH[ch].EQ[i].bw    = initData[++initDataCnt];
        RecStructData.INS_CH[ch].EQ[i].bw    +=initData[++initDataCnt]*256;
        RecStructData.INS_CH[ch].EQ[i].shf_db= initData[++initDataCnt];
        RecStructData.INS_CH[ch].EQ[i].type  = initData[++initDataCnt];
        
        //NSLog(@"Encryption EQ[@%d].level=@%d",ch,RecStructData.INS_CH[ch].EQ[i].level);
    }
    
}

void FillRecDataStructFromArray(uint8 DataStruchID, uint8 ChannelID, uint8 initData[]) {
    uint16 initDataCnt = 0;
    /*从下面机器读取的要去通信字*/
    if(BOOL_ENCRYPTION){
        //第一通判断数据是否加密，298=296+10-8
        if((ChannelID == 0) && (DataStruchID == OUTPUT)){
            NSLog(@"FillRecDataStructFromArray Encryption Flag=@%d",initData[288]);
            if(initData[288] != EncryptionFlag){//非加密
                BOOL_EncryptionFlag = false;
            }else if(initData[288] == EncryptionFlag){//加密
                BOOL_EncryptionFlag = true;
                for(int i = 0;i < OUT_LEN;i++){
                    if(i!=288){
                        if(i!=289){
                            initData[i]=initData[i]^Encrypt_DATA;
                        }
                    }
                }
            }
        }
        //若第一通判断数据加密，其他通道也加密
        if((ChannelID > 0)&&(BOOL_EncryptionFlag)&&(DataStruchID == OUTPUT)){
            for(int i=0;i<OUT_LEN;i++){
                if(i!=288){
                    initData[i]=initData[i]^Encrypt_DATA;
                }
            }
        }
    }
    /*初始化数据结构的ID*/
    if(DataStruchID == EFF){
        
    }else if(DataStruchID == MUSIC){
        if(BOOL_USE_INS){
            for(int ch=0;ch<INS_CH_MAX;ch++){
                //---id = 9        杂项
                RecStructData.INS_CH[ch].feedback = initData[initDataCnt];
                RecStructData.INS_CH[ch].polar    = initData[++initDataCnt];
                RecStructData.INS_CH[ch].eq_mode  = initData[++initDataCnt];
                RecStructData.INS_CH[ch].mute     = initData[++initDataCnt];
                RecStructData.INS_CH[ch].delay    = initData[++initDataCnt];
                RecStructData.INS_CH[ch].delay    +=initData[++initDataCnt]*256;
                RecStructData.INS_CH[ch].Valume   = initData[++initDataCnt];
                RecStructData.INS_CH[ch].Valume   +=initData[++initDataCnt]*256;
                //高低通 ,ID = 10
                RecStructData.INS_CH[ch].h_freq   = initData[++initDataCnt];
                RecStructData.INS_CH[ch].h_freq   +=initData[++initDataCnt]*256;
                RecStructData.INS_CH[ch].h_filter = initData[++initDataCnt];
                RecStructData.INS_CH[ch].h_level  = initData[++initDataCnt];
                RecStructData.INS_CH[ch].l_freq   = initData[++initDataCnt];
                RecStructData.INS_CH[ch].l_freq   +=initData[++initDataCnt]*256;
                RecStructData.INS_CH[ch].l_filter = initData[++initDataCnt];
                RecStructData.INS_CH[ch].l_level  = initData[++initDataCnt];
                //NSLog(@"------------------------------------------------");
                //EQ
                for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
                    RecStructData.INS_CH[ch].EQ[i].freq  = initData[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].freq  +=initData[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].level = initData[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].level +=initData[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].bw    = initData[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].bw    +=initData[++initDataCnt]*256;
                    RecStructData.INS_CH[ch].EQ[i].shf_db= initData[++initDataCnt];
                    RecStructData.INS_CH[ch].EQ[i].type  = initData[++initDataCnt];
                    
                    //NSLog(@"Encryption EQ[@%d].level=@%d",ch,RecStructData.INS_CH[ch].EQ[i].level);
                }
                ++initDataCnt;
            }
        }else{
            //EQ
            for(int i = 0;i< IN_CH_EQ_MAX;i++){
                RecStructData.IN_CH[ChannelID].EQ[i].freq  = initData[initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].freq  +=initData[++initDataCnt]*256;
                RecStructData.IN_CH[ChannelID].EQ[i].level = initData[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].level +=initData[++initDataCnt]*256;
                RecStructData.IN_CH[ChannelID].EQ[i].bw    = initData[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].bw    +=initData[++initDataCnt]*256;
                RecStructData.IN_CH[ChannelID].EQ[i].shf_db= initData[++initDataCnt];
                RecStructData.IN_CH[ChannelID].EQ[i].type  = initData[++initDataCnt];
                ++initDataCnt;
            }
            //---id = 10        杂项
            RecStructData.IN_CH[ChannelID].mute     = initData[initDataCnt];
            RecStructData.IN_CH[ChannelID].polar    = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].gain   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].gain   +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].delay    = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].delay    +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].eq_mode  = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].LinkFlag = initData[++initDataCnt];
            //高低通 ,ID = 11
            RecStructData.IN_CH[ChannelID].h_freq   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].h_freq   +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].h_filter = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].h_level  = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_freq   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_freq   +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].l_filter = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].l_level  = initData[++initDataCnt];
            //噪声门 ,ID = 12
            RecStructData.IN_CH[ChannelID].noisegate_t   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_a   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_k   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_k   +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].noisegate_r   = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noisegate_r   +=initData[++initDataCnt]*256;
            RecStructData.IN_CH[ChannelID].noise_config  = initData[++initDataCnt];
            RecStructData.IN_CH[ChannelID].noise_config  +=initData[++initDataCnt]*256;
            //压限 ,ID = 12
//            RecStructData.IN_CH[ChannelID].IN17_Vol    = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN17_Vol    +=initData[++initDataCnt]*256;
//            RecStructData.IN_CH[ChannelID].IN18_Vol    = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN19_Vol    = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN20_Vol  = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN21_Vol = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].IN22_Vol = initData[++initDataCnt];
//            RecStructData.IN_CH[ChannelID].comp_swi = initData[++initDataCnt];
            //name[8] ID = 13
            for(int i=0;i<8;i++){
                RecStructData.IN_CH[ChannelID].name[i] = initData[++initDataCnt];
            }
        }
        
    }else if(DataStruchID == OUTPUT){
        //EQ
        for(int i = 0; i < OUT_CH_EQ_MAX; i++){
            RecStructData.OUT_CH[ChannelID].EQ[i].freq   = initData[initDataCnt]  ;
            RecStructData.OUT_CH[ChannelID].EQ[i].freq   +=initData[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].level  = initData[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].level  +=initData[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].bw     = initData[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].bw     +=initData[++initDataCnt]*256;
            RecStructData.OUT_CH[ChannelID].EQ[i].shf_db = initData[++initDataCnt];
            RecStructData.OUT_CH[ChannelID].EQ[i].type   = initData[++initDataCnt];
            ++initDataCnt;
            //检测数据是否异常
            if((RecStructData.OUT_CH[ChannelID].EQ[i].level < EQ_LEVEL_MIN)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].level > EQ_LEVEL_MAX)){
                // U0SynDataError = true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].EQ[i].bw < 0)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].bw > EQ_BW_MAX)){
                // U0SynDataError=true;
            }
            
            if((RecStructData.OUT_CH[ChannelID].EQ[i].freq<20)
               ||(RecStructData.OUT_CH[ChannelID].EQ[i].freq>20000)){
                // U0SynDataError=true;
            }
        }
        //id = 31        杂项
        RecStructData.OUT_CH[ChannelID].mute     = initData[initDataCnt];
        RecStructData.OUT_CH[ChannelID].polar    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].gain     = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].gain     +=initData[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].delay    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].delay    +=initData[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].eq_mode  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].LinkFlag = initData[++initDataCnt];
        //检测数据是否异常
        if((RecStructData.OUT_CH[ChannelID].gain < 0)
           ||(RecStructData.OUT_CH[ChannelID].gain > Output_Volume_MAX)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].delay < 0)
           ||(RecStructData.OUT_CH[ChannelID].delay > DELAY_SETTINGS_MAX)){
            //U0SynDataError=true;
        }
        //高低通 ,ID = 32    (xover限MIC)
        RecStructData.OUT_CH[ChannelID].h_freq   = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].h_freq   +=initData[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].h_filter = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].h_level  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_freq   = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_freq   +=initData[++initDataCnt]*256;
        RecStructData.OUT_CH[ChannelID].l_filter = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].l_level  = initData[++initDataCnt];
        //检测数据是否异常
        if((RecStructData.OUT_CH[ChannelID].h_freq < 0)
           ||(RecStructData.OUT_CH[ChannelID].h_freq > 20000)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].h_filter < 0)
           ||(RecStructData.OUT_CH[ChannelID].h_filter > 2)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].h_level < 0)
           ||(RecStructData.OUT_CH[ChannelID].h_level > 7)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].l_freq < 0)
           ||(RecStructData.OUT_CH[ChannelID].l_freq > 20000)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].l_filter < 0)
           ||(RecStructData.OUT_CH[ChannelID].l_filter > 2)){
            //U0SynDataError=true;
        }
        
        if((RecStructData.OUT_CH[ChannelID].l_level < 0)
           ||(RecStructData.OUT_CH[ChannelID].l_level > 7)){
            // U0SynDataError=true;
        }
        // id = 33        混合比例
        RecStructData.OUT_CH[ChannelID].IN1_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN2_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN3_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN4_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN5_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN6_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN7_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN8_Vol  = initData[++initDataCnt];
        // id = 34        保留
        RecStructData.OUT_CH[ChannelID].IN9_Vol     = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN10_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN11_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN12_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN13_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN14_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN15_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN16_Vol    = initData[++initDataCnt];
        //RecStructData.OUT_CH[ChannelID].IN_polar   = initData[++initDataCnt]+initData[++initDataCnt]*256;
        //RecStructData.OUT_CH[ChannelID].none11   = initData[++initDataCnt];
        //检测数据是否异常
        if(BOOL_Mixer){
            if((RecStructData.OUT_CH[ChannelID].IN1_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN1_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN2_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN2_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN3_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN3_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN4_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN4_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN5_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN5_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN6_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN6_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN7_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN7_Vol > Mixer_Volume_MAX)){
                // U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN8_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN8_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN9_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN9_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN10_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN10_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN11_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN11_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN12_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN12_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN13_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN13_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN14_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN14_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN15_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN15_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
            if((RecStructData.OUT_CH[ChannelID].IN16_Vol < 0)
               ||(RecStructData.OUT_CH[ChannelID].IN16_Vol > Mixer_Volume_MAX)){
                //U0SynDataError=true;
            }
        }
        // id = 35        压限
        RecStructData.OUT_CH[ChannelID].IN17_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN18_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN19_Vol    = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN20_Vol  = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN21_Vol = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN22_Vol = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN23_Vol = initData[++initDataCnt];
        RecStructData.OUT_CH[ChannelID].IN24_Vol = initData[++initDataCnt];
        //name[8]  ID = 36
        for(int i=0;i<8;i++){
            RecStructData.OUT_CH[ChannelID].name[i] = initData[++initDataCnt];
        }
        //保存密码
        
        if(BOOL_ENCRYPTION){
            if((ChannelID == 0)&&(BOOL_EncryptionFlag)){
                for(int i = 0; i < 6; i++){
                    Encryption_PasswordBuf[i]=RecStructData.OUT_CH[ChannelID].name[2+i];
                }
            }
        }
        
    }else if(DataStruchID==SYSTEM){
        RecStructData.System.input_source = initData[initDataCnt];
        RecStructData.System.mixer_source = initData[++initDataCnt];
        RecStructData.System.InSwitch[0] = initData[++initDataCnt];
        RecStructData.System.InSwitch[1] = initData[++initDataCnt];
        RecStructData.System.InSwitch[2] = initData[++initDataCnt];
        RecStructData.System.InSwitch[3] = initData[++initDataCnt];
        RecStructData.System.InSwitch[4] = initData[++initDataCnt];
        RecStructData.System.none1 = initData[++initDataCnt];
        
        RecStructData.System.main_vol = initData[++initDataCnt];
        RecStructData.System.main_vol+=initData[++initDataCnt]*256;
        RecStructData.System.high_mode = initData[++initDataCnt];
        RecStructData.System.aux_mode = initData[++initDataCnt];
        RecStructData.System.out_mode = initData[++initDataCnt];
        RecStructData.System.mixer_SourcedB = initData[++initDataCnt];
        RecStructData.System.MainvolMuteFlg = initData[++initDataCnt];
        RecStructData.System.theme = initData[++initDataCnt];
        
//        for (int i=0; i<8; i++) {
//            RecStructData.System.none[i]=initData[++initDataCnt];
//        }
        RecStructData.System.HiInputChNum=initData[++initDataCnt];
        RecStructData.System.AuxInputChNum=initData[++initDataCnt];
        RecStructData.System.OutputChNum=initData[++initDataCnt];
        RecStructData.System.IsRTA_outch=initData[++initDataCnt];
        RecStructData.System.InSignelThreshold=initData[++initDataCnt];
        RecStructData.System.OffTime=initData[++initDataCnt];
        RecStructData.System.none[0]=initData[++initDataCnt];
        RecStructData.System.none[1]=initData[++initDataCnt];
        
        for (int i=0; i<8; i++) {
            RecStructData.System.high_Low_Set[i]=initData[++initDataCnt];
        }
        for (int i=0; i<16; i++) {
            RecStructData.System.in_spk_type[i]=initData[++initDataCnt];
        }
        for (int i=0; i<16; i++) {
            RecStructData.System.out_spk_type[i]=initData[++initDataCnt];
        }
        
    }
}

/*
 * @param DataStruchID:要初始化的数据ID
 * @param ChannelID:要初始化的数据通道ID
 * @param initBuf：赋值的数据
 */
void FillSedDataStruct(int DataStruchID, int initBuf[]) {
    if(DataStruchID == EFF){
        for(int i = 0; i < EFF_LEN; i++){
            ChannelBuf[i] = initBuf[i];
        }
    }else if(DataStruchID == MUSIC){
        if(BOOL_USE_INS){
            for(int i = 0; i < INS_LEN; i++){
                ChannelBuf[i] = initBuf[i];
            }
        }else{
            for(int i = 0; i < IN_LEN; i++){
                ChannelBuf[i] = initBuf[i];
            }
        }
        
    }else if(DataStruchID == OUTPUT){
        for(int i = 0; i < OUT_LEN; i++){
            ChannelBuf[i] = initBuf[i];
        }
    }
}
/*
 * @param DataStruchID:要初始化的数据ID
 * @param ChannelID:要初始化的数据通道ID
 * @param initData：赋值的数据
 * @param dataSize：赋值的数据的大小
 */
void FillSedData_INS_StructCHBuf(int ch) {
    int ChCnt=0;
    
    //---id = 9        杂项
    ChannelBuf[ChCnt]  = (RecStructData.INS_CH[ch].feedback & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].polar & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].eq_mode & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].mute & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].delay & 0xff);
    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].delay >> 8) & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].Valume & 0xff);
    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].Valume >> 8) & 0xff);
    //高低通 ,ID = 10
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_freq & 0xff);
    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].h_freq >> 8) & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_filter & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_level & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_freq & 0xff);
    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].l_freq >> 8) & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_filter & 0xff);
    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_level & 0xff);
    //EQ
    for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
        ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].freq & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].freq >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].level & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].level >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].bw & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].bw >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].shf_db & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].type& 0xff);
    }
}
/*
 * @param DataStruchID:要初始化的数据ID
 * @param ChannelID:要初始化的数据通道ID
 * @param initData：赋值的数据
 * @param dataSize：赋值的数据的大小
 */
void FillSedDataStructCHBuf(int DataStruchID, int ChannelID) {
    int ChCnt=0;
    /*初始化数据结构的ID*/
    if(DataStruchID == EFF){
        
    }else if(DataStruchID == MUSIC){
        if(BOOL_USE_INS){
            for(int ch=0;ch<INS_CH_MAX;ch++){
                //---id = 9        杂项
                ChannelBuf[ChCnt]  = (RecStructData.INS_CH[ch].feedback & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].polar & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].eq_mode & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].mute & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].delay & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].delay >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].Valume & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].Valume >> 8) & 0xff);
                //高低通 ,ID = 10
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_freq & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].h_freq >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_filter & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].h_level & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_freq & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].l_freq >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_filter & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].l_level & 0xff);
                //EQ
                for(int i=0;i<INS_CH_EQ_MAX_USE;i++){
                    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].freq & 0xff);
                    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].freq >> 8) & 0xff);
                    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].level & 0xff);
                    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].level >> 8) & 0xff);
                    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].bw & 0xff);
                    ChannelBuf[++ChCnt]=((RecStructData.INS_CH[ch].EQ[i].bw >> 8) & 0xff);
                    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].shf_db & 0xff);
                    ChannelBuf[++ChCnt]= (RecStructData.INS_CH[ch].EQ[i].type& 0xff);
                }
                ++ChCnt;
            }
        }else{
            //EQ
            for(int i = 0; i < IN_CH_EQ_MAX;i++){
                ChannelBuf[ChCnt]  = (RecStructData.IN_CH[ChannelID].EQ[i].freq & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].freq >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].level & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].level >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].bw & 0xff);
                ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].EQ[i].bw >> 8) & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].shf_db & 0xff);
                ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].EQ[i].type& 0xff);
                ++ChCnt;
            }
            //---id = 10        杂项
            ChannelBuf[ChCnt]  = (RecStructData.IN_CH[ChannelID].mute & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].polar & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].gain & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].gain >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].delay & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].delay >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].eq_mode & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].LinkFlag & 0xff);
            //高低通 ,ID = 11
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_freq & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].h_freq >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_filter & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].h_level & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_freq & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].l_freq >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_filter & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].l_level & 0xff);
            //噪声门 ,ID = 12
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_t & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_a & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_k & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noisegate_k >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noisegate_r & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noisegate_r >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.IN_CH[ChannelID].noise_config & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.IN_CH[ChannelID].noise_config >> 8) & 0xff);
            //压限 ,ID = 12
            //name[8] ID = 13
            for(int i=0;i<8;i++){
                ChannelBuf[++ChCnt]=RecStructData.OUT_CH[5].name[i];
            }
        }
        
        
    }else if(DataStruchID == OUTPUT){
        for(int i = 0; i < OUT_CH_EQ_MAX; i++){
            ChannelBuf[ChCnt]  = (RecStructData.OUT_CH[ChannelID].EQ[i].freq & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].freq >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].level & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].level >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].bw & 0xff);
            ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].EQ[i].bw >> 8) & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].shf_db & 0xff);
            ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].EQ[i].type& 0xff);
            ++ChCnt;
        }
        //id = 31        杂项
        ChannelBuf[ChCnt]  = (RecStructData.OUT_CH[ChannelID].mute & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].polar & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].gain & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].gain >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].delay & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].delay >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].eq_mode & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].LinkFlag & 0xff);
        //高低通 ,ID = 32    (xover限MIC)
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_freq & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].h_freq >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_filter & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].h_level & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_freq & 0xff);
        ChannelBuf[++ChCnt]=((RecStructData.OUT_CH[ChannelID].l_freq >> 8) & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_filter & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].l_level & 0xff);
        // id = 33        混合比例
        //高低通 ,ID = 32    (xover限MIC)
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN1_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN2_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN3_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN4_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN5_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN6_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN7_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN8_Vol & 0xff);
        // id = 34        保留
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN9_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN10_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN11_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN12_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN13_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN14_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN15_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN16_Vol & 0xff);
        //ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN_polar & 0xff);
        //ChannelBuf[++ChCnt]= ((RecStructData.OUT_CH[ChannelID].IN_polar >> 8) & 0xff);
        // id = 35        压限
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN17_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN18_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN19_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN20_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN21_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN22_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN23_Vol & 0xff);
        ChannelBuf[++ChCnt]= (RecStructData.OUT_CH[ChannelID].IN24_Vol & 0xff);
        //name[8]  ID = 36
        for(int i=0;i<8;i++){
            ChannelBuf[++ChCnt]=RecStructData.OUT_CH[ChannelID].name[i];
        }
        
        if(BOOL_ENCRYPTION){
            if(BOOL_EncryptionFlag){//加密
                for(int i=0;i<OUT_LEN;i++){
                    ChannelBuf[i]=(ChannelBuf[i]^Encrypt_DATA);
                }
                if(ChannelID == 0){
                    //加密标志,联调标志不加密
                    ChannelBuf[OUT_LEN-8] = EncryptionFlag;
                    //ChannelBuf[OUT_LEN-7] = RecStructData.OUT_CH[0].name[1];
                    for(int i=0;i<6;i++){
                        ChannelBuf[OUT_LEN-6+i]=(Encryption_PasswordBuf[i]^Encrypt_DATA);
                    }
                }
            }else{//非加密
                ChannelBuf[OUT_LEN-8] = DecipheringFlag;
            }
        }
    }
}
/******* 读取延时数据   *******/
void FillDelayDataBySystemChannel(){
    int initDataCnt=0;
    if(DELAY_DATA_TRANSFER == COM_TYPE_SYSTEM){
        RecStructData.OUT_CH[0].delay=RecStructData.SoundFieldSystem.SoundDelayField[initDataCnt];
        RecStructData.OUT_CH[0].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
        RecStructData.OUT_CH[1].delay=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt];
        RecStructData.OUT_CH[1].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
        RecStructData.OUT_CH[2].delay=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt];
        RecStructData.OUT_CH[2].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
        RecStructData.OUT_CH[3].delay=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt];
        RecStructData.OUT_CH[3].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
        RecStructData.OUT_CH[4].delay=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt];
        RecStructData.OUT_CH[4].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
        RecStructData.OUT_CH[5].delay=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt];
        RecStructData.OUT_CH[5].delay+=RecStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]*256;
    }
}
/* 发送系统延时数据时打包 */
void SendDelayDatabySystemChannel(){
    int initDataCnt=0;
    SendStructData.SoundFieldSystem.SoundDelayField[initDataCnt]  = (RecStructData.OUT_CH[0].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[0].delay >> 8) & 0xff);
    
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]= (RecStructData.OUT_CH[1].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[1].delay >> 8) & 0xff);
    
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]= (RecStructData.OUT_CH[2].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[2].delay >> 8) & 0xff);
    
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]= (RecStructData.OUT_CH[3].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[3].delay >> 8) & 0xff);
    
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]= (RecStructData.OUT_CH[4].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[4].delay >> 8) & 0xff);
    
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]= (RecStructData.OUT_CH[5].delay & 0xff);
    SendStructData.SoundFieldSystem.SoundDelayField[++initDataCnt]=((RecStructData.OUT_CH[5].delay >> 8) & 0xff);
    
}
void setOutputSpkType(int type,int ch){
    ChannelNumBuf[ch]= RecStructData.System.out_spk_type[ch]=type;

}
#pragma mark -----------//初始化系统结构数据
void initSystemDataStruct(){
    SendStructData.System.input_source = RecStructData.System.input_source=2;
    SendStructData.System.mixer_source = RecStructData.System.mixer_source=0;
    SendStructData.System.none1 = RecStructData.System.none1=0;
    
    SendStructData.System.main_vol = RecStructData.System.main_vol=38;
    SendStructData.System.high_mode = RecStructData.System.high_mode=0;
    SendStructData.System.aux_mode = RecStructData.System.aux_mode=0;
    SendStructData.System.out_mode = RecStructData.System.out_mode=0;
    SendStructData.System.mixer_SourcedB = RecStructData.System.mixer_SourcedB=0;
    SendStructData.System.MainvolMuteFlg = RecStructData.System.MainvolMuteFlg=0;
    SendStructData.System.theme = RecStructData.System.theme=0;
    for (int i=0; i<5; i++) {
         SendStructData.System.InSwitch[i] = RecStructData.System.InSwitch[i]=1;
    }
    SendStructData.System.OutputChNum=RecStructData.System.OutputChNum=16;
    SendStructData.System.HiInputChNum=RecStructData.System.HiInputChNum=4;
    SendStructData.System.AuxInputChNum=RecStructData.System.AuxInputChNum=4;
    for (int i=0; i<8; i++) {
        if (i<2) {
           SendStructData.System.high_Low_Set[i]=RecStructData.System.high_Low_Set[i]=1;
        }else{
            SendStructData.System.high_Low_Set[i]=RecStructData.System.high_Low_Set[i]=0;
        }
    }
}
#pragma mark-----数据初始化
void initDataStruct(){
    
    initJsonMacData();
    if(BOOL_USE_INS){
        FillRecDataStructFromArray(MUSIC, 0, inputs_init_data);
    }else{
        for(int i = 0; i < Input_CH_MAX; i++){
            FillRecDataStructFromArray(MUSIC, i, Input_init_micdata);
        }
    }
    
    if(Output_CH_EQ_MAX_USE == 10){
        FillRecDataStructFromArray(OUTPUT, 0, Output1_init_data_ofEQ10);
        FillRecDataStructFromArray(OUTPUT, 1, Output2_init_data_ofEQ10);
        FillRecDataStructFromArray(OUTPUT, 2, Output3_init_data_ofEQ10);
        FillRecDataStructFromArray(OUTPUT, 3, Output4_init_data_ofEQ10);
        FillRecDataStructFromArray(OUTPUT, 4, Output5_init_data_ofEQ10);
        FillRecDataStructFromArray(OUTPUT, 5, Output6_init_data_ofEQ10);
        if(Output_CH_MAX == 8){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ10);
        }else if(Output_CH_MAX == 10){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 8, Output9_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 9, Output10_init_data_ofEQ10);
        }else if(Output_CH_MAX == 12){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 8, Output9_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 9, Output10_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 10, Output11_init_data_ofEQ10);
            FillRecDataStructFromArray(OUTPUT, 11, Output12_init_data_ofEQ10);
        }
    }else if(Output_CH_EQ_MAX_USE == 31){
        FillRecDataStructFromArray(OUTPUT, 0, Output1_init_data_ofEQ31);
        FillRecDataStructFromArray(OUTPUT, 1, Output2_init_data_ofEQ31);
        FillRecDataStructFromArray(OUTPUT, 2, Output3_init_data_ofEQ31);
        FillRecDataStructFromArray(OUTPUT, 3, Output4_init_data_ofEQ31);
        FillRecDataStructFromArray(OUTPUT, 4, Output5_init_data_ofEQ31);
        FillRecDataStructFromArray(OUTPUT, 5, Output6_init_data_ofEQ31);
        
        if(Output_CH_MAX == 8){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ31);
        }else if(Output_CH_MAX == 10){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 8, Output9_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 9, Output10_init_data_ofEQ31);
        }else if(Output_CH_MAX == 12){
            FillRecDataStructFromArray(OUTPUT, 6, Output7_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 7, Output8_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 8, Output9_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 9, Output10_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 10, Output11_init_data_ofEQ31);
            FillRecDataStructFromArray(OUTPUT, 11, Output12_init_data_ofEQ31);
        }
    }
    //初始化系统结构数据
    initSystemDataStruct();
    
    SendStructData = RecStructData;
    DefaultStructData = RecStructData;
    BufStructData = RecStructData;
    NSLog(@"%d",RecStructData.OUT_CH[10].IN1_Vol);
    for(int i=0;i<Output_CH_MAX;i++){
        for(int j=0;j<Output_CH_EQ_MAX_USE;j++){
            BufStructData.OUT_CH[i].EQ[j].level=RecStructData.OUT_CH[i].EQ[j].level;
            RecStructData.OUT_CH_BUF[i].EQ[j].level=RecStructData.OUT_CH[i].EQ[j].level;
        }
        
    }
    
    
    for(int i=0;i<16;i++){
        for(int j=0;j<4;j++){
            INS_LINKFlag[i][j] = false;
        }
    }
    if(BOOL_SET_SpkType){
        for(int i=0;i<Output_CH_MAX_USE;i++){
            setOutputSpkType(ChannelTypeDefault[i],i);
        };
    }
    if(BOOL_Mixer&&BOOL_SET_SpkType){
        setOutputSpkTypeDefault();
    }
}
#pragma mark 混音-输出类型
void setOutputSpkTypeDefault(){
    for(int i=0;i<Output_CH_MAX_USE;i++){
        setOutputSpkType(ChannelTypeDefault[i],i);
    }
    
    for(int i=0;i<Output_CH_MAX;i++){
        //设置默认输出滤波器
        RecStructData.OUT_CH[i].h_filter=DefaultStructData.OUT_CH[i].h_filter;
        RecStructData.OUT_CH[i].l_filter=DefaultStructData.OUT_CH[i].l_filter;
        RecStructData.OUT_CH[i].h_level=DefaultStructData.OUT_CH[i].h_level;
        RecStructData.OUT_CH[i].l_level=DefaultStructData.OUT_CH[i].l_level;
        
        //根据名字设置Xover频率
        //高频
        for(int j=0;j<6;j++){
            if(HighFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==HighFreq[j]){
                    RecStructData.OUT_CH[i].h_freq = HighFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq = HighFreq_LPFreq;
                }
            }
        }
        //中频
        for(int j=0;j<3;j++){
            if(MidFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidFreq_LPFreq;
                }
            }
        }
        //低频
        for(int j=0;j<6;j++){
            if(LowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==LowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=LowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=LowFreq_LPFreq;
                }
            }
        }
        //中高
        for(int j=0;j<3;j++){
            if(MidHighFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidHighFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidHighFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidHighFreq_LPFreq;
                }
            }
        }
        //中低
        for(int j=0;j<3;j++){
            if(MidLowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==MidLowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=MidLowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=MidLowFreq_LPFreq;
                }
            }
        }
        //超低
        for(int j=0;j<4;j++){
            if(SupperLowFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==SupperLowFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=SupperLowFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=SupperLowFreq_LPFreq;
                }
            }
        }
        
        //全频
        for(int j=0;j<7;j++){
            if(AllFreq[j]!=EndFlag){
                if(ChannelNumBuf[i]==AllFreq[j]){
                    RecStructData.OUT_CH[i].h_freq=AllFreq_HPFreq;
                    RecStructData.OUT_CH[i].l_freq=AllFreq_LPFreq;
                }
            }
        }
    }
    
    for(int i=0;i<Output_CH_MAX;i++){
        setMixerVolWithOutputSpk(i);
    }
    
    //[self FlashOutputSpkType];
    
}
void setOutputSpkTypeClean(){
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i]=0;
    }

    for(int i=0;i<Output_CH_MAX;i++){
        RecStructData.OUT_CH[i].IN1_Vol = 0;
        RecStructData.OUT_CH[i].IN2_Vol = 0;
        RecStructData.OUT_CH[i].IN3_Vol = 0;
        RecStructData.OUT_CH[i].IN4_Vol = 0;
        
        RecStructData.OUT_CH[i].IN5_Vol = 0;
        RecStructData.OUT_CH[i].IN6_Vol = 0;
        RecStructData.OUT_CH[i].IN7_Vol = 0;
        RecStructData.OUT_CH[i].IN8_Vol = 0;
        
        RecStructData.OUT_CH[i].IN9_Vol  = 0;
        RecStructData.OUT_CH[i].IN10_Vol = 0;
        RecStructData.OUT_CH[i].IN11_Vol = 0;
        RecStructData.OUT_CH[i].IN12_Vol = 0;
        
        RecStructData.OUT_CH[i].IN13_Vol = 0;
        RecStructData.OUT_CH[i].IN14_Vol = 0;
        RecStructData.OUT_CH[i].IN15_Vol = 0;
        RecStructData.OUT_CH[i].IN16_Vol = 0;
    }
    
    
    for(int i=0;i<Output_CH_MAX;i++){
        //设置默认输出滤波器
        RecStructData.OUT_CH[i].h_filter=DefaultStructData.OUT_CH[i].h_filter;
        RecStructData.OUT_CH[i].l_filter=DefaultStructData.OUT_CH[i].l_filter;
        RecStructData.OUT_CH[i].h_level=DefaultStructData.OUT_CH[i].h_level;
        RecStructData.OUT_CH[i].l_level=DefaultStructData.OUT_CH[i].l_level;
        RecStructData.OUT_CH[i].h_freq=20;
        RecStructData.OUT_CH[i].l_freq=20000;
    }
    
    
    //[self FlashOutputSpkType];
}

#pragma mark Josn相关
void initJsonMacData(){
    if(BOOL_USE_INS){
        for(int i=0;i<=MAX_USE_GROUP;i++){
            for (int j=0; j<IN_CH_MAX; j++) {
                for (int k=0; k<INS_LEN; k++) {
                    JsonMacData.Data[i].JIN.MusicJ[j][k]=inputs_init_data[k];
                }
            }
        }
    }else{
        for(int i=0;i<=MAX_USE_GROUP;i++){
            for (int j=0; j<IN_CH_MAX; j++) {
                for (int k=0; k<IN_LEN; k++) {
                    JsonMacData.Data[i].JIN.MusicJ[j][k]=inputs_init_data[k];
                }
            }
        }
    }
    
    if(Output_CH_EQ_MAX_USE == 10){
        for(int i=0;i<=MAX_USE_GROUP;i++){
            for (int k=0; k<OUT_LEN; k++) {
                JsonMacData.Data[i].JOUT.OutputJ[0][k]=Output1_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[1][k]=Output2_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[2][k]=Output3_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[3][k]=Output4_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[4][k]=Output5_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[5][k]=Output6_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[6][k]=Output7_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[7][k]=Output8_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[8][k]=Output9_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[9][k]=Output10_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[10][k]=Output11_init_data_ofEQ10[k];
                JsonMacData.Data[i].JOUT.OutputJ[11][k]=Output12_init_data_ofEQ10[k];
            }
        }
    }else{
        for(int i=0;i<=MAX_USE_GROUP;i++){
            for (int k=0; k<OUT_LEN; k++) {
                JsonMacData.Data[i].JOUT.OutputJ[0][k]=Output1_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[1][k]=Output2_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[2][k]=Output3_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[3][k]=Output4_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[4][k]=Output5_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[5][k]=Output6_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[6][k]=Output7_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[7][k]=Output8_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[8][k]=Output9_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[9][k]=Output10_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[10][k]=Output11_init_data_ofEQ31[k];
                JsonMacData.Data[i].JOUT.OutputJ[11][k]=Output12_init_data_ofEQ31[k];
            }
        }
    }
}


#pragma Json Data  转换
//字典数据转化为单组数据
- (BOOL)JsonDataToSingleData:(NSDictionary*) jsonDict{
    BOOL res=false;
    
    //MUSIC
    NSArray *music = [[[jsonDict objectForKey:@"data"] objectForKey:@"music"] objectForKey:@"music"] ;
    NSLog(@"A music =%lu",(unsigned long)music.count);
    
    for(int i=0;i<music.count;i++){
        NSArray *temp = [[[[jsonDict objectForKey:@"data"] objectForKey:@"music"] objectForKey:@"music"] objectAtIndex:i];
        NSLog(@"A music temp=%lu",(unsigned long)temp.count);
        for(int j=0;j<temp.count;j++){
            JsonSinData.JIN.MusicJ[i][j]=(uint8)[[temp objectAtIndex:j] unsignedCharValue];
        }
    }
    
    //OUTPUT
    NSArray *output = [[[jsonDict objectForKey:@"data"] objectForKey:@"output"] objectForKey:@"output"];
    NSLog(@"A output =%lu",(unsigned long)output.count);
    
    for(int i=0;i<output.count;i++){
        NSArray *temp = [[[[jsonDict objectForKey:@"data"] objectForKey:@"output"] objectForKey:@"output"] objectAtIndex:i];
        NSLog(@"A output temp=%lu",(unsigned long)temp.count);
        for(int j=0;j<temp.count;j++){
            JsonSinData.JOUT.OutputJ[i][j]=(uint8)[[temp objectAtIndex:j] unsignedCharValue];
            //NSLog(@"A JsonSinData.JOUT.OutputJ[%d][%d] = %d",i,j,JsonSinData.JOUT.OutputJ[i][j]);
        }
    }
    
    //System
    //pc_source_set
    NSArray *pc_source_set = [[[jsonDict objectForKey:@"data"] objectForKey:@"system"] objectForKey:@"pc_source_set"];
    NSLog(@"A pc_source_set =%lu",(unsigned long)pc_source_set.count);
    for(int j=0;j<pc_source_set.count;j++){
        //NSLog(@"A pc_source_set[%d] = %d",j,(uint8)[[pc_source_set objectAtIndex:j] unsignedCharValue]);
        JsonSinData.Jsys[j]=(uint8)[[pc_source_set objectAtIndex:j] unsignedCharValue];
    }
    //system_data
    NSArray *system_data = [[[jsonDict objectForKey:@"data"] objectForKey:@"system"] objectForKey:@"system_data"];
    NSLog(@"A system_data =%lu",(unsigned long)system_data.count);
    for(int j=0;j<system_data.count;j++){
        //NSLog(@"A system_data[%d] = %d",j,(uint8)[[system_data objectAtIndex:j] unsignedCharValue]);
        JsonSinData.Jsys[8+j]=(uint8)[[system_data objectAtIndex:j] unsignedCharValue];
    }
    //system_spk_type
    NSArray *system_spk_type = [[[jsonDict objectForKey:@"data"] objectForKey:@"system"] objectForKey:@"system_spk_type"];
    NSLog(@"A system_spk_type =%lu",(unsigned long)system_spk_type.count);
    for(int j=0;j<system_spk_type.count;j++){
        //NSLog(@"A system_spk_type[%d] = %d",j,(uint8)[[system_spk_type objectAtIndex:j] unsignedCharValue]);
        JsonSinData.Jsys[16+j]=(uint8)[[system_spk_type objectAtIndex:j] unsignedCharValue];
    }
    //    for(int j=0;j<32;j++){
    //        NSLog(@"A JsonSinData.Jsys[%d] = %d",j,JsonSinData.Jsys[j]);
    //    }
    res=true;
    return res;
}
//字典数据转化为整机数据
- (BOOL)JsonDataToMacData:(NSDictionary*) jsonDict{
    BOOL res=false;
    
    
    NSArray *ARdata = [jsonDict objectForKey:@"data"];
    NSLog(@"A ARdata =%lu",(unsigned long)ARdata.count);
    
    int Maxuser = (int)ARdata.count;
    if(Maxuser > MAX_USE_GROUP+1){
        Maxuser = MAX_USE_GROUP+1;
    }
    for(int usr=0;usr<Maxuser;usr++){
        /**/
        //group_name
        NSArray *group_name = [[[jsonDict objectForKey:@"data"] objectAtIndex:usr ] objectForKey:@"group_name"];
        NSLog(@"A group_name =%lu",(unsigned long)group_name.count);
        for(int j=0;j<group_name.count;j++){
            JsonMacData.Data[usr].GroupName[j]=(uint8)[[group_name objectAtIndex:j] unsignedCharValue];
        }
        //MUSIC
        NSArray *music = [[[[jsonDict objectForKey:@"data"] objectAtIndex:usr ] objectForKey:@"music"] objectForKey:@"music"] ;
        NSLog(@"A music =%lu",(unsigned long)music.count);
        
        for(int i=0;i<music.count;i++){
            NSArray *temp = [[[[[jsonDict objectForKey:@"data"] objectAtIndex:usr ] objectForKey:@"music"] objectForKey:@"music"] objectAtIndex:i];
            NSLog(@"A music temp=%lu",(unsigned long)temp.count);
            for(int j=0;j<temp.count;j++){
                JsonMacData.Data[usr].JIN.MusicJ[i][j]=(uint8)[[temp objectAtIndex:j] unsignedCharValue];
            }
        }
        
        //OUTPUT
        NSArray *output = [[[[jsonDict objectForKey:@"data"] objectAtIndex:usr ] objectForKey:@"output"] objectForKey:@"output"];
        NSLog(@"A output =%lu",(unsigned long)output.count);
        
        for(int i=0;i<output.count;i++){
            NSArray *temp = [[[[[jsonDict objectForKey:@"data"] objectAtIndex:usr ] objectForKey:@"output"] objectForKey:@"output"] objectAtIndex:i];
            NSLog(@"A output temp=%lu",(unsigned long)temp.count);
            for(int j=0;j<temp.count;j++){
                JsonMacData.Data[usr].JOUT.OutputJ[i][j]=(uint8)[[temp objectAtIndex:j] unsignedCharValue];
            }
        }
        
    }
    
    //System
    //pc_source_set
    NSArray *pc_source_set = [[jsonDict objectForKey:@"system"] objectForKey:@"pc_source_set"];
    NSLog(@"A pc_source_set =%lu",(unsigned long)pc_source_set.count);
    for(int j=0;j<pc_source_set.count;j++){
        JsonSinData.Jsys[j]=(uint8)[[pc_source_set objectAtIndex:j] unsignedCharValue];
    }
    //system_data
    NSArray *system_data = [[jsonDict objectForKey:@"system"] objectForKey:@"system_data"];
    NSLog(@"A system_data =%lu",(unsigned long)system_data.count);
    for(int j=0;j<system_data.count;j++){
        JsonSinData.Jsys[8+j]=(uint8)[[system_data objectAtIndex:j] unsignedCharValue];
    }
    //system_data
    NSArray *system_spk_type = [[jsonDict objectForKey:@"system"] objectForKey:@"system_spk_type"];
    NSLog(@"A system_spk_type =%lu",(unsigned long)system_spk_type.count);
    for(int j=0;j<system_spk_type.count;j++){
        JsonSinData.Jsys[16+j]=(uint8)[[system_spk_type objectAtIndex:j] unsignedCharValue];
    }
    
    res=true;
    return res;
}


- (BOOL)jsonDataToDataArray:(NSString *)path withFileType:(NSString *) fileType{
    
    NSData *data;
    
    if ([fileType isEqualToString:@"complete"]) {
        data = [QIZFileTool decryptFilePath:path withFileType:SEFFM_TYPE];
    }else{
        data = [QIZFileTool decryptFilePath:path withFileType:SEFFS_TYPE];
    }
    //编码转换
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
    NSString *res = [[NSString alloc]initWithData:data encoding:enc];
    NSData *jdata = [res dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableLeaves error:nil];
    
    //解释出错
    if(jsonDict == nil){
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = JSONFILE_ERROR;
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        NSLog(@"jsonDataToDataArray 解释出错！！！");
        return false;
    }
    
    NSString *Brand = [[jsonDict objectForKey:@"client"] objectForKey:@"company_brand"];
    NSString *macType = [[jsonDict objectForKey:@"data_info"] objectForKey:@"data_machine_type"];
    NSLog(@"Brand=%@,macType=%@",Brand,macType);
    
    if(([Brand isEqualToString:[NSString stringWithFormat:@"%d",AgentID]])&&([macType isEqualToString:MAC_Type])){
        
    }else{
        //发送消息
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = JSONFILEMac_ERROR;
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        return false;
    }
    
    if ([fileType isEqualToString:@"complete"]) {
        NSLog(@"jsonDataToDataArray complete");
        
        if(jsonDict != nil){
            
            Boolean res=[self JsonDataToMacData:jsonDict];
            if(!res){
                
                NSLog(@"JsonDataToMacData complete ERROR");
                return false;
            }
            
            //4.如果连接则下发到设备
            if (gConnectState) {
                //更新当前组界面数据
                //MUSIC
                if(BOOL_USE_INS){
                    for(int i=0;i<INS_CH_MAX;i++){
                        FillRecDataStruct_INS_FromArray(i, JsonMacData.Data[0].JIN.MusicJ[i]);
                    }
                }else{
                    FillRecDataStructFromArray(MUSIC, 0, JsonMacData.Data[0].JIN.MusicJ[0]);
                }
                
                //OUTPUT
                for(int i=0;i<Output_CH_MAX;i++){
                    FillRecDataStructFromArray(OUTPUT, i, JsonMacData.Data[0].JOUT.OutputJ[i]);
                }
                //SYSTEM
                FillRecDataStructFromArray(SYSTEM, 0, JsonSinData.Jsys);
                [self ComparedToSendData:false];
                //USER NAme
                for(int i=0;i<=MAX_USE_GROUP;i++){
                    for(int j=0;j<16;j++){
                        RecStructData.USER[i].name[j]=JsonMacData.Data[i].GroupName[j];
                    }
                }
                
                //发送消息
                NSMutableDictionary *State = [NSMutableDictionary dictionary];
                State[@"State"] = @"YES";
                //创建一个消息对象
                NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_UpdateUI object:nil userInfo:State];
                [[NSNotificationCenter defaultCenter] postNotification:noticeState];
                //同步MCU数据
                [self saveMCUSEFFData];
            }
            
            return true;
        }else{
            return false;
        }
        
    }else if ([fileType isEqualToString:@"single"]) {
        
        NSLog(@"jsonDataToDataArray single");
        
        if(jsonDict != nil){
            Boolean res=[self JsonDataToSingleData:jsonDict];
            
            if(!res){
                
                NSLog(@"JsonDataToSingleData single ERROR");
                return false;
            }
            
            //4.如果连接则下发到设备
            if (gConnectState) {
                //MUSIC
                if(BOOL_USE_INS){
                    for(int i=0;i<INS_CH_MAX;i++){
                        FillRecDataStruct_INS_FromArray(i, JsonSinData.JIN.MusicJ[i]);
                    }
                }else{
                    FillRecDataStructFromArray(MUSIC, 0, JsonSinData.JIN.MusicJ[0]);
                }
                
                for(int i=0;i<Output_CH_MAX;i++){
                    FillRecDataStructFromArray(OUTPUT, i, JsonSinData.JOUT.OutputJ[i]);
                }
                
//                FillRecDataStructFromArray(SYSTEM, 0, JsonSinData.Jsys);
                [self ComparedToSendData:false];
                
                //发送消息
                NSMutableDictionary *State = [NSMutableDictionary dictionary];
                State[@"State"] = @"YES";
                //创建一个消息对象
                NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_UpdateUI object:nil userInfo:State];
                [[NSNotificationCenter defaultCenter] postNotification:noticeState];
                
                [self SEFF_Save:0];
                [self syncMCUSystemData];
            }
            
            
            return true;
        }else{
            return false;
        }
        
    }
    return false;
}


#pragma 加载Json文件
//发送音效文件的数据到机器：0:不发送，1：单组数据，2：整机数据
- (void)sendJsonDataToMac:(int)Type{
    if(Type == SEFFFILE_TYPE_SINGLE){
        if(BOOL_USE_INS){
            for(int i=0;i<INS_CH_MAX;i++){
                FillRecDataStruct_INS_FromArray(i, JsonSinData.JIN.MusicJ[i]);
            }
        }else{
            FillRecDataStructFromArray(MUSIC, 0, JsonSinData.JIN.MusicJ[0]);
        }
        
        for(int i=0;i<Output_CH_MAX;i++){
            FillRecDataStructFromArray(OUTPUT, i, JsonSinData.JOUT.OutputJ[i]);
        }
        
//        FillRecDataStructFromArray(SYSTEM, 0, JsonSinData.Jsys);
        [self ComparedToSendData:false];
        
        //发送消息
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = @"YES";
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_UpdateUI object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        
        [self SEFF_Save:0];
        [self syncMCUSystemData];
        
        //发送消息
        //        State = [NSMutableDictionary dictionary];
        //        State[@"State"] = SHOWLoading;
        //        //创建一个消息对象
        //        noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        //        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        
    }else if(Type == SEFFFILE_TYPE_MAC){
        //更新当前组界面数据
        //MUSIC
        //MUSIC
        if(BOOL_USE_INS){
            for(int i=0;i<INS_CH_MAX;i++){
                FillRecDataStruct_INS_FromArray(i, JsonMacData.Data[0].JIN.MusicJ[i]);
            }
        }else{
            FillRecDataStructFromArray(MUSIC, 0, JsonMacData.Data[0].JIN.MusicJ[0]);
        }
        
        //OUTPUT
        for(int i=0;i<Output_CH_MAX;i++){
            FillRecDataStructFromArray(OUTPUT, i, JsonMacData.Data[0].JOUT.OutputJ[i]);
        }
        //SYSTEM
        FillRecDataStructFromArray(SYSTEM, 0, JsonSinData.Jsys);
        [self ComparedToSendData:false];
        //USER NAme
        for(int i=0;i<=MAX_USE_GROUP;i++){
            for(int j=0;j<16;j++){
                RecStructData.USER[i].name[j]=JsonMacData.Data[i].GroupName[j];
            }
        }
        
        //发送消息
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = @"YES";
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_UpdateUI object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        //同步MCU数据
        [self saveMCUSEFFData];
        
        
        //        //发送消息
        //        State = [NSMutableDictionary dictionary];
        //        State[@"State"] = SHOWLoading;
        //        //创建一个消息对象
        //        noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        //        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
    }
    
}


-(void)fileJSSHLoad:(NSURL *)url
{
    NSString *Brand;
    NSString *macType;
    NSDictionary *jsonDict;
    NSData *data;
    //1.读取文件
    NSString *urlStr = [url absoluteString];
    NSString *reviceName = [urlStr lastPathComponent];
    NSString *fileName = nil;
    NSString *subString = nil;
    for (int i=0; i<reviceName.length; i++) {
        unichar c = [reviceName characterAtIndex:i];
        if (c == '.') {
            QIZLog(@"i:%d",i);
            fileName = [reviceName substringToIndex:i];
            subString = [reviceName substringFromIndex:i];
        }
    }
    
    //中文乱码问题
    fileName = [NSString stringWithString:[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *fileType = subString;
    if ([subString isEqualToString:SEFFS_TYPE]) {
        fileType = subString;
        NSLog(@"@@#fileJSSHLoad fileType=%@",fileType);
        //写文件到沙盒(复制)
        NSData *dataWrite = [NSData dataWithContentsOfURL:url];
        [QIZFileTool writeJsonFileToBox:fileName fileData:dataWrite fileType:SEFFS_TYPE];
        data = [QIZFileTool decryptFilePath:fileName withFileType:SEFFS_TYPE];
        //编码转换
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
        NSString *res = [[NSString alloc]initWithData:data encoding:enc];
        NSData *jdata = [res dataUsingEncoding: NSUTF8StringEncoding];
        
        //NSLog(@"res=%@",res);
        //NSLog(@"res=%ld",res.length);
        //Json格式转换
        jsonDict = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableLeaves error:nil];
    }else if ([subString isEqualToString:SEFFM_TYPE]) {
        fileType = subString;
        NSLog(@"fileJSSHLoad fileType=%@",fileType);
        //写文件到沙盒(复制)
        NSData *dataWrite = [NSData dataWithContentsOfURL:url];
        [QIZFileTool writeJsonFileToBox:fileName fileData:dataWrite fileType:SEFFM_TYPE];
        NSData *Mdata = [QIZFileTool decryptFilePath:fileName withFileType:SEFFM_TYPE];
        //编码转换
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
        NSString *res = [[NSString alloc]initWithData:Mdata encoding:enc];
        //NSLog(@"res=%@",res);
        NSLog(@"dataWrite=%ld",(unsigned long)dataWrite.length);
        NSLog(@"Mdata=%ld",(unsigned long)Mdata.length);
        NSLog(@"res.length=%ld",(unsigned long)res.length);
        NSData *jdata = [res dataUsingEncoding: NSUTF8StringEncoding];
        
        //Json格式转换
        jsonDict = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableLeaves error:nil];
        
        //Android整机文件多出的字符要处理掉
        if(jsonDict==nil){
            NSLog(@"###  jsonDict==nil");
            NSString *St = [[NSString alloc]initWithData:jdata encoding:enc];
            NSRange range;
            range = [St rangeOfString:@"]}}\n"];
            if (range.location != NSNotFound) {
                NSLog(@"### found at location = %lu, length = %lu",(unsigned long)range.location,(unsigned long)range.length);
                //NSString *ok = [St substringFromIndex:range.location];
                //NSLog(@"%@",ok);
                if(St.length >= range.location+4){
                    NSString *oks = [St substringToIndex:(unsigned long)range.location+4];//-6
                    //NSLog(@"%@",oks);
                    NSData *adata = [oks dataUsingEncoding: NSUTF8StringEncoding];
                    jsonDict = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableLeaves error:nil];
                    //复写文件到沙盒
                    [QIZFileTool deleteFileToBox:fileName];
                    NSData *fdata = [QIZFileTool exclusiveNSData:adata];
                    [QIZFileTool writeJsonFileToBox:fileName fileData:fdata fileType:SEFFM_TYPE];
                }
            }else{
                //NSLog(@"Not Found");
            }
            
        }
        /*
         if(jsonDict==nil){
         NSString *filename = @"ERRMAC";
         [QIZFileTool writeJsonFileToBox:filename fileData:jdata fileType:SEFFM_TYPE];
         
         SEFFFile *effFile = [[SEFFFile alloc] init];
         effFile.file_id = @"file_id";
         effFile.file_type = @"complete";
         effFile.file_name = filename; //fill
         effFile.file_path = [QIZFileTool backSaveBoxFileName:filename fileType:SEFFM_TYPE];//fill
         effFile.file_favorite = @"0";
         effFile.file_love = @"0";
         effFile.file_size = @"200";
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
         effFile.file_time = strDate;
         effFile.file_msg = @"file_msg";
         
         effFile.data_user_name = @"";
         effFile.data_machine_type = MAC_Type;
         effFile.data_car_type = @"";//fill
         effFile.data_car_brand = @"";//fill
         effFile.data_group_name = filename;//fill
         
         effFile.data_upload_time = strDate;
         
         //        effFile.data_eff_briefing = detailCellStr; //fill
         effFile.data_eff_briefing = filename;
         
         effFile.list_sel = @"0";
         effFile.list_is_open = @"0";
         effFile.apply_time = @"";  //初始化未使用
         
         
         BOOL bAdd = [QIZDatabaseTool addSingleEffectData:effFile];
         
         }
         */
    }else {
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = JSONFILE_ERROR;
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        NSLog(@"文件格式错误！！！");
        return;
    }
    //解释出错
    if(jsonDict == nil){
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = JSONFILE_ERROR;
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        NSLog(@"fileJSSHLoad  解释出错！！！");
        return;
    }
    //数据版本机型是否正确
    Brand = [[jsonDict objectForKey:@"client"] objectForKey:@"company_brand"];
    macType = [[jsonDict objectForKey:@"data_info"] objectForKey:@"data_machine_type"];
    NSLog(@"Brand=%@,macType=%@",Brand,macType);
    
    if(([Brand isEqualToString:[NSString stringWithFormat:@"%d",AgentID]])&&([macType isEqualToString:MAC_Type])){
        
    }else{
        //发送消息
        NSMutableDictionary *State = [NSMutableDictionary dictionary];
        State[@"State"] = JSONFILEMac_ERROR;
        //创建一个消息对象
        NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
        [[NSNotificationCenter defaultCenter] postNotification:noticeState];
        return;
    }
    
    
    
    if ([subString isEqualToString:SEFFS_TYPE]) {
        
        //2.写入数据库
        SEFFFile *effFile = [[SEFFFile alloc] init];
        effFile.file_id = @"file_id";
        effFile.file_type = @"single";
        effFile.file_name = fileName; //fill
        effFile.file_path = [QIZFileTool backSaveBoxFileName:fileName fileType:SEFFS_TYPE];//fill
        effFile.file_favorite = @"0";
        effFile.file_love = @"0";
        effFile.file_size = @"200";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        effFile.file_time = strDate;
        effFile.file_msg = @"file_msg";
        
        
        //effFile.data_user_name = @"";
        effFile.data_machine_type = [[jsonDict objectForKey:@"data_info"] objectForKey:@"data_machine_type"];
        //effFile.data_car_type = @"本田XR-V";//fill
        //effFile.data_car_brand = @"本田";//fill
        effFile.data_group_name = fileName;//fill
        effFile.data_upload_time = strDate;
        effFile.data_eff_briefing =[[jsonDict objectForKey:@"data_info"] objectForKey:@"data_eff_briefing"]; //fill
        
        effFile.list_sel = @"0";
        effFile.list_is_open = @"0";
        effFile.apply_time = @"";  //初始化未使用
        
        [QIZDatabaseTool addSingleEffectData:effFile];
        
        if(jsonDict != nil){
            [self JsonDataToSingleData:jsonDict];
            
            //4.如果连接则下发到设备
            if (gConnectState) {
                [self sendJsonDataToMac:SEFFFILE_TYPE_SINGLE];
            }else{
                REC_SEFFFileType = SEFFFILE_TYPE_SINGLE;
                //发送消息
                NSMutableDictionary *State = [NSMutableDictionary dictionary];
                State[@"State"] = SHOWRecSEFFFile;
                //创建一个消息对象
                NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
                [[NSNotificationCenter defaultCenter] postNotification:noticeState];
            }
            
        }
        
    } else {
        
        //整机文件
        //2.写入数据库
        SEFFFile *effFile = [[SEFFFile alloc] init];
        effFile.file_id = @"file_id";
        effFile.file_type = @"complete";
        effFile.file_name = fileName; //fill
        effFile.file_path = [QIZFileTool backSaveBoxFileName:fileName fileType:SEFFM_TYPE];//fill
        effFile.file_favorite = @"0";
        effFile.file_love = @"0";
        effFile.file_size = @"200";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        effFile.file_time = strDate;
        effFile.file_msg = @"file_msg";
        
        //effFile.data_user_name = @"";
        effFile.data_machine_type = [[jsonDict objectForKey:@"data_info"] objectForKey:@"data_machine_type"];
        //effFile.data_car_type = @"本田XR-V";//fill
        //effFile.data_car_brand = @"本田";//fill
        effFile.data_group_name = fileName;//fill
        effFile.data_upload_time = strDate;
        effFile.data_eff_briefing =[[jsonDict objectForKey:@"data_info"] objectForKey:@"data_eff_briefing"]; //fill
        
        effFile.list_sel = @"0";
        effFile.list_is_open = @"0";
        effFile.apply_time = @"";  //初始化未使用
        
        [QIZDatabaseTool addSingleEffectData:effFile];
        
        if(jsonDict != nil){
            [self JsonDataToMacData:jsonDict];
            
            if (gConnectState) {
                [self sendJsonDataToMac:SEFFFILE_TYPE_MAC];
                
            }else{
                REC_SEFFFileType = SEFFFILE_TYPE_MAC;
                //发送消息
                NSMutableDictionary *State = [NSMutableDictionary dictionary];
                State[@"State"] = SHOWRecSEFFFile;
                //创建一个消息对象
                NSNotification * noticeState = [NSNotification notificationWithName:MyNotification_LoadJsonFile object:nil userInfo:State];
                [[NSNotificationCenter defaultCenter] postNotification:noticeState];
            }
        }
    }
}




@end


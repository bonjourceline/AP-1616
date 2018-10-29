//
//  DataCommunication.h
//  DCP812
//
//  Created by chsdsp on 2017/2/14.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacDefine.h"
#import "DataStruct.h"


#import "QIZDatabaseTool.h"
#import "QIZFileTool.h"
#import "MasterVolView.h"
#import "SEFFFile.h"

#define DataCManager [DataCommunication shareDataCommunication]
@protocol DataCommunicationDelegate <NSObject>

- (void)sendData:(Byte[])data withSendMode:(int)mode;
//- (void)DataCommunicationStatus:(int)Event WithState:(BOOL)State WithData:(int)Data WithMsg:(NSString*)Msg;

@end


@interface DataCommunication : NSObject
{
    @private
    BOOL U0RcvFrameFlg;     // 有新接收到数据的标志
    BOOL U0SendFrameFlg;    // 有数据要发送的标志
    
    //BOOL U0SynDataSucessFlg;// 同步初始化数据完成标志
    //BOOL U0SynDataError;    // 同步初始化数据是否出错
    BOOL DeviceVerErrorFlg; // 版本号错误标志
    BOOL SendAgainFlg;      // 再次发送
    BOOL U0HeadFlg;
    uint16 U0HeadCnt;
    uint16 U0DataCnt;
    int   LEDPackageCnt;
    NSMutableArray *SendbufferList;//要发送的数据值表
    uint8 FrameDataBuf[U0DataLen + CMD_LENGHT];
    uint8 SendDataBuf[U0DataLen + CMD_LENGHT];
    uint8 FrameDataSUM;
    
}
@property (nonatomic,strong)NSMutableArray *sendListBufferList;
@property (nonatomic,strong)NSMutableArray *sendMusicBufferList;
@property (nonatomic,assign)BOOL UpdataAduanceData;//是否有加载过通道数据
/** 数据发送线程 */
@property (nonatomic, strong) NSThread *sendDataThread;

+ (instancetype)shareDataCommunication;
- (void) ReceiveDataFromDevice:(uint8) data :(uint8) type;//组包发送数据
- (void) SendDataToDevice:(BOOL) sendorinsert;//组包发送数据
- (void) ComparedToSendData:(BOOL) sendorinsert;//同步数据
- (BOOL) InitLoad; //初始化加载
-(void) sendGetSystemDataCMD;//发送音量命令CMD
- (int) GetSendbufferListCount;
-(void) FillSedDataStructCH:(int) DataStruchID DataWithCh:(int) ChannelID;


/** 代理对象 */
@property (nonatomic, weak) id<DataCommunicationDelegate> delegate;


- (void)setInputSourceNow;//立即设置音源
- (void)SEFF_Call:(int)mGroup;//读取用户组
- (void)SEFF_Delete:(int)mGroup;//删除用户且
- (void)SEFF_Save:(int)mGroup;//保存用户组
- (void)SEFF_EncryptClean;//清除加密数据
- (void)SetSEFF_GroupName:(int)mGroup;//设置用户组名字
- (void)readMacData;//读取整机数据；
- (void)syncMCUSystemData;//同步结构SYSTEM数据
-(void)fileJSSHLoad:(NSURL *)url;
- (void)sendJsonDataToMac:(int)Type;
//恢复出厂设置
- (void)sendResetGroupData:(int)ReadUserGroup;

extern void setMixerVolWithOutputSpk(int chsel);
extern void syncLinkData(int ui);
extern void LINK_MODE_AUTOTAG_IN(int ui);
extern void LINK_MODE_AUTOTAG_OUT(int ui);
extern void setDataSyncLink(void);
extern void INS_DataCopy(int Dfrom, int Dto);
extern void setOutputSpkType(int type,int ch);
extern void initDataStruct();
extern void SendDelayDatabySystemChannel();
extern void FillDelayDataBySystemChannel();
extern void FillSedDataStructCHBuf(int DataStruchID, int ChannelID);
extern void FillSedDataStruct(int DataStruchID, int initBuf[]);
extern void FillRecDataStructFromArray(uint8 DataStruchID, uint8 ChannelID, uint8 initData[]);
extern void setXOverFreqWithOutputSpkType(int channel);
extern void copyGroupData(int Dfrom, int Dto);
extern void copyGroupData_IN(int Dfrom, int Dto);
void FillSedData_INS_StructCHBuf(int ch);

#pragma Json Data  转换
- (BOOL)jsonDataToDataArray:(NSString *)path withFileType:(NSString *) fileType;

/*!
 * 发送数据
 */
- (void)BT_SendPack:(NSMutableArray *)dataArray withSize:(unsigned long)packsize;

//清空数据
-(void)setFlagDefault;
@end

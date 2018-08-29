//
//  Define_NSNotification.h
//  MT-IOS
//
//  Created by chsdsp on 2017/3/6.
//  Copyright © 2017年 dsp. All rights reserved.
//

#ifndef Define_NSNotification_h
#define Define_NSNotification_h

#define MyNotification_NoticeScanBLE (@"MyNotification_NoticeScanBLE")//成功连接BLE设备
#define MyNotification_ConnectSuccess (@"MyNotification_ConnectSuccess")//连接设备成功
#define MyNotification_UpdateUI (@"MyNotification_UpdateUI")//接收完完整的数据后更新所有界面的通知
#define MyNotification_FlashMaster (@"MyNotification_FlashMaster")//刷新主界面
#define MyNotification_ReadMacData (@"MyNotification_ReadMacData")//读取整机数据完成 
#define MyNotification_LoadJsonFile (@"MyNotification_LoadJsonFile")//加载json文件
#define MyNotification_FlashInputSource (@"MyNotification_FlashInputSource")
#define MyNotification_ShowProgress (@"MyNotification_ShowProgress")
#define MyNotification_ShowResetSEFFData (@"MyNotification_ShowResetSEFFData")//读取的数据错误，是否恢复默认数据。
#define MyNotification_updateVol @"MyNotification_updateVol"//刷新音量
#define MyNotification_ShowAD (@"MyNotification_ShowAD") //弹出广告

#define ShowProgressSave (@"ShowProgressSave")//
#define ShowProgressCall (@"ShowProgressCall")//

#define JSONFILE_ERROR (@"JSONFILE_ERROR")//
#define JSONFILEMac_ERROR (@"JSONFILEMac_ERROR")//
#define SHOWLoading (@"SHOWLoading")//显示进度框
#define SHOWRecSEFFFile (@"SHOWRecSEFFFile")//显示接收到一个音效文件 


#define DataCommunicationDelegate_ConnectState 1
#define DataCommunicationDelegate_UI_Sync_Data 2

#endif /* Define_NSNotification_h */

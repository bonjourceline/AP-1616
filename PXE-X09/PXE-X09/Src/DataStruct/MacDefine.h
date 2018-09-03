//
//  MacDefine.h
//  DCP812
//  机型定义
//  Created by chsdsp on 2017/2/13.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#import "DataStruct.h"
#import "MacDefine.h"
#ifndef MacDefine_h
#define MacDefine_h

#define DEF_APP     1
#define DEF_LIB     2
#define DEFALIB     DEF_LIB

#define SEFF_OPT_READ	1
#define SEFF_OPT_Save	2

#define SEFFFILE_TYPE_NULL 0
#define SEFFFILE_TYPE_SINGLE  1
#define SEFFFILE_TYPE_MAC  2

#define SEFFFILE_SHARE 1
#define SEFFFILE_Save  2
#define SEFFFILE_List  3
#define SEFFFILE_ShowSetName 4

#define SeffFileType_Single	1
#define SeffFileType_Mac	2

#define COM_WITH_BLE		1
#define COM_WITH_WIFT		2
///////////////////////////////
#define IN_CH_EQ_MAX		10
#define OUT_CH_EQ_MAX		31
#define EFF_CH_EQ_MAX		8
#define MAX_SEFFGroupName_Size		13 

#define EndFlag 0xee
//机型定义

#define MAC_TYPE_X2S		1

//高频
#define HighFreq_HPFreq  2200
#define HighFreq_LPFreq  20000
//中频
#define MidFreq_HPFreq  600
#define MidFreq_LPFreq  1500
//低频
#define LowFreq_HPFreq  20
#define LowFreq_LPFreq  500
//中高
#define MidHighFreq_HPFreq  600
#define MidHighFreq_LPFreq  20000
//中低
#define MidLowFreq_HPFreq  20
#define MidLowFreq_LPFreq  1600
//超低
#define SupperLowFreq_HPFreq  20
#define SupperLowFreq_LPFreq  150
//全频
#define AllFreq_HPFreq  20
#define AllFreq_LPFreq  20000
//高频
#define HighFreq_HPFreq_Max  20000
#define HighFreq_HPFreq_Min  1000

#define UI_Page_Master           0
#define UI_Page_Home             1
#define UI_Page_Delay            2
#define UI_Page_Output           3
#define UI_Page_Xover            4
#define UI_Page_EQ               5
#define UI_Page_Mixer            6


#define UI_HFilter			 1
#define UI_HOct				 2
#define UI_HFreq			 3
#define UI_LFilter			 4
#define UI_LOct				 5
#define UI_LFreq			 6
#define UI_OutVal			 7
#define UI_OutMute	         8
#define UI_OutPolar			 9
#define UI_OutEQ100			 0x0a
#define UI_OutEQ1K			 0x0b
#define UI_OutEQ10K			 0x0c
#define UI_EQ_BW			 0x0d
#define UI_EQ_Freq			 0x0e
#define UI_EQ_Level		     0x0f
#define UI_EQ_G_P_MODE_EQ	 0x10
#define UI_EQ_ALL	         0x11
#define UI_Mixer	         0x12
#define UI_Delay	         0x13


#define UI_INS_HFilter			 0x31
#define UI_INS_HOct				 0x32
#define UI_INS_HFreq			 0x33
#define UI_INS_LFilter			 0x34
#define UI_INS_LOct				 0x35
#define UI_INS_LFreq			 0x36
#define UI_INS_OutVal			 0x37
#define UI_INS_OutMute	         0x38
#define UI_INS_OutPolar			 0x39
#define UI_INS_OutEQ100			 0x3a
#define UI_INS_OutEQ1K			 0x3b
#define UI_INS_OutEQ10K			 0x3c
#define UI_INS_EQ_BW			 0x3d
#define UI_INS_EQ_Freq			 0x3e
#define UI_INS_EQ_Level		     0x3f
#define UI_INS_EQ_G_P_MODE_EQ	 0x40
#define UI_INS_EQ_ALL	         0x41
#define UI_INS_Mixer	         0x42
#define UI_INS_Delay	         0x43

#define AgentID_BAF    1  //佰芙
#define AgentID_AP     2  //阿尔派
#define AgentID_HD     3  //合德
#define AgentID_HZHY   4  //惠州惠诺
#define AgentID_YY     5  //御音
#define AgentID_RG     6  //锐高
#define AgentID_DS     7  //迪声
#define AgentID_SX     8  //声鑫
#define AgentID_PH     9  //鹏辉
#define AgentID_FL     10  //芬朗
#define AgentID_HL     11  //汇隆
#define AgentID_KL     12  //卡莱
#define AgentID_YJ     13  //云晶
#define AgentID_JB     14  //江波
#define AgentID_JH     15  //俊宏
#define AgentID_KP     16  //酷派
#define AgentID_YBD    17  //盈必达
#define AgentID_CHS    18  //车厘子
#define AgentID_RD     19  //荣鼎
#define AgentID_YB     20  //译宝
#define AgentID_LYL    21  //乐与路
#define AgentID_GEM    22  //歌尔玛
#define AgentID_LM     23  //蓝脉
#define AgentID_YG     24 //鹰歌
#define AgentID_DR     25  //东荣音响
#define AgentID_TH     26 //泰华电子
#define AgentID_ZYZ    27  //古登
#define AgentID_YYWC   28 //音乐王朝
#define AgentID_OF     29  //欧凡
#define AgentID_DF     30  //东风
#define AgentID_LY     31  //路翼
#define AgentID_XG     32  //先歌
#define AgentID_YDW    33  //雅迪威
#define AgentID_TJJ    34  //铁将军
#define AgentID_YYLM   35  //音乐联盟
#define AgentID_RF     36  //润飞
#define AgentID_HW     37  //惠威
#define AgentID_HS     38  //慧声
#define AgentID_HY     39  //汇友
#define AgentID_HH     40  //航辉
#define AgentID_SS     41  //山水
#define AgentID_XD     42 //项达
#define AgentID_HSDZ   43   //豪声电子
#define AgentID_BSYX   44   //柏仕音响

#define BT_Apple_Type    3   //CSR8670 与苹果蓝牙通信
#define BT_Conrol_Type   5   //DX-BT12 与安卓&苹果蓝牙通信类型定义
#define BT_ATS2825_Type  6   //ATS2825 与安卓&苹果蓝牙通信类型定义
//联调
#define LINKMODE_FRS        1 //前声场，后声场，超低的联调，单独分开
#define LINKMODE_FRS_A      2 //前声场，后声场，超低的联调，一起联调
#define LINKMODE_FR         3 //前声场，后声场，单独分开
#define LINKMODE_FR_A       4 //前声场，后声场，中置超低的联调，全部一起联调
#define LINKMODE_SPKTYPE    5 //设置通道输出类型后的联调
#define LINKMODE_SPKTYPE_S  6 //设置通道输出类型后的联调，可联机保存
#define LINKMODE_AUTO       7 //任意联调，每个通道可以单独联调，可联机保存
#define LINKMODE_LEFTRIGHT  8 //固定两两通道联调
#define LINKMODE_FR2A       9 //前声场，后声场，一起两两联调


/*名数据块的长度*/
//  112; //0x70  DataStruct_Iutput:EQ8X9+40=112
#define IN_LEN		(IN_CH_EQ_MAX*8+32)
//  296; //0xA8  DataStruct_Output:EQ8X31+48=296
#define OUT_LEN		(OUT_CH_EQ_MAX*8+48)
//  96;  //0x60  DataStruct_EFFect:EQ8X8+32=96
#define EFF_LEN		(EFF_CH_EQ_MAX*8+32)

#define INS_LEN		((INS_CH_EQ_MAX_USE*8+16)*INS_CH_MAX)
#define INS_S_LEN		(INS_CH_EQ_MAX_USE*8+16)

#define SYSTEM_LEN	    64
extern uint8     Define_MAC;
extern bool COM_BLE_DEVICECONNECTED;
extern bool continueSendState;
extern struct JDataARY JsonMacData;//整机数据
extern struct JData JsonSinData;//单组数据
extern struct Data RecStructData, SendStructData, DefaultStructData, BufStructData;//接收发送的数据
extern  struct MData SendMBoxData,RcvMBoxData;
extern uint8 FDMBoxBuf[512];
extern struct FrameDataStruct RecFrameData,SendFrameData;//接收发送的帧数据
extern uint8  JsonDataBuf[U0DataLen+CMD_LENGHT];
extern const double FREQ241[241];//频段基本
extern const double EQ_BW296[296];//EQ斜率

//机型参数配置
//界面功能
extern uint8    COMBleType;
extern uint8     HEAD_DATA ;	          //BAF 包头
extern NSString* MCU_Versions;   //下位机版本号
extern NSString* MCU_Versions_I;
extern NSString* BRAND;	          //BAF 包头
extern NSString* App_versions;   //定义本软件版本
extern NSString* Copyright;      //定义本版权
extern NSString* welcome_logo;
extern NSString* MAC_Type;        //下位机版本号
extern NSString* Json_versions;//定义本软件版本
extern NSString* Json_versions_V0_00;//定义本软件版本
extern NSString* Json_MacCfgVersions;//定义本软件版本
extern uint8     AgentID ;
extern NSString* DeviceVerString;
extern NSString* ENTER_ADVANCE_PW;


extern uint8     Define_MAC;
extern BOOL BOOL_MAC_Change;//两种机型
extern BOOL BOOL_USE_ADVANCE;
extern BOOL BOOL_ENTER_ADVANCE;
extern BOOL BOOL_ReadMacData;//读取整机数据

extern enum Enum_MaxDelay     enum_MaxDelay;    //延时
extern enum Enum_MaxVolume    enum_MaxVolume;   //音量值
extern enum Enum_DataTransfer enum_DataTransfer;//数据通信方式
extern int   gSeffFileType;//0:单组 1:整机
extern BOOL BOOL_ENCRYPT_SEFF;//音效文件是否加密

extern NSString * SEFFS_TYPE  ;
extern NSString * SEFFS_NAME  ;
extern NSString * SEFFS_ANAME ;

extern NSString * SEFFM_TYPE  ;
extern NSString * SEFFM_NAME  ;
extern NSString * SEFFM_ANAME ;

extern NSString * SEFFFilePathOfSingle;//单组文件路径
extern NSString * SEFFFilePathOfMac;//整机文件路径

extern NSString * SEFFFile_name;
extern NSString * SEFFFile_Dital;
extern int REC_SEFFFileType;//0:没有接收到音效文件，1：单组音效文件，2：整机文件
extern int   SEFFFILE_OPT;
extern int   output_channel_sel;//当前输出通道
extern int   input_channel_sel;//当前输入通道
extern int   CurGroup;//读当前组
extern int   CurPage;

extern BOOL BOOL_SYSTEM_SPK_TYPEB;//是否使用SYSTEM_SPK_TYPEB
extern BOOL BOOL_RESET_GROUP_DATA;//是否使用数据复位标志，当数据出错时提示用户是否恢复出厂设置
extern BOOL BOOL_TRANSMITTAL;//是否使用數據傳輸標誌
//------------------------   UI界面配置  ---------------------
//ture:XOver 和 Output合并
extern BOOL BOOL_XOverOutputUI;
//false:用户组可编辑 ，true:分长按，短按，双击
extern BOOL BOOL_USER_GROUP_UI;
//用户组名字设置0：都不显示，1：显示Button的，2：只显示TextView的，3：都显示
extern uint8 SHOW_USER_GROUP_NAME;
//用户组数,配置此时要更改xml,java等相关文件
extern uint8 MAX_USE_GROUP;
/*手动音源设置 false:自动或者无，true:手动设置*/
extern BOOL BOOL_HW_INPUTSOURCE;
/*高频二分频*/
extern BOOL BOOL_HIDEMODE;
/*光纤轴*/
extern BOOL BOOL_HW_Coaxial_Optical;
/*桥接设置*/
extern BOOL BOOL_BTL;
/*混音设置  false:无*/
extern BOOL BOOL_Mixer;
/*是否有任意设置输出通道名字功能*/
extern BOOL BOOL_SET_SpkType;
extern uint8 maxSpkType;
/*加密设置*/
extern BOOL BOOL_ENCRYPTION;
/*加密异或数值*/
extern uint8 Encrypt_DATA;
extern uint8 EncryptionFlag;
extern uint8 DecipheringFlag;
extern uint8 Encryption_PasswordBuf[];//密码保存
//读取的数据是否加密
extern BOOL BOOL_EncryptionFlag;
//------------------------   主界面  ---------------------
/*音量改变时如果静音则静音消失,true:有，false:无*/
extern BOOL  BOOL_ValC_MUTE;
/* 最大主音量 */
extern uint16 Master_Volume_MAX;
extern uint16 Master_Volume_Base;
/*主音量和静音的数据通信方式COM_TYPE_SYSTEM,COM_TYPE_INPUT,COM_TYPE_OUTPUT,(INPUT固定通道2)*/
extern uint8 MasterVolumeMute_DATA_TRANSFER;
/*是否有独立静音标志 基于MUSIC主音量和静音的数据通信方式*/
extern BOOL  BOOL_HW_MUTE;

//------------------------   延时  ---------------------
/*输出延时的设定通道，COM_TYPE_SYSTEM,COM_TYPE_INPUT,COM_TYPE_OUTPUT,
 * 若通过SYSTEM（全部用户的通道只用一组延时数据），把相关数据复制到对应通道
 * */
extern uint8 DELAY_DATA_TRANSFER;
/*延时的最大值*/
extern uint16 DELAY_SETTINGS_MAX;//960 20，384 8 ，240 5 ，259 5.396

//------------------------   输入通道  ---------------------
/*机型的Input通道数及机型的Input通道的EQ数量,主音量在MUSIC(DataStructInput)中,只使用一路*/
extern uint8 Input_CH_MAX;
extern uint8 Input_CH_Volume_MAX;

//------------------------   输出通道  ---------------------
/*机型的输出通道数及机型的输出通道的EQ数量*/
/*输出音量的最大值*/
extern uint16 Output_Volume_MAX;
extern uint16 Output_Volume_Step;//有的最大为600，60.0db
//输出通道数
extern uint8 Output_CH_MAX;// 6 8 10 12
extern uint8 Output_CH_MAX_USE;

extern int ChannelTypeDefault[16];
//--------------------------XOVER定义------------------------
//当斜率为6Db/Oct时，Filter是否隐藏
extern BOOL BOOL_FilterHide6DB_OCT;
//最大滤波器斜率个数
extern uint8 XOVER_OCT_MAXL;//0-3通道OCT个数
extern uint8 XOVER_OCT_MAXH;//4-Max通道OCT个数
extern uint8 XOVER_OCT_MAX;	//列表显示个数 B8 8, B6S 5
extern uint8 XOVER_INDEX_OCT_MAX_Volume;
extern BOOL BOOL_XOverOctArry[];
extern BOOL BOOL_XOverOctArryH[];
//------------------------   混音   ---------------------
//混音输入通道数
extern uint8 Mixer_CH_MAX;
//混音输入最大值
extern uint8 Mixer_Volume_MAX;


//---------------------------------机型Input通道定义------------------------
extern uint8 LinkMODE;
extern BOOL BOOL_LinkPolar;//正反相联调
extern BOOL BOOL_LinkDAll;//false:最后两通道是双通道联调，true:整车联调
extern BOOL BOOL_LinkMute;

extern int ChannelConFLR;
extern int ChannelConRLR;
extern int ChannelConSLR;
extern int ChannelConCS;

//变量
extern int  UI_Type;
extern BOOL BOOL_LINK;
extern int  LinkMode;
extern BOOL BOOL_LOCK;
extern BOOL BOOL_LeftCyRight;

extern int AutoLinkValue;
extern int ChannelNumBuf[16];
extern int ChannelLinkCnt;
extern int ChannelLinkBuf[16][2];
extern int ChannelAnyLinkBuf[16+1];//任意联调
extern struct LGSt_Struct LG;


extern uint16  ToningBW;
extern float SCar[];
extern float MCar[];
extern float LCar[];
extern float CCar[];
//------------------------   EQ  ---------------------
//UI配置加载的最大EQ通道数
extern uint8 Output_CH_EQ_MAX;
extern uint8 Input_CH_EQ_MAX;
//输出EQ实际使用道数
extern uint8 Output_CH_EQ_MAX_USE;
extern BOOL EnableGPEQ;
extern int eqIndex;
/*Output EQ MAX*/
extern uint16 EQ_LEVEL_MAX;
extern uint16 EQ_LEVEL_MIN;
extern uint16 EQ_LEVEL_ZERO;
extern uint16 EQ_Gain_MAX;
/*Input EQ MAX*/
extern uint16 IN_EQ_LEVEL_MAX;
extern uint16 IN_EQ_LEVEL_MIN;
extern uint16 IN_EQ_LEVEL_ZERO;
extern uint16 IN_EQ_Gain_MAX;

extern uint8 IN_CH_MAX       ;
extern uint8 IN_CH_VolumeMAX ;
extern uint8 IN_CH_EQ_MAX_USE;

extern uint16 EQ_Freq_MAX;
extern uint16 EQ_BW_MAX;

extern BOOL BOOL_USE_INS;
extern uint8 INS_CH_MAX       ;
extern uint8 INS_CH_VolumeMAX ;
extern uint8 INS_CH_EQ_MAX    ;
extern uint8 INS_CH_EQ_MAX_USE;
extern BOOL INS_LINKFlag[16][4];//输入通道联调标志，
extern BOOL BOOL_INS_LINKFlag;//输入通道联调标志，
//------------------------ 通信相关 ---------------------
/*用于结构与数组之间这转换*/
extern uint8 ChannelBuf[U0DataLen + CMD_LENGHT];
extern uint8  BLE_MaxT;//蓝牙发送数据最大值
extern uint8  COM_WITH_MODE; //通信方式
//extern BOOL U0RcvFrameFlg;        // 有新接收到数据的标志
//extern BOOL U0SendFrameFlg;       // 有数据要发送的标志
extern BOOL U0SynDataSucessFlg;// 同步初始化数据完成标志
extern BOOL U0SynDataError;    // 同步初始化数据是否出错
extern BOOL BOOL_SeffOpt;// 音效操作
//extern BOOL U0HeadFlg;
//extern uint16 U0HeadCnt;
//extern uint16 U0DataCnt;
extern BOOL gConnectState; //全局连接状态
extern BOOL gOldConnectState; //全局连接状态
extern BOOL g_bSkipTips;
//EFF
extern const uint8 Eff_init_data[];
//MIC
extern const uint8 Input_init_micdata[];
//输入
extern const uint8 Input1_init_musicdata[];
extern const uint8 inputs_init_data[];

//Music中间变量
extern int U0HeadCnt;
extern Boolean U0HeadFlag;
extern int U0DataCnt;

extern float KScreenWidth;
extern float KScreenHeight;
extern float KScreenTYPE;//屏适应类型

extern const int HighFreq[];
extern const int MidFreq[];
extern const int LowFreq[];
extern const int MidHighFreq[];
extern const int MidLowFreq[];
extern const int SupperLowFreq[];
extern const int AllFreq[];

//10段EQ的
extern const uint8 Output1_init_data_ofEQ10[];
extern const uint8 Output2_init_data_ofEQ10[];
extern const uint8 Output3_init_data_ofEQ10[];
extern const uint8 Output4_init_data_ofEQ10[];
extern const uint8 Output5_init_data_ofEQ10[];
extern const uint8 Output6_init_data_ofEQ10[];
extern const uint8 Output7_init_data_ofEQ10[];
extern const uint8 Output8_init_data_ofEQ10[];
extern const uint8 Output9_init_data_ofEQ10[];
extern const uint8 Output10_init_data_ofEQ10[];
extern const uint8 Output11_init_data_ofEQ10[];
extern const uint8 Output12_init_data_ofEQ10[];
//31段EQ的
extern const uint8 Output1_init_data_ofEQ31[];
extern const uint8 Output2_init_data_ofEQ31[];
extern const uint8 Output3_init_data_ofEQ31[];
extern const uint8 Output4_init_data_ofEQ31[];
extern const uint8 Output5_init_data_ofEQ31[];
extern const uint8 Output6_init_data_ofEQ31[];
extern const uint8 Output7_init_data_ofEQ31[];
extern const uint8 Output8_init_data_ofEQ31[];
extern const uint8 Output9_init_data_ofEQ31[];
extern const uint8 Output10_init_data_ofEQ31[];
extern const uint8 Output11_init_data_ofEQ31[];
extern const uint8 Output12_init_data_ofEQ31[];

#endif /* MacDefine_h */

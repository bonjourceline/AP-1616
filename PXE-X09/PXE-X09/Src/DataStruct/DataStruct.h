//
//  Struct.h
//  DCP812
//
//  Created by chsdsp on 2017/2/13.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#ifndef DataStruct_h
#define DataStruct_h

#define NUMBERS @"0123456789\n"

typedef unsigned char     uint8;
typedef short int         uint16;

//数据的通信通道
#define COM_TYPE_SYSTEM   1
#define COM_TYPE_INPUT    2
#define COM_TYPE_OUTPUT   3

#define STRUCT_INPUT_MAX       16
#define STRUCT_OUTPUT_MAX      16
#define STRUCT_USER_GROUP_MAX  16

#define FRAME_STA  0xee
#define FRAME_END  0xaa

#define U0DataLen  800	//数据包长度
#define M0DataLen  512 //数据包长度
#define CMD_LENGHT 16

#define WRITE_CMD  0xa1
#define READ_CMD   0xa2

#define RIGHT_ACK  0x51
#define ERROR_ACK  0x52
#define DATA_ACK   0x53

#define DATAID0x77	0x77


/*系统类型中的ID号定义*/
#define GROUP_NAME            0x00	// 20组用户数据组名称
#define EFF_GROUP_NAME		  0x01	// 单独的10组效果数据组名称
#define PC_SOURCE_SET		  0x02	//输入源选择

#define LED_DATA              0x03
#define SOFTWARE_VERSION	  0x04	//设备版本号
#define SYSTEM_DATA	          0x05
#define SYSTEM_SPK_TYPE	      0x06
#define SYSTEM_ALL            0x07
#define LOGO_INFO	          0x10
#define SYSTEM_INFO	          0x11
#define CUR_PASSWORD_DATA	  0x12
#define SUPER_PASSWORD_DATA	  0X13
#define BACKLIGHT_INFO	      0x14
#define DEVICE_ID_INFO	      0x15
#define TEMPERATURE_INFO      0x16

#define OUT_MAX_VAL_INFO	  0x20
#define OUT_MIN_VAL_INFO	  0x21
#define MIC_MAX_VAL_INFO	  0x22
#define MIC_MIN_VAL_INFO	  0x23
#define EFF_MAX_VAL_INFO	  0x24
#define EFF_MIN_VAL_INFO	  0x25
#define MUS_MAX_VAL_INFO	  0x26
#define MUS_MIN_VAL_INFO	  0x27

#define OUT_MIN_EN_INFO		  0x28
#define MIC_MIN_EN_INFO	      0x29
#define EFF_MIN_EN_INFO		  0x30
#define MUS_MIN_EN_INFO	      0x31
#define CH6_LPF_HZ_INFO		  0x32
#define Ch6_LPF_F_INFO	      0x33

#define CUR_PROGRAM_INFO      0x34
#define STARTUP_DATA_INFO     0x35

#define IAP_REQUEST_INFO      0x36 //APP端--申请进入IAP程序
#define IAP_START_INFO        0x37 //IAP端--升级开始(擦除FLASH)
#define IAP_PROGAM_INFO       0x38 //IAP端--FLASH数据包
#define IAP_END_INFO          0x39 //IAP端--升级结束包

#define IAP_DSP_REQUEST_INFO  0x3a //申请进入DSP的IAP程序
#define IAP_DSP_PROGAM_INFO   0x3b //DSP的FLASH数据包
#define IAP_DSP_END_INFO      0x3c //DSP的IAP升级结束包
//声场信息，代替现有数据中的延时(2字节)，等于是在系统中做4组6通道的延时，
//再加一个4组选择标志2字节，共50字节
#define SOUND_FIELD_INFO      0x40

#define WIFI_RESET_INFO	      0x41
#define WIFI_SETSSID_INFO	  0x42 //设置wifiSSID默认为最大为9个字符，输入字符不够PC在后面加零即可 2013-04-09

#define SYSTEM_RESET_MCU         0x60
#define SYSTEM_TRANSMITTAL       0x61
#define SYSTEM_RESET_GROUP_DATA  0x62

#define MCU_BUSY	             0xCC


/* 数据类型 */
#define  MICRO				 1
#define  EFF				 2
#define  MUSIC				 3
#define  OUTPUT				 4
#define  MICSET				 5
#define  MUSICSET			 6
#define  EFFSET				 7
#define  MIC_MUSIC_EFF_VOL	 8
#define  SYSTEM				 9
#define  FEEDBACK			 10

#define  MAX_GROUP           21

/* 数据ID */

//#define	IN_MISC_ID		31
//#define	IN_XOVER_ID		32
//#define	IN_NOISEGATE_ID	33
//#define	IN_LIMIT_ID		34
//#define	IN_NAME_ID		35
//#define	IN_ID_MAX		35

#define  IN_EQMAX_ID        10
#define	IN_MISC_ID		10
#define	IN_XOVER_ID		11
#define	IN_NOISEGATE_ID	12
#define	IN_NAME_ID		13
#define	IN_ID_MAX		13

#define	INS_MISC_ID		0
#define	INS_XOVER_ID	1
#define	INS_ID_MAX		1

#define	EFF_Echo_ID		9
#define	EFF_REV_ID		10
#define	EFF_NAME_ID		11
#define	EFF_ID_MAX		11

#define	OUT_MISC_ID		31
#define	OUT_XOVER_ID	     32
#define	OUT_Valume_ID	     33
#define	OUT_MIX_ID		34
#define	OUT_LIMIT_ID     	35
#define	OUT_NAME_ID		36
#define	OUT_ID_MAX		36

struct LG_Struct{
    uint8 group[16];
    uint8 g;
    uint8 cnt;
};
struct LGSt_Struct {
    struct    LG_Struct Data[17];    //数据内容
};

/* 数据结构*/
struct	EQ_Struct
{
    uint16	freq;	//频率  20Hz~20KHz 步进1Hz   发送数据20~20KHz
    uint16	level;	//增益值 -30.0dB~+15.0dB 步进0.1dB    发送数据300~750
    uint16	bw;		//Oct值  0.05~3.00/Oct 步进0.01       发送数据0~295
    uint8	shf_db;	//6dB,12dB(0:6dB; 1:12dB)
    uint8	type;	//类型(0:PEQ;)	不可以调
};

struct	EFFect_Struct
{
    struct EQ_Struct EQ[8];	//左回声EQ
    
    //高低通 ,ID = 8	只有频率可调 2011-10-20
    uint16	h_freq;		//高通频率，20~20K，stp:1hz,发送实际频率值，如201HZ就发201
    uint8	h_filter;	//保留	高通类型值，0－－LR,1－－BESSEL,2－－BUTTERWORTH
    uint8	h_level;	//保留	高通斜率值，0－－6db,1－－18db,2－－24db
    uint16	l_freq;		//低通频率
    uint8	l_filter;	//保留	低通类型
    uint8	l_level;	//保留	低通斜率值
    
    //----id = 9		回声
    uint8	Echo_Space;		//回声空间 改改成了 乒乓方式了
    uint8	Echo_Delay;		//右延时	 Echo delay    0~250 (0~250 stp:1ms )  发送数据范围 0~250
    uint8	Echo_level;		//保留
    uint8	Echo_Repeat;	//重复次数 0~100%
    uint8  	L_preDelay;		//保留
    uint8  	R_preDelay;		//保留
    uint8   Echo_LoRatio;	//回声湿度	0.01~0.50 步进1 发送范围 0~8
    uint8	none3;			//保留
    
    
    //Effect ,ID= 10		混响
    uint8	Rev_time;		//混响时间 Reverb time  0.0~6.0  步进:0.1s	  发送数据0~60
    uint8	Rev_level;		//混响电平 Echo level1   80~100%  步进:1%     发送数据0~99
    uint8   Rev_LoRatio;	//混响湿度 比列	0.00~0.50 步进0.01		发送数据0~50
    uint8   gain;			//效果音量，0~100%，数据0~100当为0时候静音灯亮//2010-11-8改
    uint8   Ratio;			//效果比例	2011-10-20取消
    uint8   none7;			//保留
    uint8   none8;			//保留
    uint8	Rev_preDelay;	//混响预延时	 0~100 (0~30 stp:1ms )  发送数据范围 0~30
    
    //----id =11
    uint8	name[8];
    
};

struct	input_Struct	//音乐输入  共288字节
{
    struct	EQ_Struct	EQ[10];		//音乐31EQ
    
    //杂项 ID = 31--10
    uint8	mute;	//保留 0静音 1非静音
    uint8	polar;      //极极，0－－同相，1－－反相
    uint16	gain;	// 音量 0~600 -60~0dB
    uint16	delay;		//延时
    uint8	eq_mode;		//eq模式 PEQ/GEQ
    uint8	LinkFlag;		//联调标志
    
    
    //高低通 ID = 32-11
    uint16	h_freq;		//高通频率，20~20K，stp:1hz,发送实际频率值，如201HZ就发201
    uint8	h_filter;	//保留	高通类型值，0－－LR,1－－BESSEL,2－－BUTTERWORTH
    uint8	h_level;	//保留	高通斜率值，0－－6db,1－－18db,2－－24db
    uint16	l_freq;		//低通频率
    uint8	l_filter;	//低通类型
    uint8	l_level;	//低通斜率值
    
    //噪声门 ID = 33-12
    uint8	noisegate_t; //保留  阀值，-120dbu~+10dbu,stp:1dbu,实际发送0~130
    uint8	noisegate_a; //保留  只有阀值可调，    起动时间，0.3ms ~ 100ms
    uint16	noisegate_k; //保留  只有阀值可调		保持时间,
    uint16	noisegate_r; //保留  只有阀值可调		释放时间,2X,4X,6X,8X,16X,32X
    uint16	noise_config;//保留  0--enable, 1--disable,当为disable时，阀值取 -120dbu(只由MCU及PC控制，DSP不用)
    
//    //压限器 ID = 34-12
//    uint16    lim_t;        //限幅电平 -30dbu~+20dbu，stp:0.1,实际发送值0~500
//    uint8    lim_a;
//    uint8    lim_r;
//    uint8    cliplim;
//    uint8   lim_rate;
//    uint8    lim_mode;
//    uint8   comp_swi;
    //通道名 ID = 35-13
    uint8	name[8];
};

struct	inputs_Struct
{
    //杂项 ID = 31--9
    uint8	feedback;	//保留
    uint8	polar;      //极极，0－－同相，1－－反相
    uint8	eq_mode;	//EQ 模式 PEQ/GEQ
    uint8	mute;		//静音2011-6-2  改 zhihui
    uint16	delay;		//延时
    uint16	Valume;		//输入音量 0~600
    
    
    //高低通 ID = 32-10
    uint16	h_freq;		//高通频率，20~20K，stp:1hz,发送实际频率值，如201HZ就发201
    uint8	h_filter;	//保留	高通类型值，0－－LR,1－－BESSEL,2－－BUTTERWORTH
    uint8	h_level;	//保留	高通斜率值，0－－6db,1－－18db,2－－24db
    uint16	l_freq;		//低通频率
    uint8	l_filter;	//保留	低通类型
    uint8	l_level;	//保留	低通斜率值
    
    struct	EQ_Struct	EQ[31];
};

struct	output_Struct			//输出共296字节
{
    //EQ1~EQ6, ID=0~30
    struct	EQ_Struct	EQ[31];		//输出有31个EQ
    
    //杂项 ID = 31
    uint8	mute;	     //静音，0－－静音，1－－非静音
    uint8	polar;	     //极极，0－－同相，1－－反相
    uint16	gain;		 //输出音量 0~600
    uint16	delay;		 //延时, 0~60Ms (0~475  stp:0.021ms   476~526 str:1ms) 发送数据范围 0~526
    uint8 	eq_mode;	 //EQ 模式 PEQ/GEQ
    uint8	LinkFlag;	 //所接喇叭类型 共25种 0~24表示   顺序按 无连接、前(左右)、中置、后(左右)、低音(左右)  注意：此值用系统结构中的喇叭类型代替，不随用户组数据改变
    
    //高低通 ID = 32
    uint16	h_freq;		//高通频率，20~20K，stp:1hz,发送实际频率值，如201HZ就发201
    uint8	h_filter;	//高通类型值，0－－LR,1－－BESSEL,2－－BUTTERWORTH
    uint8	h_level;	//高通斜率值，0－－6db,1－－18db,2－－24db
    uint16	l_freq;		//低通频率
    uint8	l_filter;	//低通类型
    uint8	l_level;	//低通斜率值
    
    //混合比例 ID = 33
    uint8 	IN1_Vol;	//混合器1
    uint8 	IN2_Vol;	//混合器2
    uint8 	IN3_Vol;	//混合器3
    uint8	IN4_Vol;	//混合器4
    uint8   IN5_Vol;
    uint8   IN6_Vol;
    uint8   IN7_Vol;
    uint8   IN8_Vol;
    
    //压缩器 ID = 34
    uint8	IN9_Vol;
    uint8	IN10_Vol;
    uint8	IN11_Vol;
    uint8	IN12_Vol;
    uint8	IN13_Vol;
    uint8	IN14_Vol;
    uint8	IN15_Vol;
    uint8	IN16_Vol;
    
    //压限器 ID = 35
    uint8	IN17_Vol; //限幅电平 -30dbu~+20dbu，stp:0.1,实际发送值0~500
    uint8   IN18_Vol; //起动时间,0.3ms~100ms，0.3~1ms,stp:0.1;1~100ms,stp:1,实际发送值为0~106
    uint8   IN19_Vol; //释放时间值,2x,4x,8x,16x,32x,64x ,实际发送0 ~ 5
    uint8   IN20_Vol;	//保留	clip_limit; +2 ~ +12db,stp:0.1, 实际发送0~100
    uint8   IN21_Vol;	//保留	压缩系数，1：1~1：无穷，    分1：2 ：4 ：8：16：32：64：无穷，共分7级，实际发送0~7
    uint8   IN22_Vol;	//保留	0--limit; 1---compressor
    uint8   IN23_Vol;  //保留comp_swi:	0--manual, 1--auto,linkgroup_num:0无加入联调组，>=1已经加入联调组
    uint8   IN24_Vol;
    //通道名 ID = 36
    uint8	name[8];
    
};

struct	User_Struct
{
    char	name[16];
    uint8	state;
};

struct	SoundFieldStruct
{
    uint16	Delay[24];
    uint8	DelayGroupInfo;
    uint8	DelayGroupInfo2;
    
    uint8	SoundDelayField[50];
};

//写数据：分3个小包写入，type=9
struct	System_Struct  //系统数据共64字节
{
    //PC_SOURCE_SET   共8字节 ch id=2
    uint8   input_source;      //输入音源选择 光纤 同轴 蓝牙 高电平 AUX ----0xff关闭
    uint8   mixer_source;      //混音音源 同上        ----0xff关闭
    uint8   InSwitch[5];       //5种输入方式选择 光纤 同轴 蓝牙 高电平 AUX   0表示未选择   1表示选择
    uint8    none1;            //高电平音源等级20-60（40）
    
//    uint8    Blue_src_vol;   //蓝牙音源等级20-60（40）
//    uint8    Aux_src_vol;    //低电平音源等级20-60（40）
//    uint8    none1;    //保留
//    uint8    none2;       //保留
    
    //SYSTEM_DATA   共8字节 ch id=5
    uint16  main_vol;          //输出总音量 PC端实际发送0~35，按照阿尔派标准设计，由DSP处理
    uint8   high_mode;         //高电平模式      0:自定义  1:前主动3分频后主动2分频-----等等
    uint8   aux_mode;          //AXU电平模式  0:自定义  1:立体声   2:四声道  3:六声道
    uint8   out_mode;          //输出模式 0:自定义  1:前主动3分频后主动2分频   2:前主动2分频后被动+超低 ------等等
    uint8   mixer_SourcedB;    //混音时主音源的衰减量
    uint8   MainvolMuteFlg;    //静音临时标志，这个标志关机不保存，注意特别处理
    uint8   theme;             //场景主题
    
   //SYSTEM_SPK_TYPE  //共48字节 ch_id=6
    uint8   HiInputChNum;    //输入高电平通道数量（偶数倍，最大16，高+Aux最大等于16）
    uint8   AuxInputChNum;   //输入Aux通道数量（偶数倍，最大16，高+Aux最大等于16）
    uint8   OutputChNum;     //输入通道数量 最大16
    uint8   IsRTA_outch;     //定义RTA显示的是哪一个输出的通道0~15
    uint8   InSignelThreshold; //输入LED灯显示以及混音信号有效值阈值-120dBu~0dBu 数值0~120高级设置
    uint8   OffTime;         //关机延迟时间 （需要硬件支持，暂时保留）
    uint8   none[2];                //保留
    
    uint8   high_Low_Set[8];        //8个高&低电平选择继电器设置值  0低电平   1高电平
    uint8   in_spk_type[16];        //16路模拟输入的类型 共25种 0~24表示   顺序按 无连接、前(左右)、中置、后(左右)、低音(左右)
    uint8      out_spk_type[16];      //16路模拟输出的喇叭类型 共25种 0~24表示   顺序按 无连接、前(左右)、中置、后(左右)、低音(左右)
    
    
    uint8 input_source_temp;
    //调整方式时中间变量
    uint8   InSwitch_temp[5];
    uint8   high_mode_temp;         //高电平模式      0:自定义  1:前主动3分频后主动2分频-----等等
    uint8   aux_mode_temp;          //AXU电平模式  0:自定义  1:立体声   2:四声道  3:六声道
    uint8   out_mode_temp;
    uint8   HiInputChNum_temp;    //输入高电平通道数量（偶数倍，最大16，高+Aux最大等于16）
    uint8   AuxInputChNum_temp;   //输入Aux通道数量（偶数倍，最大16，高+Aux最大等于16）
    uint8   OutputChNum_temp;     //输入通道数量 最大16
    uint8   high_Low_Set_temp[8];
    uint8   mixer_source_temp;
    uint8   in_spk_type_temp[16];
    uint8   out_spk_type_temp[16];
    
};

struct MData {
    /*
     1）    MAGIC：第一个字节0x01即SOH，第二个字节对其按位取反。
     2）    CHAN：通道模式，FLAGS第一个字节的bit[0-1]，0h00表示SPP通道，0h01表示TWI或SPI通道，其他未定义。
     3）    SEG：分段标志，FLAGS第一个字节的bit[2-3]，0h00表示不用分段，0h01表示第一段，0h10表示后续段但非最后一段，0h11表示最后一段。分段一般需要配合ACK使用。
     4）    ACK：ACK标志，FLAGS第一个字节的bit[4]，0h0表示不需要ACK，0h1表示需要ACK。可以使用该标志置位来确保命令被分发处理，如果收不到ACK，则对方可以重发命令。
     5）    FLAGS其他BIT保留。
     */
    //------------------------------------------------------------------------------------------------------------------------------
    //-------------------------------------------  通讯数据结构定义   一帧的数据定义 ----------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------------
    uint16  MAGIC;      //
    uint16  FLAGS;      //
    uint8  CMD_TYPE;   //
    uint8  CMD_ID;     //CMD ID：命令号，各种命令类型都有不同的命令号空间，详细见下面命令总表。
    uint16   CMD_LENGTH; //CMD LENGTH：命令长度，统计范围为整条命令，即16字节的固定命令头部再加上不定长参数
    int PARAM1;     //
    int PARAM2;     //
    uint8 BUF[M0DataLen];    //
    uint8 DataBUF[M0DataLen];    //
    int FLAGS_Temp;
    int ACK;
    int SEG;
    int CHAN;
};
struct	FrameDataStruct
{
    uint8   INC1;		//起始符1
    uint8   INC2;		//起始符2
    uint8   INC3;		//起始符3
    uint8	FrameStar;	//帧头(客户编号)
    uint8	FrameType;	//帧类型
    uint8	DeviceID;	//设备id
    uint8	UserID;		//用户地址
    uint8	DataType;	//数据类型
    uint8	ChannelID;	//通道id
    uint8	DataID;		//数据id
    uint8	PCFadeInFadeOutFlg;	//淡入淡出标志(用在输出小包接收数据上)，为1时，没有淡入淡出，为零时，有淡入淡出
    uint8   PcCustom;	//PC自定义字符，接收到什么返回什么，用于校验通信
    uint16	DataLen;	//buf发送区数据长度
    uint8	Buf[U0DataLen];	//数据内容
    uint8	CheckSum;	 //校验和
    uint8	FrameEnd;	//帧尾
    
    uint8	DataBuf[U0DataLen];	//数据内容
};


struct	BufData
{
    uint16	bufD[16];
};
struct Data {
    struct inputs_Struct INS_CH[STRUCT_INPUT_MAX];       //输入数据
    struct input_Struct  IN_CH[STRUCT_INPUT_MAX];       //输入数据
    struct input_Struct IN_CH_BUF[STRUCT_INPUT_MAX];//输出数据
    struct output_Struct OUT_CH[STRUCT_OUTPUT_MAX];    //输出数据
    struct output_Struct OUT_CH_BUF[STRUCT_OUTPUT_MAX];//输出数据
    struct System_Struct System;                       //系统数据
    struct User_Struct USER[STRUCT_USER_GROUP_MAX];    //用户组名字
    struct SoundFieldStruct SoundFieldSystem;          //系统的延时数据
    //struct FrameDataStruct Frame;                    //通信帧数据
    uint8 DataBuf[U0DataLen+CMD_LENGHT];               //临时数据
    uint8 CurProID; // 当前用户组ID
    uint8 TRANSMITTAL[8];             //数据传输标志
    uint8 RESET_MCU[8];               //复位MUC
    uint8 RESET_GROUP_DATA[8];        //复位MUC
};

#pragma Json 数据

struct JMusic {
    uint8	MusicJ[16][U0DataLen];	//数据内容
};
struct JOutput {
    uint8	OutputJ[16][U0DataLen];	//数据内容
};

struct JData {
    struct	JMusic JIN;	//数据内容
    struct	JOutput JOUT;	//数据内容
    uint8   GroupName[16];
    uint8   Jsys[32];
};

struct JDataARY {
    struct	JData Data[16];	//数据内容
};
#endif /* Struct_h */

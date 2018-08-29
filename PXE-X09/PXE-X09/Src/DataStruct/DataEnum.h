//
//  enum.h
//  DCP812
//
//  Created by chsdsp on 2017/2/13.
//  Copyright © 2017年 hmaudio. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef enum_h
#define enum_h

//各种音量值的集合
enum Enum_MaxVolume{
    Volume46 = 46,
    Volume60 = 60,
    Volume66 = 66,
    Volume600 = 600,
};

//各种延时值的集合
enum Enum_MaxDelay{
    Delay960 = 960,//20s
    Delay384 = 384,//8s
    Delay259 = 259,//5.396s
    Delay240 = 240,//5s
};

//数据传输方式
enum Enum_DataTransfer{
    COM_SYSTEM = COM_TYPE_SYSTEM,
    COM_INPUT  = COM_TYPE_INPUT,
    COM_OUTPUT = COM_TYPE_OUTPUT,
};

//客户包头
enum Enum_AgentIDHead{
    BAF    = 0x6D,  //佰芙
    AP     = 0x7C,  //阿尔派
    HD     = 0x00,  //合德
    HZHY   = 0x00,  //惠州惠诺
    YY     = 0x75,  //御音
    RG     = 0xB1,  //锐高
    DS     = 0x00,  //迪声
    SX     = 0x71,  //声鑫
    PH     = 0x77,  //鹏辉
    FL     = 0x72,  //芬朗
    HL     = 0x73,  //汇隆
    KL     = 0x6E,  //卡莱
    YJ     = 0x5E,  //云晶
    JB     = 0x6A,  //江波
    JH     = 0x70,  //俊宏
    KP     = 0x6B,  //酷派
    YBD    = 0x78,  //盈必达
    CHS    = 0x68,  //车厘子
    RD     = 0x5C,  //荣鼎
    YB     = 0x5E,  //译宝
};
#endif /* enum_h */

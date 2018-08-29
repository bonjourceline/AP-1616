//
//  Define_UI.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//

#ifndef Define_UI_h
#define Define_UI_h
//屏幕大小
//#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
//#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

#define SystemTopBarHeight 20  //系统状态栏高度
#define TopBarHeight 44        //自定义状态栏高度
#define TopBarHeightWithSystemBar (SystemTopBarHeight + TopBarHeight)        //自定义状态栏高度
#define ButtomBarHeight 40     //底部状态栏高度
#define UI_StartWithTopBar (SystemTopBarHeight + TopBarHeight)
#define UI_EndNoBottomBar (KScreenHeight - UI_StartNoTopBar)
#define UI_EndWithBottomBar (KScreenHeight - UI_StartNoTopBar - ButtomBarHeight)


#define UI_FragmentHeightSub (TopBarHeightWithSystemBar + ButtomBarHeight)
//顶部状态栏
#define TopBarLogoWidth  120     //顶部状态栏Logo宽度
#define TopBarLogoHeight 30     //底部状态栏Logo高度
#define TopBarMenuSize 25     //
#define TopBarMenuWidth 40     //
#define TopBarMenuHeight 40     //
#define TopBarConnectWidth 55
#define TopBarConnectSize 30     //


#define CBottomBarHeight 70
#define CBottomBarImgViewSize 30
#define CBottomBarImgViewMarginTop 22
#define CBottomBarTextMarginTopIVM 0
#define CBottomBarTextHeight 20
//Master主页
//音效按键
#define UserPresetSize   90
#define UserPresetWidth  80
#define UserPresetHeight 80
#define UserPresetMarginCenter 120
#define UserPresetMarginTopL1  20
#define UserPresetMarginTopL2  150
#define UserPresetMarginLR  70
#endif /* Define_UI_h */


//静音
#define MasterMuteWidth  90
#define MasterMuteHeight 60
//音量滑动条大小
#define MasterVolume_SB_Size    210
#define MasterVolume_SB_Width   290
#define MasterVolume_SB_Height  40

#define MasterVolume_EQSB_Width   140
#define MasterVolume_EQSB_Height  160
//音量值按键大小
#define Master_Lab_Volume_Size  60
//音量文本按键大小
#define Master_Lab_Volume_Text_Width  80
#define Master_Lab_Volume_Text_Height 30
//普通按键大小
#define MasterBtn_Width  90
#define MasterBtn_Height 30
//高级设置按键大小
#define MasterBtnAdvanceSet_Width  260
#define MasterBtnAdvanceSet_Height 45

#define MasterMarginSide 35

//输入页面
#define InputPageMarginSide 20
#define InputPageBtnMarginSide 20

#define InputPageXoverBtnHeight  32
#define InputPageXoverBtnWidth   90
//输出页面
#define OutputPageStartX  (TopBarHeightWithSystemBar + 50)
#define OutputPageMarginTop 20

#define OutputPageMarginSide 20
#define OutputPageMarginSideIN 20

#define OutputPageXoverBtnHeight  30
#define OutputPageXoverBtnWidth   95
#define OutputPageXoverBtnMarginTop  15

#define OutputPageOutSetBtnHeight  30
#define OutputPageOutSetBtnWidth   95

#define OutputPageOutPMBtnHeight  32
#define OutputPageOutPMBtnWidth   95

#define OutputPageOut_INCSUB_Size  35
#define OutputPageOut_SB_Size  200

#define EQViewHeight  160
#define EQItemHeight  320
#define EQItemWidth   80
#define EQItem_BTN_HEIGHT 25

//MixerItem
#define MixerItemHeight  100
#define MixerItemMid  0
//通道按键选择
#define Custom_ChannelBtnHeight  45
#define Custom_ChannelBtnWidth  50

#define ChannelBtnHeight  100
#define ChannelBtnWidth  70

#define ChannelBtnListHeight  40
#define ChannelBtnListWidth  80
//EQ
#define EQBtnHeight  30
#define EQBtnMarginSide  15
#define EQBtnWidth   100

//Delay
#define DelayBtnHeight  30
#define DelayBtnMarginSide  10
#define DelayBtnWidth   95



#define DelayCarTypeHeight  405
#define DelayCarTypeWidth   200

//
//  Define_Color.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#ifndef Define_Color_h
#define Define_Color_h

#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define REDA(a)        [UIColor colorWithRed:251/255.0f green:0/255.0f blue:6/255.0f alpha:a]
#define SetColor(color) [UIColor colorWithRed:((color>>16)&0x00ff)/255.0 green:((color>>8)&0x00ff)/255.0 blue:(color&0x000000ff)/255.0 alpha:((color>>24)&0x00ff)/255.0]

#define Color_R(color) (((color>>16)&0x00ff)/255.0)
#define Color_G(color) (((color>>8)&0x00ff)/255.0)
#define Color_B(color) ((color&0x000000ff)/255.0)
#define Color_A(color) (((color>>24)&0x00ff)/255.0)


#define UI_Color_None (0x00000000) //
#define UI_SystemBgColor  (0xFF1a1a1a)//主颜色（选中状态）
#define UI_SystemClearColor (0xFFffffff)
#define UI_MainStyleColorPress  (0xFF1dd522) //主颜色（选中状态）
#define UI_MainStyleColorNormal (0xFFffffff) //主颜色（平常状态）

#define UI_SystemLableColorNormal (0xFFffffff)//主颜色（平常状态）
#define UI_SystemLableColorPress (0xFFffffff)//主颜色（选中状态）
#define UI_SystemBtnColorNormal (0xFF424e57)//主颜色（平常状态）
#define UI_SystemBtnColorPress  (0xFF379af0)//主颜色（选中状态）

//*********顶部状态栏
#define UI_ToolbarBackgroundColor (0xFFf5f5f5) //顶部状态栏颜色
#define UI_ToolbarTitleColor (0xFFffffff) //顶部状态栏标题颜色
#define UI_ToolbarBackTextColor (0xFFffffff) //顶部状态栏标题颜色
#define UI_ToolbarBackgroundLineColor (0xFF3c5cc3) //顶部状态栏颜色

#define UI_Connect_Press  (0x5222ff27) //音效选中颜色
#define UI_Connect_Normal (0x52ff002e) //音效常态颜色
#define UI_Connect_Border_Normal (0xFFff002e)
#define  UI_Connect_Border_Press (0xFF22ff27)
//SimpleTopbar
#define UI_SimpleTopbarBackgroundColor (0xFF333333) //顶部状态栏颜色
//*********底部状态栏
#define UI_TabbarTextColorNormal (0xFFffffff) //顶部状态栏颜色
#define UI_TabbarTextColorPress  (0xFF2da3ff) //顶部状态栏标题颜色
#define UI_TabbarBgColor  (0xFF262626) //顶部状态栏标题颜色

//AutoLink
#define UI_AutoLink_Bg (0xFF363e43)
#define UI_AutoLink_TitleTBg  (0xFF282828)
#define UI_AutoLink_TitleBBg  (0xFF464b52)
#define UI_AutoLink_BtnTextColor_Press  (0xFFffffff)
#define UI_AutoLink_BtnTextColor_Normal (0xFFffffff)
#define UI_AutoLink_TextColor_Press  (0xFF14b118)
#define UI_AutoLink_TextColor_Normal (0xFFffffff)
#define UI_AutoLink_BtnColor_Press   (0xFF14b118)
#define UI_AutoLink_BtnColor_Normal  (0xFFffffff)
#define UI_AutoLink_line_color  (0xFFffffff)
#define UI_AutoLink_Btn_NormalIN  (0x00ffffff)
#define UI_AutoLink_Btn_PressIN    (0xFF14b118)

#define UI_AutoLink_ColorNull  (0xFF14b118)
#define UI_AutoLink_Color0 (0xFFd83afe)
#define UI_AutoLink_Color1 (0xFFd83afe)
#define UI_AutoLink_Color2 (0xFF3eb0fe)
#define UI_AutoLink_Color3 (0xFFff853c)
#define UI_AutoLink_Color4 (0xFFd6e028)
#define UI_AutoLink_Color5 (0xFF32fefc)
#define UI_AutoLink_Color6 (0xFFa3ee2a)
#define UI_AutoLink_Color7 (0xFFfe2a2a)
#define UI_AutoLink_Color8 (0xFF6295fe)
#define UI_AutoLink_Color9 (0xFFd1e20f)
#define UI_AutoLink_Color10 (0xFF8930d4)
#define UI_AutoLink_Color11 (0xFF1776d3)
#define UI_AutoLink_Color12 (0xFF1eac4b)

//*********主页
//主音量Seekbar
#define UI_Master_SB_Volume_BG (0xFF27323d)//背景色
#define UI_Master_SB_Volume_Press  (0xFF35a2ff) //音效选中颜色
#define UI_Master_SB_Volume_Normal (0xFF3b4853) //音效常态颜色
#define UI_Master_SB_Volume_Point (0x00ffab00) //音效常态颜色
#define UI_Master_SB_ColorCirInside (0xFF212f3b) //音效常态颜色

#define UI_MasterBackgroundColor (0xFF393938) //主页背景颜色
#define UI_Master_UserGroup_Btn_Press (0xFFff1818) //音效选中颜色
#define UI_Master_UserGroup_Btn_Normal (0xFF7e7e7e) //音效常态颜色
#define UI_Master_UserGroup_Btn_Disable (0xFF514e4e) //音效禁止颜色
#define UI_Master_UserGroup_BtnText_Press (0xFFffffff) //音效选中颜色
#define UI_Master_UserGroup_BtnText_Normal (0xFFffffff) //音效常态颜色
#define UI_Master_UserGroup_BtnText_Disable (0xFFffffff) //音效禁止颜色
#define UI_Master_InputSourceTextColor (0xFF414141) //常态颜色
#define UI_Master_InputSourceBtnTextColor (0xFFffffff) //常态颜色
#define UI_Master_InputSourceBtnColor (0xFFffffff) //常态颜色
#define UI_Master_VolumeTextBgColor (0xFFffffff) //常态颜色
#define UI_Master_VolumeTextColor (0xE5efefef) //常态颜色
#define UI_Master_VolumeColor (0xFFffffff) //常态颜色
#define UI_Master_VolumeBtnBgColor (0xFFffffff) //常态颜色

#define UI_MasterSubColor_normal (0xFFffffff) //常态颜色
#define UI_MasterSubColor_normal (0xFFffffff) //常态颜色
// 静音
#define UI_Master_MuteStrokeColor_normal (0xFFff381e) //常态颜色
#define UI_Master_MuteStrokeColor_normal (0xFFff381e) //常态颜色
#define UI_Master_MuteBtnColor_Normal (0xFF7e7e7e) //常态颜色
#define UI_Master_MuteBtnColor_Press (0xFFff2f2f) //常态颜色

#define UI_Master_VolumeINCSubBtnTextColor (0xFF414141) //常态颜色
// 高级选项
#define UI_MasterAdvanceSetBtnColorNormal (0x00212121)//主颜色（平常状态）
#define UI_MasterAdvanceSetBtnColorPress  (0x002a98ff)//主颜色（选中状态）
#define UI_MasterAdvanceSetBtnBorderColorNormal (0XFF7e7e7e) //边框色
#define UI_MasterAdvanceSetBtnTextColorNormal (0xFF6b6b6b)//主颜色（平常状态）
#define UI_MasterAdvanceSetBtnTextColorPress  (0xFF2a98ff)//主颜色（选中状态）

#define UI_Master_EncryptColor (0x9A0b151f) //常态颜色
//*********Delay
#define UI_DelayBtn_Press   (0xFF2ea9ff)
#define UI_DelayBtn_Normal  (0xFF7e7e7e)
#define UI_DelayBtn_PressIN   (0xFF369bff)
#define UI_DelayBtn_NormalIN  (0xFF20272e)
#define UI_DelayBtnText_Press   (0xFF5c3e10)
#define UI_DelayBtnText_Normal  (0xFFffffff)

#define UI_DelayVolColor  (0xFFffffff) //
#define UI_DelayUnit_BtnText_Press  (0xFFaab0b9) //
#define UI_DelayUnit_BtnText_Normal (0xFFafb7bb) //
//*********OutputPage
//Seekbar
#define UI_OutputPageSwitch_Press  (0xFFffffff) //音效选中颜色
#define UI_OutputPageSwitch_Normal (0xFFaab0b9) //音效常态颜色


//EQView
#define Color_EQView_Frame    (0xFF8f9eae) //EQ边框颜色
#define Color_EQView_Text     (0xFF8f9eae) //EQ文本颜色
#define Color_EQView_MidLine  (0xFF8f9eae) //EQ中线颜色
#define Color_EQView_EQLine   (0xFF369bff) //EQ曲线颜色
#define Color_EQChannelLis_bg (0xFF4b4b4b) //背景色
#define Color_Channellis_line (0xFF343434) //
#define Color_EQItemNormal    (0xFFffffff) //EQ边框颜色
#define Color_EQItemPress     (0xFF369bff) //EQ文本颜色
#define Color_EQItemDisable   (0xFFaaaaaa) //EQ中线颜色
#define Color_EQItemSBProgress     (0xFF369bff) //EQSlider颜色
#define Color_EQItemSBProgressBg   (0xFF28323c) //EQSlider颜色
#define Color_EQIndexNormal   (0xFF8f9eae) //


#define UI_EQSB_VolGain_P_Color (0xFFff0000) //音效常态颜色
#define UI_EQSB_VolGain_N_Color (0xFFff381e) //音效常态颜色
//XOver
#define UI_XOver_LabText (0xFFffffff) //
#define UI_XOver_BtnText_Press  (0xFFff1818) //
#define UI_XOver_BtnText_Normal (0xFFffffff) //
#define UI_XOver_BtnText_Disable  (0xFF888888) //
#define UI_XOver_SVolume_Press  (0xFFe2ae4e)
#define UI_XOver_SVolume_Normal  (0xFF000000)
#define UI_XOver_Btn_Press  (0xFFe2ae4e) //
#define UI_XOver_Btn_Normal (0xFF7e7e7e) //
//Mixer
#define ColorItemBG             (0x1Affffff)//背景色
#define ColorItemNormal         (0x00f9c03e)//边框颜色
#define ColorItemPress          (0xFFff1818)//边框颜色
#define ColorItemVolue          (0xFFffffff)//数值文本颜色
#define ColorItemMixerInput     (0xFFffffff)//音源文本颜色
#define ColorItemSBProgress     (0xFFe2ae4e)//
#define ColorItemSBProgressBg   (0xFF000000)//
#define ColorItemDiable         (0xBC1f1f1f)//
//通道按键选择
#define UI_Channel_BtnIN_Press  (0x10ff381e) //
#define UI_Channel_BtnIN_Normal (0x00aab0b9) //
#define UI_Channel_Btn_Press    (0xFFd8a03d) //
#define UI_Channel_Btn_Normal   (0x00aab0b9) //
#define UI_Channel_BtnText_Press  (0xFFff381e) //
#define UI_Channel_BtnText_Normal (0xFFb2b2b2) //
#define UI_Channel_line_Normal (0xFF3d518b) //
#define UI_Channel_line_Press (0xFFff381e) //

#define UI_Channel_BtnListText_Press (0xFFe2ae4e) //
#define UI_Channel_BtnListText_Normal (0xFFffffff) //
#define UI_Channel_BtnListBg (0x00323c4f) //
//通道设置
#define UI_OutSet_Btn_Press (0xFFff381e) //
#define UI_OutSet_Btn_Normal (0xFFaab0b9) //
#define UI_OutSet_BtnText_Press (0xFFaab0b9) //
#define UI_OutSet_BtnText_Normal (0xFFffffff) //

#define UI_OutPolar_BtnText_P (0xFFffffff) //
#define UI_OutPolar_BtnText_N (0xFFff0000) //
#define UI_MidLineColor (0xFF000000) //
#define UI_OutValColor (0xFFffffff) //

#define UI_OutLinkGroup_Text_Color (0xFFffffff) //
#define UI_OutName_BtnText_Press         (0x88666666)//
#define UI_OutName_BtnText_Normal         (0xFFffffff)//

#define UI_OutchannelBg         (0xFF101a4a)//
#define UI_OutMideLineColor     (0xFF2d2e31)//
#define UI_OutXoverFunsBg       (0xFF3e485f)//
//eq界面颜色
#define UI_EQSet_Btn_Press  (0xFFe2ae4e) //
#define UI_EQSet_Btn_Normal (0xFF7e7e7e) //
#define UI_EQSet_BtnText_Press  (0xFFffffff) //
#define UI_EQSet_BtnText_Normal (0xFFffffff) //
//Mixer界面颜色

#define UI_MixerIndexTextColor (0xFFffffff)
#define UI_MixerItemBgPressColor (0xFFff381e)
#define UI_MixerItemBgNormalColor (0xFFffffff)
#define UI_MixerItemValColor (0xFFff381e)


#define UI_MixerItemPolar_P (0xFFffffff)
#define UI_MixerItemPolar_N (0xFFff381e)

//音效界面颜色
#define UI_SEFFFToolbarBackTitleColor (0xFFffffff) //顶部状态栏标题颜色
#define UI_TSEFFFToolbarBgColor (0xFF1a1a1a) //顶部状态栏标题颜色
#define UI_TSEFFFToolbarBoderColor (0xFF595757) //顶部状态栏标题颜色
#define UI_TSEFFF_OPT_TextColor (0xFFffffff) //
#define UI_TSEFFFBotBarBgColor (0xFF1a1a1a) //
#define UI_SEFFF_Title_Press  (0xFFdcc611) //
#define UI_SEFFF_Title_Normal (0xFF7e8c8f) //
#define UI_TSEFFFOpenBgColor (0xFF1a1a1a) //
//INPUT
#define UI_InputCh_Btn_Press      (0xFFff381e) //音效选中颜色
#define UI_InputCh_Btn_Normal     (0xFF000000) //音效常态颜色
#define UI_InputCh_Btn_Disable    (0xFF000000) //音效禁止颜色
#define UI_InputCh_BtnText_Press  (0xFFffffff) //音效选中颜色
#define UI_InputCh_BtnText_Normal (0xFF000000) //音效常态颜色

#define UI_SEFFFItem_Color  (0xFFffffff)
#define UI_SEFFItemTitle_Color (0xFFffffff)
#define UI_SEFFFItemTime_Color  (0xFF7e8c8f) //
//musicList
#define UI_Musiclist_ThemeColor (0xFFff1818) // 主题色
#define UI_Musiclist_musicBarText (0xFFFF8800)
#define UI_Master_VolSliderBackG (0x9A0b151f)//背景


#endif /* Define_Color_h */

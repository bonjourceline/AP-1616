//
//  XOverOutputViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "XOverOutputFRSViewController.h"



#define Out_Index 0
#define Out_Mute  1
#define Out_Polar 2
#define Out_Val   3

@interface XOverOutputFRSViewController ()

@end

@implementation XOverOutputFRSViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Output;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    [center addObserver:self selector:@selector(KxMenutapCloseAction:)
                                                 name:KGModalDidHideNotification object:nil];

    
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    [self initView];
    
    if(!gConnectState){
        if(BOOL_SET_SpkType){
            [self setOutputSpkTypeDefault];
            for(int i=0;i<Output_CH_MAX;i++){
                [self setMixerVolWithOutputSpk:i];
                setXOverFreqWithOutputSpkType(i);
            }
 
        }
    }
    
    [self FlashPageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma initData
- (void)initData{
    Filter_List = [NSMutableArray array];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterLR"]];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterB"]];
    [Filter_List addObject:[LANG DPLocalizedString:@"L_XOver_FilterBW"]];
    
    AllLevel = [NSMutableArray array];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc6dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc12dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc18dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc24dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc30dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc36dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc42dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_Otc48dB"]];
    [AllLevel addObject:[LANG DPLocalizedString:@"L_XOver_OtcOFF"]];
    
//    Level_List  = [NSMutableArray array];
//    LevelH_List = [NSMutableArray array];
//    for(int i=0;i<9;i++){
//        if(BOOL_XOverOctArry[i]){
//            [Level_List addObject:[AllLevel objectAtIndex:i]];
//        }
//    }
//    for(int i=0;i<9;i++){
//        if(BOOL_XOverOctArryH[i]){
//            [LevelH_List addObject:[AllLevel objectAtIndex:i]];
//        }
//    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_filter > 3 || RecStructData.OUT_CH[output_channel_sel].h_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].h_filter = 0;
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_filter > 3 || RecStructData.OUT_CH[output_channel_sel].l_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].l_filter = 0;
    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].h_level < 0){
        RecStructData.OUT_CH[output_channel_sel].h_level = 0;
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].l_level < 0){
        RecStructData.OUT_CH[output_channel_sel].l_level = 0;
    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_freq > 20000 || RecStructData.OUT_CH[output_channel_sel].h_freq < 20){
        RecStructData.OUT_CH[output_channel_sel].h_freq = 20;
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_freq > 20000 || RecStructData.OUT_CH[output_channel_sel].l_freq < 20){
        RecStructData.OUT_CH[output_channel_sel].l_freq = 20000;
    }
    
    CurCH_SPK = [NSMutableArray arrayWithCapacity:32];
    //初始化通道类型
    CH0_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:6],//前置左全频
                [self getOutputSpkTypeNameByIndex:1] //前置左高频
               ];
    CH1_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:12],//前置右全频
                [self getOutputSpkTypeNameByIndex:7] //前置右高频
                ];
    CH2_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:15],//后置左全频
                [self getOutputSpkTypeNameByIndex:2] //前置左中频
                ];
    CH3_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:18],//后置右全频
                [self getOutputSpkTypeNameByIndex:8] //前置右中频
                ];
    CH4_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:2],//前置左中频
                [self getOutputSpkTypeNameByIndex:5] //前置左中低频
                ];
    CH5_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:8],//前置右中频
                [self getOutputSpkTypeNameByIndex:11] //前置右中低频
                ];
    CH6_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:3] //前置左低频
                ];
    CH7_SPK = @[
                [self getOutputSpkTypeNameByIndex:0],//空
                [self getOutputSpkTypeNameByIndex:9] //前置右低频
                ];
    CH8_SPK = @[
                [self getOutputSpkTypeNameByIndex:0], //空
                [self getOutputSpkTypeNameByIndex:26],//后超低频
                [self getOutputSpkTypeNameByIndex:23],//右超低频
                [self getOutputSpkTypeNameByIndex:28] //中置右全频
                ];
    CH9_SPK = @[
                [self getOutputSpkTypeNameByIndex:0], //空
                [self getOutputSpkTypeNameByIndex:25],//前超低频
                [self getOutputSpkTypeNameByIndex:22],//左超低频
                [self getOutputSpkTypeNameByIndex:27] //中置左全频
                ];
}
- (void)initView{
    
    //[self initChannelList];
    //[self initOutput];
    [self initOutputFRS];
    [self initXOver];
    [self initChannelSet];
    //[self initChannel];
    [self initEncrypt];
    [self FlashPageUI];
    
    
}
- (void)initChannel{
    
    //通道選擇
//    self.channelBtn = [[ChannelBtn alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnHeight])];
//    [self.view addSubview:self.channelBtn];
//    [self.channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.Btn_Reset.mas_bottom).offset([Dimens GDimens:18]);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnHeight]));
//    }];
//    [self.channelBtn addTarget:self action:@selector(ChannelChange:) forControlEvents:UIControlEventValueChanged];
}
//通道選擇
- (void)ChannelChange:(ChannelBtn*)sender {
    output_channel_sel = [sender GetChannelSelected];
    //NSLog(@"ChannelChange channel=@%d",output_channel_sel);
    [self FlashPageUI];
    
}


#pragma initChannelList

- (void)initChannelList{
    self.selectorHorizontal = [[IZValueSelectorView alloc]init];
    self.selectorHorizontal.dataSource = self;
    self.selectorHorizontal.delegate = self;
    self.selectorHorizontal.shouldBeTransparent = YES;
    self.selectorHorizontal.horizontalScrolling = YES;
    
    //You can toggle Debug mode on selectors to see the layout
    self.selectorHorizontal.debugEnabled = NO;
    
    //[self.selectorHorizontal setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.selectorHorizontal];
    [self.selectorHorizontal selectRowAtIndex:output_channel_sel];
    [self.selectorHorizontal setBackgroundColor:SetColor(UI_Channel_BtnListBg)];
    [self.selectorHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:70]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnListHeight]));
    }];
}


#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    //NSLog(@"##  numberOfRowsInSelector");
    return Output_CH_MAX_USE;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return [Dimens GDimens:ChannelBtnListHeight];
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return [Dimens GDimens:ChannelBtnListWidth];
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    return [self selector:valueSelector viewForRowAtIndex:index selected:NO];
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index selected:(BOOL)selected {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [Dimens GDimens:ChannelBtnListWidth], [Dimens GDimens:ChannelBtnListHeight])];
    //label.text = CurMacMode.Out.Name[index];
    label.text = [NSString stringWithFormat:@"CH%d",(int)index+1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (selected) {
        label.textColor = SetColor(UI_Channel_BtnListText_Press);
    } else {
        label.textColor = SetColor(UI_Channel_BtnListText_Normal);
    }
    [label setBackgroundColor:[UIColor clearColor]];
    //NSLog(@"##  valueSelector=%@",label.text);
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    //Just return a rect in which you want the selector image to appear
    //Use the IZValueSelector coordinates
    //Basically the x will be 0
    //y will be the origin of your image
    //width and height will be the same as in your selector image
    return CGRectMake(self.selectorHorizontal.frame.size.width/2-[Dimens GDimens:ChannelBtnListWidth]/2 , 0.0, [Dimens GDimens:ChannelBtnListWidth], [Dimens GDimens:ChannelBtnListHeight]);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    output_channel_sel = (int)index;
    [self FlashPageUI_];
}

#pragma initOutputFRS

- (void)initOutputFRS{
    
    //車类型图
    self.IV_CarType = [[UIImageView alloc]init];
    [self.view addSubview:self.IV_CarType];
    [self.IV_CarType setImage:[UIImage imageNamed:@"chs_delayset_scar"]];
    [self.IV_CarType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:70]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:180], [Dimens GDimens:400]));
    }];
    
    float height  = [Dimens GDimens:80];
    float width   = [Dimens GDimens:100];
    
    
    //初始化Item 0-1
    self.OutItemL_0 = [[OutputItemChPMV_L alloc]initWithFrame:CGRectMake([Dimens GDimens:OutputPageMarginSide],
                                                                         [Dimens GDimens:70]+height,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemL_0];
    [self.OutItemL_0 setOutputItemTag:0];
    //通道名字
    [self.OutItemL_0.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
    [self.OutItemL_0.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemL_0.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemL_0.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemL_0.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    ///
    self.OutItemR_1 = [[OutputItemChPMV_R alloc]initWithFrame:CGRectMake(KScreenWidth-width-[Dimens GDimens:OutputPageMarginSide],
                                                                         [Dimens GDimens:70]+height,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemR_1];
    [self.OutItemR_1 setOutputItemTag:1];
    //通道名字
    [self.OutItemR_1.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontRight"] forState:UIControlStateNormal] ;
    [self.OutItemR_1.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemR_1.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemR_1.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemR_1.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化Item 2-3
    self.OutItemL_2 = [[OutputItemChPMV_L alloc]initWithFrame:CGRectMake([Dimens GDimens:OutputPageMarginSide],
                                                                         [Dimens GDimens:70]+height*3,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemL_2];
    [self.OutItemL_2 setOutputItemTag:2];
    //通道名字
    [self.OutItemL_2.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearLeft"] forState:UIControlStateNormal] ;
    [self.OutItemL_2.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemL_2.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemL_2.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemL_2.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    ///
    self.OutItemR_3 = [[OutputItemChPMV_R alloc]initWithFrame:CGRectMake(KScreenWidth-width-[Dimens GDimens:OutputPageMarginSide],
                                                                         [Dimens GDimens:70]+height*3,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemR_3];
    [self.OutItemR_3 setOutputItemTag:3];
    //通道名字
    [self.OutItemR_3.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearRight"] forState:UIControlStateNormal] ;
    [self.OutItemR_3.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemR_3.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemR_3.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemR_3.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    

    //初始化Item 4-5
    self.OutItemL_4 = [[OutputItemChPMV_L alloc]initWithFrame:CGRectMake([Dimens GDimens:OutputPageMarginSide+70],
                                                                         [Dimens GDimens:70]+height*4.5,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemL_4];
    [self.OutItemL_4 setOutputItemTag:4];
    //通道名字
    [self.OutItemL_4.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_LeftSub"] forState:UIControlStateNormal] ;
    [self.OutItemL_4.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemL_4.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemL_4.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemL_4.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    ///
    self.OutItemR_5 = [[OutputItemChPMV_R alloc]initWithFrame:CGRectMake(KScreenWidth-width-[Dimens GDimens:OutputPageMarginSide+70],
                                                                         [Dimens GDimens:70]+height*4.5,
                                                                         width,
                                                                         height)];
    [self.view addSubview:self.OutItemR_5];
    [self.OutItemR_5 setOutputItemTag:5];
    //通道名字
    [self.OutItemR_5.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RightSub"] forState:UIControlStateNormal] ;
    [self.OutItemR_5.Btn_Channel addTarget:self action:@selector(Btn_Channel_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Volume
    [self.OutItemR_5.Btn_Volume addTarget:self action:@selector(Btn_Volume_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Polar
    [self.OutItemR_5.Btn_Polar addTarget:self action:@selector(Btn_Polar_Click:) forControlEvents:UIControlEventTouchUpInside];
    //Btn_Mute
    [self.OutItemR_5.Btn_Mute addTarget:self action:@selector(Btn_Mute_Click:) forControlEvents:UIControlEventTouchUpInside];

    
    
}

-(void)Btn_Channel_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Channel;
    [self setOutItemIndex];
    [self FlashPageUI_];
    
    
}

-(void)Btn_Volume_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Volume;
    [self setOutItemIndex];
    [self flashXOver];
    [self showOutputValSetDialog];
    
}

-(void)Btn_Polar_Click:(NormalButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Polar;
    [self setOutItemIndex];
    [self flashXOver];
    if(RecStructData.OUT_CH[output_channel_sel].polar == 0){
        RecStructData.OUT_CH[output_channel_sel].polar = 1;
        [self setOutItemPolar:true wihtCh:output_channel_sel];
    }else{
        RecStructData.OUT_CH[output_channel_sel].polar = 0;
        [self setOutItemPolar:false wihtCh:output_channel_sel];
    }
    
    [self flashLinkSyncData:UI_OutPolar];
}

-(void)Btn_Mute_Click:(UIButton *)sender{
    output_channel_sel = (int)sender.tag - TagStart_OutItem_Btn_Mute;
    [self setOutItemIndex];
    [self flashXOver];
    if(RecStructData.OUT_CH[output_channel_sel].mute == 0){
        RecStructData.OUT_CH[output_channel_sel].mute = 1;
        [self setOutItemMute:false wihtCh:output_channel_sel];
    }else{
        RecStructData.OUT_CH[output_channel_sel].mute = 0;
        [self setOutItemMute:true wihtCh:output_channel_sel];
    }
}


- (void)setOutItemIndex{
    [self.OutItemL_0.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    [self.OutItemR_1.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    [self.OutItemL_2.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    [self.OutItemR_3.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    [self.OutItemL_4.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    [self.OutItemR_5.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_normal"] forState:UIControlStateNormal];
    
    switch (output_channel_sel) {
        case 0:
            [self.OutItemL_0.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.OutItemR_1.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.OutItemL_2.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.OutItemR_3.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.OutItemL_4.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        case 5:
            [self.OutItemR_5.Btn_Channel setImage:[UIImage imageNamed:@"chs_channel_index_press"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}


- (void)setOutItemMute:(BOOL)Mute wihtCh:(int)ch{
    NSString *st;
    if(ch%2 == 0){
        if(Mute){
            st = @"chs_output_mute_right_press";
        }else{
            st = @"chs_output_mute_right_normal";
        }
    }else{
        if(Mute){
            st = @"chs_output_mute_left_press";
        }else{
            st = @"chs_output_mute_left_normal";
        }
    }
    
    
    switch (ch) {
        case 0:
            [self.OutItemL_0.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        case 1:
            [self.OutItemR_1.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        case 2:
            [self.OutItemL_2.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        case 3:
            [self.OutItemR_3.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        case 4:
            [self.OutItemL_4.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        case 5:
            [self.OutItemR_5.Btn_Mute setBackgroundImage:[UIImage imageNamed:st] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

- (void)setOutItemPolar:(BOOL)Polar_N wihtCh:(int)ch{
    NSString *st;
    if(Polar_N){
        st = @"L_Out_Polar_N";
    }else{
        st = @"L_Out_Polar_P";
    }
    
    
    switch (ch) {
        case 0:
            [self.OutItemL_0.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemL_0.Btn_Polar setPress];
            }else{
                [self.OutItemL_0.Btn_Polar setNormal];
            }
            break;
        case 1:
            [self.OutItemR_1.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemR_1.Btn_Polar setPress];
            }else{
                [self.OutItemR_1.Btn_Polar setNormal];
            }
            break;
        case 2:
            [self.OutItemL_2.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemL_2.Btn_Polar setPress];
            }else{
                [self.OutItemL_2.Btn_Polar setNormal];
            }
            break;
        case 3:
            [self.OutItemR_3.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemR_3.Btn_Polar setPress];
            }else{
                [self.OutItemR_3.Btn_Polar setNormal];
            }
            break;
        case 4:
            [self.OutItemL_4.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemL_4.Btn_Polar setPress];
            }else{
                [self.OutItemL_4.Btn_Polar setNormal];
            }

            break;
        case 5:
            [self.OutItemR_5.Btn_Polar setTitle:[LANG DPLocalizedString:st] forState:UIControlStateNormal];
            if(Polar_N){
                [self.OutItemR_5.Btn_Polar setPress];
            }else{
                [self.OutItemR_5.Btn_Polar setNormal];
            }
            break;
        default:
            break;
    }
    
}

- (void)setOutItemVal:(int)ch{
    
    switch (ch) {
        case 0:
            [self.OutItemL_0.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
            break;
        case 1:
            [self.OutItemR_1.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
             break;
        case 2:
            [self.OutItemL_2.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
            break;
        case 3:
            [self.OutItemR_3.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
            break;
        case 4:
            [self.OutItemL_4.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
            break;
        case 5:
            [self.OutItemR_5.Btn_Volume setTitle:[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[ch].gain/Output_Volume_Step] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}
#pragma 弹出音量设置

-(void)showOutputValSetDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(0, 0, 280, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_Out_SetValume"];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelTitle];
    
    _btnMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnMinus.frame = CGRectMake(10, 100, 30, 30);
    _btnMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    _btnMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnMinus addTarget:self action:@selector(DialogVolSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderVol = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderFreq.dataSource = weakSelf;
    _sliderVol.minimumValue = 0;
    _sliderVol.maximumValue = Output_Volume_MAX/Output_Volume_Step;
    
    _sliderVol.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [_sliderVol setValue:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    
    [_sliderVol addTarget:self action:@selector(SBDialogVolSet) forControlEvents:UIControlEventValueChanged];
    
    /*
     UIImage *stetchTrack1 = [UIImage imageNamed:@"skslider1.png"];
     UIImage *stetchTrack2 = [[UIImage imageNamed:@"skslider2.png"]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
     [_slider setThumbImage: [UIImage imageNamed:@"skbit1.png"] forState:UIControlStateNormal];
     [_slider setMinimumTrackImage:stetchTrack2 forState:UIControlStateNormal];
     [_slider setMaximumTrackImage:stetchTrack1 forState:UIControlStateNormal];
     */
    [contentView addSubview:_sliderVol];
    
    
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAdd addTarget:self action:@selector(DialogVolSet_Inc) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnAdd];
    //长按
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [_btnMinus addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [_btnAdd addGestureRecognizer:longPressVolAdd];
    
    
    
    
    
    NormalButton *btnOK = [NormalButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.frame = CGRectMake(110, 100, 60, 25);
    [btnOK initView:3 withBorderWidth:1 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
    [btnOK setTitleColor:SetColor(0xffffffff) forState:UIControlStateNormal];
    //[btnOK setTitleColor:SetColor(UI_SystemBtnColorNormal) forState:UIControlStateNormal];//常态
    [btnOK setTitleColor:SetColor(UI_SystemBtnColorPress) forState:UIControlStateHighlighted];//选中
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_PressStatus:) forControlEvents:UIControlEventTouchDown];
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_NormalStatus:) forControlEvents:UIControlEventTouchDragOutside];
    [btnOK setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    btnOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[btnOK addTarget:self action:@selector(gainExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)SBDialogVolSet{
    int sliderValue = (int)(_sliderVol.value);
    RecStructData.OUT_CH[output_channel_sel].gain = sliderValue*Output_Volume_Step;
    _sliderVol.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [self setOutItemVal:output_channel_sel];
    
    [self flashLinkSyncData:UI_OutVal];
}

- (void)DialogVolSet_Sub{
    RecStructData.OUT_CH[output_channel_sel].gain -= Output_Volume_Step;
    if(RecStructData.OUT_CH[output_channel_sel].gain < 0){
        RecStructData.OUT_CH[output_channel_sel].gain = 0;
    }
    _sliderVol.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [_sliderVol setValue:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [self setOutItemVal:output_channel_sel];
    
    [self flashLinkSyncData:UI_OutVal];
}
- (void)DialogVolSet_Inc{
    RecStructData.OUT_CH[output_channel_sel].gain += Output_Volume_Step;
    if(RecStructData.OUT_CH[output_channel_sel].gain > Output_Volume_MAX){
        RecStructData.OUT_CH[output_channel_sel].gain = Output_Volume_MAX;
    }
    _sliderVol.showValue = [NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [_sliderVol setValue:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    [self setOutItemVal:output_channel_sel];
    
    [self flashLinkSyncData:UI_OutVal];
}
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogVolSet_Sub) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolMinusTimer.isValid){
            [_pVolMinusTimer invalidate];
            _pVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_VolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogVolSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}




#pragma initXOver

- (void)initXOver{
//    UIView *mLine1 = [[UIView alloc]init];
//    [self.view addSubview:mLine1];
//    [mLine1 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.IV_CarType.mas_bottom).offset([Dimens GDimens:50]);
//        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 1));
//    }];

//    self.LabXOver_Text = [[UILabel alloc]init];
//    [self.view addSubview:self.LabXOver_Text];
//    [self.LabXOver_Text setBackgroundColor:[UIColor clearColor]];
//    [self.LabXOver_Text setTextColor:SetColor(UI_XOver_LabText)];
//    self.LabXOver_Text.text=[LANG DPLocalizedString:@"L_XOver_XOver"];
//    self.LabXOver_Text.textAlignment = NSTextAlignmentCenter;
//    self.LabXOver_Text.adjustsFontSizeToFitWidth = true;
//    self.LabXOver_Text.font = [UIFont systemFontOfSize:15];
//    [self.LabXOver_Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mIVMid.mas_bottom).offset([Dimens GDimens:10]);
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];

    self.LabHP_Text = [[UILabel alloc]init];
    [self.view addSubview:self.LabHP_Text];
    [self.LabHP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabHP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabHP_Text.text=[LANG DPLocalizedString:@"L_XOver_HighPass"];
    self.LabHP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabHP_Text.adjustsFontSizeToFitWidth = true;
    self.LabHP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabHP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IV_CarType.mas_bottom).offset([Dimens GDimens:100]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    //高通
    self.H_Filter = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Filter];
    [self.H_Filter initViewBroder:3
                 withBorderWidth:1
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_XOver_Btn_Normal
            withBorderPressColor:UI_XOver_Btn_Press
             withTextNormalColor:UI_XOver_BtnText_Normal
              withTextPressColor:UI_XOver_BtnText_Press
                        withType:0];
    [self.H_Filter addTarget:self action:@selector(H_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabHP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    self.H_Filter.hidden=true;
    
    
    self.H_Level = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Level];
    [self.H_Level initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:0];
    [self.H_Level addTarget:self action:@selector(H_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.H_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.H_Filter.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    self.H_Freq = [[NormalButton alloc]init];
    [self.view addSubview:self.H_Freq];
    [self.H_Freq initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:0];
    [self.H_Freq addTarget:self action:@selector(H_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.H_Filter.mas_centerY).offset(-[Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    //低通
    self.LabLP_Text = [[UILabel alloc]init];
    [self.view addSubview:self.LabLP_Text];
    [self.LabLP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabLP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabLP_Text.text=[LANG DPLocalizedString:@"L_XOver_LowPass"];
    self.LabLP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabLP_Text.adjustsFontSizeToFitWidth = true;
    self.LabLP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabLP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.H_Filter.mas_bottom).offset([Dimens GDimens:15]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    

    
    self.L_Filter = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Filter];
    [self.L_Filter initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:0];
    [self.L_Filter addTarget:self action:@selector(L_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.LabLP_Text.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    self.L_Filter.hidden=true;
    
    self.L_Level = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Level];
    [self.L_Level initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:0];
    [self.L_Level addTarget:self action:@selector(L_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.L_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    self.L_Freq = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Freq];
    [self.L_Freq initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:0];
    [self.L_Freq addTarget:self action:@selector(L_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
//    self.LabFilter_Text = [[UILabel alloc]init];
//    [self.view addSubview:self.LabFilter_Text];
//    [self.LabFilter_Text setBackgroundColor:[UIColor clearColor]];
//    [self.LabFilter_Text setTextColor:SetColor(UI_XOver_LabText)];
//    self.LabFilter_Text.text=[LANG DPLocalizedString:@"L_XOver_Type"];
//    self.LabFilter_Text.textAlignment = NSTextAlignmentCenter;
//    self.LabFilter_Text.adjustsFontSizeToFitWidth = true;
//    self.LabFilter_Text.font = [UIFont systemFontOfSize:13];
//    [self.LabFilter_Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.centerY.equalTo(self.H_Filter.mas_centerY).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//    self.LabLevel_Text = [[UILabel alloc]init];
//    [self.view addSubview:self.LabLevel_Text];
//    [self.LabLevel_Text setBackgroundColor:[UIColor clearColor]];
//    [self.LabLevel_Text setTextColor:SetColor(UI_XOver_LabText)];
//    self.LabLevel_Text.text=[LANG DPLocalizedString:@"L_XOver_Slope"];
//    self.LabLevel_Text.textAlignment = NSTextAlignmentCenter;
//    self.LabLevel_Text.adjustsFontSizeToFitWidth = true;
//    self.LabLevel_Text.font = [UIFont systemFontOfSize:13];
//    [self.LabLevel_Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.centerY.equalTo(self.H_Level.mas_centerY).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//    self.LabFreq_Text = [[UILabel alloc]init];
//    [self.view addSubview:self.LabFreq_Text];
//    [self.LabFreq_Text setBackgroundColor:[UIColor clearColor]];
//    [self.LabFreq_Text setTextColor:SetColor(UI_XOver_LabText)];
//    self.LabFreq_Text.text=[LANG DPLocalizedString:@"L_XOver_Frequency"];
//    self.LabFreq_Text.textAlignment = NSTextAlignmentCenter;
//    self.LabFreq_Text.adjustsFontSizeToFitWidth = true;
//    self.LabFreq_Text.font = [UIFont systemFontOfSize:13];
//    [self.LabFreq_Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.centerY.equalTo(self.H_Freq.mas_centerY).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];

    
    
    [self.H_Filter setNormal];
    [self.H_Level setNormal];
    [self.H_Freq setNormal];
    
    [self.L_Filter setNormal];
    [self.L_Level setNormal];
    [self.L_Freq setNormal];
    
    [self flashXOver];
}

- (void)H_Fifter_CLick:(NormalButton*)sender{
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].h_level == 0){
            return;
        }
    }
    Bool_HL = true;
    B_Buf = sender;
    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)H_Level_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = true;
    [self showLevelOptDialog];
    
    
}
- (void)H_Freq_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = true;
    [self showFreqDialog];
    
}
- (void)L_Fifter_CLick:(NormalButton*)sender{
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].l_level == 0){
            return;
        }
    }
    Bool_HL = false;
    B_Buf = sender;
    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)L_Level_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = false;
    [self showLevelOptDialog];
    
}
- (void)L_Freq_CLick:(NormalButton*)sender{
    [sender setPress];
    B_Buf = sender;
    Bool_HL = false;
    [self showFreqDialog];
    
    
}

- (void)flashXOver{
    if(RecStructData.OUT_CH[output_channel_sel].h_filter > 3 || RecStructData.OUT_CH[output_channel_sel].h_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].h_filter = 0;
        
        
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].h_filter=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].h_filter);
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_filter > 3 || RecStructData.OUT_CH[output_channel_sel].l_filter < 0){
        RecStructData.OUT_CH[output_channel_sel].l_filter = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].l_filter=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].l_filter);
    }
    
    if(RecStructData.OUT_CH[output_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].h_level < 0){
        RecStructData.OUT_CH[output_channel_sel].h_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].h_level=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].h_level);
    }
    if(RecStructData.OUT_CH[output_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.OUT_CH[output_channel_sel].l_level < 0){
        RecStructData.OUT_CH[output_channel_sel].l_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.OUT_CH[%d].l_level=%d",output_channel_sel,RecStructData.OUT_CH[output_channel_sel].l_level);
    }
    
    //滤波器
    [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_filter]]  forState:UIControlStateNormal];
    [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_filter]]  forState:UIControlStateNormal];
    //斜率
    [self.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_level]]  forState:UIControlStateNormal];
    [self.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_level]]  forState:UIControlStateNormal];
    //频率
    [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
    [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
    
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].h_level == 0){
            [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            
        }else{
            [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_filter]] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
    }else{
        [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].h_filter]] forState:UIControlStateNormal] ;
        [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }
    
    
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.OUT_CH[output_channel_sel].l_level == 0){
            [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            
        }else{
            [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_filter]] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
    }else{
        [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[output_channel_sel].l_filter]] forState:UIControlStateNormal] ;
        [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
    }
}

#pragma 弹出选择 Filter

- (void)showFilterOptDialog{
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetFilter:0];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:1];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterBW"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:2];
        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetFilter:(int)val{
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_filter = val;
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.OUT_CH[output_channel_sel].h_level == 0){
                [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
                
            }else{
                [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
                [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
            }
        }else{
            [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            [self.H_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
        [self flashLinkSyncData:UI_HFilter];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_filter = val;
        
        if(BOOL_FilterHide6DB_OCT){
            if(RecStructData.OUT_CH[output_channel_sel].l_level == 0){
                [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
                [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Disable) forState:UIControlStateNormal];
            }else{
                [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
                [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
            }
        }else{
            [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:val]] forState:UIControlStateNormal] ;
            [self.L_Filter setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
        }
        [self flashLinkSyncData:UI_LFilter];
    }
    
    
}
#pragma 弹出选择 Level
- (void)showLevelOptDialog{
    
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    if(output_channel_sel <= 3){
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc6dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:0];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:1];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
        
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc6dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:0];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:1];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc18dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:2];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc24dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:3];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [B_Buf setNormal];
        }]];
    }
    
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc6dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:0];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:1];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc18dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:2];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc24dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:3];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc30dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:4];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc36dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:5];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc42dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:6];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setTitleColor:SetColor(UI_XOver_BtnText_Normal) forState:UIControlStateNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc48dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:7];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_OtcOFF"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:8];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        [B_Buf setNormal];
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        [B_Buf setNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dialogSetLevel:(int)val{
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_level = val;
        [self.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.OUT_CH[output_channel_sel].h_filter];
        
        [self flashLinkSyncData:UI_HOct];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_level = val;
        [self.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.OUT_CH[output_channel_sel].l_filter];
        
        [self flashLinkSyncData:UI_LOct];
    }
}
#pragma 弹出选择 Freq

-(void)showFreqDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(0, 0, 280, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetFreq"];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelTitle];
    
    _btnFreqMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnFreqMinus.frame = CGRectMake(10, 100, 30, 30);
    _btnFreqMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnFreqMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnFreqMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [_btnFreqMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    _btnFreqMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnFreqMinus addTarget:self action:@selector(DialogFreqSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnFreqMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderFreq = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderFreq.dataSource = weakSelf;
    _sliderFreq.minimumValue = 0;
    _sliderFreq.maximumValue = 240;
    if(Bool_HL){
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];
    }else{
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];
    }
    
    [_sliderFreq addTarget:self action:@selector(SBDialogFreqSet) forControlEvents:UIControlEventValueChanged];
    
    /*
     UIImage *stetchTrack1 = [UIImage imageNamed:@"skslider1.png"];
     UIImage *stetchTrack2 = [[UIImage imageNamed:@"skslider2.png"]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
     [_slider setThumbImage: [UIImage imageNamed:@"skbit1.png"] forState:UIControlStateNormal];
     [_slider setMinimumTrackImage:stetchTrack2 forState:UIControlStateNormal];
     [_slider setMaximumTrackImage:stetchTrack1 forState:UIControlStateNormal];
     */
    [contentView addSubview:_sliderFreq];
    
    
    
    _btnFreqAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnFreqAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnFreqAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnFreqAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [_btnFreqAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    _btnFreqAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnFreqAdd addTarget:self action:@selector(DialogFreqSet_Inc) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnFreqAdd];
    //长按
    UILongPressGestureRecognizer *longPressFreqVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_FreqVolumeSUB_LongPress:)];
    longPressFreqVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [_btnFreqMinus addGestureRecognizer:longPressFreqVolMinus];
    
    UILongPressGestureRecognizer *longPressFreqVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_FreqVolumeAdd_LongPress:)];
    longPressFreqVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [_btnFreqAdd addGestureRecognizer:longPressFreqVolAdd];
    
    
    
    
    
    NormalButton *btnOK = [NormalButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.frame = CGRectMake(110, 100, 60, 25);
    [btnOK initView:3 withBorderWidth:1 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
    [btnOK setTitleColor:SetColor(0xffffffff) forState:UIControlStateNormal];
    //[btnOK setTitleColor:SetColor(UI_SystemBtnColorNormal) forState:UIControlStateNormal];//常态
    [btnOK setTitleColor:SetColor(UI_SystemBtnColorPress) forState:UIControlStateHighlighted];//选中
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_PressStatus:) forControlEvents:UIControlEventTouchDown];
    //    [btnOK addTarget:self action:@selector(Btn_NormalButtom_NormalStatus:) forControlEvents:UIControlEventTouchDragOutside];
    [btnOK setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    btnOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnOK addTarget:self action:@selector(dialogExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)dialogExit{
    [B_Buf setNormal];
}

- (void)KxMenutapCloseAction:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [B_Buf setNormal];
    });
}
- (void)SBDialogFreqSet{
    int sliderValue = (int)(_sliderFreq.value);
    _sliderFreq.showValue=[NSString stringWithFormat:@"%dHz",(int)FREQ241[sliderValue]];
    if(Bool_HL){
        RecStructData.OUT_CH[output_channel_sel].h_freq = FREQ241[sliderValue];
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        
        
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_HFreq];
    }else{
        RecStructData.OUT_CH[output_channel_sel].l_freq = FREQ241[sliderValue];
        
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_LFreq];
    }
    
}

- (void)DialogFreqSet_Sub{
    if(Bool_HL){
        if(--RecStructData.OUT_CH[output_channel_sel].h_freq < 20){
            RecStructData.OUT_CH[output_channel_sel].h_freq = 20;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
        }
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(--RecStructData.OUT_CH[output_channel_sel].l_freq < 20){
            RecStructData.OUT_CH[output_channel_sel].l_freq = 20;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_LFreq];
    }
}
- (void)DialogFreqSet_Inc{
    if(Bool_HL){
        if(++RecStructData.OUT_CH[output_channel_sel].h_freq > 20000){
            RecStructData.OUT_CH[output_channel_sel].h_freq = 20000;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].h_freq =
            RecStructData.OUT_CH[output_channel_sel].l_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].h_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].h_freq]];
        
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].h_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(++RecStructData.OUT_CH[output_channel_sel].l_freq > 20000){
            RecStructData.OUT_CH[output_channel_sel].l_freq = 20000;
        }
        
        if(RecStructData.OUT_CH[output_channel_sel].h_freq >
           RecStructData.OUT_CH[output_channel_sel].l_freq){
            
            RecStructData.OUT_CH[output_channel_sel].l_freq =
            RecStructData.OUT_CH[output_channel_sel].h_freq;
        }
        if(BOOL_SET_SpkType){
            int fr=[self getChannelNum:output_channel_sel];
            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
                if(RecStructData.OUT_CH[output_channel_sel].l_freq <1000){
                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
                }
            }
        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.OUT_CH[output_channel_sel].l_freq]];
        
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[output_channel_sel].l_freq] forState:UIControlStateNormal];
        
        [self flashLinkSyncData:UI_LFreq];
    }
}
//长按操作
-(void)Btn_FreqVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolFreqMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Sub) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolFreqMinusTimer.isValid){
            [_pVolFreqMinusTimer invalidate];
            _pVolFreqMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_FreqVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolFreqAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogFreqSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolFreqAddTimer.isValid){
            [_pVolFreqAddTimer invalidate];
            _pVolFreqAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}

- (int)getFreqIndexFromArray:(int)freq{
    int i=0;
    for(i=0;i<240;i++){
        if((freq >= FREQ241[i])&&(freq <= FREQ241[i+1])){
            break;
        }
    }
    return i;
}

- (void)checkAndGetLinkItem{
    if(BOOL_SET_SpkType){
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        
        int Dto=0xff;
        for(int i=0;i<ChannelLinkCnt;i++){
            if(ChannelLinkBuf[i][0]==output_channel_sel){
                Dto=ChannelLinkBuf[i][1];
                break;
            }else if(ChannelLinkBuf[i][1]==output_channel_sel){
                Dto=ChannelLinkBuf[i][0];
                break;
            }
        }
        //LinkXOverItem = (XOverItem *)[self.view viewWithTag:Dto+TagStart_XOVER_Self];
        
    }
}

- (int) getChannelNum:(int)channel{
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8] = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9] = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
    
    for(int i=0;i<16;i++){
        if(ChannelNumBuf[i]<0){
            ChannelNumBuf[i]=0;
        }
        if(ChannelNumBuf[i]>maxSpkType){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
}


#pragma initOutput

- (void)initOutput{
    //通道音量显示
    self.LabOutVal_Text = [[UILabel alloc]init];
    [self.view addSubview:self.LabOutVal_Text];
    [self.LabOutVal_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabOutVal_Text setTextColor:[UIColor whiteColor]];
    self.LabOutVal_Text.text=[LANG DPLocalizedString:@"L_Out_OutputValText"];
    self.LabOutVal_Text.textAlignment = NSTextAlignmentCenter;
    self.LabOutVal_Text.adjustsFontSizeToFitWidth = true;
    self.LabOutVal_Text.font = [UIFont systemFontOfSize:14];
    [self.LabOutVal_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectorHorizontal.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:180], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    self.LabOutVal_Text.hidden=false;
    
    self.LabOutVal = [[UILabel alloc]init];
    [self.view addSubview:self.LabOutVal];
    [self.LabOutVal setBackgroundColor:[UIColor clearColor]];
    [self.LabOutVal setTextColor:SetColor(UI_OutValColor)];
    self.LabOutVal.text=@"38";
    self.LabOutVal.textAlignment = NSTextAlignmentCenter;
    self.LabOutVal.adjustsFontSizeToFitWidth = true;
    self.LabOutVal.font = [UIFont systemFontOfSize:100];
    [self.LabOutVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.top.equalTo(self.LabOutVal_Text.mas_bottom).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:200], [Dimens GDimens:140]));
    }];
    
    self.SB_OutVal = [[UISlider alloc]init];
    [self.view addSubview:self.SB_OutVal];
    self.SB_OutVal.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.SB_OutVal.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_OutVal setMinimumValue:0];
    [self.SB_OutVal setMaximumValue:Output_Volume_MAX/Output_Volume_Step];
    [self.SB_OutVal setBackgroundColor:[UIColor clearColor]];
    [self.SB_OutVal setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.SB_OutVal setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    [self.SB_OutVal addTarget:self action:@selector(SB_OutVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_OutVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.top.equalTo(self.LabOutVal.mas_bottom).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:260], [Dimens GDimens:40]));
    }];
    
    
    //Seekbar
    /*
    self.SB_OutVal = [[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:OutputPageOut_SB_Size], [Dimens GDimens:OutputPageOut_SB_Size])];
    self.SB_OutVal.center = self.view.center;
    [self.view addSubview:self.SB_OutVal];
    [self.SB_OutVal addTarget:self action:@selector(SB_OutVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_OutVal setMaxProgress:Output_Volume_MAX/Output_Volume_Step];
    [self.SB_OutVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.selectorHorizontal.mas_top).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOut_SB_Size], [Dimens GDimens:OutputPageOut_SB_Size]));
    }];
    */
    //通道名字
    self.setOutNameDialog = [[OutNameSet alloc]init];
    self.OutName = [[NormalButton alloc]init];
    [self.view addSubview:self.OutName];
    [self.OutName initViewBroder:3
                 withBorderWidth:1
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_SystemBtnColorNormal
            withBorderPressColor:UI_SystemBtnColorPress
             withTextNormalColor:UI_SystemLableColorNormal
              withTextPressColor:UI_SystemLableColorPress
                        withType:4];
    [self.OutName addTarget:self action:@selector(OutName_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutName setTitle:[LANG DPLocalizedString:@"NULL"] forState:UIControlStateNormal] ;
    self.OutName.titleLabel.adjustsFontSizeToFitWidth = true;
    self.OutName.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.OutName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SB_OutVal.mas_bottom).offset([Dimens GDimens:OutputPageMarginSide/2]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    [self.OutName setNormal];
    //正反相
    self.OutPolar = [[NormalButton alloc]init];
    [self.view addSubview:self.OutPolar];
    [self.OutPolar initViewBroder:3
                 withBorderWidth:1
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_SystemBtnColorNormal
            withBorderPressColor:UI_SystemBtnColorPress
             withTextNormalColor:UI_SystemLableColorNormal
              withTextPressColor:UI_SystemLableColorPress
                        withType:4];
    [self.OutPolar addTarget:self action:@selector(OutPolar_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    self.OutPolar.titleLabel.adjustsFontSizeToFitWidth = true;
    self.OutPolar.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.OutPolar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.OutName.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];

    //静音
    self.OutMute = [[NormalButton alloc]init];
    [self.view addSubview:self.OutMute];
    [self.OutMute initViewBroder:3
                           withBorderWidth:1
                           withNormalColor:UI_DelayBtn_NormalIN
                            withPressColor:UI_DelayBtn_PressIN
                     withBorderNormalColor:UI_SystemBtnColorNormal
                      withBorderPressColor:UI_SystemBtnColorPress
                       withTextNormalColor:UI_SystemLableColorNormal
                        withTextPressColor:UI_SystemLableColorPress
                                  withType:4];
    self.OutMute.backgroundColor = [UIColor clearColor];
    [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
//    self.OutMute.imageEdgeInsets = UIEdgeInsetsMake(
//                                                           0,
//                                                           [Dimens GDimens:OutputPageXoverBtnWidth]/2-[Dimens GDimens:OutputPageXoverBtnHeight]/2,
//                                                           0,
//                                                           [Dimens GDimens:OutputPageXoverBtnWidth]/2-[Dimens GDimens:OutputPageXoverBtnHeight]/2
//                                                           );
    [self.OutMute addTarget:self action:@selector(Btn_OutputMute_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.centerY.equalTo(self.OutName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
//    self.mIVMid = [[UIView alloc]init];
//    [self.view addSubview:self.mIVMid];
//    [self.mIVMid setBackgroundColor:SetColor(UI_MidLineColor)];
//    [self.mIVMid mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.SB_OutVal.mas_bottom).offset(0);
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:1], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
    
    
    //音量增减
    self.Btn_OutputVolumeSub = [[UIButton alloc]init];
    [self.Btn_OutputVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_s_sub_normal"] forState:UIControlStateNormal];
    [self.Btn_OutputVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_s_sub_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.Btn_OutputVolumeSub];
    [self.Btn_OutputVolumeSub addTarget:self action:@selector(OutputVolume_SUB:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_OutputVolumeAdd = [[UIButton alloc]init];
    [self.Btn_OutputVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_s_inc_normal"] forState:UIControlStateNormal];
    [self.Btn_OutputVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_s_inc_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.Btn_OutputVolumeAdd];
    [self.Btn_OutputVolumeAdd addTarget:self action:@selector(OutputVolume_INC:) forControlEvents:UIControlEventTouchUpInside];
    //长按
    UILongPressGestureRecognizer *longPressMainVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_OutputVolumeSUB_LongPress:)];
    longPressMainVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [self.Btn_OutputVolumeSub addGestureRecognizer:longPressMainVolMinus];
    
    UILongPressGestureRecognizer *longPressMainVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_OutputVolumeAdd_LongPress:)];
    longPressMainVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [self.Btn_OutputVolumeAdd addGestureRecognizer:longPressMainVolAdd];
    
    
    
    //音量增减
    [self.Btn_OutputVolumeSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_OutVal.mas_centerY);
        make.right.equalTo(self.SB_OutVal.mas_left).offset([Dimens GDimens:-10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:35], [Dimens GDimens:35]));
    }];
    
    [self.Btn_OutputVolumeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_OutVal.mas_centerY);
        make.left.equalTo(self.SB_OutVal.mas_right).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:35], [Dimens GDimens:35]));
    }];
    
    self.Btn_OutputVolumeSub.hidden = false;
    self.Btn_OutputVolumeAdd.hidden = false;

}


//主音量长按操作
-(void)Btn_OutputVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OutputVolume_SUB:) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolMinusTimer.isValid){
            [_pMainVolMinusTimer invalidate];
            _pMainVolMinusTimer = nil;
        }
    }
    
}

-(void)Btn_OutputVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OutputVolume_INC:) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolAddTimer.isValid){
            [_pMainVolAddTimer invalidate];
            _pMainVolAddTimer = nil;
        }
    }
}

-(void)OutputVolume_SUB:(id)sender{
    
    RecStructData.OUT_CH[output_channel_sel].gain -= Output_Volume_Step;
    if(RecStructData.OUT_CH[output_channel_sel].gain < 0){
        RecStructData.OUT_CH[output_channel_sel].gain = 0;
    }
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    self.SB_OutVal.value = RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step;
    
    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
}
-(void)OutputVolume_INC:(id)sender{
    RecStructData.OUT_CH[output_channel_sel].gain += Output_Volume_Step;
    if(RecStructData.OUT_CH[output_channel_sel].gain > Output_Volume_MAX){
        RecStructData.OUT_CH[output_channel_sel].gain = Output_Volume_MAX;
    }
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    self.SB_OutVal.value = RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step;
    
    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];

}

//静音
-(void)Btn_OutputMute_Click:(NormalButton *)sender{
    if(RecStructData.OUT_CH[output_channel_sel].mute != 0){
        RecStructData.OUT_CH[output_channel_sel].mute = 0;
        [sender setPress];
        [self.OutMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
    }else{
        [sender setNormal];
        RecStructData.OUT_CH[output_channel_sel].mute = 1;
        [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    }
}
//正反相
-(void)OutPolar_CLick:(NormalButton *)sender{
    if(RecStructData.OUT_CH[output_channel_sel].polar != 0){
        RecStructData.OUT_CH[output_channel_sel].polar = 0;
        [sender setNormal];
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    }else{
        [sender setPress];
        RecStructData.OUT_CH[output_channel_sel].polar = 1;
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
    }
}
-(void)OutName_CLick:(NormalButton *)sender{
    if(BOOL_LOCK){
        return;
    }
//    [self showOutputSpkTypeList:sender];
    /**/
    [self.setOutNameDialog flashOutputState:[self getChannelNum:output_channel_sel]];
    [self.setOutNameDialog.Btn_Ok addTarget:self action:@selector(setOutNameDialog_Ok_Click:) forControlEvents:UIControlEventTouchUpInside];
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] setOKButton:self.setOutNameDialog.Btn_Ok];
    [[KGModal sharedInstance] setOKButton:self.setOutNameDialog.Btn_Cancel];
    [[KGModal sharedInstance] showWithContentView:self.setOutNameDialog andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
    
    
}
-(void)SB_OutVol_Val_Change:(UISlider *)sender{
    
    RecStructData.OUT_CH[output_channel_sel].gain = (int)sender.value*Output_Volume_Step;//[sender GetProgress]*Output_Volume_Step;
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    
    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
}




-(void)setOutNameDialog_Ok_Click:(UIButton *)sender{
    
    NSString *outname = [self.setOutNameDialog getOutputName];
    [self.setOutNameDialog flashOutputType:[self.setOutNameDialog getOutputTypeNum:outname]];

    [self.OutName setTitle:outname forState:UIControlStateNormal];
    int spk=[self.setOutNameDialog getCurSpkType];
    
    [self setOutputSpkType:spk];
    NSLog(@"setOutNameDialog_Ok_Click output_channel_sel=%d,spk=%d",output_channel_sel,spk);
    if(spk == 0){
        RecStructData.OUT_CH[output_channel_sel].IN1_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN2_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN3_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN4_Vol = 0;
        
        RecStructData.OUT_CH[output_channel_sel].IN5_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN6_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN7_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN8_Vol = 0;
        
        RecStructData.OUT_CH[output_channel_sel].IN9_Vol  = 0;
        RecStructData.OUT_CH[output_channel_sel].IN10_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN11_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN12_Vol = 0;
        
        RecStructData.OUT_CH[output_channel_sel].IN13_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN14_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN15_Vol = 0;
        RecStructData.OUT_CH[output_channel_sel].IN16_Vol = 0;
    }
    setXOverFreqWithOutputSpkType(output_channel_sel);
    [self setMixerVolWithOutputSpk:output_channel_sel];
    [self FlashPageUI];
}



- (void)setOutputSpkType:(int)type{
    switch (output_channel_sel) {
        case 0: RecStructData.System.out1_spk_type = type; break;
        case 1: RecStructData.System.out2_spk_type = type; break;
        case 2: RecStructData.System.out3_spk_type = type; break;
            
        case 3: RecStructData.System.out4_spk_type = type; break;
        case 4: RecStructData.System.out5_spk_type = type; break;
        case 5: RecStructData.System.out6_spk_type = type; break;
            
        case 6: RecStructData.System.out7_spk_type = type; break;
        case 7: RecStructData.System.out8_spk_type = type; break;
        case 8: RecStructData.System.out9_spk_type = type; break;
            
        case 9: RecStructData.System.out10_spk_type = type; break;
        case 10: RecStructData.System.out11_spk_type = type; break;
        case 11: RecStructData.System.out12_spk_type = type; break;
            
        case 12: RecStructData.System.out13_spk_type = type; break;
        case 13: RecStructData.System.out14_spk_type = type; break;
        case 14: RecStructData.System.out15_spk_type = type; break;
            
        case 15: RecStructData.System.out16_spk_type = type; break;
        default:
            break;
    }
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]  = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]  = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
}


- (void)flashOutput{
//    self.SB_OutVal.value = RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step;
//    //[self.SB_OutVal setProgress:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step ];
//    
//    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
//    if(RecStructData.OUT_CH[output_channel_sel].mute == 0){
//        [self.OutMute setPress];
//        [self.OutMute setImage:[UIImage imageNamed:@"master_mute_press"] forState:UIControlStateNormal];
//    }else{
//        [self.OutMute setNormal];
//        [self.OutMute setImage:[UIImage imageNamed:@"master_mute_normal"] forState:UIControlStateNormal];
//    }
//    if(RecStructData.OUT_CH[output_channel_sel].polar == 0){
//        [self.OutPolar setNormal];
//        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
//    }else{
//        [self.OutPolar setPress];
//        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
//    }
//    //Name
////    [self.OutName setTitle:[self.setOutNameDialog getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
//    [self.OutName setTitle:[self getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if(RecStructData.OUT_CH[i].polar == 1){
            [self setOutItemPolar:true wihtCh:i];
        }else{
            [self setOutItemPolar:false wihtCh:i];
        }
        
        if(RecStructData.OUT_CH[i].mute == 1){
            [self setOutItemMute:false wihtCh:i];
        }else{
            [self setOutItemMute:true wihtCh:i];
        }
        
        [self setOutItemVal:i];
    }
    
}


#pragma initChannelSet

- (void)initChannelSet{
//    UIView *mLine2 = [[UIView alloc]init];
//    [self.view addSubview:mLine2];
//    [mLine2 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.L_Filter.mas_bottom).offset([Dimens GDimens:20]);
//        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 1));
//    }];
    //重置
    self.Btn_Reset = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Reset];
    [self.Btn_Reset initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:4];
    self.Btn_Reset.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Reset addTarget:self action:@selector(Btn_Reset_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Reset setTitle:[LANG DPLocalizedString:@"L_Out_Reset"] forState:UIControlStateNormal] ;
    self.Btn_Reset.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.Btn_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(mLine2.mas_bottom).offset([Dimens GDimens:30]);
//        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOutSetBtnWidth], [Dimens GDimens:OutputPageOutSetBtnHeight]));
    }];
    //锁定
    self.Btn_Reset.hidden = true;
    self.Btn_Lock = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Lock];
    [self.Btn_Lock initViewBroder:3
                   withBorderWidth:1
                   withNormalColor:UI_DelayBtn_NormalIN
                    withPressColor:UI_DelayBtn_PressIN
             withBorderNormalColor:UI_XOver_Btn_Normal
              withBorderPressColor:UI_XOver_Btn_Press
               withTextNormalColor:UI_XOver_BtnText_Normal
                withTextPressColor:UI_XOver_BtnText_Press
                          withType:4];
    self.Btn_Lock.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Lock addTarget:self action:@selector(Btn_Lock_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
    self.Btn_Lock.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Lock.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //联调
    self.Btn_Link = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Link];
    [self.Btn_Link initViewBroder:3
                   withBorderWidth:1
                   withNormalColor:UI_DelayBtn_NormalIN
                    withPressColor:UI_DelayBtn_PressIN
             withBorderNormalColor:UI_XOver_Btn_Normal
              withBorderPressColor:UI_XOver_Btn_Press
               withTextNormalColor:UI_XOver_BtnText_Normal
                withTextPressColor:UI_XOver_BtnText_Press
                          withType:0];
    self.Btn_Link.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Link addTarget:self action:@selector(Btn_Link_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    self.Btn_Link.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Link.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.Btn_Link mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:80]);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOutSetBtnWidth], [Dimens GDimens:OutputPageOutSetBtnHeight]));
    }];

    //联调状态

    self.mVLink = [[UIView alloc]init];
    [self.view addSubview:self.mVLink];
    [self.mVLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_Reset.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    self.mVLink.hidden = true;
    
    self.mImgLink = [[UIImageView alloc]init];
    [self.mVLink addSubview:self.mImgLink];
    [self.mImgLink setImage:[UIImage imageNamed:@"linked"]];
    [self.mImgLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.mVLink.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:15]));
    }];

    self.LabLeftCh = [[UILabel alloc]init];
    [self.mVLink addSubview:self.LabLeftCh];
    [self.LabLeftCh setBackgroundColor:[UIColor clearColor]];
    [self.LabLeftCh setTextColor:SetColor(UI_OutLinkGroup_Text_Color)];
    self.LabLeftCh.text=[LANG DPLocalizedString:@"CH1"];
    self.LabLeftCh.textAlignment = NSTextAlignmentLeft;
    self.LabLeftCh.adjustsFontSizeToFitWidth = true;
    self.LabLeftCh.font = [UIFont systemFontOfSize:10];
    [self.LabLeftCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.mVLink.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    self.LabRightCh = [[UILabel alloc]init];
    [self.mVLink addSubview:self.LabRightCh];
    [self.LabRightCh setBackgroundColor:[UIColor clearColor]];
    [self.LabRightCh setTextColor:SetColor(UI_OutLinkGroup_Text_Color)];
    self.LabRightCh.text=[LANG DPLocalizedString:@"CH2"];
    self.LabRightCh.textAlignment = NSTextAlignmentRight;
    self.LabRightCh.adjustsFontSizeToFitWidth = true;
    self.LabRightCh.font = [UIFont systemFontOfSize:10];
    [self.LabRightCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.mVLink.mas_right).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
}


- (void)Btn_Reset_Click:(NormalButton*)sender{
    [self showOutputResetDialog];
}

- (void)Btn_Lock_Click:(NormalButton*)sender{
    [self showOutputLockDialog];
}

- (void)Btn_Link_Click:(NormalButton*)sender{
    if((LinkMODE == LINKMODE_SPKTYPE)||(LinkMODE == LINKMODE_SPKTYPE_S)){
        if(BOOL_LINK){
            [self setUnlinkState];
        }else{
            [self CheckChannelCanLink];
            if(ChannelLinkCnt >0){
                [self showOutputLinkDialog];
            }else{
                [self showNoLinkDialog];
            }
        }
    }else if(LinkMODE == LINKMODE_LEFTRIGHT){
        if(BOOL_LINK){
            [self setUnlinkState];
        }else{
            [self showOutputLinkDialog];
        }
    }
    
    
    
    
}

- (void)flashLinkViewState{
    [self CheckChannelCanLink];
    if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
        self.mVLink.hidden = true;
        return;
    }
    BOOL link=false;
    int  bli=0;
    for(int i=0;i<ChannelLinkCnt;i++){
        if((ChannelLinkBuf[i][0] == output_channel_sel)||(ChannelLinkBuf[i][1] == output_channel_sel)){
            bli = i;
            link=true;
            break;
        }
    }
    
    
    if(link){
        self.mVLink.hidden = false;
        self.LabLeftCh.text = [NSString stringWithFormat:@"CH%d",ChannelLinkBuf[bli][0]+1];
        self.LabRightCh.text = [NSString stringWithFormat:@"CH%d",ChannelLinkBuf[bli][1]+1];
    }else{
        self.mVLink.hidden = true;
    }
}

- (void)showOutputResetDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Reset"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Set"]preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_Emptied"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setOutputSpkTypeClean];
        [self setUnlinkState];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_Default"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setOutputSpkTypeDefault];
        [self setUnlinkState];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOutputLockDialog{
    UIAlertController *alert;
    
    if(BOOL_LOCK){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Unlock"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_unlock"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Locked"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Locked"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(BOOL_LOCK){
            BOOL_LOCK=false;
            [self setUnlinkState];
        }else{
            [self checkLock];
        }
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNotLockDialog{
    UIAlertController *alert;
    
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Locked"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_cannotlock"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)checkLock{
    BOOL lock=false;
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]  = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]  = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
    
    for(int i=0;i<Output_CH_MAX;i++){
        if(ChannelNumBuf[i]!=0){
            lock=true;
            break;
        }
    }
    
    if(lock){
        BOOL_LOCK=true;
        [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Unlock"] forState:UIControlStateNormal] ;
        [self.Btn_Lock setPress];
    }else{
        [self showNotLockDialog];
    }
}




- (void)showOutputLinkDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Set_LinkLR"]message:[LANG DPLocalizedString:@"L_Out_Opt_Channel_Link"]preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_LeftToRight"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setLinkState];
        BOOL_LeftCyRight = true;
        setDataSyncLink();
        [self FlashPageUI];
        [self.mDataTransmitOpt conformsToProtocol:false];
        [self.mDataTransmitOpt SEFF_Save:0];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Out_RightToLeft"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setLinkState];
        BOOL_LeftCyRight = false;
        setDataSyncLink();
        [self FlashPageUI];
        [self.mDataTransmitOpt conformsToProtocol:false];
        [self.mDataTransmitOpt SEFF_Save:0];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNoLinkDialog{
    UIAlertController *alert;
    
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Link"]message:[LANG DPLocalizedString:@"L_Out_NoLinkLR"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma 功能函数

- (void)setOutputSpkTypeDefault{
    RecStructData.System.out1_spk_type=3;
    RecStructData.System.out2_spk_type=9;
    RecStructData.System.out3_spk_type=2;
    RecStructData.System.out4_spk_type=8;
    RecStructData.System.out5_spk_type=1;
    RecStructData.System.out6_spk_type=7;
    RecStructData.System.out7_spk_type=14;
    RecStructData.System.out8_spk_type=17;
    
    RecStructData.System.out9_spk_type =13;
    RecStructData.System.out10_spk_type=16;
    RecStructData.System.out11_spk_type=21;
    RecStructData.System.out12_spk_type=24;
    
    
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    ChannelNumBuf[8] = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9] = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
    
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
        [self setMixerVolWithOutputSpk:i];
    }
    
    [self FlashOutputSpkType];
    
}
- (void)setOutputSpkTypeClean{
    RecStructData.System.out1_spk_type=0;
    RecStructData.System.out2_spk_type=0;
    RecStructData.System.out3_spk_type=0;
    RecStructData.System.out4_spk_type=0;
    RecStructData.System.out5_spk_type=0;
    RecStructData.System.out6_spk_type=0;
    RecStructData.System.out7_spk_type=0;
    RecStructData.System.out8_spk_type=0;
    
    RecStructData.System.out9_spk_type=0;
    RecStructData.System.out10_spk_type=0;
    RecStructData.System.out11_spk_type=0;
    RecStructData.System.out12_spk_type=0;
    
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
    
    
    [self FlashOutputSpkType];
}
- (void) setMixerVolWithOutputSpk:(int) chsel{
    int spk_type=0;
    switch (chsel) {
        case 0: spk_type = RecStructData.System.out1_spk_type;break;
        case 1: spk_type = RecStructData.System.out2_spk_type;break;
        case 2: spk_type = RecStructData.System.out3_spk_type;break;
        case 3: spk_type = RecStructData.System.out4_spk_type;break;
        case 4: spk_type = RecStructData.System.out5_spk_type;break;
        case 5: spk_type = RecStructData.System.out6_spk_type;break;
        case 6: spk_type = RecStructData.System.out7_spk_type;break;
        case 7: spk_type = RecStructData.System.out8_spk_type;break;
            
        case 8: spk_type = RecStructData.System.out9_spk_type;break;
        case 9: spk_type = RecStructData.System.out10_spk_type;break;
        case 10: spk_type = RecStructData.System.out11_spk_type;break;
        case 11: spk_type = RecStructData.System.out12_spk_type;break;
        case 12: spk_type = RecStructData.System.out13_spk_type;break;
        case 13: spk_type = RecStructData.System.out14_spk_type;break;
        case 14: spk_type = RecStructData.System.out15_spk_type;break;
        case 15: spk_type = RecStructData.System.out16_spk_type;break;
        default:
            break;
    }
    
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
            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
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
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 50;
            RecStructData.OUT_CH[chsel].IN14_Vol = 50;
            RecStructData.OUT_CH[chsel].IN15_Vol = 50;
            RecStructData.OUT_CH[chsel].IN16_Vol = 50;
            break;
        case 22://左超低
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
            RecStructData.OUT_CH[chsel].IN11_Vol = 100;
            RecStructData.OUT_CH[chsel].IN12_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 100;
            RecStructData.OUT_CH[chsel].IN14_Vol = 0;
            RecStructData.OUT_CH[chsel].IN15_Vol = 100;
            RecStructData.OUT_CH[chsel].IN16_Vol = 0;
            break;
        case 23://右超低
            RecStructData.OUT_CH[chsel].IN1_Vol = 0;
            RecStructData.OUT_CH[chsel].IN2_Vol = 100;
            RecStructData.OUT_CH[chsel].IN3_Vol = 0;
            RecStructData.OUT_CH[chsel].IN4_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN5_Vol = 0;
            RecStructData.OUT_CH[chsel].IN6_Vol = 0;
            RecStructData.OUT_CH[chsel].IN7_Vol = 0;
            RecStructData.OUT_CH[chsel].IN8_Vol = 0;
            
            RecStructData.OUT_CH[chsel].IN9_Vol  = 0;
            RecStructData.OUT_CH[chsel].IN10_Vol = 100;
            RecStructData.OUT_CH[chsel].IN11_Vol = 0;
            RecStructData.OUT_CH[chsel].IN12_Vol = 100;
            
            RecStructData.OUT_CH[chsel].IN13_Vol = 0;
            RecStructData.OUT_CH[chsel].IN14_Vol = 100;
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
            RecStructData.OUT_CH[chsel].IN8_Vol = 0 ;
            
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
- (void)FlashOutputSpkType{
    [self.OutName setTitle:[self.setOutNameDialog getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
    [self FlashPageUI];
}

- (void)setUnlinkState{
    BOOL_LINK = false;
    BOOL_LOCK = false;
    
    if(LINKMODE_SPKTYPE_S == LinkMODE){
        RecStructData.OUT_CH[0].name[1] = 0;
    }
    
    
    ChannelLinkCnt = 0;
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
    [self.Btn_Lock setNormal];
    
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    [self.Btn_Link setNormal];
    [self.OutName setTitleColor:SetColor(UI_OutName_BtnText_Normal) forState:UIControlStateNormal];
    
    [self flashLinkViewState];
}

- (void)setLinkState{
    BOOL_LINK = true;
    BOOL_LOCK = true;
    
    if(LINKMODE_SPKTYPE_S == LinkMODE){
        RecStructData.OUT_CH[0].name[1] = 1;
    }
    
    
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Unlock"] forState:UIControlStateNormal] ;
    [self.Btn_Lock setPress];
    
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_UnLink"] forState:UIControlStateNormal] ;
    [self.Btn_Link setPress];
    
    [self.OutName setTitleColor:SetColor(UI_OutName_BtnText_Press) forState:UIControlStateNormal];
}
//检查可设置联调的通道
- (void) CheckChannelCanLink{
    /*
    int i=0,j=0;
    ChannelLinkCnt = 0;
    for(i=0;i<16;i++){
        for(j=0;j<2;j++){
            ChannelLinkBuf[i][j]=EndFlag;
        }
    }

    if(((ChannelNumBuf[0] == 6)&&(ChannelNumBuf[1] == 12))
       ||((ChannelNumBuf[0] == 1)&&(ChannelNumBuf[1] == 7))){
        
        ChannelLinkBuf[ChannelLinkCnt][0] = 0;
        ChannelLinkBuf[ChannelLinkCnt][1] = 1;
        
        ++ChannelLinkCnt;
    }
    
    if(((ChannelNumBuf[2] == 15)&&(ChannelNumBuf[3] == 18))
       ||((ChannelNumBuf[2] == 2)&&(ChannelNumBuf[3] == 8))
       ){
        
        ChannelLinkBuf[ChannelLinkCnt][0] = 2;
        ChannelLinkBuf[ChannelLinkCnt][1] = 3;
        
        ++ChannelLinkCnt;
    }
    
    if(((ChannelNumBuf[4] == 5)&&(ChannelNumBuf[5] == 11))
       ||((ChannelNumBuf[4] == 2)&&(ChannelNumBuf[5] == 8))){
        
        ChannelLinkBuf[ChannelLinkCnt][0] = 4;
        ChannelLinkBuf[ChannelLinkCnt][1] = 5;
        
        ++ChannelLinkCnt;
    }
    
    if(((ChannelNumBuf[6] == 3)&&(ChannelNumBuf[7] == 9))){
        
        ChannelLinkBuf[ChannelLinkCnt][0] = 6;
        ChannelLinkBuf[ChannelLinkCnt][1] = 7;
        
        ++ChannelLinkCnt;
    }
    
    if(((ChannelNumBuf[8] == 26)&&(ChannelNumBuf[9] == 25))
       ||((ChannelNumBuf[8] == 23)&&(ChannelNumBuf[9] == 22))
       ||((ChannelNumBuf[8] == 28)&&(ChannelNumBuf[9] == 27))
       ){
        
        ChannelLinkBuf[ChannelLinkCnt][0] = 8;
        ChannelLinkBuf[ChannelLinkCnt][1] = 9;
        
        ++ChannelLinkCnt;
    }
    
     */

    int channelNameNum=0;
    int channelNameNumEls=0;
    int res=0;
    int inc=0;
    int i=0,j=0;
    ChannelLinkCnt = 0;
    for(i=0;i<16;i++){
        for(j=0;j<2;j++){
            ChannelLinkBuf[i][j]=EndFlag;
        }
    }
    for(i=0;i<Output_CH_MAX_USE;i++){
        channelNameNum=[self GetChannelNum:i];
        //NSLog(@"channelNameNum=%d",channelNameNum);
        if(channelNameNum>=0){
            for(j=i+1;j<Output_CH_MAX_USE;j++){
                channelNameNumEls=[self GetChannelNum:j];
                //NSLog(@"channelNameNumEls=%d",channelNameNumEls);
                if((channelNameNum>=1)&&(channelNameNum<=6)&&
                   (channelNameNumEls>=7)&&(channelNameNumEls<=12)){
                    res=channelNameNumEls-channelNameNum;
                    if(res==6){
                        ChannelLinkBuf[inc][0]=i;
                        ChannelLinkBuf[inc][1]=j;
                        ++inc;
                        //NSLog(@"#1 inc=%d",inc);
                    }
                }else if((channelNameNum>=7)&&(channelNameNum<=12)&&
                         (channelNameNumEls>=1)&&(channelNameNumEls<=6)){
                    res=channelNameNum-channelNameNumEls;
                    if(res==6){
                        ChannelLinkBuf[inc][0]=j;
                        ChannelLinkBuf[inc][1]=i;
                        ++inc;
                        //NSLog(@"#2 inc=%d",inc);
                    }
                }else if((channelNameNum>=13)&&(channelNameNum<=15)&&
                         (channelNameNumEls>=16)&&(channelNameNumEls<=18)){
                    res=channelNameNumEls-channelNameNum;
                    if(res==3){
                        ChannelLinkBuf[inc][0]=i;
                        ChannelLinkBuf[inc][1]=j;
                        ++inc;
                        //NSLog(@"#3 inc=%d",inc);
                    }
                }else if((channelNameNum>=16)&&(channelNameNum<=18)&&
                         (channelNameNumEls>=13)&&(channelNameNumEls<=15)){
                    res=channelNameNum-channelNameNumEls;
                    if(res==3){
                        ChannelLinkBuf[inc][0]=j;
                        ChannelLinkBuf[inc][1]=i;
                        ++inc;
                        //NSLog(@"#4 inc=%d",inc);
                    }
                }else if((channelNameNum==22)&&(channelNameNumEls==23)){
                    ChannelLinkBuf[inc][0]=i;
                    ChannelLinkBuf[inc][1]=j;
                    ++inc;
                    //NSLog(@"#5 inc=%d",inc);
                }else if((channelNameNum==23)&&(channelNameNumEls==22)){
                    ChannelLinkBuf[inc][0]=j;
                    ChannelLinkBuf[inc][1]=i;
                    ++inc;
                    //NSLog(@"#6 inc=%d",inc);
                }
            }
        }
    }
    //NSLog(@"inc=%d",inc);
    ChannelLinkCnt = inc;

}

- (int) GetChannelNum:(int)channel{
    
    //更新列表
    [self syncOutputSpkType];
    
    for(int i=0;i<16;i++){
        if(ChannelNumBuf[i]<0){
            ChannelNumBuf[i]=0;
        }
        if(ChannelNumBuf[i]>maxSpkType){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
}

- (NSString*)getOutputSpkTypeNameByIndex:(int)index{
    switch (index) {
        case 0: return [LANG DPLocalizedString:@"L_Out_NULL"];
            
        case 1: return [LANG DPLocalizedString:@"L_Out_FL_Tweeter"];
        case 2: return [LANG DPLocalizedString:@"L_Out_FL_Midrange"];
        case 3: return [LANG DPLocalizedString:@"L_Out_FL_Woofer"];
        case 4: return [LANG DPLocalizedString:@"L_Out_FL_M_T"];
        case 5: return [LANG DPLocalizedString:@"L_Out_FL_M_WF"];
        case 6: return [LANG DPLocalizedString:@"L_Out_FL_Full"];
            
        case 7: return [LANG DPLocalizedString:@"L_Out_FR_Tweeter"];
        case 8: return [LANG DPLocalizedString:@"L_Out_FR_Midrange"];
        case 9: return [LANG DPLocalizedString:@"L_Out_FR_Woofer"];
        case 10: return [LANG DPLocalizedString:@"L_Out_FR_M_T"];
        case 11: return [LANG DPLocalizedString:@"L_Out_FR_M_WF"];
        case 12: return [LANG DPLocalizedString:@"L_Out_FR_Full"];
            
        case 13: return [LANG DPLocalizedString:@"L_Out_RL_Tweeter"];
        case 14: return [LANG DPLocalizedString:@"L_Out_RL_Woofer"];
        case 15: return [LANG DPLocalizedString:@"L_Out_RL_Full"];
            
        case 16: return [LANG DPLocalizedString:@"L_Out_RR_Tweeter"];
        case 17: return [LANG DPLocalizedString:@"L_Out_RR_Woofer"];
        case 18: return [LANG DPLocalizedString:@"L_Out_RR_Full"];
            
        case 19: return [LANG DPLocalizedString:@"L_Out_C_Tweeter"];
        case 20: return [LANG DPLocalizedString:@"L_Out_C_Woofer"];
        case 21: return [LANG DPLocalizedString:@"L_Out_C_Full"];
            
        case 22: return [LANG DPLocalizedString:@"L_Out_L_Subweeter"];
        case 23: return [LANG DPLocalizedString:@"L_Out_R_Subweeter"];
        case 24: return [LANG DPLocalizedString:@"L_Out_Subweeter"];
            
        case 25: return [LANG DPLocalizedString:@"L_Out_Front_Subweeter"];
        case 26: return [LANG DPLocalizedString:@"L_Out_Rear_Subweeter"];
        case 27: return [LANG DPLocalizedString:@"L_Out_C_Front"];
        case 28: return [LANG DPLocalizedString:@"L_Out_C_Rear"];

        default: return [LANG DPLocalizedString:@"L_Out_NULL"];
    }
}

//根据通道名字获取通道类型
- (int)getOutputSpkTypeNumByName:(NSString*)Name{
    if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_NULL"]]){
        return 0;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Tweeter"]]){
        return 1;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Midrange"]]){
        return 2;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Woofer"]]){
        return 3;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_M_T"]]){
        return 4;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_M_WF"]]){
        return 5;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FL_Full"]]){
        return 6;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Tweeter"]]){
        return 7;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Midrange"]]){
        return 8;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Woofer"]]){
        return 9;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_M_T"]]){
        return 10;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_M_WF"]]){
        return 11;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_FR_Full"]]){
        return 12;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Tweeter"]]){
        return 13;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Woofer"]]){
        return 14;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RL_Full"]]){
        return 15;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Tweeter"]]){
        return 16;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Woofer"]]){
        return 17;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_RR_Full"]]){
        return 18;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Tweeter"]]){
        return 19;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Woofer"]]){
        return 20;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Full"]]){
        return 21;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_L_Subweeter"]]){
        return 22;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_R_Subweeter"]]){
        return 23;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_Subweeter"]]){
        return 24;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_Front_Subweeter"]]){
        return 25;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_Rear_Subweeter"]]){
        return 26;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Front"]]){
        return 27;
    }else if([Name isEqualToString:[LANG DPLocalizedString:@"L_Out_C_Rear"]]){
        return 28;
    }
    return 0;
}

- (void)syncOutputSpkType{
    ChannelNumBuf[0]= RecStructData.System.out1_spk_type;
    ChannelNumBuf[1]= RecStructData.System.out2_spk_type;
    ChannelNumBuf[2]= RecStructData.System.out3_spk_type;
    ChannelNumBuf[3]= RecStructData.System.out4_spk_type;
    ChannelNumBuf[4]= RecStructData.System.out5_spk_type;
    ChannelNumBuf[5]= RecStructData.System.out6_spk_type;
    ChannelNumBuf[6]= RecStructData.System.out7_spk_type;
    ChannelNumBuf[7]= RecStructData.System.out8_spk_type;
    
    ChannelNumBuf[8]  = RecStructData.System.out9_spk_type;
    ChannelNumBuf[9]  = RecStructData.System.out10_spk_type;
    ChannelNumBuf[10] = RecStructData.System.out11_spk_type;
    ChannelNumBuf[11] = RecStructData.System.out12_spk_type;
    ChannelNumBuf[12] = RecStructData.System.out13_spk_type;
    ChannelNumBuf[13] = RecStructData.System.out14_spk_type;
    ChannelNumBuf[14] = RecStructData.System.out15_spk_type;
    ChannelNumBuf[15] = RecStructData.System.out16_spk_type;
}

- (NSString*)getOutputChannelTypeName:(int)Channel{
    
    [self syncOutputSpkType];
    return [self getOutputSpkTypeNameByIndex:ChannelNumBuf[Channel]];
}

- (void)showOutputSpkTypeList:(NormalButton *)sender{
    
    [self syncOutputSpkType];
    
    [CurCH_SPK removeAllObjects];
    
    switch (output_channel_sel) {
        case 0:
            [CurCH_SPK addObjectsFromArray:CH0_SPK];
            if((ChannelNumBuf[2] == 2)
               ||(ChannelNumBuf[4] == 2)
               ||(ChannelNumBuf[4] == 5)
               ||(ChannelNumBuf[6] == 3)
               ){
                [CurCH_SPK removeObjectAtIndex:1];
            }
            break;
        case 1:
            [CurCH_SPK addObjectsFromArray:CH1_SPK];
            if((ChannelNumBuf[3] == 2)
               ||(ChannelNumBuf[5] == 8)
               ||(ChannelNumBuf[5] == 11)
               ||(ChannelNumBuf[6] == 9)
               ){
                [CurCH_SPK removeObjectAtIndex:1];
            }
            break;
        case 2:
            [CurCH_SPK addObjectsFromArray:CH2_SPK];
            if((ChannelNumBuf[0] == 6)
               ||(ChannelNumBuf[4] == 2)
               ||(ChannelNumBuf[4] == 5)
               ){
                [CurCH_SPK removeObjectAtIndex:2];
            }
            break;
        case 3:
            [CurCH_SPK addObjectsFromArray:CH3_SPK];
            if((ChannelNumBuf[1] == 12)
               ||(ChannelNumBuf[5] == 8)
               ||(ChannelNumBuf[5] == 11)
               ){
                [CurCH_SPK removeObjectAtIndex:2];
            }
            break;
        case 4:
            [CurCH_SPK addObjectsFromArray:CH4_SPK];
            if((ChannelNumBuf[0] == 6)
               ||(ChannelNumBuf[2] == 2)
               ){
                [CurCH_SPK removeObjectAtIndex:2];
                [CurCH_SPK removeObjectAtIndex:1];
            }else if(ChannelNumBuf[6] == 3
                     ){
                [CurCH_SPK removeObjectAtIndex:2];
            }
            break;
        case 5:
            [CurCH_SPK addObjectsFromArray:CH5_SPK];
            if((ChannelNumBuf[1] == 12)
               ||(ChannelNumBuf[3] == 8)
               ){
                [CurCH_SPK removeObjectAtIndex:2];
                [CurCH_SPK removeObjectAtIndex:1];
            }else if(ChannelNumBuf[7] == 9
                ){
                [CurCH_SPK removeObjectAtIndex:2];
            }
            break;
        case 6:
            [CurCH_SPK addObjectsFromArray:CH6_SPK];
            if((ChannelNumBuf[0] == 6)
               ||(ChannelNumBuf[4] == 5)
               ){
                [CurCH_SPK removeObjectAtIndex:1];
            }
            break;
        case 7:
            [CurCH_SPK addObjectsFromArray:CH7_SPK];
            if((ChannelNumBuf[1] == 12)
               ||(ChannelNumBuf[5] == 11)
               ){
                [CurCH_SPK removeObjectAtIndex:1];
            }
            break;
        case 8:
            [CurCH_SPK addObjectsFromArray:CH8_SPK];
            break;
        case 9:
            [CurCH_SPK addObjectsFromArray:CH9_SPK];
            break;
        default:
            break;
    }
//    NSLog(@"CurCH_SPK CurCH_SPK.count=%ld",CurCH_SPK.count);
    for(int i=0;i<CurCH_SPK.count;i++){
        NSLog(@"CurCH_SPK=%@",[CurCH_SPK objectAtIndex:i]);
    }
    
    //显示通道类型设置
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Out_Type"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    for(int i=0;i<CurCH_SPK.count;i++){
        [alert addAction:[UIAlertAction actionWithTitle:[CurCH_SPK objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int spkType = [self getOutputSpkTypeNumByName:[CurCH_SPK objectAtIndex:i]];
            
            NSLog(@"BUG spkType=%d",spkType);
            NSLog(@"BUG output_channel_sel=%d",output_channel_sel);
            
            [self setOutputSpkType:spkType];
            [self.OutName setTitle:[self getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
            
            setXOverFreqWithOutputSpkType(output_channel_sel);
            [self setMixerVolWithOutputSpk:output_channel_sel];
            [self FlashPageUI];

            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
}


#pragma 加密
- (void)initEncrypt{
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    self.Encrypt = [[UIButton alloc]init];
    [self.view addSubview:self.Encrypt];
    self.Encrypt.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.Encrypt setTitle:[LANG DPLocalizedString:@"L_Master_EN_HadEncryption"] forState:UIControlStateNormal];
    [self.Encrypt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.Encrypt.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.Encrypt.titleLabel.font = [UIFont systemFontOfSize:50];
    [self.Encrypt addTarget:self action:@selector(Encrypt_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Encrypt setBackgroundColor:SetColor(UI_Master_EncryptColor)];
    self.Encrypt.hidden = true;
}

- (void)Encrypt_Click:(UIButton*)sender{
    if(!gConnectState){
        [self ShowConnectDialog];
        return;
    }
    
    [self ShowSetDecipheringDialog];
}
- (void)ShowSetDecipheringDialog{
    setEnNum = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_EN_Encryption"]message:[LANG DPLocalizedString:@"L_Master_EN_SetDeciphering"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.textColor= [UIColor redColor];
        textField.text=setEnNum;
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(setEnTextDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Master_EN_EncryptionClean"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL_EncryptionFlag = FALSE;
        [_mDataTransmitOpt SEFF_EncryptClean];
        [self FlashPageUI];
        
        //[alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if(setEnNum.length == 6){
            NSData* bytes = [setEnNum dataUsingEncoding:NSUTF8StringEncoding];
            Byte * temp = (Byte *)[bytes bytes];
            BOOL bool_EnR = true;
            for(int i=0;i<6;i++){
                if(Encryption_PasswordBuf[i] != *(temp+i)){
                    NSLog(@"Encryption_PasswordBuf= %d",Encryption_PasswordBuf[i]);
                    NSLog(@"temp= %d",*(temp+i));
                    bool_EnR = false;
                }
            }
            
            if(!bool_EnR){//密码错误
                //延时执行
                [self performSelector:@selector(showPasswordIncorrect) withObject:nil afterDelay:0.1];
            }else{//密码正确
                BOOL_EncryptionFlag = FALSE;
                [_mDataTransmitOpt SEFF_Save:0];
                [self FlashPageUI];
            }
            
        }else{
            //延时执行
            [self performSelector:@selector(showEN_EnterMsgMessage) withObject:nil afterDelay:0.1];
        }
        
        //NSLog(@"点击了确定按钮");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        //NSLog(@"点击了取消按钮");
        //[self presentViewController:alert animated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showPasswordIncorrect{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_Master_EN_PasswordIncorrect"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}
- (void)showEN_EnterMsgMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessageTextMode:[LANG DPLocalizedString:@"L_Master_EN_EnterMsg"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];
        });
    });
}
//输入框文字改变时 方法
-(void)setEnTextDidChange:(UITextField *)fd{
    if(fd.text.length > 6){
        fd.text = setEnNum;
    }
    NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
    setEnNum = fd.text;
}
//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma 联调
- (void)flashLinkSyncData:(int)ui{
    UI_Type = ui;
    if((LinkMODE == LINKMODE_SPKTYPE)||(LinkMODE == LINKMODE_SPKTYPE_S)){
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        syncLinkData(ui);
    }else if(LinkMODE == LINKMODE_LEFTRIGHT){
        if(!BOOL_LINK){
            return;
        }
        syncLinkData(ui);
        
        int Dfrom=output_channel_sel;
        int Dto=0xff;

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
        
//        if(UI_Type == UI_HFilter){
//        }else if(UI_Type == UI_HOct){
//        }else if(UI_Type == UI_HFreq){
//        }else if(UI_Type == UI_LFilter){
//        }else if(UI_Type == UI_LOct){
//        }else if(UI_Type == UI_LFreq){
//        }else
//            
        if(UI_Type == UI_OutVal){
            [self setOutItemVal:Dto];
        }else if(UI_Type == UI_OutPolar){
            if(RecStructData.OUT_CH[Dto].polar == 1){
                [self setOutItemPolar:true wihtCh:Dto];
            }else{
                [self setOutItemPolar:false wihtCh:Dto];
            }
        }
        
    }else{
        
    }
    
}
#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.channelBtn setChannelSelected:output_channel_sel];
        //[self.selectorHorizontal selectRowAtIndex:output_channel_sel];
        [self setOutItemIndex];
        [self FlashPageUI_];
    });
}

- (void)FlashPageUI_{
	
    [self flashXOver];
    //[self flashLinkViewState];
    [self flashOutput];
    
    if(BOOL_LINK){
        [self setLinkState];
    }
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        self.Encrypt.hidden = false;
        
        //滤波器
        [self.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:0]]  forState:UIControlStateNormal];
        [self.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:0]]  forState:UIControlStateNormal];
        //斜率
        [self.H_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:0]]  forState:UIControlStateNormal];
        [self.L_Level setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:0]]  forState:UIControlStateNormal];
        //频率
        [self.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",20] forState:UIControlStateNormal];
        [self.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",20000] forState:UIControlStateNormal];
        
        self.SB_OutVal.value=0;
        //[self.SB_OutVal setProgress:0 ];
        self.LabOutVal.text=[NSString stringWithFormat:@"%d",0];
    }else{
        self.Encrypt.hidden = true;
    }
    
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(LinkMODE == LINKMODE_SPKTYPE_S){
            if(RecStructData.OUT_CH[0].name[1] == 1){
                BOOL_LINK = true;
                BOOL_LOCK = true;
                [self CheckChannelCanLink];
                [self setLinkState];
            }else{
                BOOL_LINK = false;
                BOOL_LOCK = false;
                [self setUnlinkState];
            }

        }
        
        [self FlashPageUI];
        
    });
}













@end

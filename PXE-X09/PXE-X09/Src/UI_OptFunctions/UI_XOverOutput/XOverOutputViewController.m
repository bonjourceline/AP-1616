//
//  XOverOutputViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "XOverOutputViewController.h"
#import "MyChannelCView.h"
#import "AnyLink.h"
@interface XOverOutputViewController (){
    int delayUnit;
}
@property(nonatomic,strong)MyChannelCView *channelColletionView;
//@property(nonatomic, strong)UILabel *delayValLab;
//@property (nonatomic, strong)UISlider *delaySB;
//@property (nonatomic, strong)NormalButton *delayUnitBtn;
@end

@implementation XOverOutputViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Output;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_Output"];
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

    
    
//    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    [self initView];
    
    [self FlashPageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------------------- initData
- (void)initData{
     delayUnit=2;
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
    
    [self initChannelList];
    [self initSubViewBg];
    [self initOutput];
    [self initXOver];
    [self initChannelSet];
    //[self initChannel];
    [self initEncrypt];
//    [self initDelayView];
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
#pragma mark -------------------- initSubViewBg
- (void)initSubViewBg{
    double vh = 150;
    double vmarlr = 20;
    
    self.mVbg2 = [[UIView alloc]init];
    [self.view addSubview:self.mVbg2];
//    self.mVbg2.backgroundColor=[UIColor greenColor];
    [self.mVbg2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mVbg3.mas_bottom).offset([Dimens GDimens:0]);
        make.top.equalTo(self.channelColletionView.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:vmarlr*2], [Dimens GDimens:250]));
    }];
    
    
   
    
    self.mVbg1 = [[UIView alloc]init];
    [self.view addSubview:self.mVbg1];
//    [self.mVbg1 setBackgroundColor:SetColor(UI_OutXoverFunsBg)];
    
    [self.mVbg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mVbg2.mas_bottom);
        //        make.top.equalTo(self.mVbg2.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:vmarlr*2], [Dimens GDimens:200]));
        
    }];
    
    self.mVbg3 = [[UIView alloc]init];
    self.mVbg3.hidden=YES;
    [self.view addSubview:self.mVbg3];
    //        [self.mVbg3 setBackgroundColor:RGBA(255, 255, 255, 0.2)];
    [self.mVbg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mVbg1.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:vmarlr*2], [Dimens GDimens:120]));
        
    }];

//     UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
//    line1.backgroundColor=SetColor(UI_OutMideLineColor);
//    [self.view addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mVbg1.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 0.5));
//    }];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    line2.backgroundColor=SetColor(UI_OutMideLineColor);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mVbg2.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 0.5));
    }];
}

#pragma mark -------------------- initChannelList

- (void)initChannelList{

    self.channelColletionView=[[MyChannelCView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnListHeight])];
    __weak typeof(self) weakself=self;
    self.channelColletionView.backgroundColor=SetColor(Color_EQChannelLis_bg);
    self.channelColletionView.selectedIndex = ^(int row) {
//        output_channel_sel = row;
        //选择后的回调
        [weakself FlashPageUI_];
    };
    [self.view addSubview:self.channelColletionView];
    [self.channelColletionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:15]);
                make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
                make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnListHeight]));
    }];
    
}
#pragma mark --------------------Delay
//-(void)initDelayView{
//    UILabel *delay_text=[[UILabel alloc]init];
//    delay_text.textColor=[UIColor whiteColor];
//    delay_text.textAlignment=NSTextAlignmentCenter;
//    delay_text.text=[LANG DPLocalizedString:@"L_out_Delaytitle"];
//    delay_text.font=[UIFont systemFontOfSize:15];
//    [self.mVbg3 addSubview:delay_text];
//    [delay_text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mVbg3.mas_top).offset([Dimens GDimens:5]);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//
//    self.delaySB=[[UISlider alloc]init];
//    [self.mVbg3 addSubview:self.delaySB];
////    [self.delaySB setMinimumTrackImage:[UIImage imageNamed:@"output_slider_press"] forState:UIControlStateNormal];
//    [self.delaySB setMinimumTrackTintColor:SetColor(UI_XOver_SVolume_Press)];
//    //    self.SB_OutVal.maximumTrackTintColor = SetColor(UI_XOver_SVolume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
////    [self.delaySB setMaximumTrackImage:[UIImage imageNamed:@"output_slider_normal"] forState:UIControlStateNormal];
//    [self.delaySB setMaximumTrackTintColor:SetColor(UI_XOver_SVolume_Normal)];
//    self.delaySB.minimumValue=0;
//    self.delaySB.maximumValue=DELAY_SETTINGS_MAX;
//    [self.delaySB addTarget:self action:@selector(changeDelay:) forControlEvents:UIControlEventValueChanged];
//    [self.delaySB setThumbImage:[UIImage imageNamed:@"chs_output_thumb"] forState:UIControlStateNormal];
//    [self.delaySB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(delay_text.mas_bottom).offset([Dimens GDimens:30]);
//        make.centerX.equalTo(self.mVbg2.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:150], [Dimens GDimens:30]));
//    }];
//
//
//    self.delayValLab=[[UILabel alloc]init];
//    self.delayValLab.layer.borderWidth=1;
//    self.delayValLab.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
//    [self.delayValLab setTextColor:[UIColor whiteColor]];
//    self.delayValLab.textAlignment=NSTextAlignmentCenter;
//    self.delayValLab.layer.cornerRadius=3;
//    self.delayValLab.layer.masksToBounds=YES;
//    self.delayValLab.font=[UIFont systemFontOfSize:13];
//    self.delayValLab.adjustsFontSizeToFitWidth=YES;
//    self.delayValLab.backgroundColor=SetColor(UI_DelayBtn_NormalIN);
//    [self.mVbg3 addSubview:self.delayValLab];
//    [self.delayValLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.delaySB);
//       make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//
//    self.delayUnitBtn=[[NormalButton alloc]init];
//    [self.delayUnitBtn initViewBroder:3
//                      withBorderWidth:0
//                      withNormalColor:UI_DelayBtn_NormalIN
//                       withPressColor:UI_DelayBtn_PressIN
//                withBorderNormalColor:UI_SystemBtnColorNormal
//                 withBorderPressColor:UI_SystemBtnColorPress
//                  withTextNormalColor:UI_SystemLableColorNormal
//                   withTextPressColor:UI_SystemLableColorPress
//                             withType:5];
//    [self.mVbg3 addSubview:self.delayUnitBtn];
//    self.delayUnitBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    self.delayUnitBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
//    [self.delayUnitBtn setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
//      [self.delayUnitBtn setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
//    [self.delayUnitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.H_Filter.imageView.image.size.width, 0, self.delayUnitBtn.imageView.image.size.width)];
//    [self.delayUnitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(OutputPageXoverBtnWidth-[Dimens GDimens:25])], 0, 0)];
//    [self.delayUnitBtn addTarget:self action:@selector(ClickDelayUnitBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.delayUnitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.delaySB);
//       make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-OutputPageMarginSide]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//
//}
//-(void)ClickDelayUnitBtn:(NormalButton *)btn{
//    UIAlertController *alert=[[UIAlertController alloc]init];
//    alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    for (int i=0; i<[self unitDelayArray].count; i++) {
//        [alert addAction:[UIAlertAction actionWithTitle:[self unitDelayArray][i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            delayUnit=i+1;
//            self.delayValLab.text=[self getDelayVal:output_channel_sel];
//            [btn setTitle:[self unitDelayArray][i] forState:UIControlStateNormal];
//        }]];
//    }
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
//}
//-(void)changeDelay:(UISlider *)slider{
//    RecStructData.OUT_CH[output_channel_sel].delay = slider.value;
//    self.delayValLab.text=[self getDelayVal:output_channel_sel];
//}
//-(NSArray *)unitDelayArray{
//    return @[[LANG DPLocalizedString:@"L_Delay_CM"],[LANG DPLocalizedString:@"L_Delay_MS"],[LANG DPLocalizedString:@"L_Delay_Inch"]];
//}
//- (NSString*)getDelayVal:(int)ch{
//
//    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
//        switch(delayUnit){
//            case 1: return [self CountDelayCM:0]; break;
//            case 2: return [self CountDelayMs:0]; break;
//            case 3: return [self CountDelayInch:0]; break;
//            default:return [self CountDelayMs:0];
//        }
//    }else{
//        NSLog(@"RecStructData.OUT_CH[ch].delay-----%d",RecStructData.OUT_CH[ch].delay);
//        switch(delayUnit){
//            case 1: return [self CountDelayCM:RecStructData.OUT_CH[ch].delay]; break;
//            case 2: return [self CountDelayMs:RecStructData.OUT_CH[ch].delay]; break;
//            case 3: return [self CountDelayInch:RecStructData.OUT_CH[ch].delay]; break;
//            default:return [self CountDelayMs:RecStructData.OUT_CH[ch].delay];
//        }
//    }
//}
///******* 延时时间转换  *******/
//- (NSString*) CountDelayCM:(int)num{
//    int m_nTemp=75;
//    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
//    float LMT = (float) (((m_nTemp-50)*0.6+331.0)/1000.0*Time);
//    LMT = LMT*100;
//
//    int fr=(int) (LMT*10);
//    int ir = fr%10;
//    int ri = 0;
//    if(ir>=5){
//        ri=fr/10+1;
//    }else{
//        ri=fr/10;
//    }
//
//    return [NSString stringWithFormat:@"%d",(int)ri];
//}
//- (NSString*) CountDelayMs:(int)num{
//    int fr = num*10000/48;
//    int ir = fr%10;
//    int ri = 0;
//    if(ir>=5){
//        ri=fr/10+1;
//    }else{
//        ri=fr/10;
//    }
//    return [NSString stringWithFormat:@"%.3f",(float)ri/1000];}
//
//- (NSString*) CountDelayInch:(int)num{
//    float base=(float) 331.0;
//    if(num == DELAY_SETTINGS_MAX){
//        base=(float) 331.4;
//    }
//    int m_nTemp=75;
//    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
//    float LMT = (float) (((m_nTemp-50)*0.6+base)/1000.0*Time);
//
//    float LFT = (float) (LMT*3.2808*12.0);
//
//    int fr=(int) (LFT*10);
//    int ir = fr%10;
//    int ri = 0;
//    if(ir>=5){
//        ri=fr/10+1;
//    }else{
//        ri=fr/10;
//    }
//    return [NSString stringWithFormat:@"%d",(int)ri];
//}
//-(void)flashDelay{
//    self.delayValLab.text=[self getDelayVal:output_channel_sel];
//    self.delaySB.value=RecStructData.OUT_CH[output_channel_sel].delay;
//}
#pragma mark -------------------- initXOver

- (void)initXOver{
    //    UIView *mLine1 = [[UIView alloc]init];
    //    [self.view addSubview:mLine1];
    //    [mLine1 setBackgroundColor:SetColor(UI_OutMideLineColor)];
    //    [mLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.OutName.mas_bottom).offset([Dimens GDimens:20]);
    //        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:0]);
    //        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 1));
    //    }];
    
        self.LabXOver_Text = [[UILabel alloc]init];
        [self.mVbg1 addSubview:self.LabXOver_Text];
        [self.LabXOver_Text setBackgroundColor:[UIColor clearColor]];
        [self.LabXOver_Text setTextColor:SetColor(UI_XOver_LabText)];
        self.LabXOver_Text.text=[LANG DPLocalizedString:@"L_XOver_XOver"];
        self.LabXOver_Text.textAlignment = NSTextAlignmentCenter;
        self.LabXOver_Text.adjustsFontSizeToFitWidth = true;
        self.LabXOver_Text.font = [UIFont systemFontOfSize:15];
        [self.LabXOver_Text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mVbg1.mas_top).offset([Dimens GDimens:5]);
            make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
        }];
    
    self.LabHP_Text = [[UILabel alloc]init];
    [self.mVbg1 addSubview:self.LabHP_Text];
    [self.LabHP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabHP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabHP_Text.text=[LANG DPLocalizedString:@"L_XOver_HighPass"];
    self.LabHP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabHP_Text.adjustsFontSizeToFitWidth = true;
    self.LabHP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabHP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabXOver_Text.mas_bottom).offset([Dimens GDimens:5]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    //高通
    self.H_Filter = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0,[Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight])];
    [self.mVbg1 addSubview:self.H_Filter];
        [self.H_Filter initViewBroder:3
                      withBorderWidth:0
                      withNormalColor:UI_DelayBtn_NormalIN
                       withPressColor:UI_DelayBtn_PressIN
                withBorderNormalColor:UI_SystemBtnColorNormal
                 withBorderPressColor:UI_SystemBtnColorPress
                  withTextNormalColor:UI_SystemLableColorNormal
                   withTextPressColor:UI_SystemLableColorPress
                             withType:5];
//    [self.H_Filter setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.H_Filter addTarget:self action:@selector(H_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.H_Filter setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
    [self.H_Filter setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.H_Filter.imageView.image.size.width, 0, self.H_Filter.imageView.image.size.width)];
    [self.H_Filter setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(OutputPageXoverBtnWidth-[Dimens GDimens:25])], 0, 0)];
    [self.H_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabHP_Text.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    self.H_Level = [[NormalButton alloc]init];
    [self.mVbg1 addSubview:self.H_Level];
        [self.H_Level initViewBroder:3
                     withBorderWidth:0
                     withNormalColor:UI_DelayBtn_NormalIN
                      withPressColor:UI_DelayBtn_PressIN
               withBorderNormalColor:UI_SystemBtnColorNormal
                withBorderPressColor:UI_SystemBtnColorPress
                 withTextNormalColor:UI_SystemLableColorNormal
                  withTextPressColor:UI_SystemLableColorPress
                            withType:5];
//    [self.H_Level setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.H_Level addTarget:self action:@selector(H_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.H_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    
       [self.H_Level setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
    [self.H_Level setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.H_Level.imageView.image.size.width, 0, self.H_Level.imageView.image.size.width)];
    [self.H_Level setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(OutputPageXoverBtnWidth-[Dimens GDimens:23])], 0, 0)];
    
    [self.H_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.H_Filter.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
       
    }];
    
    self.H_Freq = [[NormalButton alloc]init];
    [self.mVbg1 addSubview:self.H_Freq];
        [self.H_Freq initViewBroder:3
                    withBorderWidth:0
                    withNormalColor:UI_DelayBtn_NormalIN
                     withPressColor:UI_DelayBtn_PressIN
              withBorderNormalColor:UI_SystemBtnColorNormal
               withBorderPressColor:UI_SystemBtnColorPress
                withTextNormalColor:UI_SystemLableColorNormal
                 withTextPressColor:UI_SystemLableColorPress
                           withType:5];
//     [self.H_Freq setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.H_Freq addTarget:self action:@selector(H_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.H_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.H_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.H_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
 
    
    [self.H_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.H_Filter.mas_centerY).offset([Dimens GDimens:0]);
         make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));

    }];
    
    //低通
    self.LabLP_Text = [[UILabel alloc]init];
    [self.mVbg1 addSubview:self.LabLP_Text];
    [self.LabLP_Text setBackgroundColor:[UIColor clearColor]];
    [self.LabLP_Text setTextColor:SetColor(UI_XOver_LabText)];
    self.LabLP_Text.text=[LANG DPLocalizedString:@"L_XOver_LowPass"];
    self.LabLP_Text.textAlignment = NSTextAlignmentCenter;
    self.LabLP_Text.adjustsFontSizeToFitWidth = true;
    self.LabLP_Text.font = [UIFont systemFontOfSize:15];
    [self.LabLP_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.H_Freq.mas_bottom).offset([Dimens GDimens:18]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    
    
    self.L_Filter = [[NormalButton alloc]init];
    [self.mVbg1 addSubview:self.L_Filter];
        [self.L_Filter initViewBroder:3
                      withBorderWidth:0
                      withNormalColor:UI_DelayBtn_NormalIN
                       withPressColor:UI_DelayBtn_PressIN
                withBorderNormalColor:UI_SystemBtnColorNormal
                 withBorderPressColor:UI_SystemBtnColorPress
                  withTextNormalColor:UI_SystemLableColorNormal
                   withTextPressColor:UI_SystemLableColorPress
                             withType:5];
//    [self.L_Filter setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.L_Filter addTarget:self action:@selector(L_Fifter_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Filter setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Filter.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.L_Filter setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
    [self.L_Filter setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.L_Filter.imageView.image.size.width, 0, self.L_Filter.imageView.image.size.width)];
    [self.L_Filter setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(OutputPageXoverBtnWidth-[Dimens GDimens:25])], 0, 0)];
    [self.L_Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabLP_Text.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
    self.L_Level = [[NormalButton alloc]init];
    [self.mVbg1 addSubview:self.L_Level];
        [self.L_Level initViewBroder:3
                     withBorderWidth:0
                     withNormalColor:UI_DelayBtn_NormalIN
                      withPressColor:UI_DelayBtn_PressIN
               withBorderNormalColor:UI_SystemBtnColorNormal
                withBorderPressColor:UI_SystemBtnColorPress
                 withTextNormalColor:UI_SystemLableColorNormal
                  withTextPressColor:UI_SystemLableColorPress
                            withType:5];
//    [self.L_Level setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.L_Level addTarget:self action:@selector(L_Level_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Level setTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] forState:UIControlStateNormal] ;
    self.L_Level.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Level.titleLabel.font = [UIFont systemFontOfSize:13];
    
     [self.L_Level setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
    [self.L_Level setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.L_Level.imageView.image.size.width, 0, self.L_Level.imageView.image.size.width)];
    [self.L_Level setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:(OutputPageXoverBtnWidth-[Dimens GDimens:23])], 0, 0)];
    
    [self.L_Level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
       
    }];
    
    self.L_Freq = [[NormalButton alloc]init];
    [self.view addSubview:self.L_Freq];
        [self.L_Freq initViewBroder:3
                    withBorderWidth:0
                    withNormalColor:UI_DelayBtn_NormalIN
                     withPressColor:UI_DelayBtn_PressIN
              withBorderNormalColor:UI_SystemBtnColorNormal
               withBorderPressColor:UI_SystemBtnColorPress
                withTextNormalColor:UI_SystemLableColorNormal
                 withTextPressColor:UI_SystemLableColorPress
                           withType:5];
//    [self.L_Freq setBackgroundImage:[UIImage imageNamed:@"xover_btn_bg"] forState:UIControlStateNormal];
    [self.L_Freq addTarget:self action:@selector(L_Freq_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.L_Freq setTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] forState:UIControlStateNormal] ;
    self.L_Freq.titleLabel.adjustsFontSizeToFitWidth = true;
    self.L_Freq.titleLabel.font = [UIFont systemFontOfSize:13];
   
    
    [self.L_Freq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX).offset(-[Dimens GDimens:0]);
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
    
    //间隔线
//    int xlm = 21;
//    UIView *mLine1 = [[UIView alloc]init];
//    [self.view addSubview:mLine1];
//    [mLine1 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.H_Filter.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.H_Filter.mas_right).offset([Dimens GDimens:xlm]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//    UIView *mLine2 = [[UIView alloc]init];
//    [self.view addSubview:mLine2];
//    [mLine2 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.H_Filter.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.H_Level.mas_right).offset([Dimens GDimens:xlm]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//
//
//    UIView *mLine3 = [[UIView alloc]init];
//    [self.view addSubview:mLine3];
//    [mLine3 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.L_Filter.mas_right).offset([Dimens GDimens:xlm]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//    UIView *mLine4 = [[UIView alloc]init];
//    [self.view addSubview:mLine4];
//    [mLine4 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.L_Filter.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.L_Level.mas_right).offset([Dimens GDimens:xlm]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//
    
    
    //    [self.H_Filter setNormal];
    //    [self.H_Level setNormal];
    //    [self.H_Freq setNormal];
    //
    //    [self.L_Filter setNormal];
    //    [self.L_Level setNormal];
    //    [self.L_Freq setNormal];
    
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
    //    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)H_Level_CLick:(NormalButton*)sender{
    //    [sender setPress];
    B_Buf = sender;
    Bool_HL = true;
    [self showLevelOptDialog];
    
    
}
- (void)H_Freq_CLick:(NormalButton*)sender{
    //    [sender setPress];
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
    //    [sender setPress];
    [self showFilterOptDialog];
    
}
- (void)L_Level_CLick:(NormalButton*)sender{
    //    [sender setPress];
    B_Buf = sender;
    Bool_HL = false;
    [self showLevelOptDialog];
    
}
- (void)L_Freq_CLick:(NormalButton*)sender{
    //    [sender setPress];
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

#pragma mark -------------------- 弹出选择 Filter

- (void)showFilterOptDialog{
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterLR"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dialogSetFilter:0];
        //        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:1];
        //        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_FilterBW"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dialogSetFilter:2];
        //        [B_Buf setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        //        [B_Buf setNormal];
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
#pragma mark -------------------- 弹出选择 Level
- (void)showLevelOptDialog{
    
    UIAlertController *alert;
    if(Bool_HL){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }
    for (int i=0; i<AllLevel.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:AllLevel[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:i];
//            [alert dismissViewControllerAnimated:YES completion:nil];
            //        [B_Buf setNormal];
        }]];
    }
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc6dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:0];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc12dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:1];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc18dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:2];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc24dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:3];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc30dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:4];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc36dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:5];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc42dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:6];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_Otc48dB"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:7];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_XOver_OtcOFF"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dialogSetLevel:8];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//        //        [B_Buf setNormal];
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        //        [B_Buf setNormal];
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
#pragma mark -------------------- 弹出选择 Freq

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
    [btnOK initView:3 withBorderWidth:0 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
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
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)dialogExit{
    //    [B_Buf setNormal];
}

- (void)KxMenutapCloseAction:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [B_Buf setNormal];
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
                    //                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
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
                    //                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
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
                    //                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
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
                    //                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
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
                    //                    RecStructData.OUT_CH[output_channel_sel].h_freq = 1000;
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
                    //                    RecStructData.OUT_CH[output_channel_sel].l_freq = 1000;
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

- (void)flashLinkSyncData:(int)ui{
    if(BOOL_SET_SpkType){
        
        if((!BOOL_LINK)||(ChannelLinkCnt == 0)){
            return;
        }
        syncLinkData(ui);
    }else{
        if (LinkMODE==LINKMODE_AUTO) {
            if (BOOL_LINK) {
                syncLinkData(ui);
            }
        }
    }
        /*
         int Dto=0;
         for(int i=0;i<ChannelLinkCnt;i++){
         if(ChannelLinkBuf[i][0]==output_channel_sel){
         Dto=ChannelLinkBuf[i][1];
         break;
         }else if(ChannelLinkBuf[i][1]==output_channel_sel){
         Dto=ChannelLinkBuf[i][0];
         break;
         }
         }
         
         if(UI_Type == UI_HFilter){
         [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].h_filter]] forState:UIControlStateNormal] ;
         }else if(UI_Type == UI_HOct){
         if(BOOL_FilterHide6DB_OCT){
         if(RecStructData.OUT_CH[Dto].h_level == 0){
         [LinkXOverItem.H_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
         }else{
         [LinkXOverItem.H_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].h_filter]] forState:UIControlStateNormal] ;
         }
         }
         
         [LinkXOverItem.H_Level setTitle:[NSString stringWithFormat:@"%@",[Level_List objectAtIndex:RecStructData.OUT_CH[Dto].h_level]] forState:UIControlStateNormal] ;
         }else if(UI_Type == UI_HFreq){
         [LinkXOverItem.H_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[Dto].h_freq] forState:UIControlStateNormal];
         }else if(UI_Type == UI_LFilter){
         [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].l_filter]] forState:UIControlStateNormal] ;
         }else if(UI_Type == UI_LOct){
         if(BOOL_FilterHide6DB_OCT){
         if(RecStructData.OUT_CH[Dto].l_level == 0){
         [LinkXOverItem.L_Filter setTitle:[LANG DPLocalizedString:@"L_Out_NULL"] forState:UIControlStateNormal] ;
         }else{
         [LinkXOverItem.L_Filter setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.OUT_CH[Dto].l_filter]] forState:UIControlStateNormal] ;
         }
         }
         [LinkXOverItem.L_Level setTitle:[NSString stringWithFormat:@"%@",[Level_List objectAtIndex:RecStructData.OUT_CH[Dto].l_level]] forState:UIControlStateNormal] ;
         }else if(UI_Type == UI_LFreq){
         [LinkXOverItem.L_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.OUT_CH[Dto].l_freq] forState:UIControlStateNormal];
         }
         */
    
    
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


#pragma mark -------------------- initOutput

- (void)initOutput{
    
    
    //静音
    self.OutMute = [[NormalButton alloc]init];
    [self.mVbg2 addSubview:self.OutMute];
    [self.OutMute initViewBroder:3
                 withBorderWidth:0
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_SystemBtnColorNormal
            withBorderPressColor:UI_SystemBtnColorPress
             withTextNormalColor:UI_SystemLableColorNormal
              withTextPressColor:UI_SystemLableColorPress
                        withType:5];
//    [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    //    self.OutMute.imageEdgeInsets = UIEdgeInsetsMake(
    //                                                           0,
    //                                                           [Dimens GDimens:OutputPageXoverBtnWidth]/2-[Dimens GDimens:OutputPageXoverBtnHeight]/2,
    //                                                           0,
    //                                                           [Dimens GDimens:OutputPageXoverBtnWidth]/2-[Dimens GDimens:OutputPageXoverBtnHeight]/2
    //                                                           );
    [self.OutMute addTarget:self action:@selector(Btn_OutputMute_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mVbg2.mas_bottom).offset([Dimens GDimens:-35]);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:OutputPageMarginSide]);
//        make.centerX.equalTo(self.mVbg3.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
        
    }];
    //通道名字
    self.setOutNameDialog = [[OutNameSet alloc]init];
    self.OutName = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0,[Dimens GDimens:120], [Dimens GDimens:OutputPageXoverBtnHeight])];
    [self.mVbg2 addSubview:self.OutName];
    [self.OutName initViewBroder:3
                 withBorderWidth:0
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_SystemBtnColorNormal
            withBorderPressColor:UI_SystemBtnColorPress
             withTextNormalColor:UI_SystemLableColorNormal
              withTextPressColor:UI_SystemLableColorPress
                        withType:5];
    
    [self.OutName addTarget:self action:@selector(OutName_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutName setTitle:[LANG DPLocalizedString:@"NULL"] forState:UIControlStateNormal] ;
    self.OutName.titleLabel.adjustsFontSizeToFitWidth = true;
    self.OutName.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.OutName setImage:[UIImage imageNamed:@"chs_output_drop"] forState:UIControlStateNormal];
    [self.OutName setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.OutName.imageView.image.size.width, 0, self.OutName.imageView.image.size.width)];
    [self.OutName setImageEdgeInsets:UIEdgeInsetsMake(0, [Dimens GDimens:90], 0, 0)];
    
    [self.OutName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.OutMute.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth+20], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
//    self.OutName.hidden=YES;
        [self.OutName setNormal];
    //正反相
    self.OutPolar = [[NormalButton alloc]init];
    [self.mVbg2 addSubview:self.OutPolar];
    [self.OutPolar initViewBroder:3
                  withBorderWidth:0
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_SystemBtnColorNormal
             withBorderPressColor:UI_SystemBtnColorPress
              withTextNormalColor:UI_SystemLableColorNormal
               withTextPressColor:UI_SystemLableColorPress
                         withType:5];
    [self.OutPolar addTarget:self action:@selector(OutPolar_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    self.OutPolar.titleLabel.adjustsFontSizeToFitWidth = true;
    self.OutPolar.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.OutPolar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.OutMute.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
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
    
    
    
    //通道音量显示
    self.LabOutVal_Text = [[UILabel alloc]init];
    [self.mVbg2 addSubview:self.LabOutVal_Text];
    self.LabOutVal_Text.text=[LANG DPLocalizedString:@"L_Out_TypeSet"];
    self.LabOutVal_Text.textAlignment = NSTextAlignmentCenter;
    self.LabOutVal_Text.adjustsFontSizeToFitWidth = true;
    self.LabOutVal_Text.font = [UIFont systemFontOfSize:17];
    [self.LabOutVal_Text setTextColor:SetColor(UI_XOver_LabText)];
    [self.LabOutVal_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mVbg2.mas_top).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:180], [Dimens GDimens:OutputPageXoverBtnHeight]));
    }];
    
  
    self.LabOutVal = [[UILabel alloc]init];
    [self.mVbg2 addSubview:self.LabOutVal];
    [self.LabOutVal setTextColor:SetColor(UI_OutValColor)];
    self.LabOutVal.text=@"38";
    self.LabOutVal.textAlignment = NSTextAlignmentCenter;
    self.LabOutVal.adjustsFontSizeToFitWidth = true;
    self.LabOutVal.font = [UIFont systemFontOfSize:50];
    [self.LabOutVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabOutVal_Text.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:140], [Dimens GDimens:50]));
    }];
    
    self.SB_OutVal = [[UISlider alloc]init];
    [self.mVbg2 addSubview:self.SB_OutVal];
    self.SB_OutVal.minimumTrackTintColor = SetColor(UI_XOver_SVolume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
//    [self.SB_OutVal setMinimumTrackImage:[UIImage imageNamed:@"output_slider_press"] forState:UIControlStateNormal];
    self.SB_OutVal.maximumTrackTintColor = SetColor(UI_XOver_SVolume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    
//    [self.SB_OutVal setMaximumTrackImage:[UIImage imageNamed:@"output_slider_normal"] forState:UIControlStateNormal];
    [self.SB_OutVal setMinimumValue:0];
    [self.SB_OutVal setMaximumValue:Output_Volume_MAX/Output_Volume_Step];
    [self.SB_OutVal setBackgroundColor:[UIColor clearColor]];
    [self.SB_OutVal setThumbImage:[UIImage imageNamed:@"chs_output_thumb"] forState:UIControlStateNormal];
//    [self.SB_OutVal setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
     
    [self.SB_OutVal addTarget:self action:@selector(SB_OutVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
    [self.SB_OutVal mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(self.view.mas_centerX);
             make.top.equalTo(self.LabOutVal.mas_bottom).offset([Dimens GDimens:40]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:270], [Dimens GDimens:20]));
    }];
    //Seekbar
//     self.SB_OutVal = [[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:OutputPageOut_SB_Size], [Dimens GDimens:OutputPageOut_SB_Size])];
//     self.SB_OutVal.center = self.view.center;
//     [self.mVbg2 addSubview:self.SB_OutVal];
//     [self.SB_OutVal addTarget:self action:@selector(SB_OutVol_Val_Change:) forControlEvents:UIControlEventValueChanged];
//     [self.SB_OutVal setMaxProgress:Output_Volume_MAX/Output_Volume_Step];
//     [self.SB_OutVal mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.centerX.equalTo(self.view.mas_centerX);
//     make.top.equalTo(self.LabOutVal_Text.mas_bottom).offset([Dimens GDimens:10]);
//     make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOut_SB_Size], [Dimens GDimens:OutputPageOut_SB_Size]));
//     }];
    
  
    
    //音量增减
    self.Btn_OutputVolumeSub = [[UIButton alloc]init];
//    self.Btn_OutputVolumeSub.layer.borderWidth=1;
//    self.Btn_OutputVolumeSub.backgroundColor=SetColor(UI_DelayBtn_NormalIN);
//    self.Btn_OutputVolumeSub.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
//    self.Btn_OutputVolumeSub.layer.cornerRadius=3;
//    self.Btn_OutputVolumeSub.layer.masksToBounds=YES;
    [self.Btn_OutputVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_s_sub_normal"] forState:UIControlStateNormal];
    [self.Btn_OutputVolumeSub setBackgroundImage:[UIImage imageNamed:@"chs_s_sub_press"] forState:UIControlStateHighlighted];
    [self.mVbg2 addSubview:self.Btn_OutputVolumeSub];
    [self.Btn_OutputVolumeSub addTarget:self action:@selector(OutputVolume_SUB:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_OutputVolumeAdd = [[UIButton alloc]init];
//    self.Btn_OutputVolumeAdd.layer.borderWidth=1;
//    self.Btn_OutputVolumeAdd.backgroundColor=SetColor(UI_DelayBtn_NormalIN);
//    self.Btn_OutputVolumeAdd.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
//    self.Btn_OutputVolumeAdd.layer.cornerRadius=3;
//    self.Btn_OutputVolumeAdd.layer.masksToBounds=YES;
    [self.Btn_OutputVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_s_inc_normal"] forState:UIControlStateNormal];
    [self.Btn_OutputVolumeAdd setBackgroundImage:[UIImage imageNamed:@"chs_s_inc_press"] forState:UIControlStateHighlighted];
    [self.mVbg2 addSubview:self.Btn_OutputVolumeAdd];
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
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:25], [Dimens GDimens:25]));
    }];
    
    [self.Btn_OutputVolumeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SB_OutVal.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-OutputPageMarginSide]);
        make.size.mas_equalTo(self.Btn_OutputVolumeSub);
    }];

//    self.Btn_OutputVolumeSub.hidden = true;
//    self.Btn_OutputVolumeAdd.hidden = true;
    
    
    //间隔线
//    int xlm2 = 16;
//    UIView *mLine5 = [[UIView alloc]init];
//    [self.view addSubview:mLine5];
//    [mLine5 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.OutPolar.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.OutPolar.mas_right).offset([Dimens GDimens:xlm2]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
//    UIView *mLine6 = [[UIView alloc]init];
//    [self.view addSubview:mLine6];
//    [mLine6 setBackgroundColor:SetColor(UI_OutMideLineColor)];
//    [mLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.OutName.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.OutName.mas_right).offset([Dimens GDimens:xlm2]);
//        make.size.mas_equalTo(CGSizeMake(1, [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
    [self changeLabOutValframe];
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
//    [self.SB_OutVal setProgress:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    //    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
    [self changeLabOutValframe];
}
-(void)OutputVolume_INC:(id)sender{
    RecStructData.OUT_CH[output_channel_sel].gain += Output_Volume_Step;
    if(RecStructData.OUT_CH[output_channel_sel].gain > Output_Volume_MAX){
        RecStructData.OUT_CH[output_channel_sel].gain = Output_Volume_MAX;
    }
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    self.SB_OutVal.value = RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step;
//    [self.SB_OutVal setProgress:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    //    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
     [self changeLabOutValframe];
}

//静音
-(void)Btn_OutputMute_Click:(NormalButton *)sender{
    if(RecStructData.OUT_CH[output_channel_sel].mute != 0){
        RecStructData.OUT_CH[output_channel_sel].mute = 0;
                [sender setPress];
        [self.OutMute setImage:[UIImage imageNamed:@"output_mute_press"] forState:UIControlStateNormal];
    }else{
                [sender setNormal];
        RecStructData.OUT_CH[output_channel_sel].mute = 1;
        [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    }
}
//正反相
-(void)OutPolar_CLick:(UIButton *)sender{
    if(RecStructData.OUT_CH[output_channel_sel].polar != 0){
        RecStructData.OUT_CH[output_channel_sel].polar = 0;
        //        [sender setNormal];
        [sender setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    }else{
        //        [sender setPress];
        [sender setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
        RecStructData.OUT_CH[output_channel_sel].polar = 1;
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
    }
}
-(void)OutName_CLick:(UIButton *)sender{
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
-(void)changeLabOutValframe{
    /*
    CGRect trackRect=[self.SB_OutVal convertRect:self.SB_OutVal.bounds toView:nil];
    CGRect thumbRect = [self.SB_OutVal thumbRectForBounds:self.SB_OutVal.bounds trackRect:trackRect value:self.SB_OutVal.value];
    float thumbX=thumbRect.origin.x;
    CGRect frame=self.LabOutVal.frame;
    
    frame.origin.x=thumbX-ceilf(([Dimens GDimens:180]/2))+14;
    self.LabOutVal.frame=frame;
     */
}
-(void)SB_OutVol_Val_Change:(UISlider *)sender{
//    [self changeLabOutValframe];
    /*
    int val=[sender GetProgress];
    RecStructData.OUT_CH[output_channel_sel].gain = val*Output_Volume_Step;//[sender GetProgress]*Output_Volume_Step;
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    
    //    [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
     [self changeLabOutValframe];
     */
//    int val=[sender GetProgress];
    int val=sender.value;
    AutoLinkValue=val*Output_Volume_Step-RecStructData.OUT_CH[output_channel_sel].gain;
    RecStructData.OUT_CH[output_channel_sel].gain = val*Output_Volume_Step;//[sender GetProgress]*Output_Volume_Step;
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
    
        [self.OutMute setNormal];
    RecStructData.OUT_CH[output_channel_sel].mute = 1;
    [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    
    
    [self flashLinkSyncData:UI_OutVal];
    [self changeLabOutValframe];
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
//    [self setMixerVolWithOutputSpk:output_channel_sel];
    setMixerVolWithOutputSpk(output_channel_sel);
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
    self.SB_OutVal.value = RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step;
//    [self.SB_OutVal setProgress:RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step ];
    
    self.LabOutVal.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
     [self changeLabOutValframe];
    if(RecStructData.OUT_CH[output_channel_sel].mute == 0){
                [self.OutMute setPress];
        [self.OutMute setImage:[UIImage imageNamed:@"output_mute_press"] forState:UIControlStateNormal];
    }else{
                [self.OutMute setNormal];
        [self.OutMute setImage:[UIImage imageNamed:@"output_mute_normal"] forState:UIControlStateNormal];
    }
    if(RecStructData.OUT_CH[output_channel_sel].polar == 0){
        //        [self.OutPolar setNormal];
        [self.OutPolar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    }else{
        //        [self.OutPolar setPress];
        [self.OutPolar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
        [self.OutPolar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
    }
    //Name
    //    [self.OutName setTitle:[self.setOutNameDialog getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
    [self.OutName setTitle:[self getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
    
}


#pragma mark -------------------- initChannelSet

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
    self.Btn_Reset = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:OutputPageOutSetBtnWidth], [Dimens GDimens:OutputPageOutSetBtnHeight])];
    [self.Btn_Reset initViewBroder:3
                  withBorderWidth:0
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:5];
        self.Btn_Reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.Btn_Reset setTitle:[LANG DPLocalizedString:@"L_Out_Reset"] forState:UIControlStateNormal] ;
    self.Btn_Reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_Reset.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.Btn_Reset.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.Btn_Reset setImage:[UIImage imageNamed:@"chs_output_Reset"] forState:UIControlStateNormal];
    [self.view addSubview:self.Btn_Reset];
//    [self.Btn_Reset setButtonContentCenterWithTextPressColor:UI_XOver_BtnText_Press withTextNormalColor:UI_XOver_BtnText_Normal];
//    [self.Btn_Reset initViewBroder:3
//                   withBorderWidth:0
//                   withNormalColor:UI_DelayBtn_NormalIN
//                    withPressColor:UI_DelayBtn_PressIN
//             withBorderNormalColor:UI_XOver_Btn_Normal
//              withBorderPressColor:UI_XOver_Btn_Press
//               withTextNormalColor:UI_XOver_BtnText_Normal
//                withTextPressColor:UI_XOver_BtnText_Press
//                          withType:5];
    
    [self.Btn_Reset addTarget:self action:@selector(Btn_Reset_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_Reset.titleLabel.adjustsFontSizeToFitWidth = true;

    [self.Btn_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset([Dimens GDimens:-40]);
         make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOutSetBtnWidth], [Dimens GDimens:OutputPageOutSetBtnHeight]));
    }];
//    self.Btn_Reset.hidden=YES;
    //锁定
    self.Btn_Lock = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_Lock];
    [self.Btn_Lock initViewBroder:3
                  withBorderWidth:0
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:5];
    self.Btn_Lock.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Lock addTarget:self action:@selector(Btn_Lock_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
    self.Btn_Lock.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Lock.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //联调
    self.Btn_Link=[[NormalButton alloc]init];
//    [self.Btn_Link setImage:[UIImage imageNamed:@"chs_output_link"] forState:UIControlStateNormal];
    [self.Btn_Link initViewBroder:3
                  withBorderWidth:0
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_XOver_Btn_Normal
             withBorderPressColor:UI_XOver_Btn_Press
              withTextNormalColor:UI_XOver_BtnText_Normal
               withTextPressColor:UI_XOver_BtnText_Press
                         withType:5];
    [self.view addSubview:self.Btn_Link];
    self.Btn_Link.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Link addTarget:self action:@selector(Btn_Link_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
//    [self.Btn_Link setImage:[UIImage imageNamed:@"chs_output_link"] forState:UIControlStateNormal];
    self.Btn_Link.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Link.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//       [self.Btn_Link setButtonContentCenterWithTextPressColor:UI_XOver_BtnText_Press withTextNormalColor:UI_XOver_BtnText_Normal];
    [self.Btn_Link mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_Reset.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-OutputPageMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageOutSetBtnWidth], [Dimens GDimens:OutputPageOutSetBtnHeight]));
    }];
    
    //联调状态
    
    self.mVLink = [[UIView alloc]init];
//    [self.view addSubview:self.mVLink];
//    [self.mVLink mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.Btn_Reset.mas_centerY).offset([Dimens GDimens:0]);
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:OutputPageXoverBtnWidth], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
    
    self.mImgLink = [[UIImageView alloc]init];
//    [self.mVLink addSubview:self.mImgLink];
//    [self.mImgLink setImage:[UIImage imageNamed:@"linked"]];
//    [self.mImgLink mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
//        make.centerX.equalTo(self.mVLink.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:20], [Dimens GDimens:8]));
//    }];
    
    self.LabLeftCh = [[UILabel alloc]init];
//    [self.mVLink addSubview:self.LabLeftCh];
//    [self.LabLeftCh setBackgroundColor:[UIColor clearColor]];
//    [self.LabLeftCh setTextColor:SetColor(UI_OutLinkGroup_Text_Color)];
//    self.LabLeftCh.text=[LANG DPLocalizedString:@"CH1"];
//    self.LabLeftCh.textAlignment = NSTextAlignmentLeft;
//    self.LabLeftCh.adjustsFontSizeToFitWidth = true;
//    self.LabLeftCh.font = [UIFont systemFontOfSize:10];
//    [self.LabLeftCh mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
//        make.left.equalTo(self.mVLink.mas_left).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
    
    self.LabRightCh = [[UILabel alloc]init];
//    [self.mVLink addSubview:self.LabRightCh];
//    [self.LabRightCh setBackgroundColor:[UIColor clearColor]];
//    [self.LabRightCh setTextColor:SetColor(UI_OutLinkGroup_Text_Color)];
//    self.LabRightCh.text=[LANG DPLocalizedString:@"CH2"];
//    self.LabRightCh.textAlignment = NSTextAlignmentRight;
//    self.LabRightCh.adjustsFontSizeToFitWidth = true;
//    self.LabRightCh.font = [UIFont systemFontOfSize:10];
//    [self.LabRightCh mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mVLink.mas_centerY).offset([Dimens GDimens:0]);
//        make.right.equalTo(self.mVLink.mas_right).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:OutputPageXoverBtnHeight]));
//    }];
}


- (void)Btn_Reset_Click:(NormalButton*)sender{
    [self showOutputResetDialog];
}

- (void)Btn_Lock_Click:(NormalButton*)sender{
    [self showOutputLockDialog];
}

- (void)Btn_Link_Click:(NormalButton*)sender{
    
    if(LinkMODE == LINKMODE_AUTO){
        if(BOOL_LINK){
            //            [self setUnlinkState];
            [self ShowAnyLinkDialog];
        }else{
            [self ShowAnyLinkDialog];
        }
    }else if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
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
    }
}
#pragma mark -------------------- 任意联调
- (void)ShowAnyLinkDialog{
    AnyLink *mAnyLink = [[AnyLink alloc]init];
    
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0x00000000)];
    [[KGModal sharedInstance] setOKButton:mAnyLink.Btn_Cancel];
    [[KGModal sharedInstance] showWithContentView:mAnyLink andAnimated:YES];
    mAnyLink.clickBlock = ^{
        [[KGModal sharedInstance]hideWithCompletionBlock:^{
            [self setAnyLinkDialog_Ok_Click:nil];
        }];
    };
    mAnyLink.unlinkBlock = ^{
        [[KGModal sharedInstance]hideWithCompletionBlock:^{
            [self setUnlinkState];
        }];
    };
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}
-(void)setAnyLinkDialog_Ok_Click:(UIButton *)sender{
    BOOL Link = false;
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if(RecStructData.OUT_CH[i].linkgroup_num > 0){
            Link = true;
            break;
        }
    }
    if(Link){
        [self setLinkState];
//        setDataSyncLink();
        [self setDataAllLink];
        [self.mDataTransmitOpt conformsToProtocol:false];
        [self FlashPageUI];
        [self.mDataTransmitOpt SEFF_Save:0];
    }else{
        [self setUnlinkState];
    }
    NSLog(@"setAnyLinkDialog_Ok_Click======");
    
}
-(void)setDataAllLink{
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        //计算联调组有多少个成员
        int gmem=LG.Data[i].cnt;
        int Dfrom = LG.Data[i].group[0];
        if(gmem >= 2){
            for(int ch=1;ch<gmem;ch++){
                copyGroupData(Dfrom, LG.Data[i].group[ch]);
            }
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
#pragma mark -------------------- 功能函数

- (void)setOutputSpkTypeDefault{
    for(int i=0;i<Output_CH_MAX_USE;i++){
        setOutputSpkType(ChannelTypeDefault[i],i);
    }
    
    
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
        setMixerVolWithOutputSpk(i);
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

- (void)FlashOutputSpkType{
    [self.OutName setTitle:[self.setOutNameDialog getOutputChannelTypeName:output_channel_sel] forState:UIControlStateNormal];
    [self FlashPageUI];
}

- (void)setUnlinkState{
    BOOL_LINK = false;
    
    if(LinkMODE == LINKMODE_SPKTYPE_S){
        RecStructData.OUT_CH[0].name[1] = 0;
    }
    
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE)){
        BOOL_LOCK = false;
        ChannelLinkCnt = 0;
        [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Locked"] forState:UIControlStateNormal] ;
        [self.Btn_Lock setNormal];
        [self.OutName setTitleColor:SetColor(UI_OutName_BtnText_Normal) forState:UIControlStateNormal];
        [self flashLinkViewState];
    }
    
//    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    [self.Btn_Link setNormal];
    
    if(LinkMODE == LINKMODE_AUTO){
        for(int i=0;i<Output_CH_MAX_USE;i++){
            RecStructData.OUT_CH[i].linkgroup_num = 0;
        }
    }
}

- (void)setLinkState{
    if(LinkMODE == LINKMODE_SPKTYPE_S){
        RecStructData.OUT_CH[0].name[1] = 1;
    }
    if((LinkMODE == LINKMODE_SPKTYPE_S)||(LinkMODE == LINKMODE_SPKTYPE_S)){
        BOOL_LOCK = true;
        [self.Btn_Lock setTitle:[LANG DPLocalizedString:@"L_Out_Unlock"] forState:UIControlStateNormal] ;
        [self.Btn_Lock setPress];
        [self.OutName setTitleColor:SetColor(UI_OutName_BtnText_Press) forState:UIControlStateNormal];
    }
    BOOL_LINK = true;
    
//    [self.Btn_Link setTitle:[LANG DPLocalizedString:@"L_Out_UnLink"] forState:UIControlStateNormal] ;
    [self.Btn_Link setPress];
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
            setMixerVolWithOutputSpk(output_channel_sel);
//            [self setMixerVolWithOutputSpk:output_channel_sel];
            [self FlashPageUI];
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark -------------------- 加密
- (void)initEncrypt{
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    self.Encrypt = [[UIButton alloc]init];
    [self.view addSubview:self.Encrypt];
    self.Encrypt.frame = CGRectMake(0, CGRectGetMaxY(self.mToolbar.frame), KScreenWidth, KScreenHeight);
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

#pragma mark -------------------- 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.channelBtn setChannelSelected:output_channel_sel];
//        [self.selectorHorizontal selectRowAtIndex:output_channel_sel];
        
        [self FlashPageUI_];
    });
}

- (void)FlashPageUI_{
    [self.channelColletionView MyChannelReload];
    [self flashXOver];
    if (LinkMODE!=LINKMODE_AUTO) {
          [self flashLinkViewState];
    }
    [self flashOutput];
//    [self flashDelay];
    if(BOOL_LINK){
        [self setLinkState];
    }else{
        [self setUnlinkState];
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
//        [self.SB_OutVal setProgress:0 ];
        self.LabOutVal.text=[NSString stringWithFormat:@"%d",0];
         [self changeLabOutValframe];
    }else{
        self.Encrypt.hidden = true;
    }
    
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
         [self flashLinkState];
//        if(LinkMODE == LINKMODE_SPKTYPE_S){
//            if(RecStructData.OUT_CH[0].name[1] == 1){
//                BOOL_LINK = true;
//                BOOL_LOCK = true;
//                [self CheckChannelCanLink];
//                [self setLinkState];
//            }else{
//                BOOL_LINK = false;
//                BOOL_LOCK = false;
//                [self setUnlinkState];
//            }
//
//        }
        
        [self FlashPageUI];
        
    });
}
- (void)flashLinkState{
    if(LinkMODE == LINKMODE_SPKTYPE_S){
        if(RecStructData.OUT_CH[0].name[1] == 1){
            BOOL_LINK = true;
            BOOL_LOCK = true;
            [self CheckChannelCanLink];
        }else{
            BOOL_LINK = false;
            BOOL_LOCK = false;
        }
    }else if(LinkMODE == LINKMODE_AUTO){
        [self checkLinkAuto];
    }else{
        BOOL_LINK = false;
        BOOL_LOCK = false;
    }
    
}
-(void)checkLinkAuto{
    BOOL_LINK=false;
    for(int j=1;j<=16;j++){
        ChannelAnyLinkBuf[j]=0;
    }
    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((RecStructData.OUT_CH[i].linkgroup_num <= Output_CH_MAX_USE)
           && (RecStructData.OUT_CH[i].linkgroup_num!=0)){
            ChannelAnyLinkBuf[i+1]=RecStructData.OUT_CH[i].linkgroup_num;
            BOOL_LINK = true;
        }
    }
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        /*
         switch (ChannelAnyLinkBuf[i]) {
         case 1:
         LG.Data[1].g=1;
         LG.Data[1].group[LG.Data[1].cnt]=i-1;
         LG.Data[1].cnt+=1;
         break;
         
         default:
         break;
         }
         */
        
        LG.Data[ChannelAnyLinkBuf[i]].group[LG.Data[ChannelAnyLinkBuf[i]].cnt]=i-1;
        LG.Data[ChannelAnyLinkBuf[i]].cnt+=1;
    }
    
}












@end


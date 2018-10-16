//
//  EQinputViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/11.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "EQinputViewController.h"
#import "MyChannelCView.h"
#import "XoverInputitem.h"
@interface EQinputViewController ()
@property(nonatomic,strong)MyChannelCView *channelColletionView;
@property(nonatomic,strong)XoverInputitem *h_Xover;
@property(nonatomic,strong)XoverInputitem *l_Xover;
@end

@implementation EQinputViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_EQ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mToolbar setLogoShow:false];
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_EQ"];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    
    
    
    //    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    [self initView];
    [self initEncrypt];
    [self FlashPageUI];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    
}

#pragma mark -------------------- channelBar


- (void)initChannelBar{
    self.channelBar = [[ChannelBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:Custom_ChannelBtnHeight])];
    [self.view addSubview:self.channelBar];
    [self.channelBar addTarget:self action:@selector(ChannelbarEvent:) forControlEvents:UIControlEventValueChanged];
    [self.channelBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:70]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:Custom_ChannelBtnHeight]));
    }];
    
    //    UIView *VLine = [[UIView alloc]init];
    //    [self.view addSubview:VLine];
    //    [VLine setBackgroundColor:SetColor(UI_ToolbarBackgroundLineColor)];
    //    [VLine mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.channelBar.mas_bottom).offset([Dimens GDimens:0]);
    //        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
    //        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 1));
    //    }];
}

- (void)ChannelbarEvent:(ChannelBar *)sender{
    input_channel_sel = [sender getChannel];
    [self FlashPageUI_];
}


#pragma mark -------------------- initChannelList

- (void)initChannelList{
    self.channelLab =[[UILabel alloc]init];
    [self.view addSubview:self.channelLab];
    self.channelLab.textAlignment=NSTextAlignmentCenter;
    self.channelLab.textColor=[UIColor whiteColor];
    self.channelLab.text=[NSString stringWithFormat:@"输入%d",input_channel_sel];
    self.channelLab.font=[UIFont systemFontOfSize:15];
    [self.channelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:ChannelBtnListHeight]));
        
    }];
    UIButton *lastBtn=[[UIButton alloc]init];
    [self.view addSubview:lastBtn];
    [lastBtn addTarget:self action:@selector(lastCh) forControlEvents:UIControlEventTouchUpInside];
    [lastBtn setImage:[UIImage imageNamed:@"last_icon"] forState:UIControlStateNormal];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.channelLab.mas_centerY);
        make.right.equalTo(self.channelLab.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    
    UIButton *nextBtn=[[UIButton alloc]init];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextCh) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setImage:[UIImage imageNamed:@"next_icon"] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.channelLab.mas_centerY);
        make.left.equalTo(self.channelLab.mas_right);
        make.size.mas_equalTo(lastBtn);
    }];
    //    self.channelColletionView=[[MyChannelCView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnListHeight])];
    //    __weak typeof(self) weakself=self;
    //    self.channelColletionView.backgroundColor=SetColor(Color_EQChannelLis_bg);
    //    self.channelColletionView.selectedIndex = ^(int row) {
    //        //选择后的回调
    //        [weakself FlashPageUI_];
    //    };
    //    [self.view addSubview:self.channelColletionView];
    //    [self.channelColletionView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:15]);
    //                make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
    //                make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnListHeight]));
    //    }];
    
};
-(void)nextCh{
    int nextIndex=input_channel_sel;
    if (++nextIndex>=Input_CH_MAX_USE) {
        
    }else{
        input_channel_sel=nextIndex;
        [self FlashPageUI];
    }
}
-(void)lastCh{
    int lastIndex=input_channel_sel;
    if (--lastIndex<0) {
        
    }else{
        input_channel_sel=lastIndex;
        [self FlashPageUI];
    }
}
#pragma mark --------页面初始化
- (void)initView{
    [self initChannelList];
    //    [self initChannelBar];
    UIImageView *eqImageView=[[UIImageView alloc]init];
    [self.view addSubview:eqImageView];
    [eqImageView setImage:[UIImage imageNamed:@"eq_bg"]];
    [eqImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.channelLab.mas_bottom).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:EQViewHeight]));
    }];
    //EQ 曲线图
    self.EQV_INS = [[EQView alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:UI_StartWithTopBar+20], KScreenWidth-[Dimens GDimens:8], [Dimens GDimens:EQViewHeight])];
    [self.view addSubview:self.EQV_INS];
    //    self.EQV_INS.layer.borderColor=[UIColor blackColor].CGColor;
    //    self.EQV_INS.layer.borderWidth=0.5;
    [self.EQV_INS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.channelLab.mas_bottom).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:EQViewHeight]));
    }];
//    [self.EQV_INS SetINEQData:RecStructData.IN_CH[0]];
    
    //EQ提示边
    self.EQindex = [[EQIndex alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight])];
    
    [self.view addSubview:self.EQindex];
    [self.EQindex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.EQV_INS.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight-20]));
    }];
    
    //初始化scrollview
    [self initSVEQ];
    
    
    //EQ功能按键
    self.Btn_EQReset = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQReset];
    //    [self.Btn_EQReset initView:3 withBorderWidth:0 withNormalColor:UI_EQSet_Btn_Normal withPressColor:UI_EQSet_Btn_Press withType:1];
    //    [self.Btn_EQReset setTextColorWithNormalColor:UI_EQSet_BtnText_Normal withPressColor:UI_EQSet_BtnText_Press];
    [self.Btn_EQReset initViewBroder:0
                     withBorderWidth:0
                     withNormalColor:UI_DelayBtn_NormalIN
                      withPressColor:UI_DelayBtn_PressIN
               withBorderNormalColor:UI_EQSet_Btn_Normal
                withBorderPressColor:UI_EQSet_Btn_Press
                 withTextNormalColor:UI_EQSet_BtnText_Normal
                  withTextPressColor:UI_EQSet_BtnText_Press
                            withType:4];
    self.Btn_EQReset.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQReset addTarget:self action:@selector(Btn_EQReset_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQReset setTitle:[LANG DPLocalizedString:@"L_EQ_ResetEQ"] forState:UIControlStateNormal] ;
    [self.Btn_EQReset setNormal];
    [self.Btn_EQReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SVEQ.mas_bottom).offset([Dimens GDimens:5]);
        make.leftMargin.mas_equalTo([Dimens GDimens:EQBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
    }];
    //直通与恢复
    self.Btn_EQByPass = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQByPass];
    [self.Btn_EQByPass initViewBroder:0
                      withBorderWidth:0
                      withNormalColor:UI_DelayBtn_NormalIN
                       withPressColor:UI_DelayBtn_PressIN
                withBorderNormalColor:UI_EQSet_Btn_Normal
                 withBorderPressColor:UI_EQSet_Btn_Press
                  withTextNormalColor:UI_EQSet_BtnText_Normal
                   withTextPressColor:UI_EQSet_BtnText_Press
                             withType:4];
    self.Btn_EQByPass.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQByPass addTarget:self action:@selector(Btn_EQByPass_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Bypass"] forState:UIControlStateNormal] ;
    [self.Btn_EQByPass setNormal];
    if(!EnableGPEQ){
        [self.Btn_EQByPass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.Btn_EQReset.mas_centerY).offset([Dimens GDimens:0]);
            make.rightMargin.mas_equalTo([Dimens GDimens:-EQBtnMarginSide]);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
        }];
    }else{
        [self.Btn_EQByPass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.Btn_EQReset.mas_centerY).offset([Dimens GDimens:0]);
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
        }];
    }
    
    //PG_MD
    self.Btn_EQPG_MD = [[NormalButton alloc]init];
    [self.view addSubview:self.Btn_EQPG_MD];
    [self.Btn_EQPG_MD initViewBroder:3
                     withBorderWidth:0
                     withNormalColor:UI_DelayBtn_NormalIN
                      withPressColor:UI_DelayBtn_PressIN
               withBorderNormalColor:UI_EQSet_Btn_Normal
                withBorderPressColor:UI_EQSet_Btn_Press
                 withTextNormalColor:UI_EQSet_BtnText_Normal
                  withTextPressColor:UI_EQSet_BtnText_Press
                            withType:5];
    self.Btn_EQPG_MD.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.Btn_EQPG_MD addTarget:self action:@selector(Btn_PGEQMode_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    [self.Btn_EQPG_MD setNormal];
    [self.Btn_EQPG_MD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_EQReset.mas_centerY).offset([Dimens GDimens:0]);
        make.rightMargin.mas_equalTo([Dimens GDimens:-EQBtnMarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:EQBtnWidth], [Dimens GDimens:EQBtnHeight]));
    }];
    if(!EnableGPEQ){
        self.Btn_EQPG_MD.hidden = true;
    }
    
    if(RecStructData.IN_CH[input_channel_sel].eq_mode == 0){
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }
    
    [self checkByPass];
    
    
    
    //通道選擇
    //    self.channelBtn = [[ChannelBtn alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnHeight])];
    //    [self.view addSubview:self.channelBtn];
    //    [self.channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.Btn_EQReset.mas_bottom).offset([Dimens GDimens:18]);
    //        make.centerX.equalTo(self.view.mas_centerX);
    //        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnHeight]));
    //    }];
    //    [self.channelBtn addTarget:self action:@selector(ChannelChange:) forControlEvents:UIControlEventValueChanged];
    [self creatXoverView];
    
}
-(void)creatXoverView{
    self.h_Xover=[[XoverInputitem alloc]init];
    [self.h_Xover addTarget:self action:@selector(changedXover:) forControlEvents:UIControlEventValueChanged];
    [self.h_Xover setXoverType:H_Type];
    [self.view addSubview:self.h_Xover];
    [self.h_Xover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Btn_EQReset.mas_bottom).offset([Dimens GDimens:10]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:5]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth/2-[Dimens GDimens:10], [Dimens GDimens:110]));
    }];
    self.l_Xover=[[XoverInputitem alloc]init];
    [self.l_Xover addTarget:self action:@selector(changedXover:) forControlEvents:UIControlEventValueChanged];
    [self.l_Xover setXoverType:L_Type];
    [self.view addSubview:self.l_Xover];
    [self.l_Xover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.h_Xover.mas_top);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-8]);
        make.size.mas_equalTo(self.h_Xover);
    }];
}
-(void)changedXover:(XoverInputitem *)item{
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
}
#pragma mark---------滑动事件
- (void) initSVEQ{
    eqIndex = 0;
    self.SVEQ = [[UIScrollView alloc]init];
    [self.view addSubview:self.SVEQ];
    [self.SVEQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.EQindex.mas_right).offset(0);
        make.centerY.mas_equalTo(self.EQindex.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight-20]));
    }];
    self.SVEQ.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.SVEQ.delegate = self;
    // 设置内容大小
    //禁止UIScrollView垂直方向滚动，只允许水平方向滚动
    //scrollview.contentSize =  CGSizeMake(你要的长度, 0);
    //禁止UIScrollView水平方向滚动，只允许垂直方向滚动
    //scrollview.contentSize =  CGSizeMake(0, 你要的宽度);
    self.SVEQ.contentSize = CGSizeMake([Dimens GDimens:EQItemWidth]*Input_CH_EQ_MAX, 0);
    // 是否反弹
    self.SVEQ.bounces = NO;
    // 是否分页
    //self.SVEQ.pagingEnabled = YES;
    // 是否滚动
    //self.SVEQ.scrollEnabled = NO;
    //self.SVEQ.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    // self.SVEQ.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //self.SVEQ.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //self.SVEQ.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [self.SVEQ flashScrollIndicators];
    // 是否同时运动,lock
    self.SVEQ.directionalLockEnabled = NO;
    
    
    for(int i=0;i<Input_CH_EQ_MAX;i++){
        EQItem *eqitem = [[EQItem alloc]initWithFrame:CGRectMake([Dimens GDimens:EQItemWidth]*i, 0, [Dimens GDimens:EQItemWidth], [Dimens GDimens:EQItemHeight])];
        [eqitem setTag:i];
        
        [self.SVEQ addSubview:eqitem];
        
        eqitem.Lab_ID.text = [NSString stringWithFormat:@"%d",i+1];
        ///
        [eqitem.Btn_Gain setTitle:[NSString stringWithFormat:@"%@dB",[self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[i].level]] forState:UIControlStateNormal] ;
        [eqitem.Btn_Gain addTarget:self action:@selector(EQ_Btn_Gain_Click:) forControlEvents:UIControlEventTouchUpInside];
        ///
        [eqitem.Btn_BW setTitle:[self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
        [eqitem.Btn_BW addTarget:self action:@selector(EQ_Btn_BW_Click:) forControlEvents:UIControlEventTouchUpInside];
        ///
        //        [eqitem.Btn_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
        [eqitem.Btn_Freq setTitle:[NSString stringWithFormat:@"%d",RecStructData.IN_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
        [eqitem.Btn_Freq addTarget:self action:@selector(EQ_Btn_Freq_Click:) forControlEvents:UIControlEventTouchUpInside];
        //
        eqitem.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[i].level - EQ_LEVEL_MIN;
        [eqitem.SB_Gain addTarget:self action:@selector(EQ_SB_Gain_ValueChanged:) forControlEvents:UIControlEventValueChanged];
        //
        [eqitem.Btn_Reset addTarget:self action:@selector(EQ_Btn_Reset_Click:) forControlEvents:UIControlEventTouchUpInside];
        
        [eqitem setEQItemTag:i];
    }
    
}

- (void)EQ_Btn_Gain_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.IN_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    //NSLog(@"EQ_Btn_Gain_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Gain;
    EQ_MODE = 1;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_BW_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.IN_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    //NSLog(@"EQ_Btn_BW_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_BW;
    EQ_MODE = 2;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_Freq_Click:(UIButton*)sender{
    if(EnableGPEQ){
        if(RecStructData.IN_CH[input_channel_sel].eq_mode != 0){
            return;
        }
    }
    
    //NSLog(@"EQ_Btn_Freq_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Freq;
    EQ_MODE = 3;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    [self showEQDialog];
}
- (void)EQ_Btn_Reset_Click:(UIButton*)sender{
    //NSLog(@"EQ_Btn_Reset_Click id=%d",(int)sender.tag);
    eqIndex = (int)sender.tag-TagStartEQItem_Btn_Reset;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    
    
    if((RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level == EQ_LEVEL_ZERO)
       &&(BufStructData.IN_CH[input_channel_sel].EQ[eqIndex].level != EQ_LEVEL_ZERO)){
        RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level =
        BufStructData.IN_CH[input_channel_sel].EQ[eqIndex].level;
        
        BufStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
        [_CurEQItem.Btn_Reset setImage:[UIImage imageNamed:@"eq_resetg_press"] forState:UIControlStateNormal];
    }else if((RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level != EQ_LEVEL_ZERO)){
        BufStructData.IN_CH[input_channel_sel].EQ[eqIndex].level =
        RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level;
        
        RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
        [_CurEQItem.Btn_Reset setImage:[UIImage imageNamed:@"eq_resetg_normal"] forState:UIControlStateNormal];
    }
    
    _CurEQItem.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level-EQ_LEVEL_MIN;
    [_CurEQItem.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level] forState:UIControlStateNormal] ;
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
    
    syncLinkData(UI_EQ_ALL);
}
- (void)EQ_SB_Gain_ValueChanged:(UISlider*)sender{
    //NSLog(@"EQ_SB_Gain_ValueChanged id=%d",(int)sender.tag);
    //NSLog(@"EQ_SB_Gain_ValueChanged value=%d",(uint16)sender.value);
    eqIndex = (int)sender.tag-TagStartEQItem_SB_Gain;
    _CurEQItem = (EQItem *)[self.view viewWithTag:eqIndex+TagStartEQItem_Self];
    [self setEQItemSelColor];
    RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = (uint16)sender.value + EQ_LEVEL_MIN;
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
    BufStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = EQ_LEVEL_ZERO;
    [_CurEQItem.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level] forState:UIControlStateNormal] ;
    
    [self checkCurResetBtnState];
    syncLinkData(UI_EQ_Level);
}
- (NSString*)ChangeGainValume:(int) num{
    num -= EQ_LEVEL_MIN;
    //    return [NSString stringWithFormat:@"%.1fdB",0.0-(EQ_Gain_MAX/2-num)/10.0];
    return [NSString stringWithFormat:@"%.1fdB",0.0-(EQ_Gain_MAX/2-num)/10.0];
}
//获取Equalizer 的EQ的Q值数据显示
- (NSString*) ChangeBWValume:(int) num{
    if(num>EQ_BW_MAX){
        num=EQ_BW_MAX;
    }
    return [NSString stringWithFormat:@"%.3f",EQ_BW296[num]];
}

#pragma mark -
/*
 // 返回一个放大或者缩小的视图
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
 
 }
 // 开始放大或者缩小
 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:
 (UIView *)view
 {
 
 }
 
 // 缩放结束时
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
 
 }
 
 // 视图已经放大或缩小
 - (void)scrollViewDidZoom:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidScrollToTop");
 }
 */

// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScrollToTop");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating");
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
}
#pragma 响应事件
//通道選擇
- (void)ChannelChange:(ChannelBtn*)sender {
    input_channel_sel = [sender GetChannelSelected];
    //NSLog(@"ChannelChange channel=@%d",input_channel_sel);
    [self FlashPageUI];
    
}
//EQ功能按键-重置EQ
- (void)Btn_EQReset_click:(NormalButton*)sender {
    [self.Btn_EQReset setPress];
    [self showEQResetDialog];
}

//EQ功能按键-直通与恢复EQ
- (void)Btn_EQByPass_click:(NormalButton*)sender {
    [self.Btn_EQByPass setPress];
    [self showEQByPassDialog];
}

- (void)Btn_PGEQMode_click:(NormalButton*)sender {
    if(RecStructData.IN_CH[input_channel_sel].eq_mode == 0){
        RecStructData.IN_CH[input_channel_sel].eq_mode = 1;
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        RecStructData.IN_CH[input_channel_sel].eq_mode = 0;
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }
    for(int j=0;j<Input_CH_EQ_MAX;j++){
        RecStructData.IN_CH[input_channel_sel].EQ[j].bw = DefaultStructData.IN_CH[input_channel_sel].EQ[j].bw;
        RecStructData.IN_CH[input_channel_sel].EQ[j].freq = DefaultStructData.IN_CH[input_channel_sel].EQ[j].freq;
        RecStructData.IN_CH[input_channel_sel].EQ[j].level = DefaultStructData.IN_CH[input_channel_sel].EQ[j].level;
        RecStructData.IN_CH[input_channel_sel].EQ[j].shf_db= DefaultStructData.IN_CH[input_channel_sel].EQ[j].shf_db;
        RecStructData.IN_CH[input_channel_sel].EQ[j].type = DefaultStructData.IN_CH[input_channel_sel].EQ[j].type;
    }
    //    syncLinkData(UI_EQ_G_P_MODE_EQ);
    [self FlashPageUI];
}

#pragma 功能函数
- (void)setEQItemSelColorClean{
    EQItem *find_btn;
    for(int i=0;i<Input_CH_EQ_MAX;i++){
        find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
        if(RecStructData.IN_CH[input_channel_sel].eq_mode == 0){
            [find_btn setStateColor:EQItemNoramlColor];
        }else{
            [find_btn setStateColor:EQItemNoramlLockColor];
        }
    }
    syncLinkData(UI_EQ_ALL);
}
- (void)setEQItemSelColor{
    
    [self setEQItemSelColorClean];
    if(RecStructData.IN_CH[input_channel_sel].eq_mode == 0){
        [_CurEQItem setStateColor:EQItemPressColor];
    }else{
        [_CurEQItem setStateColor:EQItemLockedlColor];
    }
    
    
}

- (BOOL)getByPass{
    for(int i=0;i<Input_CH_EQ_MAX;i++){
        if(RecStructData.IN_CH[input_channel_sel].EQ[i].level != EQ_LEVEL_ZERO){
            return false;
        }
    }
    return true;
}


- (void)checkByPass{
    
    bool_ByPass = [self getByPass];
    if(bool_ByPass){
        [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Restore"] forState:UIControlStateNormal] ;
        [self.Btn_EQByPass setNormal];
    }else{
        [self.Btn_EQByPass setTitle:[LANG DPLocalizedString:@"L_EQ_Bypass"] forState:UIControlStateNormal] ;
        [self.Btn_EQByPass setPress];
    }
}
- (void)checkCurResetBtnState{
    if(RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level == EQ_LEVEL_ZERO){
        [_CurEQItem.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [_CurEQItem.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    [self checkByPass];
}

- (void)setEQByPass{
    if(bool_ByPass){
        for(int j=0;j<Input_CH_EQ_MAX;j++){
            RecStructData.IN_CH[input_channel_sel].EQ[j].level =
            RecStructData.IN_CH_BUF[input_channel_sel].EQ[j].level;
        }
        
    }else{
        for(int j=0;j<Input_CH_EQ_MAX;j++){
            RecStructData.IN_CH_BUF[input_channel_sel].EQ[j].level =
            RecStructData.IN_CH[input_channel_sel].EQ[j].level;
            RecStructData.IN_CH[input_channel_sel].EQ[j].level = EQ_LEVEL_ZERO;
        }
    }
    syncLinkData(UI_EQ_Level);
    [self FlashPageUI];
}
#pragma 弹出对话框
- (void)showEQResetDialog{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_EQ_ResetEQ"]message:[LANG DPLocalizedString:@"L_EQ_ResetEQ_Msg"]preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Btn_EQReset setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for(int i=0;i<Input_CH_EQ_MAX;i++){
            RecStructData.IN_CH[input_channel_sel].EQ[i].bw     = DefaultStructData.IN_CH[input_channel_sel].EQ[i].bw;
            RecStructData.IN_CH[input_channel_sel].EQ[i].freq   = DefaultStructData.IN_CH[input_channel_sel].EQ[i].freq;
            RecStructData.IN_CH[input_channel_sel].EQ[i].level  = DefaultStructData.IN_CH[input_channel_sel].EQ[i].level;
            RecStructData.IN_CH[input_channel_sel].EQ[i].shf_db = DefaultStructData.IN_CH[input_channel_sel].EQ[i].shf_db;
            RecStructData.IN_CH[input_channel_sel].EQ[i].type   = DefaultStructData.IN_CH[input_channel_sel].EQ[i].type;
        }
        //EQ复位用
        for(int j=0;j<Input_CH_EQ_MAX;j++){
            BufStructData.IN_CH[input_channel_sel].EQ[j].level = EQ_LEVEL_ZERO;
        }
        for(int j=0;j<Input_CH_EQ_MAX;j++){
            RecStructData.IN_CH_BUF[input_channel_sel].EQ[j].level =  EQ_LEVEL_ZERO;
        }
        syncLinkData(UI_EQ_ALL);
        [self FlashPageUI];
        [self.Btn_EQReset setNormal];
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showEQByPassDialog{
    bool_ByPass = [self getByPass];
    if (bool_ByPass) {
        UIAlertController *alert;
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_EQ_Restore_Msg"]message:@""  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
            [self.Btn_EQByPass setNormal];
            [self setEQByPass];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.Btn_EQByPass setNormal];
            [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert;
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_EQ_ByPass_Msg"]message:@""  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
            [self.Btn_EQByPass setNormal];
            [self setEQByPass];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [self.Btn_EQByPass setNormal];
            [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma 弹出选择 EQ
- (int)getFreqIndexFromArray:(int)freq{
    int i=0;
    for(i=0;i<240;i++){
        if((freq >= FREQ241[i])&&(freq <= FREQ241[i+1])){
            break;
        }
    }
    return i;
}
-(void)showEQDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.frame = CGRectMake(0, 0, 280, 30);
    labelTitle.text = [LANG DPLocalizedString:@"L_Delay_SetOutputDelay"];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelTitle];
    
    _btnMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnMinus.frame = CGRectMake(10, 100, 30, 30);
    _btnMinus.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnMinus setTitle:@"-" forState:UIControlStateNormal];
    [_btnMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [_btnMinus setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    _btnMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnMinus addTarget:self action:@selector(DialogSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderEQ = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderEQ.dataSource = weakSelf;
    
    
    switch (EQ_MODE) {
        case 1:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetGain"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = EQ_Gain_MAX;
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level];
            [_sliderEQ setValue:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level- IN_EQ_LEVEL_MIN];
            break;
        case 2:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetEQ"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = EQ_BW_MAX;
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw];
            [_sliderEQ setValue:EQ_BW_MAX - RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw];
            break;
        case 3:
            labelTitle.text = [LANG DPLocalizedString:@"L_XOver_SetFreq"];
            _sliderEQ.minimumValue = 0;
            _sliderEQ.maximumValue = 240;
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq];
            [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq]];
            break;
        default:
            break;
    }
    
    
    
    [_sliderEQ addTarget:self action:@selector(SBDialogSet) forControlEvents:UIControlEventValueChanged];
    
    /*
     UIImage *stetchTrack1 = [UIImage imageNamed:@"skslider1.png"];
     UIImage *stetchTrack2 = [[UIImage imageNamed:@"skslider2.png"]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
     [_slider setThumbImage: [UIImage imageNamed:@"skbit1.png"] forState:UIControlStateNormal];
     [_slider setMinimumTrackImage:stetchTrack2 forState:UIControlStateNormal];
     [_slider setMaximumTrackImage:stetchTrack1 forState:UIControlStateNormal];
     */
    [contentView addSubview:_sliderEQ];
    
    
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [_btnAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    _btnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAdd addTarget:self action:@selector(DialogSet_Inc) forControlEvents:UIControlEventTouchUpInside];
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
    [btnOK initView:3 withBorderWidth:0 withNormalColor:UI_MainStyleColorNormal withPressColor:UI_MainStyleColorPress withType:1];//设置参数
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
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}

- (void)SBDialogSet{
    
    int sliderValue = (int)(_sliderEQ.value);
    switch (EQ_MODE) {
        case 1:
        {
            RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level=EQ_LEVEL_MIN+sliderValue;
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level];
            
            [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
            _CurEQItem.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [self checkCurResetBtnState];
            syncLinkData(UI_EQ_Level);
        }
            break;
        case 2:
        {
            sliderValue = EQ_BW_MAX - sliderValue;
            RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw=sliderValue;
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw];
            
            [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_BW);
        }
            break;
        case 3:
        {
            RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq= FREQ241[sliderValue];
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq];
            
            [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_Freq);
        }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
}

- (void)DialogSet_Sub{
    switch (EQ_MODE) {
        case 1:
        {
            if(--RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level < IN_EQ_LEVEL_MIN){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = IN_EQ_LEVEL_MIN;
            }
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level];
            _sliderEQ.value=RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
            _CurEQItem.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [self checkCurResetBtnState];
            syncLinkData(UI_EQ_Level);
        }
            break;
        case 2:
        {
            if(++RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw > EQ_BW_MAX){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw = EQ_BW_MAX;
            }
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw];
            _sliderEQ.value=EQ_BW_MAX - RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw;
            
            [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_BW);
        }
            break;
        case 3:
        {
            if(--RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq < 20){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq = 20;
            }
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq];
            [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq]];
            
            [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_Freq);
        }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
}
- (void)DialogSet_Inc{
    switch (EQ_MODE) {
        case 1:
        {
            if(++RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level > IN_EQ_LEVEL_MAX){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level = IN_EQ_LEVEL_MAX;
            }
            _sliderEQ.showValue = [self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level];
            _sliderEQ.value=RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [_CurEQItem.Btn_Gain setTitle:_sliderEQ.showValue forState:UIControlStateNormal];
            _CurEQItem.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].level - IN_EQ_LEVEL_MIN;
            
            [self checkCurResetBtnState];
            syncLinkData(UI_EQ_Level);
        }
            break;
        case 2:
        {
            if(--RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw < 0){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw = 0;
            }
            _sliderEQ.showValue = [self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw];
            _sliderEQ.value=EQ_BW_MAX - RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].bw;
            
            [_CurEQItem.Btn_BW setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_BW);
        }
            
            break;
        case 3:
        {
            if(++RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq > 20000){
                RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq = 20000;
            }
            _sliderEQ.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq];
            [_sliderEQ setValue:[self getFreqIndexFromArray: RecStructData.IN_CH[input_channel_sel].EQ[eqIndex].freq]];
            
            [_CurEQItem.Btn_Freq setTitle:_sliderEQ.showValue forState:UIControlStateNormal] ;
            syncLinkData(UI_EQ_Freq);
        }
            break;
        default:
            break;
    }
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];}
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogSet_Sub) userInfo:nil repeats:YES];
        
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
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(DialogSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}


#pragma 加密
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
        //[self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Master_EN_EncryptionSave"] WithMode:SEFF_OPT_Save];
        
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
                //[self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Master_EN_EncryptionSave"] WithMode:SEFF_OPT_Save];
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
//音效操作进度
/*
 Mode=1: 读取
 Mode=2: 保存
 */
-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode{
    [self initSaveLoadSEFFProgress];
    self.HUD_SEFF.detailsLabelText = Detail;
    [self.HUD_SEFF showWhileExecuting:@selector(HUD_SEFFProgressTask) onTarget:self withObject:nil animated:YES];
    
}
-(void)initSaveLoadSEFFProgress{
    
    self.HUD_SEFF = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD_SEFF];    //常用的设置
    //小矩形的背景色
    //self.HUD_SEFF.color = [UIColor blueColor];//这儿表示无背景clearColor
    //显示的文字
    self.HUD_SEFF.labelText = @"";
    //细节文字
    self.HUD_SEFF.detailsLabelText = @"";
    //是否有庶罩
    self.HUD_SEFF.dimBackground = YES;
    //[self.HUD_SEFF hide:YES afterDelay:2];
    
    self.HUD_SEFF.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD_SEFF.delegate = self;
    
}
-(void) HUD_SEFFProgressTask{
    
    
    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
    
    NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [_mDataTransmitOpt GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
        self.HUD_SEFF.progress = 1-progress/100.0;
        usleep(10000);
    }
}
//输入框文字改变时 方法
-(void)setEnTextDidChange:(UITextField *)fd{
    if(fd.text.length > 6){
        fd.text = setEnNum;
    }
    //NSLog(@"setEnTextDidChange setEnNum=%@",fd.text);
    setEnNum = fd.text;
}
//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma
//检查可设置联调的通道
- (void) CheckChannelCanLink{
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
    for(i=0;i<Input_CH_MAX_USE;i++){
        channelNameNum=[self GetChannelNum:i];
        //NSLog(@"channelNameNum=%d",channelNameNum);
        if(channelNameNum>=0){
            for(j=i+1;j<Input_CH_MAX_USE;j++){
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
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }
    
    for(int i=0;i<16;i++){
        if(ChannelNumBuf[i]<0){
            ChannelNumBuf[i]=0;
        }
        if(ChannelNumBuf[i]>25){
            ChannelNumBuf[i]=0;
        }
    }
    
    return ChannelNumBuf[channel];
}
#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        //    [self.channelBtn setChannelSelected:input_channel_sel];
        //        [self.channelBar selectRowAtIndex:input_channel_sel];
        //        [self.channelBar setChannel:input_channel_sel];
        
        [self FlashPageUI_];
    });
}

- (void)FlashPageUI_{
    //更新控件选择位置
    [self.h_Xover flashXover];
    [self.l_Xover flashXover];
    //    [self.channelColletionView MyChannelReload];
    self.channelLab.text=[NSString stringWithFormat:@"输入%d",input_channel_sel+1];
    EQItem *find_btn;
    [self.EQV_INS SetINEQData:RecStructData.IN_CH[input_channel_sel]];
    [self setEQItemSelColorClean];
    for(int i=0;i<Input_CH_EQ_MAX;i++){
        
        find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
        //        if(input_channel_sel >=6){
        //            if(i>=10){
        //                find_btn.hidden = true;
        //            }
        //            self.SVEQ.contentSize = CGSizeMake([Dimens GDimens:EQItemWidth]*10, 0);
        //        }else{
        //            if(i>=10){
        //                find_btn.hidden = false;
        //            }
        //            self.SVEQ.contentSize = CGSizeMake([Dimens GDimens:EQItemWidth]*Input_CH_EQ_MAX, 0);
        //        }
        
        
        [find_btn.Btn_Gain setTitle:[self ChangeGainValume:RecStructData.IN_CH[input_channel_sel].EQ[i].level] forState:UIControlStateNormal] ;
        find_btn.SB_Gain.value = RecStructData.IN_CH[input_channel_sel].EQ[i].level - IN_EQ_LEVEL_MIN;
        [find_btn.Btn_BW setTitle:[self ChangeBWValume:RecStructData.IN_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
        [find_btn.Btn_Freq setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
        
        if(RecStructData.IN_CH[input_channel_sel].EQ[i].level == EQ_LEVEL_ZERO){
            [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    [self checkByPass];
    if(RecStructData.IN_CH[input_channel_sel].eq_mode == 0){
        [self.Btn_EQPG_MD setPress];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_PEQ_MODE"] forState:UIControlStateNormal] ;
    }else{
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
    }
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        self.Encrypt.hidden = false;
        
        [self.Btn_EQPG_MD setNormal];
        [self.Btn_EQPG_MD setTitle:[LANG DPLocalizedString:@"L_EQ_GEQ_MODE"] forState:UIControlStateNormal] ;
        [self.EQV_INS SetINEQData:DefaultStructData.IN_CH[input_channel_sel]];
        for(int i=0;i<Input_CH_EQ_MAX;i++){
            find_btn = (EQItem *)[self.view viewWithTag:i+TagStartEQItem_Self];
            
            [find_btn.Btn_Gain setTitle:[self ChangeGainValume:DefaultStructData.IN_CH[input_channel_sel].EQ[i].level] forState:UIControlStateNormal] ;
            find_btn.SB_Gain.value = DefaultStructData.IN_CH[input_channel_sel].EQ[i].level - IN_EQ_LEVEL_MIN;
            [find_btn.Btn_BW setTitle:[self ChangeBWValume:DefaultStructData.IN_CH[input_channel_sel].EQ[i].bw] forState:UIControlStateNormal] ;
            [find_btn.Btn_Freq setTitle:[NSString stringWithFormat:@"%d",DefaultStructData.IN_CH[input_channel_sel].EQ[i].freq] forState:UIControlStateNormal] ;
            
            if(DefaultStructData.IN_CH[input_channel_sel].EQ[i].level == EQ_LEVEL_ZERO){
                [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else{
                [find_btn.Btn_Reset setImage:[[UIImage imageNamed:@"eq_resetg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
        }
        
    }else{
        self.Encrypt.hidden = true;
    }
    
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
        
        //        if (LinkMODE == LINKMODE_SPKTYPE_S) {
        //            if(RecStructData.IN_CH[0].name[1] == 1){
        //                BOOL_LINK = true;
        //                BOOL_LOCK = true;
        //                [self CheckChannelCanLink];
        //            }else{
        //                BOOL_LINK = false;
        //                BOOL_LOCK = false;
        //            }
        //        }else{
        //            BOOL_LINK = false;
        //            BOOL_LOCK = false;
        //        }
        //
    });
}


@end


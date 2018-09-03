//
//  MixerViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MixerViewController.h"
#import "MixerTableViewCell.h"
#import "MyChannelCView.h"
#import "MixCollectionViewCell.h"
#define itemMargin  20
@interface MixerViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)MyChannelCView *channelColletionView;
@property (nonatomic,strong)UICollectionView *mixerCollectionView;
@end

@implementation MixerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Mixer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_Mixer_Mixer"];
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_FlashInputSource object:nil];
    
    
//    self.view.backgroundColor = [UIColor clearColor];
//    [self initData];
    [self initView];
    [self initEncrypt];
    [self FlashPageUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma initData
- (void)initData{
 
}

#pragma mark ---Channel select

- (void)initChannel{
    [self initChannelList];
//    [self initChannelBar];
}


- (void)initChannelBar{
    self.channelBar = [[ChannelBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:Custom_ChannelBtnHeight])];
    [self.view addSubview:self.channelBar];
    [self.channelBar addTarget:self action:@selector(ChannelbarEvent:) forControlEvents:UIControlEventValueChanged];
    [self.channelBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:0]);
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
    output_channel_sel = [sender getChannel];
    [self FlashPageUI_];
}
#pragma  initChannelList
- (void)initChannelList{
  
   
//    [self.selectorHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:70]);
//        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnListHeight]));
//    }];
    
    self.channelColletionView=[[MyChannelCView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnListHeight])];
    self.channelColletionView.backgroundColor=SetColor(Color_EQChannelLis_bg);
    __weak typeof(self) weakself=self;
    self.channelColletionView.selectedIndex = ^(int row) {
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


- (void)initView{
    [self initChannel];
    [self initSVMixer];
    
    //通道選擇
//    self.channelBtn = [[ChannelBtn alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ChannelBtnHeight])];
//    [self.view addSubview:self.channelBtn];
//    [self.channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.SVMixer.mas_bottom).offset(0);
//        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:ChannelBtnHeight]));
//    }];
//    [self.channelBtn addTarget:self action:@selector(ChannelChange:) forControlEvents:UIControlEventValueChanged];
//    


}

//通道選擇
- (void)ChannelChange:(ChannelBtn*)sender {
    output_channel_sel = [sender GetChannelSelected];
    //NSLog(@"ChannelChange channel=@%d",output_channel_sel);
    [self FlashPageUI];
}

#pragma initSVMixer
#pragma 滑动事件
-(void)creatCollectionView{
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.itemSize=CGSizeMake((KScreenWidth-(3*[Dimens GDimens:itemMargin]))/2, [Dimens GDimens:90]);
    //水平方向
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing=[Dimens GDimens:50];
//        flow.minimumInteritemSpacing=[Dimens GDimens:itemMargin];
    self.mixerCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,20+[Dimens GDimens:44], KScreenWidth, KScreenHeight-(20+[Dimens GDimens:44])-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:100]) collectionViewLayout:flow];
    [self.view addSubview:self.mixerCollectionView];
    self.mixerCollectionView.backgroundColor=[UIColor clearColor];
    self.mixerCollectionView.delegate=self;
    self.mixerCollectionView.dataSource=self;
    [self.mixerCollectionView registerClass:[MixCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    //是否允许滑动
    self.mixerCollectionView.scrollEnabled=YES;
    self.mixerCollectionView.showsHorizontalScrollIndicator=NO;
    self.mixerCollectionView.showsVerticalScrollIndicator=NO;
    [self.mixerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelColletionView.mas_bottom).offset([Dimens GDimens:20]);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset([Dimens GDimens:-20]);
//        if(KScreenHeight==812){
//            make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]-40-[Dimens GDimens:20]));
//        }else{
//            make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]-[Dimens GDimens:20]));
//        }
        
    }];
}
-(void)creatTableView{
    self.SVMixer1=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:525]) style:UITableViewStylePlain];
    self.SVMixer1.delegate=self;
    self.SVMixer1.dataSource=self;
    self.SVMixer1.userInteractionEnabled=YES;
    [self.view addSubview:self.SVMixer1];
    [self.SVMixer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.channelColletionView.mas_bottom).offset([Dimens GDimens:0]);
        
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-self.tabBarController.tabBar.bounds.size.height-CGRectGetMaxY(self.mToolbar.frame)-[Dimens GDimens:20]-[Dimens GDimens:ChannelBtnListHeight]));
    }];
    self.SVMixer1.backgroundColor=[UIColor clearColor];
    self.SVMixer1.tableFooterView=[UIView new];
}
- (void) initSVMixer{
    
//    self.SVMixer1.hidden=YES;
//    [self creatCollectionView];
     [self creatTableView];
    
    
    
    eqIndex = 0;
    self.SVMixer = [[UIScrollView alloc]init];
    self.SVMixer.hidden=YES;
    [self.view addSubview:self.SVMixer];
    [self.SVMixer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:70]);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, [Dimens GDimens:525]));
    }];
    self.SVMixer.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.SVMixer.delegate = self;
    // 设置内容大小
    //禁止UIScrollView垂直方向滚动，只允许水平方向滚动
    //scrollview.contentSize =  CGSizeMake(你要的长度, 0);
    //禁止UIScrollView水平方向滚动，只允许垂直方向滚动
    //scrollview.contentSize =  CGSizeMake(0, 你要的宽度);
    self.SVMixer.contentSize = CGSizeMake(0,[Dimens GDimens:MixerItemHeight]*(Mixer_CH_MAX));
    // 是否反弹
    self.SVMixer.bounces = YES;
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
    [self.SVMixer flashScrollIndicators];
    // 是否同时运动,lock
    self.SVMixer.directionalLockEnabled = NO;
    
    CGFloat sty=0;
    for(int i=0;i<Mixer_CH_MAX;i++){
        sty=[Dimens GDimens:MixerItemHeight]*i;
        
        MixerItem *item = [[MixerItem alloc]initWithFrame:CGRectMake(
            0,
            sty,//[Dimens GDimens:MixerItemHeight]*i,
            KScreenWidth,
            [Dimens GDimens:MixerItemHeight])
        ];
        
        [item setMixerItemTag:i];
        
        [self.SVMixer addSubview:item];
        
        if(i==0){
            _CurMixerItem=item;
        }
        
        
        [item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_IN%d",i+1]]];
        [item setDataMax:Mixer_Volume_MAX];
        [item setDataVal:[self getIN_VolByIndex:i]];
        [item addTarget:self action:@selector(MixerItemEvent:) forControlEvents:UIControlEventValueChanged];
//        if(i<8){
//            if((RecStructData.OUT_CH[output_channel_sel].lim_mode & (1<<input_channel_sel))==1){
//                [item setPolar:1];
//            }else{
//                [item setPolar:0];
//            }
//        }else{
//            if((RecStructData.OUT_CH[output_channel_sel].linkgroup_num & (1<<(input_channel_sel-8)))==1){
//                [item setPolar:1];
//            }else{
//                [item setPolar:0];
//            }
//        }
    }
    
}

- (void)MixerItemEvent:(MixerItem*)sender{
    if(self.mMixerItem != nil){
        [self.mMixerItem setMixerItemNormal];
    }
    
    input_channel_sel = (int) ((int)sender.tag - TagStart_MixerItem_self);
    _CurMixerItem = (MixerItem *)[self.view viewWithTag:input_channel_sel+TagStart_MixerItem_self];
    [_CurMixerItem setMixerItemPress];
    _mMixerItem = _CurMixerItem;
    
//    if(input_channel_sel == 8){
//        input_channel_sel = 10;
//    }
    
    int val = [_CurMixerItem getDataVal];
    [self setIN_VolByIndex:input_channel_sel withVal:val];
    
//    int polar = [_CurMixerItem getPolar];
//    if(input_channel_sel < 8){
//        if(polar == 1){
//            RecStructData.OUT_CH[output_channel_sel].lim_mode =
//            RecStructData.OUT_CH[output_channel_sel].lim_mode | (1<<input_channel_sel);
//        }else{
//            RecStructData.OUT_CH[output_channel_sel].lim_mode =
//            RecStructData.OUT_CH[output_channel_sel].lim_mode & (0<<input_channel_sel);
//        }
//    }else{
//        if(polar == 1){
//            RecStructData.OUT_CH[output_channel_sel].linkgroup_num =
//            RecStructData.OUT_CH[output_channel_sel].linkgroup_num | (1<<input_channel_sel);
//        }else{
//            RecStructData.OUT_CH[output_channel_sel].linkgroup_num =
//            RecStructData.OUT_CH[output_channel_sel].linkgroup_num & (0<<input_channel_sel);
//        }
//    }
}

- (void)checkMixerItemDisableWithInputsource:(int)index withItem:(MixerItem*)item{
    [item setMixerItemDisable:true];
    switch (RecStructData.System.input_source) {
        case 1://高电平
            if(index <=7){
                [item setMixerItemDisable:true];
            }else{
                [item setMixerItemDisable:false];
            }
            break;
        case 3://AUX
            if((index <= 11)&&(index >= 8)){
                [item setMixerItemDisable:true];
            }else{
                [item setMixerItemDisable:false];
            }
            break;

        case 0://数字
            if((index <= 13)&&(index >= 12)){
                [item setMixerItemDisable:true];
            }else{
                [item setMixerItemDisable:false];
            }
            break;
        case 2://蓝牙
//            if((index <= 13)&&(index >= 12)){
            if((index <= 15)&&(index >= 14)){
                [item setMixerItemDisable:true];
            }else{
                [item setMixerItemDisable:false];
            }
            break;
        case 4://同轴
            if(index == 9){
                [item setMixerItemDisable:true];
            }else{
                [item setMixerItemDisable:false];
            }
            break;
        default:
            break;
    }
    
//    if (RecStructData.System.input_source!=2) {
//    switch (RecStructData.System.Blue_src_vol) {
//        case 1://高电平
//            if(index <=7){
//                [item setMixerItemDisable:true];
//            }
//            break;
//        case 3://AUX
//            if((index <= 11)&&(index >= 8)){
//                [item setMixerItemDisable:true];
//            }
//            break;
//            
//        case 0://数字
//            if((index <= 13)&&(index >= 12)){
//                [item setMixerItemDisable:true];
//            }
//            break;
//        case 2://蓝牙
////            if((index <= 13)&&(index >= 12)){
//            if((index <= 15)&&(index >= 14)){
//                [item setMixerItemDisable:true];
//            }
//            break;
//            
//        default:
//            break;
//    }
//    }
}


- (int)getIN_VolByIndex:(int)index{
    switch (index) {
        case 0: return RecStructData.OUT_CH[output_channel_sel].IN1_Vol;
        case 1: return RecStructData.OUT_CH[output_channel_sel].IN2_Vol;
        case 2: return RecStructData.OUT_CH[output_channel_sel].IN3_Vol;
        case 3: return RecStructData.OUT_CH[output_channel_sel].IN4_Vol;
        case 4: return RecStructData.OUT_CH[output_channel_sel].IN5_Vol;
        case 5: return RecStructData.OUT_CH[output_channel_sel].IN6_Vol;
        case 6: return RecStructData.OUT_CH[output_channel_sel].IN7_Vol;
        case 7: return RecStructData.OUT_CH[output_channel_sel].IN8_Vol;
        case 8: return RecStructData.OUT_CH[output_channel_sel].IN9_Vol;
        case 9: return RecStructData.OUT_CH[output_channel_sel].IN10_Vol;
        case 10: return RecStructData.OUT_CH[output_channel_sel].IN11_Vol;
        case 11: return RecStructData.OUT_CH[output_channel_sel].IN12_Vol;
        case 12: return RecStructData.OUT_CH[output_channel_sel].IN13_Vol;
        case 13: return RecStructData.OUT_CH[output_channel_sel].IN14_Vol;
        case 14: return RecStructData.OUT_CH[output_channel_sel].IN15_Vol;
        case 15: return RecStructData.OUT_CH[output_channel_sel].IN16_Vol;
        default:
            return 100;
            break;
    }
}
- (void)setIN_VolByIndex:(int)index withVal:(int)val{
    switch (index) {
        case 0: RecStructData.OUT_CH[output_channel_sel].IN1_Vol=val;break;
        case 1: RecStructData.OUT_CH[output_channel_sel].IN2_Vol=val;break;
        case 2: RecStructData.OUT_CH[output_channel_sel].IN3_Vol=val;break;
        case 3: RecStructData.OUT_CH[output_channel_sel].IN4_Vol=val;break;
        case 4: RecStructData.OUT_CH[output_channel_sel].IN5_Vol=val;break;
        case 5: RecStructData.OUT_CH[output_channel_sel].IN6_Vol=val;break;
        case 6: RecStructData.OUT_CH[output_channel_sel].IN7_Vol=val;break;
        case 7: RecStructData.OUT_CH[output_channel_sel].IN8_Vol=val;break;
        case 8: RecStructData.OUT_CH[output_channel_sel].IN9_Vol=val;break;
        case 9: RecStructData.OUT_CH[output_channel_sel].IN10_Vol=val;break;
        case 10: RecStructData.OUT_CH[output_channel_sel].IN11_Vol=val;break;
        case 11: RecStructData.OUT_CH[output_channel_sel].IN12_Vol=val;break;
        case 12: RecStructData.OUT_CH[output_channel_sel].IN13_Vol=val;break;
        case 13: RecStructData.OUT_CH[output_channel_sel].IN14_Vol=val;break;
        case 14: RecStructData.OUT_CH[output_channel_sel].IN15_Vol=val;break;
        case 15: RecStructData.OUT_CH[output_channel_sel].IN16_Vol=val;break;
        default:
            break;
    }
}

- (int)getDataBufIN_VolByIndex:(int)index{
    switch (index) {
        case 0: return BufStructData.OUT_CH[output_channel_sel].IN1_Vol;
        case 1: return BufStructData.OUT_CH[output_channel_sel].IN2_Vol;
        case 2: return BufStructData.OUT_CH[output_channel_sel].IN3_Vol;
        case 3: return BufStructData.OUT_CH[output_channel_sel].IN4_Vol;
        case 4: return BufStructData.OUT_CH[output_channel_sel].IN5_Vol;
        case 5: return BufStructData.OUT_CH[output_channel_sel].IN6_Vol;
        case 6: return BufStructData.OUT_CH[output_channel_sel].IN7_Vol;
        case 7: return BufStructData.OUT_CH[output_channel_sel].IN8_Vol;
        case 8: return BufStructData.OUT_CH[output_channel_sel].IN9_Vol;
        case 9: return BufStructData.OUT_CH[output_channel_sel].IN10_Vol;
        case 10: return BufStructData.OUT_CH[output_channel_sel].IN11_Vol;
        case 11: return BufStructData.OUT_CH[output_channel_sel].IN12_Vol;
        case 12: return BufStructData.OUT_CH[output_channel_sel].IN13_Vol;
        case 13: return BufStructData.OUT_CH[output_channel_sel].IN14_Vol;
        case 14: return BufStructData.OUT_CH[output_channel_sel].IN15_Vol;
        case 15: return BufStructData.OUT_CH[output_channel_sel].IN16_Vol;
        default:
            return 100;
            break;
    }
}
- (void)setDataBufIN_VolByIndex:(int)index withVal:(int)val{
    switch (index) {
        case 0: BufStructData.OUT_CH[output_channel_sel].IN1_Vol=val;break;
        case 1: BufStructData.OUT_CH[output_channel_sel].IN2_Vol=val;break;
        case 2: BufStructData.OUT_CH[output_channel_sel].IN3_Vol=val;break;
        case 3: BufStructData.OUT_CH[output_channel_sel].IN4_Vol=val;break;
        case 4: BufStructData.OUT_CH[output_channel_sel].IN5_Vol=val;break;
        case 5: BufStructData.OUT_CH[output_channel_sel].IN6_Vol=val;break;
        case 6: BufStructData.OUT_CH[output_channel_sel].IN7_Vol=val;break;
        case 7: BufStructData.OUT_CH[output_channel_sel].IN8_Vol=val;break;
        case 8: BufStructData.OUT_CH[output_channel_sel].IN9_Vol=val;break;
        case 9: BufStructData.OUT_CH[output_channel_sel].IN10_Vol=val;break;
        case 10: BufStructData.OUT_CH[output_channel_sel].IN11_Vol=val;break;
        case 11: BufStructData.OUT_CH[output_channel_sel].IN12_Vol=val;break;
        case 12: BufStructData.OUT_CH[output_channel_sel].IN13_Vol=val;break;
        case 13: BufStructData.OUT_CH[output_channel_sel].IN14_Vol=val;break;
        case 14: BufStructData.OUT_CH[output_channel_sel].IN15_Vol=val;break;
        case 15: BufStructData.OUT_CH[output_channel_sel].IN16_Vol=val;break;
        default:
            break;
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

#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        //    [self.channelBtn setChannelSelected:output_channel_sel];
        //    [self.mChannel setChannel:output_channel_sel];
//        [self.channelBar setChannel:output_channel_sel];
        //        [self.selectorHorizontal selectRowAtIndex:output_channel_sel];
        [self FlashPageUI_];
    });
}
- (void)FlashPageUI_{


    [self.channelColletionView MyChannelReload];
    
    MixerItem *item;
    for(int i=0;i<Mixer_CH_MAX;i++){
        
        item = (MixerItem *)[self.view viewWithTag:i+TagStart_MixerItem_self];
        [item setDataVal:[self getIN_VolByIndex:i]];
        [self checkMixerItemDisableWithInputsource:i withItem:item];
        if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
            [item setDataVal:0];
        }
        
//        if(i<8){
//            if((RecStructData.OUT_CH[output_channel_sel].lim_mode & (1<<i))==1){
//                [item setPolar:1];
//            }else{
//                [item setPolar:0];
//            }
//        }else{
//            if((RecStructData.OUT_CH[output_channel_sel].linkgroup_num & (1<<(i-8)))==1){
//                [item setPolar:1];
//            }else{
//                [item setPolar:0];
//            }
//        }
    }
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        self.Encrypt.hidden = false;
    }else{
        self.Encrypt.hidden = true;
    }
    [self.SVMixer1 reloadData];
//    [self.mixerCollectionView reloadData];
    
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
        
    });
}
#pragma mark ------------------TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Dimens GDimens:MixerItemHeight];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(RecStructData.System.input_source == 1){
//        return 8;
//    }else if(RecStructData.System.input_source == 2){
//        return 4;
//    }else {
//        return 2;
//    }
    return Mixer_CH_MAX;//
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    MixerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[MixerTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    int row = (int)indexPath.row;
    int srow = 0;
    int vals = 0;
    //HI:0-7(6.7不用)，AUX:8-11,Dig:12-13,BLE:14-15
    //0-5,6-9,10-11,12-13
    
    [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_IN%d",(row+1)]]];
    srow = (int)indexPath.row;
    vals = [self getIN_VolByIndex:srow];
    [cell.item setDataVal:vals];
//    if(row<=7){
//        [cell.item setLab_MixerInput:[NSString stringWithFormat:@"%@%d",[LANG DPLocalizedString:@"L_TabBar_Input"],(int)(indexPath.row+1)]];
//        srow = (int)indexPath.row;
//        vals = [self getIN_VolByIndex:srow];
//        [cell.item setDataVal:vals];
//    }
//    }else if (row>=8&&row<=11){
//        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_AUX_%d",row-7]]];
//        srow = (int)indexPath.row;
//        vals = [self getIN_VolByIndex:srow];
//        [cell.item setDataVal:vals];
//
//    }
//    else if(row>=12&&row<=13){//数字
//        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_DI_%d",row-11]]];
//        srow=(int)indexPath.row;
//        vals=[self getIN_VolByIndex:srow];
//        [cell.item setDataVal:vals];
//    }
//    else if (row>=14&&row<=15){//蓝牙
//        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_BLUE_%d",row-13]]];
//        srow = (int)indexPath.row;
//        vals = [self getIN_VolByIndex:srow];
//
//        [cell.item setDataVal:vals];
//
//    }
    [self checkMixerItemDisableWithInputsource:(int)indexPath.row withItem:cell.item];

    __block MixerTableViewCell *blockCell=cell;
    cell.MixerBlock = ^(MixerItem *curitem) {
        if (!blockCell.selected) {
            [self.SVMixer1 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        //移除了数字，所以蓝牙位置改变
        
        input_channel_sel = (int)indexPath.row;
        int val = [curitem getDataVal];
//        switch (RecStructData.System.input_source) {
//            case 3://AUX
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            case 1://HI
//
//                 [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//
//            case 2://Bluetooth
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            case 0:
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            default:
//                break;
//        }
        
        [self setIN_VolByIndex:input_channel_sel withVal:val];
    };
    return cell;
}

#pragma mark -------collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 14;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cellid";
    MixCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    int row = (int)indexPath.row;
    int srow = 0;
    int vals = 0;
    //HI:0-7(6.7不用)，AUX:8-11,Dig:12-13,BLE:14-15
    //0-5,6-9,10-11,12-13
    if(row<=5){
        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_HI_%d",row+1]]];
        srow = (int)indexPath.row;
        vals = [self getIN_VolByIndex:srow];
        [cell.item setDataVal:vals];
    }else if (row>=6&&row<=9){
        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_AUX_%d",row-5]]];
        srow = (int)indexPath.row+2;
        vals = [self getIN_VolByIndex:srow];
        [cell.item setDataVal:vals];
        
    }
    else if(row>=10&&row<=11){//数字
        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_DI_%d",row-9]]];
        srow=(int)indexPath.row+2;
        vals=[self getIN_VolByIndex:srow];
        [cell.item setDataVal:vals];
    }
    else if (row>=12&&row<=13){//蓝牙
        [cell.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_BLUE_%d",row-11]]];
        srow = (int)indexPath.row+2;
        vals = [self getIN_VolByIndex:srow];
        
        [cell.item setDataVal:vals];
        
    }
//    [self checkMixerItemDisableWithInputsource:(int)indexPath.row withItem:cell.item];
    
    __block MixCollectionViewCell *blockCell=cell;
    cell.MixerBlock = ^(MixerItem *curitem) {
        if (!blockCell.selected) {
            [self.mixerCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition: UICollectionViewScrollPositionNone];
//            [self.mixerCollectionView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        //移除了数字，所以蓝牙位置改变
        if (indexPath.row<=5) {
              input_channel_sel = (int)indexPath.row;
        }else{
            input_channel_sel=(int)indexPath.row+2;
        }
      
        int val = [curitem getDataVal];
         [self setIN_VolByIndex:input_channel_sel withVal:val];
//        switch (RecStructData.System.input_source) {
//            case 3://AUX
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            case 1://HI
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//
//            case 2://Bluetooth
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            case 0:
//
//                [self setIN_VolByIndex:input_channel_sel withVal:val];
//                break;
//            default:
//                break;
//        }
//
//
    };
    return cell;
}
//每个小控件的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-(3*[Dimens GDimens:itemMargin]))/2, [Dimens GDimens:90]);
}
//控件与控件之间的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, [Dimens GDimens:20], 0, [Dimens GDimens:20]);
}


@end

//
//  DelayViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "DelayViewController.h"
#import "Define_Dimens.h"
#import "Define_Color.h"
@interface DelayViewController()

@property (nonatomic,strong)NSArray *SpkBtnArray;
@property (nonatomic,strong)NSArray *normalImageArray;
@property (nonatomic,strong)NSMutableArray *pressImageArray;

@end

@implementation DelayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Delay;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_Delay"];
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    
    
    
    
    
    
//    self.view.backgroundColor = [UIColor clearColor];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"delaysettings_bg"]]];
    [self initView];
    [self initDelayUnitView];
    [self initEncrypt];
    [self FlashPageUI];
    
}
-(NSArray *)SpkBtnArray{
    if (!_SpkBtnArray) {
        _SpkBtnArray=@[self.BtnSpk0,self.BtnSpk1,self.BtnSpk2,self.BtnSpk3,self.BtnSpk4,self.BtnSpk5,self.BtnSpk6,self.BtnSpk7,self.BtnSpk8,self.BtnSpk9,self.BtnSpk10,self.BtnSpk11,self.BtnSpk12,self.BtnSpk13,self.BtnSpk14,self.BtnSpk15,self.BtnSpk16,self.BtnSpk17,self.BtnSpk18,self.BtnSpk19,self.BtnSpk20];
    }
    return _SpkBtnArray;
}
-(NSArray *)normalImageArray{
    if (!_normalImageArray) {
        _normalImageArray=@[@"speaker_high_left_normal",@"speaker_left_normal",@"speaker_left_normal",@"speaker_high_right_normal",@"speaker_right_normal",@"speaker_right_normal",@"speaker_high_left_normal",@"speaker_left_normal",@"speaker_high_right_normal",@"speaker_right_normal",@"speaker_high_center_normal",@"speaker_center_normal",@"speaker_low_normal",@"speaker_low_normal",@"speaker_low_normal",@"speaker_low_d_normal",@"speaker_low_normal",@"speaker_center_normal",@"speaker_center_normal",@"speaker_left_normal",@"speaker_right_normal"];
    }
    return _normalImageArray;
}
-(NSMutableArray *)pressImageArray{
    if (!_pressImageArray) {
        _pressImageArray=[[NSMutableArray alloc]init];
        for (NSString *norstr in self.normalImageArray) {
            if (norstr.length>6) {
                NSMutableString *prestr=[NSMutableString stringWithFormat:@"%@",norstr];
                [prestr replaceCharactersInRange:NSMakeRange(norstr.length-6, 6) withString:@"press"];
                
                [_pressImageArray addObject:prestr];
            }
        }
    }
    return _pressImageArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma initView

- (void)initView{
    
    self.BtnLinkA=[[NormalButton alloc]init];
//    [self.view addSubview:self.BtnLinkA];
    [self.BtnLinkA initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_DelayBtn_NormalIN
                   withPressColor:UI_DelayBtn_PressIN
            withBorderNormalColor:UI_EQSet_Btn_Normal
             withBorderPressColor:UI_EQSet_Btn_Press
              withTextNormalColor:UI_EQSet_BtnText_Normal
               withTextPressColor:UI_EQSet_BtnText_Press
                         withType:5];
    self.BtnLinkA.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.BtnLinkA setTitle:[LANG DPLocalizedString:@"L_DelayLink_LR"] forState:UIControlStateNormal];
   [self.BtnLinkA addTarget:self action:@selector(BtnLinkA_CLick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.BtnLinkA mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-[Dimens GDimens:20]);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:30]));
//    }];
    if (LinkMode==2) {
        [self.BtnLinkA setPress];
    }else{
        [self.BtnLinkA setNormal];
    }
     
    [self initViewTag];
    [self FlashDelaySpk];
}
- (void)BtnLinkA_CLick:(NormalButton*)sender{
    if(LinkMode == 0){
        LinkMode = 2;
        [self.BtnLinkA setPress];
        [self CheckChannelCanLink];
    }else{
        LinkMode = 0;
        [self.BtnLinkA setNormal];
    }
}
- (void)initViewTag{
    [self.V_Delay0 setTag:TagStart_DelayView+0];
    [self.V_Delay1 setTag:TagStart_DelayView+1];
    [self.V_Delay2 setTag:TagStart_DelayView+2];
    [self.V_Delay3 setTag:TagStart_DelayView+3];
    [self.V_Delay4 setTag:TagStart_DelayView+4];
    [self.V_Delay5 setTag:TagStart_DelayView+5];
    [self.V_Delay6 setTag:TagStart_DelayView+6];
    [self.V_Delay7 setTag:TagStart_DelayView+7];
    [self.V_Delay8 setTag:TagStart_DelayView+8];
    [self.V_Delay9 setTag:TagStart_DelayView+9];
    [self.V_Delay10 setTag:TagStart_DelayView+10];
    [self.V_Delay11 setTag:TagStart_DelayView+11];
    [self.V_Delay12 setTag:TagStart_DelayView+12];
    [self.V_Delay13 setTag:TagStart_DelayView+13];
    [self.V_Delay14 setTag:TagStart_DelayView+14];
    [self.V_Delay15 setTag:TagStart_DelayView+15];
    [self.V_Delay16 setTag:TagStart_DelayView+16];
    [self.V_Delay17 setTag:TagStart_DelayView+17];
    [self.V_Delay18 setTag:TagStart_DelayView+18];
    [self.V_Delay19 setTag:TagStart_DelayView+19];
    [self.V_Delay20 setTag:TagStart_DelayView+20];
    
    [self.BtnVal0 setTag:TagStart_DelayBtnVal+0];
    [self.BtnVal1 setTag:TagStart_DelayBtnVal+1];
    [self.BtnVal2 setTag:TagStart_DelayBtnVal+2];
    [self.BtnVal3 setTag:TagStart_DelayBtnVal+3];
    [self.BtnVal4 setTag:TagStart_DelayBtnVal+4];
    [self.BtnVal5 setTag:TagStart_DelayBtnVal+5];
    [self.BtnVal6 setTag:TagStart_DelayBtnVal+6];
    [self.BtnVal7 setTag:TagStart_DelayBtnVal+7];
    [self.BtnVal8 setTag:TagStart_DelayBtnVal+8];
    [self.BtnVal9 setTag:TagStart_DelayBtnVal+9];
    [self.BtnVal10 setTag:TagStart_DelayBtnVal+10];
    [self.BtnVal11 setTag:TagStart_DelayBtnVal+11];
    [self.BtnVal12 setTag:TagStart_DelayBtnVal+12];
    [self.BtnVal13 setTag:TagStart_DelayBtnVal+13];
    [self.BtnVal14 setTag:TagStart_DelayBtnVal+14];
    [self.BtnVal15 setTag:TagStart_DelayBtnVal+15];
    [self.BtnVal16 setTag:TagStart_DelayBtnVal+16];
    [self.BtnVal17 setTag:TagStart_DelayBtnVal+17];
    [self.BtnVal18 setTag:TagStart_DelayBtnVal+18];
    [self.BtnVal19 setTag:TagStart_DelayBtnVal+19];
    [self.BtnVal20 setTag:TagStart_DelayBtnVal+20];
    
    [self.BtnSpk0 setTag:TagStart_DelaySpk+0];
    [self.BtnSpk1 setTag:TagStart_DelaySpk+1];
    [self.BtnSpk2 setTag:TagStart_DelaySpk+2];
    [self.BtnSpk3 setTag:TagStart_DelaySpk+3];
    [self.BtnSpk4 setTag:TagStart_DelaySpk+4];
    [self.BtnSpk5 setTag:TagStart_DelaySpk+5];
    [self.BtnSpk6 setTag:TagStart_DelaySpk+6];
    [self.BtnSpk7 setTag:TagStart_DelaySpk+7];
    [self.BtnSpk8 setTag:TagStart_DelaySpk+8];
    [self.BtnSpk9 setTag:TagStart_DelaySpk+9];
    [self.BtnSpk10 setTag:TagStart_DelaySpk+10];
    [self.BtnSpk11 setTag:TagStart_DelaySpk+11];
    [self.BtnSpk12 setTag:TagStart_DelaySpk+12];
    [self.BtnSpk13 setTag:TagStart_DelaySpk+13];
    [self.BtnSpk14 setTag:TagStart_DelaySpk+14];
    [self.BtnSpk15 setTag:TagStart_DelaySpk+15];
    [self.BtnSpk16 setTag:TagStart_DelaySpk+16];
    [self.BtnSpk17 setTag:TagStart_DelaySpk+17];
    [self.BtnSpk18 setTag:TagStart_DelaySpk+18];
    [self.BtnSpk19 setTag:TagStart_DelaySpk+19];
    [self.BtnSpk20 setTag:TagStart_DelaySpk+20];
   
    
    [self.BtnVal0 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal1 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal2 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal3 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal4 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal5 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal6 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal7 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal8 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal9 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal10 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal11 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal12 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal13 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal14 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal15 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal16 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal17 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal18 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal19 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnVal20 addTarget:self action:@selector(DelayVolume_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnSpk0 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk1 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk2 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk3 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk4 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk5 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk6 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk7 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk8 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk9 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk10 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk11 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk12 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk13 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk14 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk15 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk16 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk17 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk18 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk19 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSpk20 addTarget:self action:@selector(DelaySpk_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnVal0 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal1 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal2 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal3 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal4 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal5 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal6 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal7 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal8 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal9 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal10 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal11 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal12 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal13 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal14 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal15 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal16 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal17 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal18 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal19 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
    [self.BtnVal20 setTitleColor:SetColor(UI_DelayVolColor) forState:UIControlStateNormal];
}

- (void)DelayVolume_Click:(UIButton*)sender{
    spkNum = (int)sender.tag-TagStart_DelayBtnVal;
    [self initDialogDelay];
}
- (void)DelaySpk_Click:(UIButton*)sender{
    spkNum = (int)sender.tag-TagStart_DelaySpk;
    [self initDialogDelay];
}

- (void)initDialogDelay{
    
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        
        if([self GetDelayId:ChannelNumBuf[i]] == spkNum){
             int seletID=[self GetDelayId:ChannelNumBuf[output_channel_sel]];
            if (!(seletID<self.SpkBtnArray.count)) {
                continue;
            }
            UIButton *seleBtn=[self.SpkBtnArray objectAtIndex:seletID];
            [seleBtn setBackgroundImage:[UIImage imageNamed:self.normalImageArray[seletID]] forState:UIControlStateNormal];
            
            output_channel_sel = i;
            
            seletID=[self GetDelayId:ChannelNumBuf[output_channel_sel]];
            if (!(seletID<self.SpkBtnArray.count)) {
                continue;
            }
            seleBtn=[self.SpkBtnArray objectAtIndex:seletID];
            [seleBtn setBackgroundImage:[UIImage imageNamed:self.pressImageArray[seletID]] forState:UIControlStateNormal];
            
        }
        
    }
    
    [self showDelayDialog];
}
- (void)initDelayUnitView{
    delayUnit = 2;
    
    [self.Btn_CM setTag:1];
    [self.Btn_MS setTag:2];
    [self.Btn_INCH setTag:3];
    
    [self.Btn_CM addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MS addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_INCH addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_CM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    [self.Btn_MS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    [self.Btn_INCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    self.Btn_CM.layer.cornerRadius=25;
    self.Btn_CM.layer.masksToBounds=YES;
    self.Btn_MS.layer.cornerRadius=25;
    self.Btn_MS.layer.masksToBounds=YES;
    self.Btn_INCH.layer.cornerRadius=25;
    self.Btn_INCH.layer.masksToBounds=YES;
    
    self.Btn_CM.hidden = true;
    self.Btn_MS.hidden = true;
    self.Btn_INCH.hidden = true;
    self.IV_UnitDelaySwitch.hidden = true;
    
    //[self flashDelayUnitSel];
    
  
    
    self.BtnMS = [[NormalButton alloc]init];
    self.BtnMS.tag = 2;
    [self.view addSubview:self.BtnMS];
    [self.BtnMS initViewBroder:0
               withBorderWidth:0
               withNormalColor:UI_DelayBtn_NormalIN
                withPressColor:UI_DelayBtn_PressIN
         withBorderNormalColor:UI_DelayBtn_Normal
          withBorderPressColor:UI_DelayBtn_Press
           withTextNormalColor:UI_DelayBtnText_Normal
            withTextPressColor:UI_DelayBtnText_Press
                      withType:5];
    [self.BtnMS addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnMS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal] ;
    self.BtnMS.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnMS.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnMS mas_makeConstraints:^(MASConstraintMaker *make) {
        if(KScreenHeight==812){
            make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:140]);
        }else{
            make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:110]);
        }
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    
    self.BtnCM = [[NormalButton alloc]init];
    self.BtnCM.tag = 1;
    [self.view addSubview:self.BtnCM];
    [self.BtnCM initViewBroder:0
               withBorderWidth:0
               withNormalColor:UI_DelayBtn_NormalIN
                withPressColor:UI_DelayBtn_PressIN
         withBorderNormalColor:UI_DelayBtn_Normal
          withBorderPressColor:UI_DelayBtn_Press
           withTextNormalColor:UI_DelayBtnText_Normal
            withTextPressColor:UI_DelayBtnText_Press
                      withType:5];
    [self.BtnCM addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnCM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal] ;
    self.BtnCM.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnCM.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnCM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.BtnMS);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:25]);
        
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    
    self.BtnINCH = [[NormalButton alloc]init];
    self.BtnINCH.tag = 3;
    [self.view addSubview:self.BtnINCH];
    [self.BtnINCH initViewBroder:0
               withBorderWidth:0
               withNormalColor:UI_DelayBtn_NormalIN
                withPressColor:UI_DelayBtn_PressIN
         withBorderNormalColor:UI_DelayBtn_Normal
          withBorderPressColor:UI_DelayBtn_Press
           withTextNormalColor:UI_DelayBtnText_Normal
            withTextPressColor:UI_DelayBtnText_Press
                      withType:5];
    [self.BtnINCH addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnINCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal] ;
    self.BtnINCH.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnINCH.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnINCH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.BtnCM.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-25]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    
    
    [self flashDelayUnitSel_T];
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

#pragma 延時
- (void)delayUnitSel:(UIButton*)sender{
    delayUnit = (int)sender.tag;
    //[self flashDelayUnitSel];
    [self flashDelayUnitSel_T];
    
}


- (void)flashDelayUnitSel{
    
    [self.Btn_CM setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_MS setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_INCH setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    
    switch (delayUnit) {
        case 1:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed:@"delay_unit_cm"]];
            [self.Btn_CM setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        case 2:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed:@"delay_unit_ms"]];
            [self.Btn_MS setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        case 3:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed:@"delay_unit_inch"]];
            [self.Btn_INCH setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self FlashDelayVolume];
}

- (void)flashDelayUnitSel_T{
    
    [self.BtnCM setNormal];
    [self.BtnMS setNormal];
    [self.BtnINCH setNormal];
    
    switch (delayUnit) {
        case 1:
            [self.BtnCM setPress];
            break;
        case 2:
            [self.BtnMS setPress];
            break;
        case 3:
            [self.BtnINCH setPress];
            break;
        default:
            break;
    }
    [self FlashDelayVolume];
}

-(void)setUIViewBackgound:(UIView *)uiview name:(NSString *)name {
    
    UIGraphicsBeginImageContext(uiview.frame.size);
    [[UIImage imageNamed:name] drawInRect:uiview.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    uiview.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

#pragma 功能函数

- (void)hideAllDelayItem{
    self.V_Delay0.hidden = true;
    self.V_Delay1.hidden = true;
    self.V_Delay2.hidden = true;
    self.V_Delay3.hidden = true;
    self.V_Delay4.hidden = true;
    self.V_Delay5.hidden = true;
    self.V_Delay6.hidden = true;
    self.V_Delay7.hidden = true;
    self.V_Delay8.hidden = true;
    self.V_Delay9.hidden = true;
    self.V_Delay10.hidden = true;
    self.V_Delay11.hidden = true;
    self.V_Delay12.hidden = true;
    self.V_Delay13.hidden = true;
    self.V_Delay14.hidden = true;
    
    self.V_Delay15.hidden = true;
    self.V_Delay16.hidden = true;
    self.V_Delay17.hidden = true;
    self.V_Delay18.hidden = true;
    self.V_Delay19.hidden = true;
    self.V_Delay20.hidden = true;
}


- (void)FlashDelaySpk{
    [self  hideAllDelayItem];
    
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if(ChannelNumBuf[i]!=0){
            [self showDelayItemByIndex:[self GetDelayId:ChannelNumBuf[i]]];
        }
         int seletID=[self GetDelayId:ChannelNumBuf[i]];
        if (!(seletID<self.SpkBtnArray.count)) {
            continue;
        }

         UIButton *seleBtn=[self.SpkBtnArray objectAtIndex:seletID];
        if (i==output_channel_sel) {
            [seleBtn setBackgroundImage:[UIImage imageNamed:self.pressImageArray[seletID]] forState:UIControlStateNormal];
        }else{
           [seleBtn setBackgroundImage:[UIImage imageNamed:self.normalImageArray[seletID]] forState:UIControlStateNormal];
        }
    }
}

- (void)FlashDelayVolume{
    
    for (int i=0; i<16; i++) {
        ChannelNumBuf[i]=RecStructData.System.out_spk_type[i];
    }

    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if(ChannelNumBuf[i]!=0){
            [self setDelayValByIndex:[self GetDelayId:ChannelNumBuf[i]] wihtChannel:i];
        }
    }
    
}



- (void)setDelayValByIndex:(int)index wihtChannel:(int)ch{
    switch (index) {
        case 0: [self.BtnVal0 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 1: [self.BtnVal1 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 2: [self.BtnVal2 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 3: [self.BtnVal3 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 4: [self.BtnVal4 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 5: [self.BtnVal5 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 6: [self.BtnVal6 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 7: [self.BtnVal7 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 8: [self.BtnVal8 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 9: [self.BtnVal9 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 10: [self.BtnVal10 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
            
        case 11: [self.BtnVal11 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 12: [self.BtnVal12 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 13: [self.BtnVal13 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 14: [self.BtnVal14 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
            
        case 15: [self.BtnVal15 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 16: [self.BtnVal16 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 17: [self.BtnVal17 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 18: [self.BtnVal18 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
            
        case 19: [self.BtnVal19 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
        case 20: [self.BtnVal20 setTitle:[self getDelayVal:ch] forState:UIControlStateNormal]; break;
            
        default:
            break;
    }
}
- (NSString*)getDelayVal:(int)ch{
    
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        switch(delayUnit){
            case 1: return [self CountDelayCM:0]; break;
            case 2: return [self CountDelayMs:0]; break;
            case 3: return [self CountDelayInch:0]; break;
            default:return [self CountDelayMs:0];
        }
    }else{
        switch(delayUnit){
            case 1: return [self CountDelayCM:RecStructData.OUT_CH[ch].delay]; break;
            case 2: return [self CountDelayMs:RecStructData.OUT_CH[ch].delay]; break;
            case 3: return [self CountDelayInch:RecStructData.OUT_CH[ch].delay]; break;
            default:return [self CountDelayMs:RecStructData.OUT_CH[ch].delay];
        }
    }
}

/******* 延时时间转换  *******/
- (NSString*) CountDelayCM:(int)num{
    int m_nTemp=75;
    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+331.0)/1000.0*Time);
    LMT = LMT*100;
    
    int fr=(int) (LMT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    
    return [NSString stringWithFormat:@"%d",(int)ri];
}
- (NSString*) CountDelayMs:(int)num{
    int fr = num*10000/48;
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%.3f",(float)ri/1000];}

- (NSString*) CountDelayInch:(int)num{
    float base=(float) 331.0;
    if(num == DELAY_SETTINGS_MAX){
        base=(float) 331.4;
    }
    int m_nTemp=75;
    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+base)/1000.0*Time);
    
    float LFT = (float) (LMT*3.2808*12.0);
    
    int fr=(int) (LFT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%d",(int)ri];
}

- (void)showDelayItemByIndex:(int)index{
    switch (index) {
        case 0: self.V_Delay0.hidden = false; break;
        case 1: self.V_Delay1.hidden = false; break;
        case 2: self.V_Delay2.hidden = false; break;
        case 3: self.V_Delay3.hidden = false; break;
        case 4: self.V_Delay4.hidden = false; break;
        case 5: self.V_Delay5.hidden = false; break;
        case 6: self.V_Delay6.hidden = false; break;
        case 7: self.V_Delay7.hidden = false; break;
        case 8: self.V_Delay8.hidden = false; break;
        case 9: self.V_Delay9.hidden = false; break;
        case 10: self.V_Delay10.hidden = false; break;
        case 11: self.V_Delay11.hidden = false; break;
        case 12: self.V_Delay12.hidden = false; break;
        case 13: self.V_Delay13.hidden = false; break;
        case 14: self.V_Delay14.hidden = false; break;
        case 15: self.V_Delay15.hidden = false; break;
        case 16: self.V_Delay16.hidden = false; break;
        case 17: self.V_Delay17.hidden = false; break;
        case 18: self.V_Delay18.hidden = false; break;
        case 19: self.V_Delay19.hidden = false; break;
        case 20: self.V_Delay20.hidden = false; break;
        default:
            break;
    }
}
//得到通道类型所属控件id
- (int)GetDelayId:(int)channelNameId{
    int id=0;
    switch (channelNameId) {
        case 1:
            id=0;
            break;
        case 2:
        case 4:
        case 5:
        case 6:
            id=1;
            break;
        case 3:
            id=2;
            break;
        case 7:
            id=3;
            break;
        case 8:
        case 10:
        case 11:
        case 12:
            id=4;
            break;
        case 9:
            id=5;
            break;
        case 13:
            id=6;
            break;
        case 14:
        case 15:
            id=7;
            break;
        case 16:
            id=8;
            break;
        case 17:
        case 18:
            id=9;
            break;
        case 19:
            id=10;
            break;
        case 20:
        case 21:
            id=11;
            break;
        case 22:
            id=12;    
            break;    
        case 23:
            id=13;
            break;    
        case 24:
            id=14;
            break;
            
        case 25:
            id=15;
            break;
        case 26:
            id=16;
            break;
        case 27:
            id=17;
            break;
        case 28:
            id=18;
            break;
            ///--------------    
//        case 2:
//            id=19;
//            break;
//        case 8:
//            id=20;
//            break;
            
        default:
            id=21;
            break;
    }    
    return id;
}

#pragma 弹出选择 

-(void)showDelayDialog{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
    
    UILabel *labelCH = [[UILabel alloc] init];
    labelCH.textColor = [UIColor whiteColor];
    labelCH.frame = CGRectMake(0, 0, 50, 30);
    labelCH.text = [NSString stringWithFormat:@"CH%d",output_channel_sel+1];
    labelCH.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelCH];
    
    
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
    _btnMinus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnMinus addTarget:self action:@selector(DialogFreqSet_Sub) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_btnMinus];
    
    
    CGRect sliderRect = CGRectInset(contentView.bounds, 366, 19);
    sliderRect.origin.y = 20;
    sliderRect.size.height = 20;
    _sliderFreq = [[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(10, 63, 260, 20)];
    //    __weak __typeof(self) weakSelf = self;
    //    _sliderFreq.dataSource = weakSelf;
    _sliderFreq.minimumValue = 0;
    _sliderFreq.maximumValue = DELAY_SETTINGS_MAX;
    
    _sliderFreq.showValue = [self getDelayVal:output_channel_sel];
    [_sliderFreq setValue:RecStructData.OUT_CH[output_channel_sel].delay];
    
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
    
    
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnAdd.frame = CGRectMake(240, 100, 30, 30);
    //    [btnAdd setBackgroundImage:[UIImage imageNamed:@"channel_pol_add.png"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    //[_btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [_btnAdd setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    _btnAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAdd addTarget:self action:@selector(DialogFreqSet_Inc) forControlEvents:UIControlEventTouchUpInside];
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
- (void)flashLinkSyncData_Delay:(int)val{
    if(BOOL_SET_SpkType){
        if((!(LinkMode==2))||(ChannelLinkCnt==0)){
            return;
        }
        int Dfrom=output_channel_sel;
        int Dto=0xff;
        Dfrom = output_channel_sel;
        for(int i=0;i<ChannelLinkCnt;i++){
            if(ChannelLinkBuf[i][0]==output_channel_sel){
                Dto=ChannelLinkBuf[i][1];
            }else if(ChannelLinkBuf[i][1]==output_channel_sel){
                Dto=ChannelLinkBuf[i][0];
            }
        }
        if(Dto < Output_CH_MAX){
            int newVal=RecStructData.OUT_CH[Dto].delay+val;
            if (newVal>DELAY_SETTINGS_MAX) {
                RecStructData.OUT_CH[Dto].delay=DELAY_SETTINGS_MAX;
            }else if (newVal<0){
                RecStructData.OUT_CH[Dto].delay=0;
            }else{
                RecStructData.OUT_CH[Dto].delay=newVal;
            }
            [self FlashDelayVolume];
        }
    }
}
- (void)SBDialogFreqSet{
    int sliderValue = (int)(_sliderFreq.value);
    int val =sliderValue-RecStructData.OUT_CH[output_channel_sel].delay;
    RecStructData.OUT_CH[output_channel_sel].delay = sliderValue;
    //赋值
    [self setDelayValByIndex:[self GetDelayId:ChannelNumBuf[output_channel_sel]] wihtChannel:output_channel_sel];
    _sliderFreq.showValue = [self getDelayVal:output_channel_sel];
    [self flashLinkSyncData_Delay:val];
}

- (void)DialogFreqSet_Sub{
    
    if(--RecStructData.OUT_CH[output_channel_sel].delay < 0){
        RecStructData.OUT_CH[output_channel_sel].delay = 0;
    }else{
        [self flashLinkSyncData_Delay:-1];
    }
    [self setDelayValByIndex:[self GetDelayId:ChannelNumBuf[output_channel_sel]] wihtChannel:output_channel_sel];
    _sliderFreq.showValue = [self getDelayVal:output_channel_sel];
    
    
}
- (void)DialogFreqSet_Inc{
    if(++RecStructData.OUT_CH[output_channel_sel].delay > DELAY_SETTINGS_MAX){
        RecStructData.OUT_CH[output_channel_sel].delay = DELAY_SETTINGS_MAX;
    }else{
         [self flashLinkSyncData_Delay:1];
    }
    [self setDelayValByIndex:[self GetDelayId:ChannelNumBuf[output_channel_sel]] wihtChannel:output_channel_sel];
    _sliderFreq.showValue = [self getDelayVal:output_channel_sel];
}
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(DialogFreqSet_Sub) userInfo:nil repeats:YES];
        
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
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(DialogFreqSet_Inc) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}



#pragma 广播通知
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (LinkMode==2) {
            [self CheckChannelCanLink];
        }
        [self FlashDelaySpk];
        [self FlashDelayVolume];
        
        if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
            self.Encrypt.hidden = false;
        }else{
            self.Encrypt.hidden = true;
        }
    });
    
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
    });
}
@end


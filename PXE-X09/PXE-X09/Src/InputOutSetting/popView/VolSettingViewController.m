//
//  VolSettingViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/10.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "VolSettingViewController.h"

@interface VolSettingViewController ()
{
    //主音量计数定时器 减
    NSTimer *_pMainVolMinusTimer;
    NSTimer *_pMainVolAddTimer;
}
@end

@implementation VolSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle=UIModalTransitionStyleCrossDissolve;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:500])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:500]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:500])];
    [bgImageView setImage:[UIImage imageNamed:@"volView_bg"]];
    [bgView addSubview:bgImageView];
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
    }];
    self.chTopLabel=[[UILabel alloc]init];
    self.chTopLabel.text=[NSString stringWithFormat:@"输出1音量"];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    
    self.chLabel=[[UILabel alloc]init];
    self.chLabel.text=[NSString stringWithFormat:@"输出1"];
    [bgView addSubview:self.chLabel];
    self.chLabel.textColor=[UIColor whiteColor];
    self.chLabel.textAlignment=NSTextAlignmentCenter;
    self.chLabel.font=[UIFont systemFontOfSize:17];
    
   [self.chLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset([Dimens GDimens:60]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:ChannelBtnListHeight]));
        
    }];
    UIButton *lastBtn=[[UIButton alloc]init];
    [self.view addSubview:lastBtn];
    [lastBtn addTarget:self action:@selector(lastCh) forControlEvents:UIControlEventTouchUpInside];
    [lastBtn setImage:[UIImage imageNamed:@"last_icon"] forState:UIControlStateNormal];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chLabel.mas_centerY);
        make.right.equalTo(self.chLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    
    UIButton *nextBtn=[[UIButton alloc]init];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextCh) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setImage:[UIImage imageNamed:@"next_icon"] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chLabel.mas_centerY);
        make.left.equalTo(self.chLabel.mas_right);
        make.size.mas_equalTo(lastBtn);
    }];
    
    self.sbVol=[[VolumeCircleIMLine alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterVolume_SB_Size], [Dimens GDimens:MasterVolume_SB_Size])];
    [self.sbVol setMaxProgress:Output_Volume_MAX+10];
    [self.sbVol addTarget:self action:@selector(VolumeSBChange:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:self.sbVol];
    [self.sbVol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chLabel.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MasterVolume_SB_Size], [Dimens GDimens:MasterVolume_SB_Size]));
    }];
    
    self.volLab=[[UILabel alloc]init];
    self.volLab.textColor=[UIColor whiteColor];
    self.volLab.font=[UIFont systemFontOfSize:40];
    self.volLab.text=@"55";
    [bgView addSubview:self.volLab];
    [self.volLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sbVol.mas_centerX);
        make.centerY.equalTo(self.sbVol.mas_centerY);
    }];
    
    UIButton *subBtn=[[UIButton alloc]init];
    [bgView addSubview:subBtn];
    [subBtn addTarget:self action:@selector(subClick) forControlEvents:UIControlEventTouchUpInside];
    [subBtn setBackgroundImage:[UIImage imageNamed:@"mastervolume_sub_normal"] forState:UIControlStateNormal];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sbVol.mas_bottom).offset([Dimens GDimens:-30]);
        make.left.equalTo(self.sbVol.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    UIButton *incBtn=[[UIButton alloc]init];
    [bgView addSubview:incBtn];
    [incBtn setBackgroundImage:[UIImage imageNamed:@"mastervolume_inc_normal"] forState:UIControlStateNormal];
    [incBtn addTarget:self action:@selector(incClick) forControlEvents:UIControlEventTouchUpInside];
    [incBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sbVol.mas_bottom).offset([Dimens GDimens:-30]);
        make.right.equalTo(self.sbVol.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    UILongPressGestureRecognizer *longPressMainVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_MasterVolumeSUB_LongPress:)];
    longPressMainVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [subBtn addGestureRecognizer:longPressMainVolMinus];
    
    UILongPressGestureRecognizer *longPressMainVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_MasterVolumeAdd_LongPress:)];
    longPressMainVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [incBtn addGestureRecognizer:longPressMainVolAdd];
    
    self.polarBtn=[[UIButton alloc]init];
    [self.polarBtn addTarget:self action:@selector(OutPolar_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_normal"] forState:UIControlStateNormal];
    self.polarBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.polarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal];
    [bgView addSubview:self.polarBtn];
    [self.polarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sbVol.mas_bottom).offset([Dimens GDimens:30]);
        make.centerX.equalTo(self.sbVol.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:50]));
    }];
    [self flashView];
    // Do any additional setup after loading the view.
}
#pragma mark------按钮
-(void)VolumeSBChange:(VolumeCircleIMLine *)sender{
    int val=[sender GetProgress];
    if (self.chType==CH_OUT) {
        RecStructData.OUT_CH[output_channel_sel].gain=val;
    }else{
        RecStructData.IN_CH[input_channel_sel].gain=val;
    }
    self.volLab.text=[NSString stringWithFormat:@"%d",val/Output_Volume_Step];
}
-(void)subClick{
    int val=0;
    if (self.chType==CH_OUT) {
        val=RecStructData.OUT_CH[output_channel_sel].gain-(1*Output_Volume_Step);
        if (val<0) {
            val=0;
        }
         RecStructData.OUT_CH[output_channel_sel].gain=val;
    }else{
        val=RecStructData.IN_CH[input_channel_sel].gain-(1*Output_Volume_Step);
        if (val<0) {
            val=0;
        }
         RecStructData.IN_CH[input_channel_sel].gain=val;
    }
   
    [self.sbVol setProgress:val];
    self.volLab.text=[NSString stringWithFormat:@"%d",val/Output_Volume_Step];
}
-(void)incClick{
    int val=0;
    if (self.chType==CH_OUT) {
        val=RecStructData.OUT_CH[output_channel_sel].gain+(1*Output_Volume_Step);
        if (val>Output_Volume_MAX) {
            val=Output_Volume_MAX;
        }
         RecStructData.OUT_CH[output_channel_sel].gain=val;
    }else{
        val=RecStructData.IN_CH[input_channel_sel].gain+(1*Output_Volume_Step);
        if (val>Input_CH_Volume_MAX) {
            val=Input_CH_Volume_MAX;
        }
         RecStructData.IN_CH[input_channel_sel].gain=val;
    }
    [self.sbVol setProgress:val];
    self.volLab.text=[NSString stringWithFormat:@"%d",val/Output_Volume_Step];
}
//主音量长按操作
-(void)Btn_MasterVolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(subClick) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolMinusTimer.isValid){
            [_pMainVolMinusTimer invalidate];
            _pMainVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}

-(void)Btn_MasterVolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pMainVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(incClick) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pMainVolAddTimer.isValid){
            [_pMainVolAddTimer invalidate];
            _pMainVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}
-(void)nextCh{
    if (self.chType==CH_OUT) {
        int nextIndex=output_channel_sel;
        if (++nextIndex>=Output_CH_MAX_USE) {
            
        }else{
            output_channel_sel=nextIndex;
            
        }
    }else{
        int nextIndex=input_channel_sel;
        if (++nextIndex>=Input_CH_MAX_USE) {
            
        }else{
            input_channel_sel=nextIndex;
            
        }
    }
    
    [self flashView];
}
-(void)lastCh{
    if (self.chType==CH_OUT) {
        int lastIndex=output_channel_sel;
        if (--lastIndex<0) {
            
        }else{
            output_channel_sel=lastIndex;
            
        }
    }else{
        int lastIndex=input_channel_sel;
        if (--lastIndex<0) {
            
        }else{
            input_channel_sel=lastIndex;
            
        }
    }
    [self flashView];
}
-(void)OutPolar_CLick:(UIButton *)sender{
    if (self.chType==CH_OUT) {
        if(RecStructData.OUT_CH[output_channel_sel].polar != 0){
            RecStructData.OUT_CH[output_channel_sel].polar = 0;
            //        [sender setNormal];
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_normal"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
        }else{
            //        [sender setPress];
            RecStructData.OUT_CH[output_channel_sel].polar = 1;
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_press"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        }
    }else{
        if(RecStructData.IN_CH[input_channel_sel].polar != 0){
            RecStructData.IN_CH[input_channel_sel].polar = 0;
            //        [sender setNormal];
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_normal"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
        }else{
            RecStructData.IN_CH[input_channel_sel].polar = 1;
            //        [sender setPress];
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_press"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        }
    }
   
}
#pragma mark--------刷新
-(void)flashView{
    if (self.chType==CH_OUT) {
        
        self.chTopLabel.text=[NSString stringWithFormat:@"输出%d音量",output_channel_sel+1];
        self.chLabel.text=[NSString stringWithFormat:@"输出%d",output_channel_sel+1];
        [self.sbVol setProgress:RecStructData.OUT_CH[output_channel_sel].gain];
        self.volLab.text=[NSString stringWithFormat:@"%d",RecStructData.OUT_CH[output_channel_sel].gain/Output_Volume_Step];
        if (RecStructData.OUT_CH[output_channel_sel].polar==0) {
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_normal"] forState:UIControlStateNormal];
             [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
        }else{
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_press"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        }
    }else if(self.chType==CH_INPUT){
        self.chTopLabel.text=[NSString stringWithFormat:@"输入%d音量",input_channel_sel+1];
        self.chLabel.text=[NSString stringWithFormat:@"输入%d",input_channel_sel+1];
        [self.sbVol setProgress:RecStructData.IN_CH[input_channel_sel].gain];
        self.volLab.text=[NSString stringWithFormat:@"%d",RecStructData.IN_CH[input_channel_sel].gain/Output_Volume_Step];
        if (RecStructData.IN_CH[input_channel_sel].polar==0) {
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_normal"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
        }else{
            [self.polarBtn setBackgroundImage:[UIImage imageNamed:@"polar_press"] forState:UIControlStateNormal];
            [self.polarBtn setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal];
        }
    }
}
-(void)dismissView{
    self.dismissBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

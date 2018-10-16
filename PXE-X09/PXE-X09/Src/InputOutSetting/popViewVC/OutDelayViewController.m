//
//  OutDelayViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/10.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "OutDelayViewController.h"

@interface OutDelayViewController ()
{
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
}
@end

@implementation OutDelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350])];
    [bgImageView setImage:[UIImage imageNamed:@"delay_bg"]];
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
    self.chTopLabel.text=[NSString stringWithFormat:@"输出1延时"];
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
    self.mslLab=[[UILabel alloc]init];
    self.mslLab.font=[UIFont systemFontOfSize:15];
    self.mslLab.text=@"20.000";
    self.mslLab.textColor=SetColor(UI_SystemBtnColorPress);
    UILabel *msflg=[[UILabel alloc]init];
    msflg.text=@"ms";
    msflg.textColor=SetColor(0xFF7b838a);
    msflg.font=[UIFont systemFontOfSize:13];
    UIStackView *msView=[[UIStackView alloc]init];
    msView.axis=UILayoutConstraintAxisHorizontal;
    msView.alignment=UIStackViewAlignmentBottom;
    [self.view addSubview:msView];
    [msView addArrangedSubview:self.mslLab];
    [msView addArrangedSubview:msflg];
    [msView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_centerY);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    self.cmLab=[[UILabel alloc]init];
    self.cmLab.font=[UIFont systemFontOfSize:15];
    self.cmLab.text=@"600";
    self.cmLab.textColor=SetColor(UI_SystemBtnColorPress);
    UILabel *cmflg=[[UILabel alloc]init];
    cmflg.text=@"cm";
    cmflg.textColor=SetColor(0xFF7b838a);
    cmflg.font=[UIFont systemFontOfSize:13];
    UIStackView *cmView=[[UIStackView alloc]init];
    cmView.axis=UILayoutConstraintAxisHorizontal;
    cmView.alignment=UIStackViewAlignmentBottom;
    [self.view addSubview:cmView];
    [cmView addArrangedSubview:self.cmLab];
    [cmView addArrangedSubview:cmflg];
    [cmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msView.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    
    self.delaySlider=[[UISlider alloc]init];
    [bgView addSubview:self.delaySlider];
    [self.delaySlider setMaximumValue:DELAY_SETTINGS_MAX];
    [self.delaySlider setMinimumValue:0];
    [self.delaySlider setThumbImage:[UIImage imageNamed:@"delay_thumb"] forState:UIControlStateNormal];
    self.delaySlider.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.delaySlider.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.delaySlider addTarget:self action:@selector(delayChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.delaySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cmView.mas_bottom).offset([Dimens GDimens:50]);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:230], [Dimens GDimens:30]));
    }];
    UIButton *subBtn=[[UIButton alloc]init];
    [bgView addSubview:subBtn];
    [subBtn addTarget:self action:@selector(subClick) forControlEvents:UIControlEventTouchUpInside];
    [subBtn setBackgroundImage:[UIImage imageNamed:@"mastervolume_sub_normal"] forState:UIControlStateNormal];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.delaySlider.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.delaySlider.mas_left).offset([Dimens GDimens:-15]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
        
    }];
    UIButton *incBtn=[[UIButton alloc]init];
    [bgView addSubview:incBtn];
    [incBtn setBackgroundImage:[UIImage imageNamed:@"mastervolume_inc_normal"] forState:UIControlStateNormal];
    [incBtn addTarget:self action:@selector(incClick) forControlEvents:UIControlEventTouchUpInside];
    [incBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.delaySlider.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.delaySlider.mas_right).offset([Dimens GDimens:15]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间定义按的时间
    [subBtn addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5;
    [incBtn addGestureRecognizer:longPressVolAdd];
    [self flashView];
    // Do any additional setup after loading the view.
}
#pragma mark--------按钮
-(void)delayChange:(UISlider *)slider{
    RecStructData.OUT_CH[output_channel_sel].delay=(int)slider.value;
    [self flashView];
}
-(void)incClick{
    if(++RecStructData.OUT_CH[output_channel_sel].delay > DELAY_SETTINGS_MAX){
        RecStructData.OUT_CH[output_channel_sel].delay = DELAY_SETTINGS_MAX;
    }
    [self flashView];
}
-(void)subClick{
    if(--RecStructData.OUT_CH[output_channel_sel].delay < 0){
        RecStructData.OUT_CH[output_channel_sel].delay = 0;
    }
    [self flashView];
}
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(subClick) userInfo:nil repeats:YES];
        
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
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(incClick) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}
-(void)nextCh{
    int nextIndex=output_channel_sel;
    if (++nextIndex>=Output_CH_MAX_USE) {
        
    }else{
        output_channel_sel=nextIndex;
        
    }
    [self flashView];
}
-(void)lastCh{
    int lastIndex=output_channel_sel;
    if (--lastIndex<0) {
        
    }else{
        output_channel_sel=lastIndex;
        
    }
    [self flashView];
}
-(void)flashView{
    self.chTopLabel.text=[NSString stringWithFormat:@"输出%d延时",output_channel_sel+1];
    self.chLabel.text=[NSString stringWithFormat:@"输出%d",output_channel_sel+1];
    self.delaySlider.value=RecStructData.OUT_CH[output_channel_sel].delay;
    self.cmLab.text=[self CountDelayCM:RecStructData.OUT_CH[output_channel_sel].delay];
    self.mslLab.text=[self CountDelayMs:RecStructData.OUT_CH[output_channel_sel].delay];
    
}
#pragma mark /******* 延时时间转换  *******/

- (NSString*) CountDelayCM:(int)num{
    int m_nTemp=75;
    float Time = (float) (num/96.0); //当Delay〈476时STEP是0.021MS；
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
    int fr = num*10000/96;
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
    float Time = (float) (num/96.0); //当Delay〈476时STEP是0.021MS；
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

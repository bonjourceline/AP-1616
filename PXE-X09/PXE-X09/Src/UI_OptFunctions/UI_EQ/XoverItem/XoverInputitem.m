//
//  XoverInputitem.m
//  PXE-X09
//
//  Created by celine on 2018/10/11.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "XoverInputitem.h"
#import "KGModal.h"
#define btnBorderColor (0xFF212932)
#define btnTextColor (0xFFffffff)
@implementation XoverInputitem{
    XoverType type;
    NSMutableArray *Filter_List;
    NSMutableArray *AllLevel;
    //主音量计数定时器 减
    NSTimer *_pVolFreqMinusTimer;
    NSTimer *_pVolFreqAddTimer;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)setXoverType:(XoverType)xoverType{
    type=xoverType;
    [self setup];
}
-(void)setup{
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
    
    
    UIView *bgView=[[UIView alloc]init];
    [self addSubview:bgView];
    bgView.layer.borderWidth=1;
    bgView.layer.cornerRadius=5;
    bgView.layer.borderColor=SetColor(0xFF212932).CGColor;
    bgView.layer.masksToBounds=YES;
    
    UILabel *xoverLab=[[UILabel alloc]init];
    [self addSubview:xoverLab];
    xoverLab.backgroundColor=SetColor(0xFF111519);
    xoverLab.textColor=SetColor(0xFFbac5d0);
    xoverLab.textAlignment=NSTextAlignmentCenter;
    xoverLab.font=[UIFont systemFontOfSize:12];
    [xoverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        
        
    }];
    UIImageView *xoverImage=[[UIImageView alloc]init];
    //    xoverImage.contentMode=UIViewContentModeLeft;
    [self addSubview:xoverImage];
    [xoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xoverLab.mas_top);
        make.bottom.equalTo(xoverLab.mas_bottom);
        make.left.equalTo(xoverLab.mas_left).offset([Dimens GDimens:-8]);
        make.right.equalTo(xoverLab.mas_right).offset([Dimens GDimens:8]);
    }];
    if (type==H_Type) {
        xoverLab.text=[LANG DPLocalizedString:@"L_XOver_HighPass"];
        [xoverImage setImage:[UIImage imageNamed:@"xover_left"]];
    }else{
        xoverLab.text=[LANG DPLocalizedString:@"L_XOver_LowPass"];
        [xoverImage setImage:[UIImage imageNamed:@"xover_right"]];
    }
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xoverLab.mas_centerY).offset([Dimens GDimens:5]);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //类型
    UILabel *filterlab=[[UILabel alloc]init];
    [self addSubview:filterlab];
    filterlab.font=[UIFont systemFontOfSize:11];
    filterlab.textColor=SetColor(0xFF747e88);
    filterlab.adjustsFontSizeToFitWidth=YES;
    [filterlab setText:[LANG DPLocalizedString:@"L_XOver_Type"]];
    self.filterBtn=[[NormalButton alloc]init];
    [self.filterBtn  initViewBroder:3
                    withBorderWidth:1
                    withNormalColor:(0x00000000)
                     withPressColor:(0x00000000)
              withBorderNormalColor:btnBorderColor
               withBorderPressColor:btnBorderColor
                withTextNormalColor:btnTextColor
                 withTextPressColor:btnTextColor
                           withType:0];
    self.filterBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.filterBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:self.filterBtn];
    [self.filterBtn addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-[Dimens GDimens:10]);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:60], [Dimens GDimens:25]));
    }];
    [filterlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.filterBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.filterBtn.mas_centerX);
        
    }];
    //频率
    UILabel *freqLab=[[UILabel alloc]init];
    [self addSubview:freqLab];
    freqLab.font=[UIFont systemFontOfSize:11];
    freqLab.textColor=SetColor(0xFF747e88);
    freqLab.adjustsFontSizeToFitWidth=YES;
    [freqLab setText:[LANG DPLocalizedString:@"L_XOver_Frequency"]];
    self.freqBtn=[[NormalButton alloc]init];
    [self addSubview:self.freqBtn];
    [self.freqBtn initViewBroder:3
                 withBorderWidth:1
                 withNormalColor:(0x00000000)
                  withPressColor:(0x00000000)
           withBorderNormalColor:btnBorderColor
            withBorderPressColor:btnBorderColor
             withTextNormalColor:btnTextColor
              withTextPressColor:btnTextColor
                        withType:0];
    [self.freqBtn addTarget:self action:@selector(clickFreq:) forControlEvents:UIControlEventTouchUpInside];
    self.freqBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.freqBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.freqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.filterBtn.mas_centerY);
        make.size.mas_equalTo(self.filterBtn);
    }];
    [freqLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.freqBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.freqBtn.mas_centerX);
        
    }];
    //斜率
    UILabel *levelLab=[[UILabel alloc]init];
    [self addSubview:levelLab];
    levelLab.font=[UIFont systemFontOfSize:11];
    levelLab.textColor=SetColor(0xFF747e88);
    levelLab.adjustsFontSizeToFitWidth=YES;
    [levelLab setText:[LANG DPLocalizedString:@"L_XOver_Slope"]];
    self.levelBtn=[[NormalButton alloc]init];
    [self addSubview:self.levelBtn];
    [self.levelBtn initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:(0x00000000)
                   withPressColor:(0x00000000)
            withBorderNormalColor:btnBorderColor
             withBorderPressColor:btnBorderColor
              withTextNormalColor:btnTextColor
               withTextPressColor:btnTextColor
                         withType:0];
    [self.levelBtn addTarget:self action:@selector(clickLevel:) forControlEvents:UIControlEventTouchUpInside];
    self.levelBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.levelBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.filterBtn.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-5]);
        make.size.mas_equalTo(self.filterBtn);
    }];
    [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.levelBtn.mas_top).offset([Dimens GDimens:-10]);
        make.centerX.equalTo(self.levelBtn.mas_centerX);
    }];
    [self flashXover];
}
-(void)flashXover{
    if(RecStructData.IN_CH[input_channel_sel].h_filter > 3 || RecStructData.IN_CH[input_channel_sel].h_filter < 0){
        RecStructData.IN_CH[input_channel_sel].h_filter = 0;
        
        
        NSLog(@"flashXOver ERROR  RecStructData.IN_CH[%d].h_filter=%d",input_channel_sel,RecStructData.IN_CH[input_channel_sel].h_filter);
        
    }
    if(RecStructData.IN_CH[input_channel_sel].l_filter > 3 || RecStructData.IN_CH[input_channel_sel].l_filter < 0){
        RecStructData.IN_CH[input_channel_sel].l_filter = 0;
        NSLog(@"flashXOver ERROR  RecStructData.IN_CH[%d].l_filter=%d",input_channel_sel,RecStructData.IN_CH[input_channel_sel].l_filter);
    }
    
    if(RecStructData.IN_CH[input_channel_sel].h_level > XOVER_OCT_MAX || RecStructData.IN_CH[input_channel_sel].h_level < 0){
        RecStructData.IN_CH[input_channel_sel].h_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.IN_CH[%d].h_level=%d",input_channel_sel,RecStructData.IN_CH[input_channel_sel].h_level);
    }
    if(RecStructData.IN_CH[input_channel_sel].l_level > XOVER_OCT_MAX || RecStructData.IN_CH[input_channel_sel].l_level < 0){
        RecStructData.IN_CH[input_channel_sel].l_level = 0;
        NSLog(@"flashXOver ERROR  RecStructData.IN_CH[%d].l_level=%d",input_channel_sel,RecStructData.IN_CH[input_channel_sel].l_level);
    }
    
    if (type==H_Type) {
        [self.filterBtn setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.IN_CH[input_channel_sel].h_filter]]  forState:UIControlStateNormal];
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.IN_CH[input_channel_sel].h_level]]  forState:UIControlStateNormal];
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
    }else{
        [self.filterBtn setTitle:[NSString stringWithFormat:@"%@",[Filter_List objectAtIndex:RecStructData.IN_CH[input_channel_sel].l_filter]]  forState:UIControlStateNormal];
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:RecStructData.IN_CH[input_channel_sel].l_level]]  forState:UIControlStateNormal];
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
    }
    
}
#pragma mark-------弹窗
-(void)clickFilter:(NormalButton *)sender{
    if(BOOL_FilterHide6DB_OCT){
        if(RecStructData.IN_CH[input_channel_sel].h_level == 0){
            return;
        }
    }
    //    [sender setPress];
    [self showFilterOptDialog];
}
-(void)clickFreq:(NormalButton *)sender{
    [self showFreqDialog];
}
-(void)clickLevel:(NormalButton *)sender{
    [self showLevelOptDialog];
}


#pragma mark -------------------- 弹出选择 Filter
- (void)showFilterOptDialog{
    UIAlertController *alert;
    if(type==H_Type){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Type"]preferredStyle:UIAlertControllerStyleAlert];
    }
    for (int i=0; i<Filter_List.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[Filter_List objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetFilter:i];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        //        [B_Buf setNormal];
    }]];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}
- (void)dialogSetFilter:(int)val{
    if (val<Filter_List.count) {
        RecStructData.IN_CH[input_channel_sel].h_filter = val;
        [self.filterBtn setTitle:[Filter_List objectAtIndex:val] forState:UIControlStateNormal];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
    if(type==H_Type){
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].h_freq]];
    }else{
        _sliderFreq.showValue = [NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].l_freq]];
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
    //    [btnOK addTarget:self action:@selector(dialogExit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnOK];
    
    [[KGModal sharedInstance] setOKButton:btnOK];
    [[KGModal sharedInstance] setModalBackgroundColor:SetColor(0xff303030)];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
}
- (void)SBDialogFreqSet{
    int sliderValue = (int)(_sliderFreq.value);
    _sliderFreq.showValue=[NSString stringWithFormat:@"%dHz",(int)FREQ241[sliderValue]];
    if(type==H_Type){
        RecStructData.IN_CH[input_channel_sel].h_freq = FREQ241[sliderValue];
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].h_freq =
            RecStructData.IN_CH[input_channel_sel].l_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].h_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].h_freq = 1000;
        //                }
        //            }
        //        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].h_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq]];
        
        
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_HFreq];
    }else{
        RecStructData.IN_CH[input_channel_sel].l_freq = FREQ241[sliderValue];
        
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].l_freq =
            RecStructData.IN_CH[input_channel_sel].h_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].l_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].l_freq = 1000;
        //                }
        //            }
        //        }
        _sliderFreq.value = [self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].l_freq];
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq]];
        
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_LFreq];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}
- (void)DialogFreqSet_Sub{
    if(type==H_Type){
        if(--RecStructData.IN_CH[input_channel_sel].h_freq < 20){
            RecStructData.IN_CH[input_channel_sel].h_freq = 20;
        }
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].h_freq =
            RecStructData.IN_CH[input_channel_sel].l_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].h_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].h_freq = 1000;
        //                }
        //            }
        //        }
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].h_freq]];
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(--RecStructData.IN_CH[input_channel_sel].l_freq < 20){
            RecStructData.IN_CH[input_channel_sel].l_freq = 20;
        }
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].l_freq =
            RecStructData.IN_CH[input_channel_sel].h_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].l_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].l_freq = 1000;
        //                }
        //            }
        //        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].l_freq]];
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_LFreq];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)DialogFreqSet_Inc{
    if(type==H_Type){
        if(++RecStructData.IN_CH[input_channel_sel].h_freq > 20000){
            RecStructData.IN_CH[input_channel_sel].h_freq = 20000;
        }
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].h_freq =
            RecStructData.IN_CH[input_channel_sel].l_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].h_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].h_freq = 1000;
        //                }
        //            }
        //        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].h_freq]];
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].h_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_HFreq];
    }else{
        if(++RecStructData.IN_CH[input_channel_sel].l_freq > 20000){
            RecStructData.IN_CH[input_channel_sel].l_freq = 20000;
        }
        
        if(RecStructData.IN_CH[input_channel_sel].h_freq >
           RecStructData.IN_CH[input_channel_sel].l_freq){
            
            RecStructData.IN_CH[input_channel_sel].l_freq =
            RecStructData.IN_CH[input_channel_sel].h_freq;
        }
        //        if(BOOL_SET_SpkType){
        //            int fr=[self getChannelNum:input_channel_sel];
        //            if((fr==1)||(fr==7)||(fr==13)||(fr==16)||(fr==19)){
        //                if(RecStructData.IN_CH[input_channel_sel].l_freq <1000){
        //                    //                    RecStructData.IN_CH[input_channel_sel].l_freq = 1000;
        //                }
        //            }
        //        }
        
        
        [_sliderFreq setShowValue:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq]];
        [_sliderFreq setValue:[self getFreqIndexFromArray:RecStructData.IN_CH[input_channel_sel].l_freq]];
        
        [self.freqBtn setTitle:[NSString stringWithFormat:@"%dHz",RecStructData.IN_CH[input_channel_sel].l_freq] forState:UIControlStateNormal];
        
        //        [self flashLinkSyncData:UI_LFreq];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
    return i+1;
}
#pragma mark -------------------- 弹出选择 Level
- (void)showLevelOptDialog{
    
    UIAlertController *alert;
    if(type==H_Type){
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_HighPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_XOver_LowPassFilter"]message:[LANG DPLocalizedString:@"L_XOver_Slope"]preferredStyle:UIAlertControllerStyleAlert];
    }
    for (int i=0; i<AllLevel.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:AllLevel[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dialogSetLevel:i];
            
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
        //        [B_Buf setNormal];
    }]];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}
- (void)dialogSetLevel:(int)val{
    if(type==H_Type){
        RecStructData.IN_CH[input_channel_sel].h_level = val;
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.IN_CH[input_channel_sel].h_filter];
        
        //        [self flashLinkSyncData:UI_HOct];
    }else{
        RecStructData.IN_CH[input_channel_sel].l_level = val;
        [self.levelBtn setTitle:[NSString stringWithFormat:@"%@",[AllLevel objectAtIndex:val]] forState:UIControlStateNormal] ;
        [self dialogSetFilter:RecStructData.IN_CH[input_channel_sel].l_filter];
        
        //        [self flashLinkSyncData:UI_LOct];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

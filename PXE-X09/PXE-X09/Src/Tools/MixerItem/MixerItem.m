//
//  MixerItem.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/30.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MixerItem.h"

#define MixerItemLabWidth  60
#define MixerItemBtnSize   25
#define MixerItemINSSUBBtnSize   20
@implementation MixerItem
@synthesize SB_Volume;
- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        [self setup];
    }
    //self.frame = CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:MixerItemHeight]);
    return self;
}

- (void)setup{
//    self.backgroundColor = SetColor(UI_MasterBackgroundColor);
    DataTemp = 0;
    
    
    ItemColorNormal = ColorItemNormal;   //边框颜色
    ItemColorPress = ColorItemPress;    //边框颜色
        ItemColorVolue = SetColor(ColorItemVolue); //数值文本颜色
    
    ItemColorMixerInput = SetColor(ColorItemMixerInput); //音源文本颜色
    ItemColorSBProgress = SetColor(ColorItemSBProgress);   //
    ItemColorSBProgressBg = SetColor(ColorItemSBProgressBg);    //
    
    NormalColorSpace = CGColorSpaceCreateDeviceRGB();
    //    NormalColorref = CGColorCreate(NormalColorSpace,(CGFloat[]){((ItemColorNormal>>16)&0x00ff)/255.0 ,((ItemColorNormal>>8)&0x00ff)/255.0,(ItemColorNormal&0x000000ff)/255.0,((ItemColorNormal>>24)&0x00ff)/255.0});
    
    PressColorSpace = CGColorSpaceCreateDeviceRGB();
    PressColorref = CGColorCreate(NormalColorSpace,(CGFloat[]){((ItemColorPress>>16)&0x00ff)/255.0 ,((ItemColorPress>>8)&0x00ff)/255.0,(ItemColorPress&0x000000ff)/255.0,((ItemColorPress>>24)&0x00ff)/255.0});
    //    PressColorref=SetColor(ColorItemPress).CGColor;
    NormalColorref = SetColor(ColorItemNormal).CGColor;
    mView = [[UIView alloc]initWithFrame:CGRectMake(
                                                    [Dimens GDimens:MixerItemMid],
                                                    [Dimens GDimens:MixerItemMid],
                                                    KScreenWidth-[Dimens GDimens:MixerItemMid*2],
                                                    [Dimens GDimens:MixerItemHeight-MixerItemMid])
             ];
   
//    mView.backgroundColor=SetColor(ColorItemBG);
    [self addSubview:mView];
    [mView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [mView.layer setMasksToBounds:YES];
//    [mView.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [mView.layer setBorderWidth:1];   //边框宽度
//    [mView.layer setBorderColor:NormalColorref]; //边框颜色
    
    
    
    
    
    tag = 0;
    //MixerInput
    Lab_MixerInput = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MixerItemLabWidth], [Dimens GDimens:MixerItemBtnSize])];
   
    Lab_MixerInput.userInteractionEnabled=YES;
    [mView addSubview:Lab_MixerInput];
    [Lab_MixerInput setTag:tag];
    
    [Lab_MixerInput setTextColor:ItemColorMixerInput];
    Lab_MixerInput.text=@"Input";
    Lab_MixerInput.textAlignment = NSTextAlignmentCenter;
    Lab_MixerInput.adjustsFontSizeToFitWidth = true;
    Lab_MixerInput.font = [UIFont systemFontOfSize:14];
    [Lab_MixerInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mView.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(mView.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MixerItemLabWidth], [Dimens GDimens:MixerItemBtnSize]));
    }];
    
    Btn_Polar = [[UIButton alloc]init];
    [mView addSubview:Btn_Polar];
    [Btn_Polar setTag:tag];
    [Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
    [Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    Btn_Polar.titleLabel.adjustsFontSizeToFitWidth = true;
    Btn_Polar.titleLabel.font = [UIFont systemFontOfSize:13];
    [Btn_Polar addTarget:self action:@selector(Btn_PolarEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Btn_Polar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mView.mas_top).offset(WIND_Height/4);
        make.left.equalTo(Lab_MixerInput.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:MixerItemBtnSize]));
    }];
    Btn_Polar.hidden = true;
    
    Lab_Volue = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MixerItemLabWidth], [Dimens GDimens:MixerItemBtnSize])];
    [mView addSubview:Lab_Volue];
    [Lab_Volue setTag:tag];
    [Lab_Volue setBackgroundColor:[UIColor clearColor]];
    [Lab_Volue setTextColor:ItemColorVolue];
    Lab_Volue.text=@"Input";
    Lab_Volue.textAlignment = NSTextAlignmentCenter;
    Lab_Volue.adjustsFontSizeToFitWidth = true;
    Lab_Volue.font = [UIFont systemFontOfSize:15];
    [Lab_Volue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mView.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(Lab_MixerInput.mas_right).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:50], [Dimens GDimens:MixerItemBtnSize]));
    }];
    
    
    //增减操作
    BtnSub = [[UIButton alloc]init];
//    BtnSub.layer.borderWidth=1;
//    BtnSub.backgroundColor=SetColor(UI_DelayBtn_NormalIN);
//    BtnSub.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
    BtnSub.layer.cornerRadius=3;
    BtnSub.layer.masksToBounds=YES;
    [BtnSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [BtnSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    [self addSubview:BtnSub];
    [BtnSub addTarget:self action:@selector(BtnSubClick:) forControlEvents:UIControlEventTouchUpInside];
    [BtnSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mView.mas_centerY);
        make.left.equalTo(Lab_Volue.mas_right).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MixerItemINSSUBBtnSize], [Dimens GDimens:MixerItemINSSUBBtnSize]));
    }];
    
    BtnInc = [[UIButton alloc]init];
//    BtnInc.layer.borderWidth=1;
//    BtnInc.backgroundColor=SetColor(UI_DelayBtn_NormalIN);
//    BtnInc.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
    BtnInc.layer.cornerRadius=3;
    BtnInc.layer.masksToBounds=YES;
    [BtnInc setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [BtnInc setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    [self addSubview:BtnInc];
    [BtnInc addTarget:self action:@selector(BtnIncClick:) forControlEvents:UIControlEventTouchUpInside];
    [BtnInc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mView.mas_centerY);
        make.right.mas_equalTo(mView.mas_right).offset([Dimens GDimens:-5]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MixerItemINSSUBBtnSize], [Dimens GDimens:MixerItemINSSUBBtnSize]));
    }];
    
    //SB_Volume
    SB_Volume = [[UISlider alloc]initWithFrame:CGRectMake(0, 60, WIND_Width-[Dimens GDimens:200], [Dimens GDimens:40])];
    mView.userInteractionEnabled=YES;
    [mView addSubview:SB_Volume];
    
    [SB_Volume setMinimumValue:0];
    [SB_Volume setMaximumValue:0];
    [SB_Volume setMaximumValue:Mixer_Volume_MAX];
        SB_Volume.minimumTrackTintColor = SetColor(ColorItemSBProgress); //滑轮左边颜色如果设置了左边的图片就不会显示
        SB_Volume.maximumTrackTintColor = SetColor(ColorItemSBProgressBg); //滑轮右边颜色如果设置了右边的图片就不会显
    [SB_Volume setThumbImage:[UIImage imageNamed:@"chs_mvs_thumb_normal"] forState:UIControlStateNormal];
    
//    [SB_Volume setThumbImage:[UIImage imageNamed:@"chs_mvs_thumb_press"] forState:UIControlStateHighlighted];
//    [SB_Volume setMaximumTrackImage:[UIImage imageNamed:@"mhs_progress_normal"] forState:UIControlStateNormal];
//    [SB_Volume setMinimumTrackImage:[UIImage imageNamed:@"mhs_progress_normal"] forState:UIControlStateNormal];
    [SB_Volume addTarget:self action:@selector(SB_VolumeEvent:) forControlEvents:UIControlEventValueChanged];
    [SB_Volume setBackgroundColor:[UIColor clearColor]];
    [SB_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(Lab_Volue.mas_centerY);
        make.right.equalTo(BtnInc.mas_left).offset(-[Dimens GDimens:10]);
        make.left.equalTo(BtnSub.mas_right).offset([Dimens GDimens:10]);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:240], [Dimens GDimens:40]));
        //        make.left.mas_equalTo(Lab_Volue.mas_right).offset([Dimens GDimens:15]);
        //        make.right.mas_equalTo(mView.mas_right).offset(-10);
    }];
    
    
    
    

//    BtnSub.hidden=YES;
    //MixerInput
 
    
    //Btn_Switch
//    Btn_Switch = [[UIButton alloc]init];
//    [mView addSubview:Btn_Switch];
    [Btn_Switch setTag:tag];
    [Btn_Switch setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
    [Btn_Switch addTarget:self action:@selector(Btn_SwitchEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [Btn_Switch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(Lab_Volue.mas_centerY);
//        make.right.equalTo(Lab_Volue.mas_left);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:MixerItemBtnSize], [Dimens GDimens:MixerItemBtnSize]));
//    }];
    
    
   

    //长按
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [BtnSub addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [BtnInc addGestureRecognizer:longPressVolAdd];
    
    
    
    
    
    
    
   
    
    V_Disable = [[UIView alloc]initWithFrame:CGRectMake(
                                                        [Dimens GDimens:MixerItemMid],
                                                        [Dimens GDimens:MixerItemMid],
                                                        KScreenWidth-[Dimens GDimens:MixerItemMid*2],
                                                        [Dimens GDimens:MixerItemHeight-MixerItemMid])
                 ];
    [self addSubview:V_Disable];
    [V_Disable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    [V_Disable.layer setMasksToBounds:YES];
//    [V_Disable.layer setCornerRadius:5]; //设置矩形四个圆角半径
    [V_Disable.layer setBorderWidth:1];   //边框宽度
    [V_Disable.layer setBorderColor:NormalColorref]; //边框颜色
    [V_Disable setBackgroundColor:SetColor(ColorItemDiable)];
    V_Disable.hidden = true;
}
-(void)aaa
{
    NSLog(@"aaaaaaaaaa");
}
#pragma 响应事件
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(BtnSubClick:) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolMinusTimer.isValid){
            [_pVolMinusTimer invalidate];
            _pVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}
-(void)Btn_VolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(BtnIncClick:) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}

- (void)Btn_PolarEvent:(UIButton*)sender{
    
    if(polar == 1){
        polar = 0;
        [Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
        [Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    }else{
        polar = 1;
        [Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
        [Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal] ;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)BtnSubClick:(UIButton*)sender{
    
    if(--DataVal < 0){
        DataVal = 0;
    }
    SB_Volume.value = DataVal;
    Lab_Volue.text = [NSString stringWithFormat:@"%d",DataVal];
    [self checkSwitchState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)BtnIncClick:(UIButton*)sender{
    
    if(++DataVal > DataMax){
        DataVal = DataMax;
    }
    SB_Volume.value = DataVal;
    Lab_Volue.text = [NSString stringWithFormat:@"%d",DataVal];
    [self checkSwitchState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}

- (void)checkSwitchState{
    if(DataVal == 0){
        [self setMixerItemBtnSwitchNormal];
    }else{
        [self setMixerItemBtnSwitchPress];
    }
}
- (void)Btn_SwitchEvent:(UIButton*)sender{
    if(DataVal == 0){
        DataVal = DataTemp;
    }else{
        DataTemp = DataVal;
        DataVal = 0;
    }
    SB_Volume.value = DataVal;
    Lab_Volue.text = [NSString stringWithFormat:@"%d",DataVal];
    [self checkSwitchState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)SB_VolumeEvent:(UISlider*)sender{
    
    DataVal = (int) sender.value;
    Lab_Volue.text = [NSString stringWithFormat:@"%d",DataVal];
    [self checkSwitchState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma 接口函数
- (void)setMixerItemTag:(int)stag{
    tag = stag;
    [Lab_MixerInput setTag:TagStart_MixerItem_Lab_MixerInput+stag];
    [Lab_Volue      setTag:TagStart_MixerItem_Lab_Volue+stag];
    [Btn_Switch     setTag:TagStart_MixerItem_Btn_Switch+stag];
    
    [SB_Volume      setTag:TagStart_MixerItem_SB_Volume+stag];
    [V_Disable      setTag:TagStart_MixerItem_V_Disable+stag];
    [mView          setTag:TagStart_MixerItem_mView+stag];
    [self                setTag:TagStart_MixerItem_self+stag];
}

- (void)setMixerItemDisable:(BOOL)Set{
    V_Disable.hidden = Set;
}


- (void)setMixerItemPress{
    [mView.layer setBorderColor:PressColorref]; //边框颜色
}

- (void)setMixerItemNormal{
    [mView.layer setBorderColor:NormalColorref]; //边框颜色
}

- (void)setMixerItemBtnSwitchPress{
    [Btn_Switch setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
}

- (void)setMixerItemBtnSwitchNormal{
    [Btn_Switch setBackgroundImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
}

- (void)setDataVal:(int)val{
    if(val > DataMax){
        val = DataMax;
    }
    DataVal = val;
    [self checkSwitchState];
    Lab_Volue.text = [NSString stringWithFormat:@"%d",DataVal];
    SB_Volume.value = DataVal;
}
- (void)setDataMax:(int)val{
    DataMax = val;
    [SB_Volume setMaximumValue:0];
    [SB_Volume setMinimumValue:0];
    [SB_Volume setMaximumValue:DataMax];
}

- (int)getDataVal{
    return DataVal;
}

- (void)setLab_MixerInput:(NSString*)val{
    Lab_MixerInput.text = val;
}

- (void)setPolar:(int)val{
    polar = val;
    if(polar == 0){
        [Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_P) forState:UIControlStateNormal];
        [Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_P"] forState:UIControlStateNormal] ;
    }else{
        [Btn_Polar setTitleColor:SetColor(UI_OutPolar_BtnText_N) forState:UIControlStateNormal];
        [Btn_Polar setTitle:[LANG DPLocalizedString:@"L_Out_Polar_N"] forState:UIControlStateNormal] ;
    }
}

- (int)getPolar{
    return polar;
}

@end

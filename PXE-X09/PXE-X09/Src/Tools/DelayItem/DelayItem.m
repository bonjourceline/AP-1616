//
//  DelayItem.m
//  KP-DAP46-CF-A6
//
//  Created by chsdsp on 2017/5/2.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "DelayItem.h"


#define SB_Volume_Size 95
#define DelayItemBtnHeight 25
#define DelayItemBtnWidth 110

#define DelayItem_Btn_Ch_Press (0xFFfce802) //
#define DelayItem_Btn_Ch_Normal (0xFFfce802) //
#define DelayItem_Btn_ChText_Press (0xFFfce802) //
#define DelayItem_Btn_ChText_Normal (0xffffffff) //
#define DelayItem_Btn_ChTextVal (0xFFfce802) //
#define DelayItem_Btn_BG (0x30ffffff) //
@implementation DelayItem

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = KScreenWidth/2;//frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //[self.layer setBorderWidth:1];   //边框宽度
    //[self.layer setBorderColor:normalColorrefWhite]; //边框颜色
    self.backgroundColor = SetColor(DelayItem_Btn_BG);

    
    //self.SB_Volume = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, WIND_Width-[Dimens GDimens:40], [Dimens GDimens:50])];
    self.SB_Volume = [[UISlider alloc]init];
    [self addSubview:self.SB_Volume];
    [self.SB_Volume addTarget:self action:@selector(SB_VolumeEvent:) forControlEvents:UIControlEventValueChanged];
    self.SB_Volume.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.SB_Volume.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.SB_Volume setBackgroundColor:[UIColor clearColor]];
    self.SB_Volume.minimumValue = 0;//设置最小值
    self.SB_Volume.maximumValue = DELAY_SETTINGS_MAX;//设置最大值
    [self.SB_Volume setThumbImage:[UIImage imageNamed:@"chs_thumb_normal"] forState:UIControlStateNormal];
    [self.SB_Volume setThumbImage:[UIImage imageNamed:@"chs_thumb_press"] forState:UIControlStateHighlighted];
    self.SB_Volume.value = 0;//设置默认值
    self.SB_Volume.continuous = YES;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.SB_Volume.transform = trans;
    [self.SB_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset([Dimens GDimens:40]);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(WIND_Height-[Dimens GDimens:10], [Dimens GDimens:40]));
    }];

    //通道号
    self.Btn_Channel = [[UIButton alloc]init];
    [self addSubview:self.Btn_Channel];
    [self.Btn_Channel setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Channel setTitleColor:SetColor(DelayItem_Btn_ChText_Normal) forState:UIControlStateNormal];
    //[self.Btn_Channel setTitle:@"CH1" forState:UIControlStateNormal] ;
    self.Btn_Channel.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Channel.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_Channel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Channel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:80], [Dimens GDimens:DelayItemBtnHeight*2]));
    }];
    //音量值
    self.Btn_Volume = [[UIButton alloc]init];
    [self addSubview:self.Btn_Volume];
    [self.Btn_Volume setBackgroundColor:[UIColor clearColor]];
    [self.Btn_Volume setTitleColor:SetColor(DelayItem_Btn_ChTextVal) forState:UIControlStateNormal];
    //[self.Btn_Volume setTitle:@"60" forState:UIControlStateNormal] ;
    //self.Btn_Volume.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Volume.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_Volume.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.Btn_Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayItemBtnWidth], [Dimens GDimens:DelayItemBtnHeight*1.5]));
    }];

    //增减操作
    int SizeINSSUB = 35;
    BtnSub = [[UIButton alloc]init];
    [BtnSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [BtnSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_press"] forState:UIControlStateHighlighted];
    [self addSubview:BtnSub];
    [BtnSub addTarget:self action:@selector(BtnSubClick:) forControlEvents:UIControlEventTouchUpInside];
    [BtnSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:SizeINSSUB], [Dimens GDimens:SizeINSSUB]));
    }];
    BtnSub.hidden = false;
    
    BtnInc = [[UIButton alloc]init];
    [BtnInc setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [BtnInc setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_press"] forState:UIControlStateHighlighted];
    [self addSubview:BtnInc];
    [BtnInc addTarget:self action:@selector(BtnIncClick:) forControlEvents:UIControlEventTouchUpInside];
    [BtnInc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-[Dimens GDimens:40]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:SizeINSSUB], [Dimens GDimens:SizeINSSUB]));

    }];
    BtnInc.hidden = false;
    //长按
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [BtnSub addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [BtnInc addGestureRecognizer:longPressVolAdd];

}
//长按操作

- (void)BtnSubClick:(UIButton*)sender{
    
    if(--DataVal < 0){
        DataVal = 0;
    }
    
    [self.Btn_Volume setTitle:[self getDelayVal] forState:UIControlStateNormal] ;
    self.SB_Volume.value = DataVal;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)BtnIncClick:(UIButton*)sender{
    
    if(++DataVal > DataMax){
        DataVal = DataMax;
    }
    [self.Btn_Volume setTitle:[self getDelayVal] forState:UIControlStateNormal] ;
    self.SB_Volume.value = DataVal;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}

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


- (void)SB_VolumeEvent:(UISlider*)sender{
    DataVal = (int)sender.value;
    [self.Btn_Volume setTitle:[self getDelayVal] forState:UIControlStateNormal] ;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setDelayItemTag:(int)stag{
    tag = stag;
    [self.SB_Volume setTag:stag+TagStart_DelayItem_SB_Volume];
    [self.Btn_Volume setTag:stag+TagStart_DelayItem_Btn_Volume];
    [self.Btn_Channel setTag:stag+TagStart_DelayItem_Btn_Channel];
    [self setTag:stag+TagStart_DelayItem_Self];

}

- (NSString*)getDelayVal{
    switch(delayUnit){
        case DelayUnit_CM: return [self CountDelayCM:DataVal]; break;
        case DelayUnit_MS: return [self CountDelayMs:DataVal]; break;
        case DelayUnit_INCH: return [self CountDelayInch:DataVal]; break;
        default:return [self CountDelayMs:DataVal];
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

- (void)setDelayItemVal:(int)sval{
    DataVal = sval;
    [self.Btn_Volume setTitle:[self getDelayVal] forState:UIControlStateNormal] ;
    self.SB_Volume.value = sval;
}
- (void)setDelayItemMax:(int)sMax{
    DataMax = sMax;
}
- (int)getDelayItemVal{
    return DataVal;
}

- (void)setDelayItemDelayUnit:(int)sDelayUnit{
    delayUnit = sDelayUnit;
    [self.Btn_Volume setTitle:[self getDelayVal] forState:UIControlStateNormal] ;
}


@end

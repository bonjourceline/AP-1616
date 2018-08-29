//
//  GainSBItem.m
//  YBD-DAP460-NDS460
//
//  Created by chsdsp on 2017/6/15.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "SliderButton.h"

#define BtnPart 6
#define TextSizeFrame 40


@implementation SliderButton


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
        WIND_MIN     = MIN(WIND_Width, WIND_Height);
        btnSize = WIND_Width/BtnPart;
        //        NSLog(@"WIND_Width = @%f",WIND_Width);
        //        NSLog(@"WIND_Height = @%f",WIND_Height);
        
        [self setup];
    }
    return self;
}

- (void)setup{
    BOOL_DB = false;
    self.backgroundColor = [UIColor clearColor];
    
    
    mSBGain = [[Slider alloc] initWithFrame:CGRectMake((WIND_Width-WIND_MIN)/2, [Dimens GDimens:10], WIND_MIN, WIND_MIN)];
    [self addSubview:mSBGain];
    //mSBGain.center = self.center;
    [mSBGain addTarget:self action:@selector(mSBGainEventValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    //Max min Text
    Min = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:TextSizeFrame], [Dimens GDimens:TextSizeFrame])];
    [self addSubview:Min];
    [Min setBackgroundColor:[UIColor clearColor]];
    [Min setTextColor:[UIColor whiteColor]];
    Min.text=@"Min";
    Min.textAlignment = NSTextAlignmentCenter;
    Min.adjustsFontSizeToFitWidth = true;
    Min.font = [UIFont systemFontOfSize:10];
    [Min mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mSBGain.mas_left).offset(0);
        make.bottom.equalTo(mSBGain.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TextSizeFrame], [Dimens GDimens:TextSizeFrame]));
    }];
   
    Max = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:TextSizeFrame], [Dimens GDimens:TextSizeFrame])];
    [self addSubview:Max];
    [Max setBackgroundColor:[UIColor clearColor]];
    [Max setTextColor:[UIColor whiteColor]];
    Max.text=@"Max";
    Max.textAlignment = NSTextAlignmentCenter;
    Max.adjustsFontSizeToFitWidth = true;
    Max.font = [UIFont systemFontOfSize:10];
    [Max mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mSBGain.mas_right).offset(0);
        make.bottom.equalTo(mSBGain.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TextSizeFrame], [Dimens GDimens:TextSizeFrame]));
    }];
    
    
    //增减
    BtnSub = [[UIButton alloc]initWithFrame:CGRectMake(0, WIND_Height-btnSize, btnSize, btnSize)];
    [BtnSub setBackgroundImage:[UIImage imageNamed:@"chs_val_sub_normal"] forState:UIControlStateNormal];
    [self addSubview:BtnSub];
    [BtnSub addTarget:self action:@selector(BtnSubClick:) forControlEvents:UIControlEventTouchUpInside];
    
    BtnInc = [[UIButton alloc]initWithFrame:CGRectMake(WIND_Width-btnSize, WIND_Height-btnSize, btnSize, btnSize)];
    [BtnInc setBackgroundImage:[UIImage imageNamed:@"chs_val_inc_normal"] forState:UIControlStateNormal];
    [self addSubview:BtnInc];
    [BtnInc addTarget:self action:@selector(BtnIncClick:) forControlEvents:UIControlEventTouchUpInside];
    BtnInc.hidden=true;
    
    //长按
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [BtnSub addGestureRecognizer:longPressVolMinus];
    
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [BtnInc addGestureRecognizer:longPressVolAdd];
    BtnSub.hidden=true;
    
    mText = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, [Dimens GDimens:30])];
    [self addSubview:mText];
    [mText setBackgroundColor:[UIColor clearColor]];
    mText.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    mText.titleLabel.adjustsFontSizeToFitWidth = true;
    mText.titleLabel.font = [UIFont systemFontOfSize:15];
    //mText.center = mSBGain.center;
    //[mText addTarget:self action:@selector(mTextClick:) forControlEvents:UIControlEventTouchUpInside];

    
    Table = [[UIButton alloc]initWithFrame:CGRectMake(0, WIND_Height-[Dimens GDimens:30], WIND_Width, [Dimens GDimens:30])];
    [self addSubview:Table];
    [Table setBackgroundColor:[UIColor clearColor]];
    Table.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    Table.titleLabel.adjustsFontSizeToFitWidth = true;
    Table.titleLabel.font = [UIFont systemFontOfSize:15];
    [Table setTitle:@"Table" forState:UIControlStateNormal];
    //mText.center = mSBGain.center;
    //[Table addTarget:self action:@selector(mTextClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma 事件响应
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

- (void)BtnSubClick:(UIButton*)sender{

    if(--DataVal < 0){
        DataVal = 0;
    }
    [mSBGain setProgress:DataVal];
    [self ValumeChange];
}

- (void)BtnIncClick:(UIButton*)sender{
    
    if(++DataVal > DataMax){
        DataVal = DataMax;
    }
    [mSBGain setProgress:DataVal];
    [self ValumeChange];
}

- (void)mSBGainEventValueChanged:(Slider*)sender{
    DataVal = [sender GetProgress];
    [self ValumeChange];
}

- (void)mTextClick:(UIButton*)sender{
    
    DataVal = DataMax/2;
    [mSBGain setProgress:DataVal];
    [self ValumeChange];
}


- (void)ValumeChange{
    [mText setTitle:[self ChangeGainValume:DataVal] forState:UIControlStateNormal];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (NSString*)ChangeGainValume:(int) num{
    if(!BOOL_DB){
        return [NSString stringWithFormat:@"%d",num];
    }else{
        return [NSString stringWithFormat:@"%.1fdB",0.0-(DataMax/2-num)/10.0];
    }
}
#pragma 接口
- (void)setMaxProgress:(int)val{
    [mSBGain setMaxProgress:val];
    DataMax = val;
}
- (void)setProgress:(int)val{
    if(val > DataMax){
        val = DataMax;
    }
    
    DataVal = val;
    [mSBGain setProgress:val];
    [mText setTitle:[self ChangeGainValume:DataVal] forState:UIControlStateNormal];
}


- (int)GetProgress{
    return DataVal;
}

- (void)setMidTextString:(NSString*)st{
    [Table setTitle:st forState:UIControlStateNormal];
}
- (void)setShowDB:(BOOL)val{
    BOOL_DB = val;
}
- (void)setVolTextSize:(int)val{
    mText.titleLabel.font = [UIFont systemFontOfSize:val];
}






@end

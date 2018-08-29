//
//  ChannelBtn.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/4/7.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ChannelBtn.h"

#define btn_height 30
#define btn_Div 5

@implementation ChannelBtn

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
    return self;
}
//#define UI_Channel_Btn_Press (0xff1eac4b) //
//#define UI_Channel_Btn_Normal (0xff000000) //
//#define UI_Channel_BtnText_Press (0xFFffffff) //
//#define UI_Channel_BtnText_Normal (0xff000000) //
- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    
    // 2个按钮之间的横间距
    Width_Space = KScreenWidth/(Output_CH_MAX_USE*0.5*btn_Div + (Output_CH_MAX_USE*0.5+1));
    Button_Width = Width_Space*btn_Div;// 宽
    Button_Height=[Dimens GDimens:btn_height];// 高
    Height_Space =[Dimens GDimens:btn_height*0.66];// 竖间距
    
    for (int i = 0; i<Output_CH_MAX_USE; i++) {
        NSInteger x = i % (Output_CH_MAX_USE/2);
        NSInteger y = i / (Output_CH_MAX_USE/2);
        
        Start_X = Width_Space+x*(Button_Width + Width_Space);
        Start_Y = Height_Space+y*(Button_Height + Height_Space);
        
        NormalButton *btn = [[NormalButton alloc]init];
        btn.frame = CGRectMake(Start_X, Start_Y, Button_Width, Button_Height);
        
        [self addSubview:btn];
        [btn setTag:i+TagChannelBtnStart];
        [btn initView:3 withBorderWidth:1 withNormalColor:UI_Channel_Btn_Normal withPressColor:UI_Channel_Btn_Press withType:1];
        [btn setTextColorWithNormalColor:UI_Channel_BtnText_Normal withPressColor:UI_Channel_BtnText_Press];
         btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        if(BOOL_SET_SpkType){
            [btn setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_CH%d",(i+1)]] forState:UIControlStateNormal] ;
        }else{
            switch (i) {
                case 0:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
                    break;
                case 1:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_FrontRight"] forState:UIControlStateNormal] ;
                    break;
                case 2:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_RearLeft"] forState:UIControlStateNormal] ;
                    break;
                case 3:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_RearRight"] forState:UIControlStateNormal] ;
                    break;
                case 4:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_LeftSub"] forState:UIControlStateNormal] ;
                    break;
                case 5:[btn setTitle:[LANG DPLocalizedString:@"L_XOver_RightSub"] forState:UIControlStateNormal] ;
                    break;
                default:
                    break;
            }
        }
        
        if(i==0){
            [btn setPress];
            NB_Btn = btn;
        }else{
            [btn setNormal];
        }
    }
}


- (void)btn_click:(NormalButton*)sender{
    [NB_Btn setNormal];
    
    [sender setPress];
    channel = (int)sender.tag-TagChannelBtnStart;
    NSLog(@"BUG ChannelBtn.Click channel=@%d",channel);
    NB_Btn = sender;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/**/
//获取当前通道
- (int)GetChannelSelected{
    return channel;
}

- (void)setChannelSelected:(int)ch{
    for(int i=0;i<Output_CH_MAX_USE; i++) {
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:i+TagChannelBtnStart];
        
        [find_btn setNormal];
        
        if(i==ch){
            [find_btn setPress];
            NB_Btn = find_btn;
        }
    }
}


@end

//
//  X2S_PageTitleBar.m
//  YB-DAP460-X2S
//
//  Created by chsdsp on 2017/4/27.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ChannelLineBar.h"

#define Btn_start 650
#define view_start 670

@implementation ChannelLineBar

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

- (void)setup{
    // 2个按钮之间的横间距
    Button_Width = KScreenWidth/Output_CH_MAX_USE;// 宽
    Button_Height=[Dimens GDimens:Custom_ChannelBtnHeight];// 高
    int lineWidth = [Dimens GDimens:Custom_ChannelBtnWidth];// 宽
    
    self.backgroundColor = [UIColor clearColor];
    VLine = [[UIView alloc]init];
    VLine.frame = CGRectMake(0, Button_Height-1, KScreenWidth, 1);
    [self addSubview:VLine];
    [VLine setBackgroundColor:SetColor(UI_Channel_line_Normal)];

    
    for (int i = 0; i<Output_CH_MAX_USE; i++) {
        Start_X = Button_Width*i;
        Start_Y = 0;
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.frame = CGRectMake(Start_X, Start_Y, Button_Width, Button_Height);
        [self addSubview:btn];
        [btn setTag:Btn_start+i];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:SetColor(UI_Channel_BtnListText_Normal) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *mV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineWidth, 2)];
        [self addSubview:mV];
        [mV setTag:view_start+i];
        [mV setBackgroundColor:[UIColor clearColor]];
        [mV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(VLine.mas_top).offset([Dimens GDimens:0]);
            make.centerX.equalTo(btn.mas_centerX).offset([Dimens GDimens:0]);
            make.size.mas_equalTo(CGSizeMake(lineWidth, 2));
        }];
        
        
        if(BOOL_SET_SpkType){
            [btn setTitle:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_CH%d",(i+1)]] forState:UIControlStateNormal] ;
            if(i==0){
                NB_Btn = btn;
                Vlines = mV;
                [mV setBackgroundColor:SetColor(UI_Channel_line_Press)];
            }
        }else{
            switch (i) {
                case 0:
                    NB_Btn = btn;
                    Vlines = mV;
                    [mV setBackgroundColor:SetColor(UI_Channel_line_Press)];

                    [btn setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
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
        
    }
    
}

- (void)setChannel:(int)sel{
    channel = sel;
    [NB_Btn setTitleColor:SetColor(UI_Channel_BtnListText_Normal) forState:UIControlStateNormal];
    [Vlines setBackgroundColor:[UIColor clearColor]];
    
    NB_Btn = (UIButton *)[self viewWithTag:channel+Btn_start];
    Vlines = (UIView *)[self viewWithTag:channel+view_start];
    
    [NB_Btn setTitleColor:SetColor(UI_Channel_BtnText_Press) forState:UIControlStateNormal];
    [Vlines setBackgroundColor:SetColor(UI_Channel_line_Press)];
}


- (void)btn_click:(UIButton*)sender{
    channel = (int)sender.tag-Btn_start;
    
    [NB_Btn setTitleColor:SetColor(UI_Channel_BtnListText_Normal) forState:UIControlStateNormal];
    [Vlines setBackgroundColor:[UIColor clearColor]];
    
    NB_Btn = sender;
    Vlines = (UIView *)[self viewWithTag:channel+view_start];

    [sender setTitleColor:SetColor(UI_Channel_BtnText_Press) forState:UIControlStateNormal];
    [Vlines setBackgroundColor:SetColor(UI_Channel_line_Press)];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/**/
//获取当前通道
-(int)getChannel{
    return channel;
}

@end

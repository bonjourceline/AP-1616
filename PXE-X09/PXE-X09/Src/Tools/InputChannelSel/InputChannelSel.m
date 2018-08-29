//
//  InputChannelSel.m
//  KP_DBP410_CF_A10S
//
//  Created by chsdsp on 2017/6/26.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "InputChannelSel.h"

@implementation InputChannelSel



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
        //        NSLog(@"WIND_Width = @%f",WIND_Width);
        //        NSLog(@"WIND_Height = @%f",WIND_Height);
        
        [self setup];
    }
    return self;
}

- (void)setup{
    side=[Dimens GDimens:MasterBtn_Height]/5;
    BOOL_LINKA = false;
    BOOL_LINKB = false;
    channelStart = 0;
    CurChannel = 0;
    event = EVENT_CH;
    self.backgroundColor = [UIColor clearColor];
    
    ch1 = [[NormalButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [ch1 setTag:0];
    [self addSubview:ch1];
    [ch1 initView:3 withBorderWidth:1 withNormalColor:UI_InputCh_Btn_Normal withPressColor:UI_InputCh_Btn_Press withType:1];
    [ch1 setTitleColor:SetColor(UI_InputCh_BtnText_Normal) forState:UIControlStateNormal];
    [ch1 setTextColorWithNormalColor:UI_InputCh_BtnText_Normal withPressColor:UI_InputCh_BtnText_Press];
    [ch1 addTarget:self action:@selector(ch_click:) forControlEvents:UIControlEventTouchUpInside];
    [ch1 setTitle:@"1" forState:UIControlStateNormal] ;
    ch1.titleLabel.adjustsFontSizeToFitWidth = true;
    ch1.titleLabel.font = [UIFont systemFontOfSize:13];
    
    ch2 = [[NormalButton alloc]initWithFrame:CGRectMake(([Dimens GDimens:MasterBtn_Height]+side)*2, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [ch2 setTag:1];
    [self addSubview:ch2];
    [ch2 setTitleColor:SetColor(UI_InputCh_BtnText_Normal) forState:UIControlStateNormal];
    [ch2 initView:3 withBorderWidth:1 withNormalColor:UI_InputCh_Btn_Normal withPressColor:UI_InputCh_Btn_Press withType:1];
    [ch2 setTextColorWithNormalColor:UI_InputCh_BtnText_Normal withPressColor:UI_InputCh_BtnText_Press];
    [ch2 addTarget:self action:@selector(ch_click:) forControlEvents:UIControlEventTouchUpInside];
    [ch2 setTitle:@"2" forState:UIControlStateNormal] ;
    ch2.titleLabel.adjustsFontSizeToFitWidth = true;
    ch2.titleLabel.font = [UIFont systemFontOfSize:13];
    

    ch3 = [[NormalButton alloc]initWithFrame:CGRectMake(([Dimens GDimens:MasterBtn_Height]+side)*4, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [ch3 setTag:2];
    [self addSubview:ch3];
    [ch3 setTitleColor:SetColor(UI_InputCh_BtnText_Normal) forState:UIControlStateNormal];
    [ch3 initView:3 withBorderWidth:1 withNormalColor:UI_InputCh_Btn_Normal withPressColor:UI_InputCh_Btn_Press withType:1];
    [ch3 setTextColorWithNormalColor:UI_InputCh_BtnText_Normal withPressColor:UI_InputCh_BtnText_Press];
    [ch3 addTarget:self action:@selector(ch_click:) forControlEvents:UIControlEventTouchUpInside];
    [ch3 setTitle:@"3" forState:UIControlStateNormal] ;
    ch3.titleLabel.adjustsFontSizeToFitWidth = true;
    ch3.titleLabel.font = [UIFont systemFontOfSize:13];

    ch4 = [[NormalButton alloc]initWithFrame:CGRectMake(([Dimens GDimens:MasterBtn_Height]+side)*6, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [ch4 setTag:3];
    [self addSubview:ch4];
    [ch4 setTitleColor:SetColor(UI_InputCh_BtnText_Normal) forState:UIControlStateNormal];
    [ch4 initView:3 withBorderWidth:1 withNormalColor:UI_InputCh_Btn_Normal withPressColor:UI_InputCh_Btn_Press withType:1];
    [ch4 setTextColorWithNormalColor:UI_InputCh_BtnText_Normal withPressColor:UI_InputCh_BtnText_Press];
    [ch4 addTarget:self action:@selector(ch_click:) forControlEvents:UIControlEventTouchUpInside];
    [ch4 setTitle:@"4" forState:UIControlStateNormal] ;
    ch4.titleLabel.adjustsFontSizeToFitWidth = true;
    ch4.titleLabel.font = [UIFont systemFontOfSize:13];
    //联调
    LinkA = [[UIButton alloc]initWithFrame:CGRectMake(([Dimens GDimens:MasterBtn_Height]+side)*1, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [self addSubview:LinkA];
    //[LinkA setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
    [LinkA addTarget:self action:@selector(LinkA_click:) forControlEvents:UIControlEventTouchUpInside];
    
    //联调
    LinkB = [[UIButton alloc]initWithFrame:CGRectMake(([Dimens GDimens:MasterBtn_Height]+side)*5, 0, [Dimens GDimens:MasterBtn_Height], [Dimens GDimens:MasterBtn_Height])];
    [self addSubview:LinkB];
    //[LinkB setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
    [LinkB addTarget:self action:@selector(LinkB_click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ch_click:(NormalButton*)sender{
    CurChannel = (int)sender.tag + channelStart;
    [self setAllBtnNoraml];
    [self setBtnPressByIndex:CurChannel - channelStart];
    
    if((BOOL_LINKA)&&((int)sender.tag <= 1 )){
        [self setBtnPressByIndex:0];
        [self setBtnPressByIndex:1];
    }
    if((BOOL_LINKB)&&((int)sender.tag >= 2 )){
        [self setBtnPressByIndex:2];
        [self setBtnPressByIndex:3];
    }
    
    event = EVENT_CH;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)LinkA_click:(UIButton*)sender{
//    if(BOOL_LINKA){
//        BOOL_LINKA = false;
//        [LinkA setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
//        [self setAllBtnNoraml];
//        [self setBtnPressByIndex:0];
//    }else{
//        BOOL_LINKA = true;
//        [LinkA setBackgroundImage:[UIImage imageNamed:@"input_link_press"] forState:UIControlStateNormal];
//        [self setAllBtnNoraml];
//        [self setBtnPressByIndex:0];
//        [self setBtnPressByIndex:1];
//    }
    
//    CurChannel = channelStart;
    event = EVENT_LINKA;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)LinkB_click:(UIButton*)sender{
//    if(BOOL_LINKB){
//        BOOL_LINKB = false;
//        [LinkB setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
//        [self setAllBtnNoraml];
//        [self setBtnPressByIndex:2];
//    }else{
//        BOOL_LINKB = true;
//        [LinkB setBackgroundImage:[UIImage imageNamed:@"input_link_press"] forState:UIControlStateNormal];
//        [self setAllBtnNoraml];
//        [self setBtnPressByIndex:2];
//        [self setBtnPressByIndex:3];
//    }
//    CurChannel = channelStart+2;
    event = EVENT_LINKB;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setAllBtnNoraml{
    [ch1 setNormal];
    [ch2 setNormal];
    [ch3 setNormal];
    [ch4 setNormal];
}

- (void)setBtnPressByIndex:(int)index{
    
    switch (index) {
        case 0: [ch1 setPress]; break;
        case 1: [ch2 setPress]; break;
        case 2: [ch3 setPress]; break;
        case 3: [ch4 setPress]; break;
        default:
            break;
    }
    
}


#pragma 接口
- (void)setChannelStart:(int)val{
    channelStart = val;
    

}

- (void)setCurChannel:(int)val{
    CurChannel = val;
    [self setAllBtnNoraml];
    [self setBtnPressByIndex:CurChannel - channelStart];
    
    if((BOOL_LINKA)&&((CurChannel -channelStart) <= 1 )){
        [self setBtnPressByIndex:0];
        [self setBtnPressByIndex:1];
    }
    if((BOOL_LINKB)&&((CurChannel -channelStart) >= 2 )){
        [self setBtnPressByIndex:2];
        [self setBtnPressByIndex:3];
    }
}


- (void)setLinkA:(BOOL)val{
    BOOL_LINKA = val;
    if(BOOL_LINKA){
        [LinkA setBackgroundImage:[UIImage imageNamed:@"input_link_press"] forState:UIControlStateNormal];
        [self setAllBtnNoraml];
        [self setBtnPressByIndex:0];
        [self setBtnPressByIndex:1];
    }else{
        [LinkA setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
        [self setAllBtnNoraml];
        [self setBtnPressByIndex:0];

    }
    CurChannel = channelStart;
}

- (void)setLinkB:(BOOL)val{
    BOOL_LINKB = val;
    if(BOOL_LINKB){
        [LinkB setBackgroundImage:[UIImage imageNamed:@"input_link_press"] forState:UIControlStateNormal];
        [self setAllBtnNoraml];
        [self setBtnPressByIndex:2];
        [self setBtnPressByIndex:3];
    }else{
        [LinkB setBackgroundImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
        [self setAllBtnNoraml];
        [self setBtnPressByIndex:2];
        
    }
    CurChannel = channelStart+2;
}


- (int)getCurChannel{
    return CurChannel;
}


- (BOOL)getLinkA{
    return BOOL_LINKA;
}


- (BOOL)getLinkB{
    return BOOL_LINKB;
}


- (int)getEvent{
    return event;
}



@end

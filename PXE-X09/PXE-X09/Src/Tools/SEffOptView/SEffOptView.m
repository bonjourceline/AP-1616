//
//  SEffOptView.m
//  YB-DAP612(H680)
//
//  Created by chsdsp on 2017/4/14.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "SEffOptView.h"

//通道按键选择
#define Color_SEffOptViewBg (0x88000000) //屏蔽层


@implementation SEffOptView


- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    self.Btn_SEffOptView_Bg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.Btn_SEffOptView_Bg setBackgroundColor:SetColor(Color_SEffOptViewBg)];
    [self addSubview:self.Btn_SEffOptView_Bg];
    
}

@end

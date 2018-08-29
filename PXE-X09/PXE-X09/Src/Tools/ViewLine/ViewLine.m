//
//  ViewLine.m
//  YB-DAP460-X2S
//
//  Created by chsdsp on 2017/4/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ViewLine.h"

@implementation ViewLine
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

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:ViewLineHeight]);

    VLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:Line1Height])];
    [self addSubview:VLine1];
    [VLine1 setBackgroundColor:SetColor(UI_Line1_Color)];
    
    VLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:Line1Height], KScreenWidth, [Dimens GDimens:Line2Height])];
    [self addSubview:VLine1];
    [VLine1 setBackgroundColor:SetColor(UI_Line2_Color)];

}
@end

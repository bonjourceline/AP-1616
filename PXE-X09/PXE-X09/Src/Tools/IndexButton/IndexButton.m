//
//  NormalButton.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "IndexButton.h"



@implementation IndexButton

- (instancetype)init{
    
    
    
    self = [super init];
    if (self) {

    }
    return self;
}



- (void)initView:(float) CornerRadius withBorderWidth: (float)BorderWidth withNormalColor: (int32_t) NormalColor withPressColor: (int32_t)PressColor withType: (int32_t)Type{
    
    cornerRadius = CornerRadius;
    borderWidth = BorderWidth;
    normalColor = NormalColor;
    pressColor  = PressColor;
    if(Type > 4){
        Type = 1;
    }
    UIB_Type = Type;
    
    CGColorSpaceRef colorSpaceWhite = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorrefWhite = CGColorCreate(colorSpaceWhite,(CGFloat[]){((normalColor>>16)&0x00ff)/255.0 ,((normalColor>>8)&0x00ff)/255.0,(normalColor&0x000000ff)/255.0,((normalColor>>24)&0x00ff)/255.0});
    
    [self setImage:[[UIImage imageNamed:@"index_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //self.imageView.contentMode = UIViewContentModeRight;
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = self.frame.size.width-self.frame.size.height*0.65,
        .bottom = 0,
        .right  = 0,
    };
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = self.frame.size.height,
    };

    
    if((UIB_Type == 0)||(UIB_Type == 1)){
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:CornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:BorderWidth];   //边框宽度
        [self.layer setBorderColor:colorrefWhite]; //边框颜色
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 2)||(UIB_Type == 3)){//实心
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:CornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:0];   //边框宽度
        [self.layer setBorderColor:colorrefWhite]; //边框颜色
        self.backgroundColor = SetColor(normalColor);
    }
}
//0:Normal  空心 Press：空心
//1:Normal  空心 Press：实心
//2:Normal  实心 Press：空心
//3:Normal  实心 Press：实心

- (void) setNormal{
    if((UIB_Type == 0)||(UIB_Type == 1)){//空心
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = [UIColor clearColor];
        
    }else if((UIB_Type == 2)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = SetColor(normalColor);
    }
}
- (void) setPress{
    if((UIB_Type == 0)||(UIB_Type == 2)){//空心
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 1)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = SetColor(pressColor);
        //[self setTitleColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forState:UIControlStateHighlighted];
    }
}

- (void) setDisable{
    if((UIB_Type == 0)||(UIB_Type == 2)){//空心
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 1)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = SetColor(pressColor);
        //[self setTitleColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forState:UIControlStateHighlighted];
    }
}


@end

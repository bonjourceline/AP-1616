//
//  NormalButton.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "NormalButton.h"
#import "Define_Color.h"
@implementation NormalButton

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setButtonContentCenterWithTextPressColor:(int32_t)PressColor withTextNormalColor:(int32_t)normalColor{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    //设置按钮内边距
    imgViewSize = self.imageView.bounds.size;
    titleSize = self.titleLabel.bounds.size;
    btnSize = self.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [self setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    
    
    [self setTitleEdgeInsets:titleEdge];
    textPressColor=PressColor;
    textNormalColor=normalColor;
    
}
- (void)initView:(float) CornerRadius
 withBorderWidth: (float)BorderWidth
 withNormalColor: (int32_t) NormalColor
  withPressColor: (int32_t)PressColor
        withType: (int32_t)Type{
    
    cornerRadius = CornerRadius;
    borderWidth  = BorderWidth;
    //按键实心颜色
    normalColor  = NormalColor;
    pressColor   = PressColor;
    //按键字体颜色
    textPressColor  = normalColor;
    textNormalColor = pressColor;
    //按键边框颜色
    BorderNormalColor = normalColor;
    BorderPressColor  = pressColor;
    
    UIB_Type = Type;
    
    [self setUp];
}

- (void)initViewBroder:(float) CornerRadius
       withBorderWidth: (float)BorderWidth
       withNormalColor: (int32_t)NormalColor
        withPressColor: (int32_t)PressColor
 withBorderNormalColor: (int32_t)BorderNormalColorS
  withBorderPressColor: (int32_t)BorderPressColorS
   withTextNormalColor: (int32_t)TextNormalColorS
    withTextPressColor: (int32_t)TextPressColorS
              withType: (int32_t)Type{
    
    cornerRadius = CornerRadius;
    borderWidth  = BorderWidth;
    //按键实心颜色
    normalColor  = NormalColor;
    pressColor   = PressColor;
    //按键字体颜色
    textPressColor  = TextPressColorS;
    textNormalColor = TextNormalColorS;
    //按键边框颜色
    BorderNormalColor = BorderNormalColorS;
    BorderPressColor  = BorderPressColorS;
    
    UIB_Type = Type;
    
    [self setUp];
}

- (void)setUp{
    //self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    normalColorrefWhite = SetColor(BorderNormalColor).CGColor;
    
    pressColorSpaceWhite = CGColorSpaceCreateDeviceRGB();
    pressColorrefWhite = SetColor(BorderPressColor).CGColor;
    
    if((UIB_Type == 0)||(UIB_Type == 1)){
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 2)||(UIB_Type == 3)){//实心
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
        self.backgroundColor = SetColor(normalColor);
    }else if(UIB_Type == 4){
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
        //        [self setImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
//        [self setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
        self.backgroundColor = SetColor(normalColor);
    }else if(UIB_Type==5){//空心加图片
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
        [self setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
        self.backgroundColor=[UIColor clearColor];
        //        self.backgroundColor = SetColor(normalColor);
    }
    
}
//0:Normal  空心 Press：空心
//1:Normal  空心 Press：实心
//2:Normal  实心 Press：空心
//3:Normal  实心 Press：实心

- (void) setNormal{
    [self setTitleColor:SetColor(textNormalColor) forState:UIControlStateNormal];
    if((UIB_Type == 0)||(UIB_Type == 1)){//空心
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = [UIColor clearColor];
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
    }else if((UIB_Type == 2)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = SetColor(normalColor);
    }else if(UIB_Type == 4){
//        [self setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = SetColor(normalColor);
        [self.layer setBorderColor:SetColor(BorderNormalColor).CGColor]; //边框颜色
    }else if(UIB_Type == 5){
        [self setBackgroundImage:[UIImage imageNamed:@"use_group_normal"] forState:UIControlStateNormal];
    }
}
- (void) setPress{
    [self setTitleColor:SetColor(textPressColor) forState:UIControlStateNormal];
    if((UIB_Type == 0)||(UIB_Type == 2)){//空心
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(BorderPressColor).CGColor]; //边框颜色
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 1)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:borderWidth]; //边框宽度
        self.backgroundColor = SetColor(pressColor);
        [self.layer setBorderColor:SetColor(BorderPressColor).CGColor];
        //[self setTitleColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forState:UIControlStateHighlighted];
    }else if(UIB_Type == 4){
        self.backgroundColor = [UIColor clearColor];
//        [self setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateNormal];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = SetColor(pressColor);
        [self.layer setBorderColor:SetColor(BorderPressColor).CGColor]; //边框颜色
    }else if(UIB_Type == 5){
        [self setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateNormal];
    }
}
- (void) setPress:(int32_t)PressColor{
    
    if((UIB_Type == 0)||(UIB_Type == 2)){//空心
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        [self.layer setBorderColor:SetColor(PressColor).CGColor]; //边框颜色
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 1)||(UIB_Type == 3)){//实心
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = SetColor(PressColor);
        //[self setTitleColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forState:UIControlStateHighlighted];
    }else if(UIB_Type == 4){
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = SetColor(PressColor);
        [self.layer setBorderColor:SetColor(PressColor).CGColor]; //边框颜色
    }else if(UIB_Type==5){
        [self setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateNormal];
    }
}
- (void) setDisable{
    [self setTitleColor:SetColor(textPressColor) forState:UIControlStateNormal];
    if((UIB_Type == 0)||(UIB_Type == 2)){//空心
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = [UIColor clearColor];
    }else if((UIB_Type == 1)||(UIB_Type == 3)){//实心
        [self.layer setBorderWidth:0]; //边框宽度
        self.backgroundColor = [UIColor redColor];
        //[self setTitleColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forState:UIControlStateHighlighted];
    }else if(UIB_Type == 4){
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:borderWidth];   //边框宽度
        self.backgroundColor = SetColor(pressColor);
        [self.layer setBorderColor:SetColor(BorderPressColor).CGColor]; //边框颜色
    }else if(UIB_Type==5){
        [self setBackgroundImage:[UIImage imageNamed:@"use_group_press"] forState:UIControlStateNormal];
    }
}

//设置文字颜色
- (void)setTextColorWithNormalColor:(int32_t)setNormalColor withPressColor:(int32_t)setPressColor{
    textPressColor = setPressColor;
    textNormalColor= setNormalColor;
}

@end


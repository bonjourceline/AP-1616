//
//  NormalButton.h
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalButton : UIButton{
    
    @private
    float cornerRadius;
    float borderWidth;
    
    int32_t textNormalColor;
    int32_t textPressColor;
    
    int32_t normalColor;
    int32_t pressColor;
    
    int32_t BorderNormalColor;
    int32_t BorderPressColor;
    
    int32_t UIB_Type;
    
    CGColorSpaceRef normalColorSpaceWhite;
    CGColorRef normalColorrefWhite;
    
    CGColorSpaceRef pressColorSpaceWhite;
    CGColorRef pressColorrefWhite;
    //0:Normal  空心 Press：空心
    //1:Normal  空心 Press：实心
    //2:Normal  实心 Press：空心
    //3:Normal  实心 Press：实心
    //4:Normal  实心 Press：实心
}
- (void)initViewBroder:(float) CornerRadius
    withBorderWidth: (float)BorderWidth
    withNormalColor: (int32_t)NormalColor
    withPressColor: (int32_t)PressColor
    withBorderNormalColor: (int32_t)BorderNormalColorS
    withBorderPressColor: (int32_t)BorderPressColorS
    withTextNormalColor: (int32_t)TextNormalColorS
    withTextPressColor: (int32_t)TextPressColorS
    withType: (int32_t)Type;

- (void)initView:(float) CornerRadius withBorderWidth: (float)BorderWidth withNormalColor: (int32_t) NormalColor withPressColor: (int32_t)PressColor withType: (int32_t)Type;
//设置文字颜色
- (void)setTextColorWithNormalColor:(int32_t)setNormalColor withPressColor:(int32_t)setPressColor;
- (void) setNormal;
- (void) setPress;
- (void) setDisable;
//图片文字上下垂直
-(void)setButtonContentCenterWithTextPressColor:(int32_t)PressColor withTextNormalColor:(int32_t)normalColor;
@property (assign, nonatomic) int GStatus;//0:原始，1：将要加入的，2：已经加入的
@property (assign, nonatomic) int Group;//
- (void) setPress:(int32_t)PressColor;
@end

//
//  NormalButton.h
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexButton : UIButton{
    
    @private
    float cornerRadius;
    float borderWidth;
    
    int32_t normalColor;
    int32_t pressColor;
    int32_t UIB_Type;
    //0:Normal  空心 Press：空心
    //1:Normal  空心 Press：实心
    //2:Normal  实心 Press：空心
    //3:Normal  实心 Press：实心
}
- (void)initView:(float) CornerRadius withBorderWidth: (float)BorderWidth withNormalColor: (int32_t) NormalColor withPressColor: (int32_t)PressColor withType: (int32_t)Type;

- (void) setNormal;
- (void) setPress;

@end

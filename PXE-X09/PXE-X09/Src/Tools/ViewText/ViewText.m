//
//  ViewText.m
//  YB-DAP460-X2S
//
//  Created by chsdsp on 2017/4/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ViewText.h"

@implementation ViewText

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
    self.frame = CGRectMake(0, 0, [Dimens GDimens:ViewTextWidth], [Dimens GDimens:ViewTextHeight]);
    self.mView = [[UIButton alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:ViewTextTop], [Dimens GDimens:ViewHeight], [Dimens GDimens:ViewHeight])];
    [self addSubview:self.mView];
    //[self.mView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chs_seff_null"]]];
    //[self setUIViewBackgound:self.mView name:@"chs_seff_null"];
    
    self.mLable  = [[UILabel alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:ViewHeight+ViewTextTop], [Dimens GDimens:ViewHeight], [Dimens GDimens:TextHeight])];
    [self addSubview:self.mLable];
    [self.mLable setBackgroundColor:[UIColor clearColor]];
    [self.mLable setTextColor:SetColor(UI_ViewText_Normal)];
    self.mLable.text = @"";
    self.mLable.adjustsFontSizeToFitWidth = true;
    self.mLable.font = [UIFont systemFontOfSize:11];
    self.mLable.textAlignment = NSTextAlignmentCenter;

}
//-(void)setUIViewBackgound:(UIView *)uiview name:(NSString *)name {
//    
//    UIGraphicsBeginImageContext(uiview.frame.size);
//    [[UIImage imageNamed:name] drawInRect:uiview.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    uiview.backgroundColor = [UIColor colorWithPatternImage:image];
//}
- (void)setTag:(int)stag{
    tag=stag;
}
@end

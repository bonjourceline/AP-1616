//
//  HiAuxItem.m
//  PXE-X09
//
//  Created by chs on 2018/9/28.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "HiAuxItem.h"
#import "Masonry.h"
#define bgColorNormal (0xFF5a6571)
#define bgColorPress  (0xFF37a3ff)
#define textColorNormal     (0xFFffffff)
#define imagebgNormal (0xFF191f25)
#define imagebgPress  (0x7F191f25)
@implementation HiAuxItem{
    UIView *grayView;
}
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
-(void)setup{
    self.layer.cornerRadius=5;
    self.layer.masksToBounds=YES;
    
    self.userInteractionEnabled=YES;
    
    self.typeImageView=[[UIImageView alloc]init];
    self.typeImageView.userInteractionEnabled=YES;
    self.typeImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.typeImageView.backgroundColor=SetColor(imagebgNormal);
    [self addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset([Dimens GDimens:20]);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    grayView=[[UIView alloc]init];
    grayView.backgroundColor=SetColor(imagebgPress);
    [self.typeImageView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset([Dimens GDimens:20]);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    
    self.bgView=[[UIView alloc]init];
    self.bgView.userInteractionEnabled=YES;
    self.bgView.layer.cornerRadius=5;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.borderWidth=1;
    self.bgView.layer.borderColor=SetColor(bgColorNormal).CGColor;
    [self addSubview:self.bgView];
    //    self.bgView.backgroundColor=SetColor(bgColorNormal);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.typeName=[[UILabel alloc]init];
    [self.bgView addSubview:self.typeName];
    self.typeName.font=[UIFont systemFontOfSize:12];
    self.typeName.numberOfLines=2;
    self.typeName.adjustsFontSizeToFitWidth=YES;
    self.typeName.textAlignment=NSTextAlignmentCenter;
    self.typeName.backgroundColor=SetColor(bgColorNormal);
    self.typeName.textColor=SetColor(textColorNormal);
    [self.typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo([Dimens GDimens:35]);
    }];
    [self setNormal];
}
-(void)setPress{
    self.typeName.backgroundColor=SetColor(bgColorPress);
    self.bgView.layer.borderColor=SetColor(bgColorPress).CGColor;
    grayView.hidden=YES;
}
-(void)setNormal{
    self.typeName.backgroundColor=SetColor(bgColorNormal);
    self.bgView.layer.borderColor=SetColor(bgColorNormal).CGColor;
    grayView.hidden=NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [super touchesBegan:touches withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

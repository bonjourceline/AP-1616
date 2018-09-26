//
//  SourceItem.m
//  PXE-X09
//
//  Created by chs on 2018/9/17.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "SourceItem.h"
#import "Masonry.h"
@implementation SourceItem
{
    BOOL isSelected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.logoImage=[[UIImageView alloc]init];
    [self addSubview:self.logoImage];
    self.logoImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    self.SoucreTitle=[[UILabel alloc]init];
    self.SoucreTitle.font=[UIFont systemFontOfSize:15];
    self.SoucreTitle.textColor=[UIColor whiteColor];
    [self addSubview:self.SoucreTitle];
    [self.SoucreTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImage.mas_centerY);
        make.left.equalTo(self.logoImage.mas_right).offset([Dimens GDimens:8]);
    }];
    self.selectBtn=[[UIButton alloc]init];
    [self addSubview:self.selectBtn];
    self.selectBtn.contentMode=UIViewContentModeScaleAspectFit;
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset([Dimens GDimens:-20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:45]));
    }];
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=SetColor(0xff2c363e);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.mas_left);
        make.right.equalTo(self.SoucreTitle.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}
-(void)selectSource:(UIButton *)sender{
    isSelected=!isSelected;
    [self flashSelect:isSelected];
}
-(void)flashSelect:(BOOL)isChoose{
    if (isChoose) {
        isSelected=YES;
        [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        isSelected=NO;
        [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}
@end

//
//  DelayCollectionViewCell.m
//  HH-RDDSP
//
//  Created by chs on 2018/3/27.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "DelayCollectionViewCell.h"
#import "Masonry.h"
#import "Dimens.h"
#import "MacDefine.h"
@implementation DelayCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UIView *view=[[UIView alloc]initWithFrame:self.contentView.frame];
    view.layer.cornerRadius=5;
    view.layer.masksToBounds=YES;
    view.backgroundColor=[UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.1];
    [self.contentView addSubview:view];
    //    self.backgroundColor=[UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.3];
    self.chLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.chLab.textAlignment=NSTextAlignmentLeft;
    self.chLab.textColor=[UIColor whiteColor];
    self.chLab.font=[UIFont systemFontOfSize:13];
    self.chLab.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:self.chLab];
    [self.chLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset([Dimens GDimens:20]);
        make.top.equalTo(self.contentView.mas_top).offset([Dimens GDimens:10]);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.volValue=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.volValue.textColor=[UIColor whiteColor];
    self.volValue.text=@"0";
    self.volValue.font=[UIFont systemFontOfSize:13];
    self.volValue.textAlignment=NSTextAlignmentRight;
    self.volValue.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:self.volValue];
    [self.volValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chLab.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset([Dimens GDimens:-20]);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.delaySlider=[[UISlider alloc]initWithFrame:CGRectMake(0,0, 30, 30)];
    [self.contentView addSubview:self.delaySlider];
    self.delaySlider.minimumValue=0;
    self.delaySlider.maximumValue=DELAY_SETTINGS_MAX;
    [self.delaySlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
    [self.delaySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset([Dimens GDimens:20]);
        make.left.equalTo(self.contentView.mas_left).offset([Dimens GDimens:20]);
        make.right.equalTo(self.contentView.mas_right).offset([Dimens GDimens:-20]);
    }];
}
-(void)changeValue{
    self.valueChangeBlock(self.delaySlider, self.volValue,self.selectIndex);
}
@end


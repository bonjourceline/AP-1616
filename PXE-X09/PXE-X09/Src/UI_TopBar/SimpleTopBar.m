//
//  SimpleTopBar.m
//  YB-DAP460-X2
//
//  Created by chsdsp on 2017/7/5.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "SimpleTopBar.h"

@implementation SimpleTopBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}


- (void) initView{
    [self setBackgroundColor:SetColor(UI_SimpleTopbarBackgroundColor)];
    //1.创建UI
    self.Btn_Back    = [[UIButton alloc] init];
    self.lab_Title   = [[UILabel  alloc] init];
    self.Btn_Settings    = [[UIButton alloc] init];
    
    
    [self addSubview:self.Btn_Back];
    [self addSubview:self.lab_Title];
    [self addSubview:self.Btn_Settings];
    //设置返回
    //[self.Btn_Back addTarget:self action:@selector(ClickEventOfBack) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Back setImage:[[UIImage imageNamed:[PIMG DPIMG:@"topbar_back"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.Btn_Back setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.textColor = SetColor(UI_ToolbarBackTextColor);
    [self.Btn_Back setTitleColor:SetColor(UI_ToolbarBackTextColor) forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Back.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_Back.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_Back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_Back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.Btn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:15]);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(TopBarLogoWidth, [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    //设置主题
    self.lab_Title.textColor = SetColor(UI_ToolbarTitleColor);
    self.lab_Title.adjustsFontSizeToFitWidth = true;
    self.lab_Title.font = [UIFont systemFontOfSize:20];
    self.lab_Title.textAlignment = NSTextAlignmentCenter;
    self.lab_Title.text = [LANG DPLocalizedString:@"L_Ad_Title"];
    self.lab_Title.hidden = false;
    [self.lab_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:150], [Dimens GDimens:TopBarLogoHeight]));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.Btn_Settings setTitle:[LANG DPLocalizedString:@"L_Out_Reset"] forState:UIControlStateNormal];
    self.Btn_Settings.titleLabel.textColor = SetColor(UI_ToolbarBackTextColor);
    [self.Btn_Settings setTitleColor:SetColor(UI_ToolbarBackTextColor) forState:UIControlStateNormal];
    self.Btn_Settings.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Settings.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_Settings.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_Settings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.Btn_Settings.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.Btn_Settings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-[Dimens GDimens:15]);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(TopBarLogoWidth, [Dimens GDimens:TopBarLogoHeight]));
    }];
    
    self.Btn_Settings.hidden = true;
}

@end

//
//  OutputPageViewController.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OutputPageViewController.h"

#import "MacDefine.h"
#import "Masonry.h"





@interface OutputPageViewController ()

@end

@implementation OutputPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
#pragma mark initView

- (void)initView{
    self.IV_ChannelSwitch = [[UIImageView alloc]init];
    [self.view addSubview:self.IV_ChannelSwitch];
    [self.IV_ChannelSwitch setImage:[UIImage imageNamed:@"output_funs_output"]];
    [self.IV_ChannelSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:80]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:300], [Dimens GDimens:35]));
    }];
    
    self.Btn_OutputPage = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_OutputPage];
    [self.Btn_OutputPage setBackgroundColor:[UIColor clearColor]];
    [self.Btn_OutputPage setTitleColor:SetColor(UI_OutputPageSwitch_Press) forState:UIControlStateNormal];
    [self.Btn_OutputPage addTarget:self action:@selector(Btn_OutputPage_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_OutputPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_OutputPage.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_OutputPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IV_ChannelSwitch.mas_top).offset(0);
        make.left.equalTo(self.IV_ChannelSwitch.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:35]));
    }];
    
    self.Btn_EQPage = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_EQPage];
    [self.Btn_EQPage setBackgroundColor:[UIColor clearColor]];
    [self.Btn_EQPage setTitleColor:SetColor(UI_OutputPageSwitch_Normal) forState:UIControlStateNormal];
    [self.Btn_EQPage addTarget:self action:@selector(Btn_EQPage_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_EQPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_EQPage.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_EQPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IV_ChannelSwitch.mas_top).offset(0);
        make.centerX.equalTo(self.IV_ChannelSwitch.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:35]));
    }];

    self.Btn_DelayPage = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_DelayPage];
    [self.Btn_DelayPage setBackgroundColor:[UIColor clearColor]];
    [self.Btn_DelayPage setTitleColor:SetColor(UI_OutputPageSwitch_Normal) forState:UIControlStateNormal];
    [self.Btn_DelayPage addTarget:self action:@selector(Btn_DelayPage_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_DelayPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_DelayPage.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_DelayPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IV_ChannelSwitch.mas_top).offset(0);
        make.right.equalTo(self.IV_ChannelSwitch.mas_right).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:35]));
    }];

    //初始化通道选择按键
    [self.Btn_OutputPage setTitle:[LANG DPLocalizedString:@"L_TabBar_Output"] forState:UIControlStateNormal];
    [self.Btn_EQPage setTitle:[LANG DPLocalizedString:@"L_TabBar_EQ"] forState:UIControlStateNormal];
    [self.Btn_DelayPage setTitle:[LANG DPLocalizedString:@"L_TabBar_Delay"] forState:UIControlStateNormal];
    
    self.Btn_OutputPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_OutputPage.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_EQPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_EQPage.titleLabel.font = [UIFont systemFontOfSize:13];
    self.Btn_DelayPage.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_DelayPage.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    //加载其他按键器
    self.mXOverOutputPage = [[XOverOutputViewController alloc]init];
    self.mEQPage = [[EQViewController alloc]init];
    self.mDelayPage = [[DelayViewController alloc]init];
    
    [self addChildViewController:self.mXOverOutputPage];
    [self.view addSubview:self.mXOverOutputPage.view];
    [self addChildViewController:self.mEQPage];
    [self.view addSubview:self.mEQPage.view];
    [self addChildViewController:self.mDelayPage];
    [self.view addSubview:self.mDelayPage.view];
    
    frameStartY = [Dimens GDimens:120];
    //frameEndY = KScreenHeight-[Dimens GDimens:OutputPageStartX] - [Dimens GDimens:ButtomBarHeight]-[Dimens GDimens:TopBarHeight];
    frameEndY = KScreenHeight;
    
    self.mXOverOutputPage.view.frame = CGRectMake(0, frameStartY+[Dimens GDimens:8], KScreenWidth, frameEndY);
    self.mEQPage.view.frame = CGRectMake(0, frameStartY, KScreenWidth, frameEndY);
    self.mDelayPage.view.frame = CGRectMake(0, frameStartY+[Dimens GDimens:8], KScreenWidth, frameEndY);
    
//    [self.mXOverOutputPage.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.mas_equalTo(5);
//        make.top.mas_equalTo(self.IV_ChannelSwitch.mas_bottom).offset([Dimens GDimens:OutputPageMarginTop]);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-ButtomBarHeight);
//    }];
//    [self.mEQPage.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.mas_equalTo(5);
//        make.top.mas_equalTo(self.IV_ChannelSwitch.mas_bottom).offset([Dimens GDimens:OutputPageMarginTop]);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-ButtomBarHeight);
//    }];
//    [self.mDelayPage.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.mas_equalTo(5);
//        make.top.mas_equalTo(self.IV_ChannelSwitch.mas_bottom).offset([Dimens GDimens:OutputPageMarginTop]);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-ButtomBarHeight);
//    }];
    
    [self.IV_ChannelSwitch setImage:[UIImage imageNamed:@"output_funs_output"]];
    [self setChannelSwitchDefault];
    [self.Btn_OutputPage setTitleColor:SetColor(UI_OutputPageSwitch_Press) forState:UIControlStateNormal];
    [self.mXOverOutputPage.view setHidden:false];
}

#pragma mark Click event
- (IBAction)Btn_OutputPage_Click:(UIButton *)sender {
    [self setChannelSwitchDefault];
    [self.mXOverOutputPage.view setHidden:false];
    //[self presentViewController:self.mXOverOutputPage animated:NO completion:nil];
    [sender setTitleColor:SetColor(UI_OutputPageSwitch_Press) forState:UIControlStateNormal];
    [self.IV_ChannelSwitch setImage:[UIImage imageNamed:@"output_funs_output"]];
    [self.mXOverOutputPage FlashPageUI];
}

- (IBAction)Btn_EQPage_Click:(UIButton *)sender {
    [self setChannelSwitchDefault];
    [self.mEQPage.view setHidden:false];
    //[self presentViewController:self.mEQPage animated:NO completion:nil];
    [sender setTitleColor:SetColor(UI_OutputPageSwitch_Press) forState:UIControlStateNormal];
    [self.IV_ChannelSwitch setImage:[UIImage imageNamed:@"output_funs_eq"]];
    [self.mEQPage FlashPageUI];
}

- (IBAction)Btn_DelayPage_Click:(UIButton *)sender {
    [self setChannelSwitchDefault];
    [self.mDelayPage.view setHidden:false];
    //[self presentViewController:self.mDelayPage animated:NO completion:nil];
    [sender setTitleColor:SetColor(UI_OutputPageSwitch_Press) forState:UIControlStateNormal];
    [self.IV_ChannelSwitch setImage:[UIImage imageNamed:@"output_funs_delay"]];
    [self.mDelayPage FlashPageUI];
}



#pragma mark


- (void)setChannelSwitchDefault{
    [self.Btn_OutputPage setTitleColor:SetColor(UI_OutputPageSwitch_Normal) forState:UIControlStateNormal];
    [self.Btn_EQPage setTitleColor:SetColor(UI_OutputPageSwitch_Normal) forState:UIControlStateNormal];
    [self.Btn_DelayPage setTitleColor:SetColor(UI_OutputPageSwitch_Normal) forState:UIControlStateNormal];
    
    [self.mXOverOutputPage.view setHidden:true];
    [self.mEQPage.view setHidden:true];
    [self.mDelayPage.view setHidden:true];
}


- (void)FlashPageUI{
    [self.mDelayPage FlashPageUI];
    [self.mEQPage FlashPageUI];
    [self.mXOverOutputPage FlashPageUI];
}












@end

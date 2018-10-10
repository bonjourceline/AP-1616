//
//  OutDelayViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/10.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "OutDelayViewController.h"

@interface OutDelayViewController ()

@end

@implementation OutDelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle=UIModalTransitionStyleCrossDissolve;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:350])];
    [bgImageView setImage:[UIImage imageNamed:@"delay_bg"]];
    [bgView addSubview:bgImageView];
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
    }];
    self.chTopLabel=[[UILabel alloc]init];
    self.chTopLabel.text=[NSString stringWithFormat:@"输出1延时"];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    
    self.chLabel=[[UILabel alloc]init];
    self.chLabel.text=[NSString stringWithFormat:@"输出1"];
    [bgView addSubview:self.chLabel];
    self.chLabel.textColor=[UIColor whiteColor];
    self.chLabel.textAlignment=NSTextAlignmentCenter;
    self.chLabel.font=[UIFont systemFontOfSize:17];
    
    [self.chLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset([Dimens GDimens:60]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:ChannelBtnListHeight]));
        
    }];
    UIButton *lastBtn=[[UIButton alloc]init];
    [self.view addSubview:lastBtn];
    [lastBtn addTarget:self action:@selector(lastCh) forControlEvents:UIControlEventTouchUpInside];
    [lastBtn setImage:[UIImage imageNamed:@"last_icon"] forState:UIControlStateNormal];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chLabel.mas_centerY);
        make.right.equalTo(self.chLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:40], [Dimens GDimens:40]));
    }];
    
    UIButton *nextBtn=[[UIButton alloc]init];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextCh) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setImage:[UIImage imageNamed:@"next_icon"] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chLabel.mas_centerY);
        make.left.equalTo(self.chLabel.mas_right);
        make.size.mas_equalTo(lastBtn);
    }];
    // Do any additional setup after loading the view.
}
-(void)nextCh{
    int nextIndex=output_channel_sel;
    if (++nextIndex>=Output_CH_MAX_USE) {
        
    }else{
        output_channel_sel=nextIndex;
        
    }
    [self flashView];
}
-(void)lastCh{
    int lastIndex=output_channel_sel;
    if (--lastIndex<0) {
        
    }else{
        output_channel_sel=lastIndex;
        
    }
    [self flashView];
}
-(void)flashView{
    self.chTopLabel.text=[NSString stringWithFormat:@"输出%d延时",output_channel_sel+1];
    self.chLabel.text=[NSString stringWithFormat:@"输出%d",output_channel_sel+1];
}
-(void)dismissView{
    self.dismissBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

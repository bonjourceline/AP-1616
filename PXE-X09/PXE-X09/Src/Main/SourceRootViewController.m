//
//  SourceRootViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/27.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "SourceRootViewController.h"

@interface SourceRootViewController ()
{
}
@property(nonatomic,strong)UIButton *Btn_Back;
@end

@implementation SourceRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBgTypeView];
    // Do any additional setup after loading the view.
}

-(void)creatBgTypeView{
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [bgImage setImage:[UIImage imageNamed:@"rootbg"]];
    [self.view addSubview:bgImage];
    [self.view insertSubview:bgImage atIndex:0];
    self.navBar=[[UIView alloc]init];
    if (KScreenHeight>=812) {
        self.navBar.frame=CGRectMake(0, 44, KScreenWidth, [Dimens GDimens:44]);
    }else{
        self.navBar.frame = CGRectMake(0, 20, KScreenWidth, [Dimens GDimens:44] );
    }
    [self.view addSubview:self.navBar];
    self.tiltleLab=[[UILabel alloc]init];
    [self.tiltleLab setText:[LANG DPLocalizedString:@"音源设置"]];
    self.tiltleLab.font=[UIFont systemFontOfSize:20];
    self.tiltleLab.textAlignment = NSTextAlignmentCenter;
    self.tiltleLab.textColor = SetColor(UI_ToolbarTitleColor);
    self.tiltleLab.adjustsFontSizeToFitWidth=YES;
    [self.navBar addSubview:self.tiltleLab];
    [self.tiltleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar.mas_centerY);
        make.centerX.equalTo(self.navBar.mas_centerX);
    }];
    self.Btn_Back=[[UIButton alloc]init];
    [self.Btn_Back addTarget:self action:@selector(ClickEventOfBack) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Back setImage:[[UIImage imageNamed:@"topbar_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //    [self.Btn_Back setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.textColor = SetColor(UI_ToolbarBackTextColor);
    [self.Btn_Back setTitleColor:SetColor(UI_ToolbarBackTextColor) forState:UIControlStateNormal];
    self.Btn_Back.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Back.titleLabel.font = [UIFont systemFontOfSize:15];
    self.Btn_Back.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_Back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_Back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:self.Btn_Back];
    [self.Btn_Back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar.mas_left).offset([Dimens GDimens:10]);
        make.centerY.equalTo(self.navBar.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:TopBarLogoWidth], [Dimens GDimens:TopBarLogoHeight]));
    }];
    
//    if ([DeviceUtils isFisrtStarApp]) {
//        self.Btn_Back.hidden=YES;
//    }else{
//        self.Btn_Back.hidden=NO;
//    }
    self.passBtn=[[UIButton alloc]init];
    [self.view addSubview:self.passBtn];
    self.passBtn.layer.borderWidth=1;
    self.passBtn.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
    self.passBtn.layer.cornerRadius=5;
    self.passBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    self.passBtn.layer.masksToBounds=YES;
    [self.passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [self.passBtn addTarget:self action:@selector(toPassView) forControlEvents:UIControlEventTouchUpInside];
    [self.passBtn setTitle:[LANG DPLocalizedString:@"上一步"] forState:UIControlStateNormal];
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenHeight>=812) {
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:620]);
        }else{
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:600]);
        }
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:160], [Dimens GDimens:40]));
    }];
    
    self.nextBtn=[[UIButton alloc]init];
    [self.view addSubview:self.nextBtn];
    self.nextBtn.layer.borderWidth=1;
    self.nextBtn.layer.borderColor=SetColor(UI_SystemBtnColorNormal).CGColor;
    self.nextBtn.backgroundColor=SetColor(UI_SystemBtnColorPress);
    self.nextBtn.layer.cornerRadius=5;
    self.nextBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    self.nextBtn.layer.masksToBounds=YES;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(toNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setTitle:[LANG DPLocalizedString:@"下一步"] forState:UIControlStateNormal];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenHeight>=812) {
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:620]);
        }else{
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:600]);
        }
        
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:160], [Dimens GDimens:40]));
    }];
}
//返回上一页
-(void)ClickEventOfBack{
    UIViewController *vc=self;
    while (vc.presentingViewController) {
        vc=vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
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

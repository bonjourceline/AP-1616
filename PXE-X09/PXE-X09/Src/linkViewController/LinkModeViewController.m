//
//  LinkModeViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/31.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "LinkModeViewController.h"
#define LINKMODE_FLG @"LINKMODEFLG"
#define linkBtnTag  222
@interface LinkModeViewController (){
    NSArray *typeName;
}
@property (nonatomic,strong)NSMutableArray *modeArray;
@property(nonatomic,strong)UILabel *chTopLabel;
@end

@implementation LinkModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self initData];
    [self creatView];
    // Do any additional setup after loading the view.
}
-(void)initData{
    typeName=@[@"EQ",@"静音",@"音量",@"分频器",@"相位",@"延时"];
    self.modeArray=[[NSMutableArray alloc]init];
    [self getAutoFlg];
}
-(void)creatView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380])];
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
    self.chTopLabel.textColor=[UIColor whiteColor];
    self.chTopLabel.text=[LANG DPLocalizedString:@"输出联调设置"];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    UIView *line=[[UIView alloc]init];
    [bgView addSubview:line];
    line.backgroundColor=SetColor(0xFF262d35);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:10]);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-10]);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-68]);
    }];
    
    UIButton *okBtn=[[UIButton alloc]init];
    okBtn.backgroundColor=SetColor(0xFF2ea1ff);
    [bgView addSubview:okBtn];
    [okBtn setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-20]);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-25]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:85], [Dimens GDimens:28]));
    }];
    
    UIButton *cancelBtn=[[UIButton alloc]init];
    cancelBtn.backgroundColor=SetColor(0xFF27323d);
    [bgView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_System_Cancel"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(okBtn.mas_centerY);
        make.right.equalTo(okBtn.mas_left).offset([Dimens GDimens:-20]);
        make.size.mas_equalTo(okBtn);
    }];
    
    UILabel *tisLabel=[[UILabel alloc]init];
    tisLabel.text=[LANG DPLocalizedString:@"勾选你想要联调的功能"];
    tisLabel.textColor=[UIColor whiteColor];
    tisLabel.font=[UIFont systemFontOfSize:13];
    [bgView addSubview:tisLabel];
    [tisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset([Dimens GDimens:50]);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:200], [Dimens GDimens:30]));
    }];
    for (int i=0; i<6; i++) {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=linkBtnTag+i;
        [btn setTitle:typeName[i] forState:UIControlStateNormal];
        [bgView addSubview:btn];
        if (i<3) {
            btn
        }else{
            
        }
    }
}

-(void)okClick{
    [self saveAutoFlg];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)cancleClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --查看沙盒的设置
-(void)getAutoFlg{
    self.modeArray=[[NSUserDefaults standardUserDefaults]objectForKey:LINKMODE_FLG];
    if (!self.modeArray) {
        [self.modeArray addObjectsFromArray:@[@(1),@(1),@(1),@(1),@(1),@(1)]];
    }
}
-(void)saveAutoFlg{
    [[NSUserDefaults standardUserDefaults]setObject:self.modeArray forKey:LINKMODE_FLG];
    [[NSUserDefaults standardUserDefaults]synchronize];
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

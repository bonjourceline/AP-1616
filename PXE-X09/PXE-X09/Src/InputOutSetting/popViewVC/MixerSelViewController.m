//
//  MixerSelViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/17.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "MixerSelViewController.h"
#import "SourceItem.h"
#define SourceItemTag 100
@interface MixerSelViewController ()
@property(nonatomic,strong)UILabel *chTopLabel;
@property(nonatomic,strong)NSArray *NameArray;
@property(nonatomic,strong)NSArray *ImageArray;
@end

@implementation MixerSelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RecStructData.System.mixer_source_temp=RecStructData.System.mixer_source;
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:60], [Dimens GDimens:430])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:60], [Dimens GDimens:430]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:60], [Dimens GDimens:430])];
    [bgImageView setImage:[UIImage imageNamed:@"delay_bg"]];
    [bgView addSubview:bgImageView];
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:35], [Dimens GDimens:35]));
    }];
    self.chTopLabel=[[UILabel alloc]init];
    self.chTopLabel.text=[NSString stringWithFormat:@"音源叠加"];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:14];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:35]);
    }];
    
    UIButton *passBtn=[[UIButton alloc]init];
    passBtn.backgroundColor=SetColor(0xFF20272e);
    [passBtn setTitle:[LANG DPLocalizedString:@"跳过"] forState:UIControlStateNormal];
    [passBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    passBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:passBtn];
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-25]);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:35]));
    }];
    
    UIButton *okBtn=[[UIButton alloc]init];
    okBtn.backgroundColor=SetColor(0xFF20272e);
    [okBtn setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    okBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-25]);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:100], [Dimens GDimens:35]));
    }];
    [okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i=0; i<5; i++) {
        SourceItem *item=[[SourceItem alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:40]+[Dimens GDimens:60]*i, bgView.frame.size.width, [Dimens GDimens:60])];
        [bgView addSubview:item];
        item.SoucreTitle.text=[LANG DPLocalizedString:self.NameArray[i]];
        [item.logoImage setImage:[UIImage imageNamed:self.ImageArray[i]]];
        
        [item setTag:i+SourceItemTag];
        item.selectBlock = ^(BOOL isSelected, NSInteger itemTag) {
            int value=(int)itemTag-SourceItemTag;
            if (value==0) {
                if (RecStructData.System.input_source!=1) {
                    RecStructData.System.mixer_source_temp=value;
                }
            }else if(value==1){
                if (RecStructData.System.input_source!=0) {
                    RecStructData.System.mixer_source_temp=value;
                }
            }else{
                RecStructData.System.mixer_source_temp=value;
            }
            
            [self flashItem];
        };
    }
    [self flashItem];
//    @property(nonatomic,strong)UIImageView *logoImage;
//    @property(nonatomic,strong)UILabel *SoucreTitle;
//    @property(nonatomic,strong)UIButton *selectBtn;
//    @property(nonatomic,strong)itemClickBlock selectBlock;
//
//    -(void)flashSelect:(BOOL)isChoose;
    
}
-(void)okClick{
    RecStructData.System.mixer_source=RecStructData.System.mixer_source_temp;
    self.mixerBlock();
    [self dismissView];
}
-(void)flashItem{
    for (int i=0; i<5; i++) {
        SourceItem *item=(SourceItem *)[self.view viewWithTag:i+SourceItemTag];
        if (i==RecStructData.System.mixer_source_temp) {
            [item.selectBtn setImage:[UIImage imageNamed:@"source_press"] forState:UIControlStateNormal];
        }else{
            [item.selectBtn setImage:[UIImage imageNamed:@"source_normal"] forState:UIControlStateNormal];
        }
    }
}
-(NSArray *)NameArray{
    if (!_NameArray) {
        _NameArray=@[@"L_InputSource_Optical",@"L_InputSource_Coaxial",@"L_InputSource_Bluetooth",@"L_InputSource_High",@"L_InputSource_AUX"];
    }
    return _NameArray;
}
-(NSArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray=@[@"Source_Optical",@"Source_Coaxial",@"Source_Blue",@"Source_High",@"Source_Aux"];
    }
    return _ImageArray;
}
-(void)dismissView{
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

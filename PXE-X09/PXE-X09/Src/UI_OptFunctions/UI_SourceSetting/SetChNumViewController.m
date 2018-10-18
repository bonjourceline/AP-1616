//
//  SetChNumViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/14.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SetChNumViewController.h"
#import "NormalButton.h"
#import "LMJDropdownMenu.h"
#define  weight 380
#define  btnNormal (0xFF20272e)
#define  btnPress (0xFF2ea1ff)
@interface SetChNumViewController ()<LMJDropdownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int HNum;
    int ANum;
    int OutNum;
    NormalButton *curBtn;
    NSArray *numTitles;
    NSArray *numValues;
    NSMutableArray *showTitles;
    UIView *bgView;
}
@property (nonatomic,strong)NormalButton *input_HNumBtn;
@property (nonatomic,strong)UIView *input_HNumBtnView;
@property (nonatomic,strong)NormalButton *input_ANumBtn;
@property (nonatomic,strong)UIView *input_ANumBtnView;
@property (nonatomic,strong)NormalButton *ouputNumBtn;
@property (nonatomic,strong)UIView *ouputNumBtnView;
@property (nonatomic,strong)UILabel *chTopLabel;
@property (nonatomic,strong)UIStackView *stackView;
@property (nonatomic,strong)LMJDropdownMenu *dropdownMenu;
@end

@implementation SetChNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self creatView];
    ANum=RecStructData.System.AuxInputChNum_temp;
    HNum=RecStructData.System.HiInputChNum_temp;
    OutNum=RecStructData.System.OutputChNum_temp;
    // Do any additional setup after loading the view.
}
-(void)creatView{
    
    numValues=@[@(2),@(4),@(6),@(8),@(10),@(12),@(14),@(16)];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle=UIModalTransitionStyleCrossDissolve;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:380], [Dimens GDimens:500])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
        make.top.equalTo(self.view.mas_top).offset((KScreenHeight-[Dimens GDimens:320])/2);
        make.width.mas_equalTo([Dimens GDimens:380]);
        make.bottom.equalTo(self.view.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:380], [Dimens GDimens:500]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:380], [Dimens GDimens:320])];
    [bgImageView setImage:[UIImage imageNamed:@"delay_bg"]];
    [bgView addSubview:bgImageView];
    
    UIButton *passBtn=[[UIButton alloc]init];
    [passBtn setTitle:[LANG DPLocalizedString:@"跳过"] forState:UIControlStateNormal];
    passBtn.backgroundColor=SetColor(btnNormal);
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    passBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    passBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [bgView addSubview:passBtn];
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgImageView.mas_bottom).offset([Dimens GDimens:-20]);
        make.left.equalTo(bgImageView.mas_left).offset([Dimens GDimens:15]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:85], [Dimens GDimens:30]));
    }];
    [passBtn addTarget:self action:@selector(passView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn=[[UIButton alloc]init];
    [okBtn setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    okBtn.backgroundColor=SetColor(btnPress);
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    okBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [bgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgImageView.mas_bottom).offset([Dimens GDimens:-20]);
        make.right.equalTo(bgImageView.mas_right).offset([Dimens GDimens:-15]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:85], [Dimens GDimens:30]));
    }];
    [okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lastBtn=[[UIButton alloc]init];
    [lastBtn setTitle:[LANG DPLocalizedString:@"上一步"] forState:UIControlStateNormal];
    lastBtn.backgroundColor=SetColor(btnNormal);
    [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lastBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    lastBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [bgView addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgImageView.mas_bottom).offset([Dimens GDimens:-20]);
        make.right.equalTo(okBtn.mas_left).offset([Dimens GDimens:-10]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:85], [Dimens GDimens:30]));
    }];
    [lastBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(0xFF262d35);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastBtn.mas_top).offset([Dimens GDimens:-20]);
        make.left.equalTo(bgImageView.mas_left).offset([Dimens GDimens:15]);
        make.right.equalTo(bgImageView.mas_right).offset([Dimens GDimens:-15]);
        make.height.mas_equalTo(1);
    }];
    
    self.stackView=[[UIStackView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:150], [Dimens GDimens:350])];
    [bgView addSubview:self.stackView];
    self.stackView.axis=UILayoutConstraintAxisVertical;
    self.stackView.spacing=[Dimens GDimens:10];
    self.stackView.alignment=UIStackViewAlignmentCenter;
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left);
        make.centerY.equalTo(bgImageView.mas_centerY).offset([Dimens GDimens:-30]);
        make.width.mas_equalTo([Dimens GDimens:380]);
    }];
   
    
    UIButton *backBtn=[[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_top);
        make.right.equalTo(bgImageView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
    }];
    self.chTopLabel=[[UILabel alloc]init];
    self.chTopLabel.text=[NSString stringWithFormat:@"输出1延时"];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_top);
        make.left.equalTo(bgImageView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    [self setChNumType:self.type];
    
   
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)passView{
    self.blackHome();
}
-(void)okClick{
    if (self.type==CHNUMTYPE_input) {
        int H_count=2;
        int A_count=2;
        if (RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.high_mode_temp==0) {
            RecStructData.System.HiInputChNum_temp=HNum;
            H_count=HNum/2;
            for (int i=0; i<H_count; i++) {
                RecStructData.System.high_Low_Set_temp[i]=1;
            }
        }
        if (RecStructData.System.InSwitch_temp[4]==1&&RecStructData.System.aux_mode_temp==0) {
             RecStructData.System.AuxInputChNum_temp=ANum;
            A_count=ANum/2;
            for (int i=H_count; i<(H_count+A_count); i++) {
                RecStructData.System.high_Low_Set_temp[i]=0;
            }
        }
       
    }else{
        RecStructData.System.OutputChNum_temp=OutNum;
    }
    [SourceModeUtils syncSource];
    
    self.blackHome();
}
-(void)setChNumType:(CHNUMTYPE)type{
    if (type==CHNUMTYPE_input) {
        self.chTopLabel.text=[NSString stringWithFormat:@"输入自定义"];
        if (RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.high_mode_temp==0) {
            [self.stackView addArrangedSubview:self.input_HNumBtnView];
            [self.input_HNumBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake([Dimens GDimens:380], [Dimens GDimens:45]));
            }];
        }
        if(RecStructData.System.InSwitch_temp[4]==1&&RecStructData.System.aux_mode_temp==0){
            [self.stackView addArrangedSubview:self.input_ANumBtnView];
            [self.input_ANumBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake([Dimens GDimens:380], [Dimens GDimens:45]));
            }];
        }
    }else if(type==CHNUMTYPE_output){
        self.chTopLabel.text=[NSString stringWithFormat:@"输出自定义"];
         [self.stackView addArrangedSubview:self.ouputNumBtnView];
        [self.ouputNumBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:380], [Dimens GDimens:45]));
        }];
    }
}
-(UIView *)input_ANumBtnView{
    if (!_input_ANumBtnView) {
        _input_ANumBtnView=[[UIView alloc]init];
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.text=[LANG DPLocalizedString:@"设置低电平通道个数"];
        [_input_ANumBtnView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_input_ANumBtnView.mas_left);
            make.centerY.equalTo(_input_ANumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:170], [Dimens GDimens:40]));
        }];
        self.input_ANumBtn=[[NormalButton alloc]init];
        self.input_ANumBtn.layer.borderWidth=1;
        [self.input_ANumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.input_ANumBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        self.input_ANumBtn.layer.borderColor=SetColor(0xFF2f3b42).CGColor;
        [self.input_ANumBtn setTitle:[NSString stringWithFormat:@"%d",RecStructData.System.AuxInputChNum_temp] forState:UIControlStateNormal];
        [self.input_ANumBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_input_ANumBtnView addSubview:self.input_ANumBtn];
        [self.input_ANumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.centerY.equalTo(_input_ANumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:175], [Dimens GDimens:40]));
        }];
    }
    return _input_ANumBtnView;
}
-(UIView *)input_HNumBtnView{
    if (!_input_HNumBtnView) {
        _input_HNumBtnView=[[UIView alloc]init];
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.text=[LANG DPLocalizedString:@"设置高电平通道个数"];
        [_input_HNumBtnView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_input_HNumBtnView.mas_left);
            make.centerY.equalTo(_input_HNumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:170], [Dimens GDimens:40]));
        }];
        self.input_HNumBtn=[[NormalButton alloc]init];
        self.input_HNumBtn.layer.borderWidth=1;
        [self.input_HNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.input_HNumBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        self.input_HNumBtn.layer.borderColor=SetColor(0xFF2f3b42).CGColor;
        [self.input_HNumBtn setTitle:[NSString stringWithFormat:@"%d",RecStructData.System.HiInputChNum_temp] forState:UIControlStateNormal];
        [self.input_HNumBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_input_HNumBtnView addSubview:self.input_HNumBtn];
        [self.input_HNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.centerY.equalTo(_input_HNumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:175], [Dimens GDimens:40]));
        }];
    }
    return _input_HNumBtnView;
}
-(UIView *)ouputNumBtnView{
    if (!_ouputNumBtnView) {
        _ouputNumBtnView=[[UIView alloc]init];
        _ouputNumBtnView=[[UIView alloc]init];
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.text=[LANG DPLocalizedString:@"设置输出通道个数"];
        [_ouputNumBtnView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ouputNumBtnView.mas_left);
            make.centerY.equalTo(_ouputNumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:170], [Dimens GDimens:40]));
        }];
        self.ouputNumBtn=[[NormalButton alloc]init];
        self.ouputNumBtn.layer.borderWidth=1;
        [self.ouputNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ouputNumBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        self.ouputNumBtn.layer.borderColor=SetColor(0xFF2f3b42).CGColor;
        [self.ouputNumBtn setTitle:[NSString stringWithFormat:@"%d",RecStructData.System.OutputChNum_temp] forState:UIControlStateNormal];
        [self.ouputNumBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_ouputNumBtnView addSubview:self.ouputNumBtn];
        [self.ouputNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.centerY.equalTo(_ouputNumBtnView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake([Dimens GDimens:175], [Dimens GDimens:40]));
        }];
    }
    return _ouputNumBtnView;
}
-(void)showMenu:(NormalButton *)sender{
   
    if (curBtn==sender) {
        [self.dropdownMenu clickMainBtn];
        return;
    }else{
         [self.dropdownMenu hideDropDown];
    }
    curBtn=sender;
    if (self.type==CHNUMTYPE_input) {
        if ((RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.high_mode_temp==0)&&(RecStructData.System.InSwitch_temp[4]==1&&RecStructData.System.aux_mode_temp==0)) {
            if (curBtn==self.input_HNumBtn) {
                
                self.dropdownMenu.frame=CGRectMake([Dimens GDimens:170], [Dimens GDimens:123], [Dimens GDimens:175], 0);
                showTitles=[self getValueArrayStr];
                [self.dropdownMenu setMenuTitles:showTitles rowHeight:[Dimens GDimens:45]];
                
            }else if(curBtn==self.input_ANumBtn){
                
                self.dropdownMenu.frame=CGRectMake([Dimens GDimens:170], [Dimens GDimens:178], [Dimens GDimens:175], 0);
                showTitles=[self getValueArrayStr];
                [self.dropdownMenu setMenuTitles:showTitles rowHeight:[Dimens GDimens:45]];

            }
        }else{
            self.dropdownMenu.frame=CGRectMake([Dimens GDimens:170], [Dimens GDimens:150], [Dimens GDimens:175], 0);
            showTitles=[self getValueArrayStr];
            [self.dropdownMenu setMenuTitles:showTitles rowHeight:[Dimens GDimens:45]];
            
        }
    }else{
        self.dropdownMenu.frame=CGRectMake([Dimens GDimens:170], [Dimens GDimens:150], [Dimens GDimens:175], 0);
        showTitles=[[NSMutableArray alloc]init];
        for (int i=1; i<17; i++) {
            [showTitles addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.dropdownMenu setMenuTitles:showTitles rowHeight:[Dimens GDimens:45]];
    }
    [self.dropdownMenu clickMainBtn];
}
-(LMJDropdownMenu *)dropdownMenu{
    if (!_dropdownMenu) {
        _dropdownMenu=[[LMJDropdownMenu alloc]init];
        _dropdownMenu.delegate=self;
        [bgView addSubview:_dropdownMenu];
    }
    return _dropdownMenu;
}
-(NSMutableArray *)getValueArrayStr{
    NSMutableArray *valueArray=[[NSMutableArray alloc]init];
    if (curBtn==self.input_ANumBtn) {
        for (id num in numValues) {
            int intNum=[num intValue];
            if (((intNum+HNum)<=16)||(RecStructData.System.InSwitch_temp[3]==0)) {
                [valueArray addObject:[NSString stringWithFormat:@"%d",intNum]];
            }
        }
    }else if(curBtn==self.input_HNumBtn){
        for (id num in numValues) {
            int intNum=[num intValue];
            if (((intNum+ANum)<=16)||(RecStructData.System.InSwitch_temp[4]==0)) {
                [valueArray addObject:[NSString stringWithFormat:@"%d",intNum]];
            }
        }
    }
    return valueArray;
}
-(NSMutableArray *)getValueArray{
    NSMutableArray *valueArray=[[NSMutableArray alloc]init];
    if (curBtn==self.input_ANumBtn) {
        for (id num in numValues) {
            int intNum=[num intValue];
            if (((intNum+HNum)<=16)||(RecStructData.System.InSwitch_temp[3]==0)) {
                [valueArray addObject:num];
            }
        }
    }else if(curBtn==self.input_HNumBtn){
        for (id num in numValues) {
            int intNum=[num intValue];
            if (((intNum+ANum)<=16)||(RecStructData.System.InSwitch_temp[4]==0)) {
                [valueArray addObject:num];
            }
        }
    }
    return valueArray;
}
#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    NSMutableArray *ValueArray=[self getValueArray];
    [curBtn setTitle:showTitles[number] forState:UIControlStateNormal];
    if (curBtn==self.input_HNumBtn) {
        HNum=[ValueArray[number] intValue];
    }else if (curBtn==self.input_ANumBtn){
        ANum=[ValueArray[number] intValue];
    }else if (curBtn==self.ouputNumBtn){
        OutNum=(int)number+1;
    }
    [self.dropdownMenu clickMainBtn];
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

//
//  OutSetViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/29.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "OutSetViewController.h"
#import "DoubleOutTableViewCell.h"
#import "LinkViewController.h"
//#import "SingleOutTableViewCell.h"
#import "EQViewController.h"
#import "OutModeViewController.h"
#define btnWidth 60
#define btnHeight 25

@interface OutSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *outputTypeBtn;
    int chCount;
}
@property(nonatomic,strong)UITableView *outputTableView;
@property (nonatomic,strong)UIButton *linkBtn;
@end

@implementation OutSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_OutputPage"];
    [self creatTopView];
    [self creatTableView];
    // Do any additional setup after loading the view.
}
-(void)creatTopView{
    outputTypeBtn=[[UIButton alloc]init];
    [self.view addSubview:outputTypeBtn];
    outputTypeBtn.layer.borderColor=[UIColor blackColor].CGColor;
    outputTypeBtn.layer.borderWidth=1;
    outputTypeBtn.layer.masksToBounds=YES;
    outputTypeBtn.backgroundColor=SetColor(UI_SystemBtnColorPress);
    [outputTypeBtn setTitleColor:SetColor(UI_SystemLableColorNormal) forState:UIControlStateNormal];
    [outputTypeBtn setTitle:[LANG DPLocalizedString:@"输出方式"] forState:UIControlStateNormal];
    outputTypeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [outputTypeBtn addTarget:self action:@selector(goToSourceSetting) forControlEvents:UIControlEventTouchUpInside];
    outputTypeBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [outputTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:8]);
        make.centerX.equalTo(self.view.mas_right).offset(-[Dimens GDimens:95]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:btnWidth], [Dimens GDimens:btnHeight]));
    }];
    
    self.linkBtn=[[UIButton alloc]init];
    [self.view addSubview:self.linkBtn];
    [self.linkBtn addTarget:self action:@selector(openLinkVc) forControlEvents:UIControlEventTouchUpInside];
    [self.linkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.linkBtn.backgroundColor=[UIColor greenColor];
    [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outputTypeBtn.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-13]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
        
    }];
    
    UILabel *muteLabel=[[UILabel alloc]init];
    muteLabel.adjustsFontSizeToFitWidth=YES;
    muteLabel.font=[UIFont systemFontOfSize:12];
    muteLabel.text=[LANG DPLocalizedString:@"静音"];
    muteLabel.textColor=SetColor(0XFF757f8b);
    [muteLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:muteLabel];
    [muteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outputTypeBtn.mas_centerY);
        make.centerX.equalTo(outputTypeBtn.mas_centerX).offset(-[Dimens GDimens:65]);
    }];
    UILabel *volLabel=[[UILabel alloc]init];
    volLabel.adjustsFontSizeToFitWidth=YES;
    volLabel.font=[UIFont systemFontOfSize:12];
    volLabel.text=[LANG DPLocalizedString:@"音量(dB)"];
    volLabel.textColor=SetColor(0XFF757f8b);
    [volLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:volLabel];
    [volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outputTypeBtn.mas_centerY);
        make.centerX.equalTo(muteLabel.mas_centerX).offset(-[Dimens GDimens:65]);
    }];
    
    UILabel *delaylab=[[UILabel alloc]init];
    delaylab.adjustsFontSizeToFitWidth=YES;
    delaylab.font=[UIFont systemFontOfSize:12];
    delaylab.text=[LANG DPLocalizedString:@"延时"];
    delaylab.textColor=SetColor(0XFF757f8b);
    [delaylab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:delaylab];
    [delaylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outputTypeBtn.mas_centerY);
        make.centerX.equalTo(volLabel.mas_centerX).offset(-[Dimens GDimens:65]);
    }];
    
    UILabel *eqlabel=[[UILabel alloc]init];
    eqlabel.adjustsFontSizeToFitWidth=YES;
    eqlabel.font=[UIFont systemFontOfSize:12];
    eqlabel.text=@"EQ";
    eqlabel.textColor=SetColor(0XFF757f8b);
    [eqlabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:eqlabel];
    [eqlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outputTypeBtn.mas_centerY);
        make.centerX.equalTo(delaylab.mas_centerX).offset(-[Dimens GDimens:70]);
    }];
}
-(void)goToSourceSetting{
    OutModeViewController *vc=[[OutModeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)creatTableView{
    self.outputTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:525]) style:UITableViewStylePlain];
    self.outputTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.outputTableView.showsVerticalScrollIndicator=NO;
    self.outputTableView.delegate=self;
    self.outputTableView.dataSource=self;
    self.outputTableView.userInteractionEnabled=YES;
    [self.view addSubview:self.outputTableView];
    [self.outputTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:15]);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(outputTypeBtn.mas_bottom).offset([Dimens GDimens:10]);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.outputTableView.backgroundColor=[UIColor clearColor];
    self.outputTableView.tableFooterView=[UIView new];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(0xFF313c45);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.outputTableView.mas_centerY);
        make.right.equalTo(self.outputTableView.mas_left);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark--------tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [Dimens GDimens:190];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return chCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"DoubleOutTableViewCell";
    DoubleOutTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[DoubleOutTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.item.item1.lineTop.hidden=NO;
    cell.item.item1.lineBottom.hidden=NO;
    cell.item.item2.lineBottom.hidden=NO;
    cell.item.item2.hidden=NO;
    if (indexPath.row==0) {
        cell.item.item1.lineTop.hidden=YES;
       
    }
    if (indexPath.row==chCount-1){
        
        if (RecStructData.System.OutputChNum%2==1) {
            cell.item.item1.lineBottom.hidden=YES;
            cell.item.item2.hidden=YES;
        }else{
            cell.item.item2.hidden=NO;
            cell.item.item2.lineBottom.hidden=YES;
        }
    }
    
    
    [cell.item setChannelIndex:(int)indexPath.row*2];
    [cell.item flashView];
    //eq
    cell.item.item1.eqblock = ^(int index) {
        [self openEqVc];
    };
    cell.item.item1.reloadblock = ^{
        [self.outputTableView reloadData];
    };
    cell.item.item2.eqblock = ^(int index) {
        [self openEqVc];
    };
    cell.item.item2.reloadblock = ^{
        [self.outputTableView reloadData];
    };

    
    return cell;
}
#pragma mark--------弹窗
-(void)openEqVc{
    EQViewController *vc=[[EQViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

}
-(void)openLinkVc{
    LinkViewController *vc=[[LinkViewController alloc]init];
    vc.isInputType=NO;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)FlashPageUI{
    
    if (RecStructData.System.OutputChNum%2==1) {
        chCount=RecStructData.System.OutputChNum/2+1;
    }else{
        chCount=RecStructData.System.OutputChNum/2;
    }
    
    [self.outputTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the ·  selected object to the new view controller.
}
*/

@end

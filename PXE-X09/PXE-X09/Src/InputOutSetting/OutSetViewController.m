//
//  OutSetViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/29.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "OutSetViewController.h"
#import "SingleOutTableViewCell.h"
#import "EQViewController.h"
#define btnWidth 60
#define btnHeight 25

@interface OutSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *outputTypeBtn;
}
@property(nonatomic,strong)UITableView *outputTableView;
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
    volLabel.text=[LANG DPLocalizedString:@"音量"];
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
    return [Dimens GDimens:95];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Output_CH_MAX_USE;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"SingleOutTableViewCell";
    SingleOutTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[SingleOutTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.item.lineTop.hidden=YES;
    }else if (indexPath.row==Output_CH_MAX_USE-1){
        cell.item.lineBottom.hidden=YES;
    }else{
        cell.item.lineTop.hidden=NO;
        cell.item.lineBottom.hidden=NO;
    }
    [cell.item setChannelIndex:(int)indexPath.row];
    [cell.item flashView];
    //eq
    cell.item.eqblock = ^(int index) {
        [self openEqVc];
    };
    cell.item.reloadblock = ^{
        [self.outputTableView reloadData];
    };

    
    return cell;
}
#pragma mark--------弹窗
-(void)openEqVc{
    EQViewController *vc=[[EQViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

    
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

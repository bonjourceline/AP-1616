//
//  InputSetViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/29.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "InputSetViewController.h"
#import "SingleTableViewCell.h"
#import "SourceSettingController.h"
#define btnWidth 80
#define btnHeight 25
@interface InputSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *inputTypeBtn;
}
@property(nonatomic,strong)UITableView *inputTableView;

@end

@implementation InputSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_Input"];
    [self creatTopView];
    [self creatTableView];
    // Do any additional setup after loading the view.
}
-(void)creatTopView{
    inputTypeBtn=[[UIButton alloc]init];
    [self.view addSubview:inputTypeBtn];
    inputTypeBtn.layer.borderColor=[UIColor blackColor].CGColor;
    inputTypeBtn.layer.borderWidth=1;
    inputTypeBtn.layer.masksToBounds=YES;
    inputTypeBtn.backgroundColor=SetColor(UI_SystemBtnColorPress);
    [inputTypeBtn setTitleColor:SetColor(UI_SystemLableColorNormal) forState:UIControlStateNormal];
    [inputTypeBtn setTitle:[LANG DPLocalizedString:@"输入方式"] forState:UIControlStateNormal];
    inputTypeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [inputTypeBtn addTarget:self action:@selector(goToSourceSetting) forControlEvents:UIControlEventTouchUpInside];
    inputTypeBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [inputTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:8]);
        make.centerX.equalTo(self.view.mas_left).offset([Dimens GDimens:125]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:btnWidth], [Dimens GDimens:btnHeight]));
    }];
    UILabel *eqlabel=[[UILabel alloc]init];
    eqlabel.adjustsFontSizeToFitWidth=YES;
    eqlabel.font=[UIFont systemFontOfSize:12];
    eqlabel.text=@"EQ";
    eqlabel.textColor=SetColor(0XFF757f8b);
    [eqlabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:eqlabel];
    [eqlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputTypeBtn.mas_centerY);
        make.centerX.equalTo(inputTypeBtn.mas_centerX).offset([Dimens GDimens:85]);
    }];
    UILabel *volLabel=[[UILabel alloc]init];
    volLabel.adjustsFontSizeToFitWidth=YES;
    volLabel.font=[UIFont systemFontOfSize:12];
    volLabel.text=[LANG DPLocalizedString:@"音量"];
    volLabel.textColor=SetColor(0XFF757f8b);
    [volLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:volLabel];
    [volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputTypeBtn.mas_centerY);
        make.centerX.equalTo(eqlabel.mas_centerX).offset([Dimens GDimens:80]);
    }];
    UILabel *muteLabel=[[UILabel alloc]init];
    muteLabel.adjustsFontSizeToFitWidth=YES;
    muteLabel.font=[UIFont systemFontOfSize:12];
    muteLabel.text=[LANG DPLocalizedString:@"音量"];
    muteLabel.textColor=SetColor(0XFF757f8b);
    [muteLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:muteLabel];
    [muteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputTypeBtn.mas_centerY);
        make.centerX.equalTo(volLabel.mas_centerX).offset([Dimens GDimens:75]);
    }];
}
#pragma mark ------tableView

-(void)creatTableView{
    self.inputTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:525]) style:UITableViewStylePlain];
    self.inputTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.inputTableView.showsVerticalScrollIndicator=NO;
    self.inputTableView.delegate=self;
    self.inputTableView.dataSource=self;
    self.inputTableView.userInteractionEnabled=YES;
    [self.view addSubview:self.inputTableView];
    [self.inputTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-20]);
        make.top.equalTo(inputTypeBtn.mas_bottom).offset([Dimens GDimens:10]);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.inputTableView.backgroundColor=[UIColor clearColor];
    self.inputTableView.tableFooterView=[UIView new];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=SetColor(0xFF313c45);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputTableView.mas_centerY);
        make.left.equalTo(self.inputTableView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark--------tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Dimens GDimens:95];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return INS_CH_MAX;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"SingleTableViewCell";
    SingleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[SingleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.item.lineTop.hidden=YES;
    }else if (indexPath.row==INS_CH_MAX-1){
        cell.item.lineBottom.hidden=YES;
    }else{
        cell.item.lineTop.hidden=NO;
        cell.item.lineBottom.hidden=NO;
    }
    [cell.item setChannelIndex:(int)indexPath.row];
    [cell.item flashView];
    return cell;
}
#pragma mark-----------输入方式
-(void)goToSourceSetting{
    SourceSettingController *vc=[[SourceSettingController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.hidden=YES;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)FlashPageUI{
    [self.inputTableView reloadData];
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

//
//  InputSetViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/29.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "InputSetViewController.h"
#import "SingleTableViewCell.h"
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
    inputTypeBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [inputTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:8]);
        make.centerX.equalTo(self.view.mas_left).offset([Dimens GDimens:110]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:btnWidth], [Dimens GDimens:btnHeight]));
    }];
}
#pragma mark ------tableView

-(void)creatTableView{
    self.inputTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:525]) style:UITableViewStylePlain];
    self.inputTableView.delegate=self;
    self.inputTableView.dataSource=self;
    self.inputTableView.userInteractionEnabled=YES;
    [self.view addSubview:self.inputTableView];
    [self.inputTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-20]);
        make.top.equalTo(inputTypeBtn.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.inputTableView.backgroundColor=[UIColor clearColor];
    self.inputTableView.tableFooterView=[UIView new];
}
#pragma mark--------tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Dimens GDimens:80];
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
    return cell;
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

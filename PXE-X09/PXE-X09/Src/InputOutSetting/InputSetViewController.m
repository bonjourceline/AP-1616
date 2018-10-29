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
#import "EQinputViewController.h"
#import "DoubleChTableViewCell.h"
#import "LinkViewController.h"
#define btnWidth 80
#define btnHeight 25
@interface InputSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *inputTypeBtn;
    int chCount;
}
@property(nonatomic,strong)UITableView *inputTableView;
@property (nonatomic,strong)NSMutableArray *threeCells;
@property (nonatomic,strong)UIButton *linkBtn;

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
    self.linkBtn=[[UIButton alloc]init];
    [self.view addSubview:self.linkBtn];
    [self.linkBtn addTarget:self action:@selector(openLinkVc) forControlEvents:UIControlEventTouchUpInside];
    [self.linkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.linkBtn.backgroundColor=[UIColor greenColor];
    [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputTypeBtn.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:18]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
        
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
    if (indexPath.row<self.threeCells.count) {
        return [Dimens GDimens:95];
    }else{
        return [Dimens GDimens:190];
    }
    return [Dimens GDimens:95];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //---------单个通道显示
    if (indexPath.row<self.threeCells.count) {
        static NSString *cellId=@"SingleTableViewCell";
        SingleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[SingleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==0) {
            cell.item.lineTop.hidden=YES;
        }else if (indexPath.row==chCount-1){
            cell.item.lineBottom.hidden=YES;
        }else{
            cell.item.lineTop.hidden=NO;
            cell.item.lineBottom.hidden=NO;
        }
        int chValue=[self.threeCells[indexPath.row] intValue];
        [cell.item setChannelIndex:chValue];
        cell.item.spkBtn.hidden=YES;
        [cell.item flashView];
        if (chValue==0) {
            cell.item.chName.text=[LANG DPLocalizedString:@"L_InputSource_Optical"];
            [cell.item.sourceImage setImage:[UIImage imageNamed:@"Source_Optical"]];
        }else if(chValue==1){
            cell.item.chName.text=[LANG DPLocalizedString:@"L_InputSource_Coaxial"];
            [cell.item.sourceImage setImage:[UIImage imageNamed:@"Source_Coaxial"]];
        }else if(chValue ==2){
            cell.item.chName.text=[LANG DPLocalizedString:@"L_InputSource_Bluetooth"];
            [cell.item.sourceImage setImage:[UIImage imageNamed:@"Source_Blue"]];
        }
        cell.item.eqblock = ^(int index) {
            [self openEqVc];
        };
        cell.item.reloadblock = ^{
            [self.inputTableView reloadData];
        };
        return cell;
        
    }else{
        /////////////双通道显示
        static NSString *cellId=@"DoubleChTableViewCell";
        DoubleChTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[DoubleChTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==0) {
            cell.item.item1.lineTop.hidden=YES;
        }else if (indexPath.row==chCount-1){
            cell.item.item2.lineBottom.hidden=YES;
        }else{
            cell.item.item1.lineTop.hidden=NO;
            cell.item.item2.lineBottom.hidden=NO;
        }
        
        cell.item.item1.eqblock = ^(int index) {
            [self openEqVc];
        };
        cell.item.item1.reloadblock = ^{
            [self.inputTableView reloadData];
        };
        cell.item.item2.eqblock = ^(int index) {
            [self openEqVc];
        };
        cell.item.item2.reloadblock = ^{
            [self.inputTableView reloadData];
        };
        int chValue=(int)(indexPath.row-self.threeCells.count+1)*2+1;
        NSLog(@"----------%d",chValue);
        [cell.item setChannelIndex:chValue];
        [cell.item flashView];
        return cell;
    }
}
#pragma mark--------弹窗
-(void)openEqVc{
    EQinputViewController *vc=[[EQinputViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)openLinkVc{
    LinkViewController *vc=[[LinkViewController alloc]init];
    vc.isInputType=YES;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark-----------输入方式
-(void)goToSourceSetting{
    SourceSettingController *vc=[[SourceSettingController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.hidden=YES;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)FlashPageUI{
    self.threeCells =[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        if (RecStructData.System.InSwitch[i]!=0) {
            [self.threeCells addObject:@(i)];
        }
    }
    chCount=(int)self.threeCells.count;
    if (RecStructData.System.InSwitch[3]!=0) {
        chCount=chCount+(RecStructData.System.HiInputChNum)/2;
    }
    if (RecStructData.System.InSwitch[4]!=0) {
        chCount=chCount+(RecStructData.System.AuxInputChNum)/2;
    }
    
    [self.inputTableView reloadData];
}
-(NSMutableArray *)threeCells{
    if (!_threeCells) {
        _threeCells=[[NSMutableArray alloc]init];
    }
    return _threeCells;
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

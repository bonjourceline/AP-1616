//
//  SpkViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/11.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SpkViewController.h"

@interface SpkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *firstTableView;
@property (nonatomic,strong)UITableView *secTableView;
@property(nonatomic,strong)UILabel *chTopLabel;
@property (nonatomic,strong)NSArray *firstArray;
@property (nonatomic,strong)NSArray *secArray;
@end

@implementation SpkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:-60], [Dimens GDimens:600])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:60], [Dimens GDimens:600]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:60], [Dimens GDimens:600])];
    [bgImageView setImage:[UIImage imageNamed:@"volView_bg"]];
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
    self.chTopLabel.text=[LANG DPLocalizedString:@"L_Out_Type"];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    self.firstTableView=[[UITableView alloc]init];
    self.firstTableView.backgroundColor=[UIColor clearColor];
    self.firstTableView.delegate=self;
    self.firstTableView.dataSource=self;
    [bgView addSubview: self.firstTableView];
    [self.firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backBtn.mas_bottom).offset([Dimens GDimens:10]);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    [self.firstTableView reloadData];
    // Do any additional setup after loading the view.
}
-(NSArray *)firstArray{
    if (!_firstArray) {
        _firstArray=@[
                      [LANG DPLocalizedString:@"L_Out_NULL"],
                      [LANG DPLocalizedString:@"L_Out_F"],
                      [LANG DPLocalizedString:@"L_Out_R"],
                      [LANG DPLocalizedString:@"L_Out_C"],
                      [LANG DPLocalizedString:@"L_Out_S"],
                      ];
    }
    return _firstArray;
}
-(void)dismissView{
    self.dismissBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSString*)getOutputSpkTypeNameByIndex:(int)index{
    switch (index) {
        case 0: return [LANG DPLocalizedString:@"L_Out_NULL"];
            
        case 1: return [LANG DPLocalizedString:@"L_Out_FL_Tweeter"];
        case 2: return [LANG DPLocalizedString:@"L_Out_FL_Midrange"];
        case 3: return [LANG DPLocalizedString:@"L_Out_FL_Woofer"];
        case 4: return [LANG DPLocalizedString:@"L_Out_FL_M_T"];
        case 5: return [LANG DPLocalizedString:@"L_Out_FL_M_WF"];
        case 6: return [LANG DPLocalizedString:@"L_Out_FL_Full"];
            
        case 7: return [LANG DPLocalizedString:@"L_Out_FR_Tweeter"];
        case 8: return [LANG DPLocalizedString:@"L_Out_FR_Midrange"];
        case 9: return [LANG DPLocalizedString:@"L_Out_FR_Woofer"];
        case 10: return [LANG DPLocalizedString:@"L_Out_FR_M_T"];
        case 11: return [LANG DPLocalizedString:@"L_Out_FR_M_WF"];
        case 12: return [LANG DPLocalizedString:@"L_Out_FR_Full"];
            
        case 13: return [LANG DPLocalizedString:@"L_Out_RL_Tweeter"];
        case 14: return [LANG DPLocalizedString:@"L_Out_RL_Woofer"];
        case 15: return [LANG DPLocalizedString:@"L_Out_RL_Full"];
            
        case 16: return [LANG DPLocalizedString:@"L_Out_RR_Tweeter"];
        case 17: return [LANG DPLocalizedString:@"L_Out_RR_Woofer"];
        case 18: return [LANG DPLocalizedString:@"L_Out_RR_Full"];
            
        case 19: return [LANG DPLocalizedString:@"L_Out_C_Tweeter"];
        case 20: return [LANG DPLocalizedString:@"L_Out_C_Woofer"];
        case 21: return [LANG DPLocalizedString:@"L_Out_C_Full"];
            
        case 22: return [LANG DPLocalizedString:@"L_Out_L_Subweeter"];
        case 23: return [LANG DPLocalizedString:@"L_Out_R_Subweeter"];
        case 24: return [LANG DPLocalizedString:@"L_Out_Subweeter"];
            
        case 25: return [LANG DPLocalizedString:@"L_Out_Front_Subweeter"];
        case 26: return [LANG DPLocalizedString:@"L_Out_Rear_Subweeter"];
        case 27: return [LANG DPLocalizedString:@"L_Out_C_Front"];
        case 28: return [LANG DPLocalizedString:@"L_Out_C_Rear"];
            
        default: return [LANG DPLocalizedString:@"L_Out_NULL"];
    }
}
#pragma mark-------tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Dimens GDimens:40];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 12;
    }else if (section==2){
        return 6;
    }else if (section==3){
        return 3;
    }else if (section==4){
        return 3;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.firstArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return [Dimens GDimens:45];
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else{
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:-60], [Dimens GDimens:45])];
        bgView.backgroundColor=[UIColor grayColor];
        UILabel *sectionLab=[[UILabel alloc]init];
        sectionLab.textColor=[UIColor whiteColor];
        sectionLab.font=[UIFont systemFontOfSize:15];
        sectionLab.text=self.firstArray[section];
        [bgView addSubview:sectionLab];
        [sectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX);
            make.centerY.equalTo(bgView.mas_centerY);
        }];
        return bgView;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    NSString *rowName=[[NSString alloc]init];
    if (indexPath.section==0) {
        rowName=[self getOutputSpkTypeNameByIndex:(int)indexPath.row];
//        return 1;
    }else if (indexPath.section==1){
         rowName=[self getOutputSpkTypeNameByIndex:(int)indexPath.row+1];
//        return 12;
    }else if (indexPath.section==2){
         rowName=[self getOutputSpkTypeNameByIndex:(int)indexPath.row+13];
//        return 6;
    }else if (indexPath.section==3){
         rowName=[self getOutputSpkTypeNameByIndex:(int)indexPath.row+19];
//        return 3;
    }else if (indexPath.section==4){
         rowName=[self getOutputSpkTypeNameByIndex:(int)indexPath.row+21];
//        return 3;
    }
    cell.textLabel.text=rowName;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myType==SPKTYPE_OUT) {
        if (indexPath.section==0) {
            RecStructData.System.out_spk_type[output_channel_sel]=indexPath.row;
            //        return 1;
        }else if (indexPath.section==1){
            RecStructData.System.out_spk_type[output_channel_sel]=indexPath.row+1;
            
            //        return 12;
        }else if (indexPath.section==2){
            RecStructData.System.out_spk_type[output_channel_sel]=indexPath.row+13;
            //        return 6;
        }else if (indexPath.section==3){
            RecStructData.System.out_spk_type[output_channel_sel]=indexPath.row+19;
            //        return 3;
        }else if (indexPath.section==4){
            RecStructData.System.out_spk_type[output_channel_sel]=indexPath.row+21;
            //        return 3;
        }
    }else if(self.myType==SPKTYPE_IN){
        if (indexPath.section==0) {
            RecStructData.System.in_spk_type[input_channel_sel]=indexPath.row;
            //        return 1;
        }else if (indexPath.section==1){
            RecStructData.System.in_spk_type[input_channel_sel]=indexPath.row+1;
            
            //        return 12;
        }else if (indexPath.section==2){
            RecStructData.System.in_spk_type[input_channel_sel]=indexPath.row+13;
            //        return 6;
        }else if (indexPath.section==3){
            RecStructData.System.in_spk_type[input_channel_sel]=indexPath.row+19;
            //        return 3;
        }else if (indexPath.section==4){
            RecStructData.System.in_spk_type[input_channel_sel]=indexPath.row+21;
            //        return 3;
        }
        
    }
    
    
    [self dismissView];
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

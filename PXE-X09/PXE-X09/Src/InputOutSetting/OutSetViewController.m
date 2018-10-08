//
//  OutSetViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/29.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "OutSetViewController.h"

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
    // Do any additional setup after loading the view.
}
-(void)creatTopView{
    
}
-(void)creatTableView{
    
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

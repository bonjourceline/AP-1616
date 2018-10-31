//
//  QIZLikeTableViewController.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/30.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZLikeTableViewController.h"
#import "LocalEffectTableViewCell.h"
#import "SEFFFile.h"
#import "Masonry.h"
#import "QIZDatabaseTool.h"
#import "QIZFileTool.h"


#define kTopViewH 50
#define kBottomViewH 60

#define kEffectOpInBtnW 30
#define kEffectOpInBtnH 45

#define kTopBtnW 110
#define kTopBtnH 40

#define kMargin 10

@interface QIZLikeTableViewController ()<LocalEffectTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,UIAlertViewDelegate>
{
    float _nActiveRowHeight;
}

@end

@implementation QIZLikeTableViewController

-(NSMutableArray *)arrayM
{
    if (!_arrayM) {
        _arrayM = [NSMutableArray array];
    }
    return _arrayM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _nActiveRowHeight = 50.0;
    self.isMultiSelect = NO;
    self.isAllSelect = NO;
    self.selectRowTotal = 0;
    self.isASC = YES;
    
    self.openMultiH =  KScreenHeight-kTopViewH-kBottomViewH-113;
    self.closeMultiH =  KScreenHeight-kTopViewH-kBottomViewH-55;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopViewH, KScreenWidth, self.closeMultiH+1)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = SetColor(UI_SystemBgColor);
    [self.view addSubview:_tableView];
    
    //顶部视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, KScreenWidth+2, kTopViewH)];
    _topView.layer.borderColor = SetColor(UI_TSEFFFToolbarBoderColor).CGColor;
    _topView.layer.borderWidth = 1.0;
    [_topView setBackgroundColor:SetColor(UI_SystemBgColor)];
    [self.view addSubview:_topView];
    
    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderBtn setImage:[UIImage imageNamed:@"seff_order_up"] forState:UIControlStateNormal];
    [_orderBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_reorder"] forState:UIControlStateNormal];
    _orderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_orderBtn setTitleColor:SetColor(UI_TSEFFF_OPT_TextColor) forState:UIControlStateNormal];
    [self.topView addSubview:_orderBtn];
    
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allSelectBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
    [_allSelectBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_sellall"]  forState:UIControlStateNormal];
    _allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_allSelectBtn setTitleColor:SetColor(UI_TSEFFF_OPT_TextColor) forState:UIControlStateNormal];
    [self.topView addSubview:_allSelectBtn];
    
    _multiSelectOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_multiSelectOpenBtn setImage:[UIImage imageNamed:@"seff_multiselect"] forState:UIControlStateNormal];
    [_multiSelectOpenBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_multiselect"]  forState:UIControlStateNormal];
    _multiSelectOpenBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_multiSelectOpenBtn setTitleColor:SetColor(UI_TSEFFF_OPT_TextColor) forState:UIControlStateNormal];
//    [self.topView addSubview:_multiSelectOpenBtn];
    
    _multiSelectLabel = [UILabel new];
    _multiSelectLabel.textColor = [UIColor whiteColor];
    _multiSelectLabel.text = [LANG DPLocalizedString:@"L_seffitem_haveSel"] ;
    _multiSelectLabel.textAlignment = NSTextAlignmentCenter;
    _multiSelectLabel.font = [UIFont systemFontOfSize:15.0];
    [self.topView addSubview:_multiSelectLabel];

    
//    [self.multiSelectOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.topView.mas_right).mas_equalTo(-2*kMargin);
//        make.centerY.mas_equalTo(self.topView.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(kTopBtnW, kTopBtnH));
//    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).mas_equalTo(2*kMargin);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kTopBtnW, kTopBtnH));
    }];
    
    //全选
    [self.allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).mas_equalTo(2*kMargin);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kTopBtnW, kTopBtnH));
    }];
    
    [self.multiSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kTopBtnW, kTopBtnH));
    }];
    
    //底部视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-kBottomViewH, KScreenWidth, kBottomViewH)];
    _bottomView.backgroundColor = SetColor(UI_TSEFFFBotBarBgColor);
    [self.view addSubview:_bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake( KScreenWidth,kBottomViewH));
    }];
    
    _multiCollectionBtn = [IconButton new];
    [_multiCollectionBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_favoriate"] forState:UIControlStateNormal];
    _multiCollectionBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_multiCollectionBtn setImage:[UIImage imageNamed:@"seff_favorite"] forState:UIControlStateNormal];
    [self.bottomView addSubview:_multiCollectionBtn];
    [self.multiCollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.bottomView.mas_left).mas_equalTo((0.5*KScreenWidth-kEffectOpInBtnW)*0.5);
        make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
    }];
    
    _multiLikeBtn = [IconButton new];
    [_multiLikeBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_love"]  forState:UIControlStateNormal];
    _multiLikeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_multiLikeBtn setImage:[UIImage imageNamed:@"seff_love"] forState:UIControlStateNormal];
    [self.bottomView addSubview:_multiLikeBtn];
    [self.multiLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
    }];

    _multiDeteleBtn = [IconButton new];
    [_multiDeteleBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_delete"]  forState:UIControlStateNormal];
    _multiDeteleBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_multiDeteleBtn setImage:[UIImage imageNamed:@"seff_delete"] forState:UIControlStateNormal];
    [self.bottomView addSubview:_multiDeteleBtn];
    [self.multiDeteleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.right.mas_equalTo(self.bottomView.mas_right).mas_equalTo(-(0.5*KScreenWidth-kEffectOpInBtnW)*0.5);
        make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
    }];
    
    if (self.isMultiSelect) {
        self.orderBtn.hidden = YES;
        self.allSelectBtn.hidden = NO;
        self.multiSelectLabel.hidden = NO;
        self.bottomView.hidden = NO;
    }else {
        self.orderBtn.hidden = NO;
        self.allSelectBtn.hidden = YES;
        self.multiSelectLabel.hidden = YES;
        self.bottomView.hidden = YES;
    }

    //添加监听事件
    [self.orderBtn addTarget:self action:@selector(doOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.allSelectBtn addTarget:self action:@selector(doAllSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.multiSelectOpenBtn addTarget:self action:@selector(doMultiSelectOpenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.multiCollectionBtn addTarget:self action:@selector(doMultiCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.multiLikeBtn addTarget:self action:@selector(doMultiLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.multiDeteleBtn addTarget:self action:@selector(doMultiDeteleBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ------多选监听事件-----
-(void)doOrderBtn:(UIButton *)sender
{
    self.isASC = !self.isASC;
    if (self.isASC) {
        [_orderBtn setImage:[UIImage imageNamed:@"seff_order_up"] forState:UIControlStateNormal];
        self.arrayM = [QIZDatabaseTool queryAllDataSortMode:@"ASC"];
    }else {
        [_orderBtn setImage:[UIImage imageNamed:@"seff_order_down"] forState:UIControlStateNormal];
        self.arrayM = [QIZDatabaseTool queryAllDataSortMode:@"DESC"];
    }
    [self.tableView reloadData];
    //NSLog(@"doOrderBtn");
}

-(void)doAllSelectBtn:(UIButton *)sender
{
    self.isAllSelect = !self.isAllSelect;
    
    //本身按钮更新
    if (self.isAllSelect) {
        self.selectRowTotal = (int)self.arrayM.count;
        [self.allSelectBtn setImage:[UIImage imageNamed:@"seff_sel_press"] forState:UIControlStateNormal];
    }else {
        self.selectRowTotal = 0;
        [self.allSelectBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
    }
    
    if (self.isMultiSelect) {
        for (int i=0; i<self.arrayM.count; i++) {
            LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isCheck = self.isAllSelect;
            
            //更新模型 数据库
            SEFFFile *effData = (SEFFFile *)self.arrayM[i];
            effData.list_sel = [NSString stringWithFormat:@"%d",self.isAllSelect];
            [QIZDatabaseTool updateRowCheckFieldValue:[NSString stringWithFormat:@"%d",self.isAllSelect] where:effData.data_group_name];
            
            if ([effData.list_sel isEqualToString:@"0"]) {
                effData.list_sel = @"0";
                [QIZDatabaseTool updateRowCheckFieldValue:@"0" where:effData.data_group_name];
            }else {
                effData.list_sel = @"1";
                [QIZDatabaseTool updateRowCheckFieldValue:@"1" where:effData.data_group_name];
            }
            [self.arrayM replaceObjectAtIndex:i withObject:effData];
        }
    }
    
    NSString *selectedStr = [NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_seffitem_haveSel"],self.selectRowTotal];
    self.multiSelectLabel.text = selectedStr;
    
    [self.tableView reloadData];
}

-(void)doMultiSelectOpenBtn:(UIButton *)sender
{
    self.isMultiSelect = !self.isMultiSelect;
    
    //顶部视图切换
    if (self.isMultiSelect) {
        self.allSelectBtn.hidden = NO;
        self.orderBtn.hidden = YES;
        self.multiSelectLabel.hidden = NO;
        [self.multiSelectOpenBtn setImage:nil forState:UIControlStateNormal];
        [self.multiSelectOpenBtn setTitle:[LANG DPLocalizedString:@"L_System_Cancel"] forState:UIControlStateNormal];
    }else {
        self.allSelectBtn.hidden = YES;
        self.orderBtn.hidden = NO;
        self.multiSelectLabel.hidden = YES;
        [self.multiSelectOpenBtn setImage:[UIImage imageNamed:@"seff_multiselect"] forState:UIControlStateNormal];
        [self.multiSelectOpenBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_multiselect"] forState:UIControlStateNormal];
    }
    
    //表格高度变化
//    if (self.isMultiSelect) {
//        self.tableView.rowHeight = self.openMultiH;
//    }else {
//        self.tableView.rowHeight = self.closeMultiH;
//    }
    
    //显示隐藏底部视图
    
    if (self.isMultiSelect) {
        self.bottomView.hidden = NO;
        [self.tableView setFrame:CGRectMake(0, kTopViewH, KScreenWidth,
                                            self.closeMultiH+1-
                                            self.bottomView.frame.size.height)];
    }else {
        self.bottomView.hidden = YES;
        [self.tableView setFrame:CGRectMake(0, kTopViewH, KScreenWidth,                                            self.closeMultiH+1)];
    }
    
    //如果点击取消重置
    if (!self.isMultiSelect) {
        self.isAllSelect = NO;
        self.selectRowTotal = 0;
        [self.allSelectBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
        NSString *selectedStr = [NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_seffitem_haveSel"],self.selectRowTotal];
        self.multiSelectLabel.text = selectedStr;
        for (int i=0; i<self.arrayM.count; i++) {
            LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isCheck = NO;
            cell.isOpen = NO;
        }
    }else{
        self.isAllSelect = NO;
        for (int i=0; i<self.arrayM.count; i++) {
            LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isCheck = NO;
            cell.isOpen = NO;
            //更新模型 数据库
            SEFFFile *effData = (SEFFFile *)self.arrayM[i];
            effData.list_sel = [NSString stringWithFormat:@"%d",self.isAllSelect];
            [QIZDatabaseTool updateRowCheckFieldValue:[NSString stringWithFormat:@"%d",self.isAllSelect] where:effData.data_group_name];
            
            effData.list_sel = @"0";
            [self.arrayM replaceObjectAtIndex:i withObject:effData];
            [QIZDatabaseTool updateRowCheckFieldValue:@"0" where:effData.data_group_name];
        }
    }

    [self.tableView reloadData];

    //NSLog(@"FUCK doMultiSelectBtn");
}

-(void)doMultiCollectionBtn:(UIButton *)sender
{
    int collectionTotal = 0;
    int allYES = 0;
    int allNO = 0;
    NSMutableArray *checkArrayM = [NSMutableArray array];
    for (int i=0; i<self.arrayM.count; i++) {
        LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.isCheck) {
            [checkArrayM addObject:[NSNumber numberWithInt:i]];
            
            collectionTotal++;
            SEFFFile *effData = (SEFFFile *)self.arrayM[i];
            NSString *collectionStatus = effData.file_favorite;
            if ([collectionStatus isEqualToString:@"0"]) {
                allNO++;
            }else {
                allYES++;
            }
        }
    }
    
    //0：全部未收藏 1：全部收藏 2：收藏、未收藏混合
    int collectionFlag = 0;
    if (collectionTotal == allNO) {
        collectionFlag = 0;
    }else if(collectionTotal == allYES){
        collectionFlag = 1;
    }else {
        collectionFlag = 2;
    }
    
    //处理收藏状态
    if (0 == collectionTotal) {
        return;
    }
    
    switch (collectionFlag) {
        case 0://修改成收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_favorite = @"1";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateFavoriteFieldValue:@"1" where:effData.data_group_name];
            }
            
        }
            break;
        case 1: //修改成未收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_favorite = @"0";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateFavoriteFieldValue:@"0" where:effData.data_group_name];
            }
        }
            break;
        case 2://修改成收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_favorite = @"1";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateFavoriteFieldValue:@"1" where:effData.data_group_name];
            }
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    //NSLog(@"doMultiCollectionBtn");
}

-(void)doMultiLikeBtn:(UIButton *)sender
{
    int collectionTotal = 0;
    int allYES = 0;
    int allNO = 0;
    NSMutableArray *checkArrayM = [NSMutableArray array];
    for (int i=0; i<self.arrayM.count; i++) {
        LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        SEFFFile *effData = (SEFFFile *)self.arrayM[i];
        
        if ([effData.list_sel isEqualToString:@"1"]) {
            [checkArrayM addObject:[NSNumber numberWithInt:i]];
            
            collectionTotal++;
            SEFFFile *effData = (SEFFFile *)self.arrayM[i];
            NSString *collectionStatus = effData.file_love;
            if ([collectionStatus isEqualToString:@"0"]) {
                allNO++;
            }else {
                allYES++;
            }
        }
    }
    
    //0：全部未喜欢 1：全部喜欢 2：喜欢、未喜欢混合
    int likeFlag = 0;
    if (collectionTotal == allNO) {
        likeFlag = 0;
    }else if(collectionTotal == allYES){
        likeFlag = 1;
    }else {
        likeFlag = 2;
    }
    
    //处理收藏状态
    if (0 == collectionTotal) {
        return;
    }
    
    switch (likeFlag) {
        case 0://修改成收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_love = @"1";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateLoveFieldValue:@"1" where:effData.data_group_name];
            }
            
        }
            break;
        case 1: //修改成未收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_love = @"0";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateLoveFieldValue:@"0" where:effData.data_group_name];
            }
        }
            break;
        case 2://修改成收藏状态
        {
            int index = 0;
            for (int i=0; i<checkArrayM.count; i++) {
                //修改模型、数据库
                index = [[checkArrayM objectAtIndex:i] intValue];
                SEFFFile *effData = (SEFFFile *)self.arrayM[index];
                effData.file_love = @"1";
                [self.arrayM replaceObjectAtIndex:index withObject:effData];
                [QIZDatabaseTool updateLoveFieldValue:@"1" where:effData.data_group_name];
            }
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.arrayM];
    for (SEFFFile *effData in copyArray) {
        if ([effData.file_love isEqualToString:@"0"]) {
            [self.arrayM removeObject:effData];
        }
    }
    
    [self.tableView reloadData];
    //NSLog(@"doMultiLikeBtn");
}

-(void)doMultiDeteleBtn:(UIButton *)sender
{
    NSMutableArray *checkArrayM = [NSMutableArray array];
    for (int i=0; i<self.arrayM.count; i++) {
        LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        SEFFFile *effData = (SEFFFile *)self.arrayM[i];
        if ([effData.list_sel isEqualToString:@"1"]) {
            [checkArrayM addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    //删除
    if (checkArrayM.count>0) {
        
        int index = 0;
        for (int i=0; i<checkArrayM.count; i++) {

            index = [[checkArrayM objectAtIndex:i] intValue];
            SEFFFile *effData = (SEFFFile *)self.arrayM[index]; //这里下标
            
            //1.删除数据库
            NSString *nID = [NSString stringWithFormat:@"%d",effData.autoID];
            BOOL isDBDelete = [QIZDatabaseTool deleteSingleRecord:nID];
            //NSLog(@"isDBDelete=%d",isDBDelete);
            //2.删除沙盒中的数据文件
            NSString *fFileName = effData.file_name;
            NSString *aFileName;
            if ([effData.file_type isEqualToString:@"complete"]) {
                aFileName = [fFileName stringByAppendingString:SEFFM_TYPE];
            }else {
                aFileName = [fFileName stringByAppendingString:SEFFS_TYPE];
            }

            [QIZFileTool deleteFileToBox:aFileName];

        }
        
        //重新查询出数据赋值
        self.arrayM = [QIZDatabaseTool queryAllData];

        //4.收起弹出菜单
        for (int i=0; i<self.arrayM.count; i++) {
            LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isOpen = NO;
            cell.isCheck = NO;
        }
        
        self.multiSelectLabel.text = [NSString stringWithFormat:@"%@:0",[LANG DPLocalizedString:@"L_seffitem_haveSel"]];
        
        //5.刷新表格
        [self.tableView reloadData];
        
    }
    
    //NSLog(@"doMultiDeteleBtn");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.tableView.frame = CGRectMake(0, 20, kWindowW, kWindowH-40);
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 20)];
//    view.backgroundColor = [UIColor blueColor];
//    [self.tableView addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.arrayM.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _nActiveRowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"fuck you";
    return cell;
    */
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
//    static NSString *CellIdentifier = @"Cell";
    LocalEffectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LocalEffectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SEFFFile *effData = (SEFFFile *)self.arrayM[indexPath.row];
    
    cell.effectTitleLabel.text = effData.data_group_name;
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        cell.singleLabel.text = [LANG DPLocalizedString:@"L_SSM_Machine2"];
    }else {
        cell.singleLabel.text = [LANG DPLocalizedString:@"L_SSM_Single2"];
    }
    
//    BOOL isLogin = [CLZUserDefaults isLogined];
//    if (isLogin) {
//        NSString *userName = [CLZUserDefaults getUserName];
//        cell.userNameLabel.text = userName;
//        
//    }else {
//        cell.userNameLabel.text = @"";
//    }
//    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *strUpLoadDate = effData.data_upload_time;
    NSString *strAppend = [NSString stringWithFormat:@"%@:", [LANG DPLocalizedString:@"L_down_title_time"]];
    cell.uploadTimeLabel.text = [strAppend stringByAppendingString:strUpLoadDate];
    
    [cell.popMenuBtn setImage:[UIImage imageNamed:@"seff_menu"] forState:UIControlStateNormal];
    cell.delegate = self;
    //NSLog(@"section:%d,row:%d",(int)indexPath.section,(int)indexPath.row);
    [cell.popMenuBtn addTarget:self action:@selector(doOpenMenu:) forControlEvents:UIControlEventTouchUpInside];
    
     
    if (cell.isOpen) {
        cell.effectOpView.hidden = NO;
    }
    else {
        cell.effectOpView.hidden = YES;
    }
    
    _nActiveRowHeight = cell.cellHeight;
    
    [cell.applicationBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_apply"] forState:UIControlStateNormal];
    [cell.shareBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_share"] forState:UIControlStateNormal];
//    [cell.collectionBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_favoriate"] forState:UIControlStateNormal];
    [cell.likeBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_love"] forState:UIControlStateNormal];
    [cell.deleteBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_delete"] forState:UIControlStateNormal];
    [cell.detailBtn setTitle:[LANG DPLocalizedString:@"L_seffitem_details"] forState:UIControlStateNormal];
    
    //添加监听事件
    [cell.applicationBtn addTarget:self action:@selector(doApplyEffect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(doShareEffect:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.collectionBtn addTarget:self action:@selector(doCollectionEffect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(doLikeEffect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(doDeleteEffect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailBtn addTarget:self action:@selector(doDetailEffect:) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏、喜欢
    NSString *collectionFlag = effData.file_favorite;
    NSString *likeFlag = effData.file_love;
    
    if ([collectionFlag isEqualToString:@"0"]) {
        cell.collectionIconCellBtn.hidden = YES;
    }else {
        cell.collectionIconCellBtn.hidden = NO;
    }
    
    if ([likeFlag isEqualToString:@"0"]) {
        cell.likeIconCellBtn.hidden = YES;
    }else {
        cell.likeIconCellBtn.hidden = NO;
    }
    
    [cell.collectionIconCellBtn addTarget:self action:@selector(doCollectionEffectCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeIconCellBtn addTarget:self action:@selector(doLikeEffectCell:) forControlEvents:UIControlEventTouchUpInside];
    
    //多选
    if ([effData.list_sel isEqualToString:@"1"]) {
        [cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_press"] forState:UIControlStateNormal];
    }else {
        [cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
    }
//    if (cell.isCheck) {
//        [cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_press"] forState:UIControlStateNormal];
//    }else {
//        [cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
//    }
    
    if (self.isMultiSelect) {
        cell.multiCheckBtn.hidden = NO;
    }else{
        cell.multiCheckBtn.hidden = YES;
    }
    [cell.multiCheckBtn addTarget:self action:@selector(doMultiCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.multiCheckBtn.tag = indexPath.row;
    cell.collectionIconCellBtn.tag = indexPath.row;
    cell.likeIconCellBtn.tag = indexPath.row;
    cell.popMenuBtn.tag = indexPath.row;
    cell.applicationBtn.tag = indexPath.row;
    cell.shareBtn.tag = indexPath.row;
//    cell.collectionBtn.tag = indexPath.row;
    cell.likeBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    cell.detailBtn.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = (int)indexPath.row;
//    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
//    NSString *detailStr = effData.data_eff_briefing;
    
    SEFFFile *effData = (SEFFFile *)self.arrayM[indexPath.row];
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        [self showUseMACSEFFDialog];
    }else {
       [self showUseSingleSEFFDialog];
    }
    //NSLog(@"didSelectRowAtIndexPath");
}


#pragma mark ----------菜单展开-------------
-(void)doOpenMenu:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    //NSLog(@"doOpenMenu:%d",(int)sender.tag);
//  这里屏蔽
//    NSIndexPath *first = [NSIndexPath
//                          indexPathForRow:1 inSection:0];
//    
//    [self.tableView selectRowAtIndexPath:first
//                           animated:YES
//                     scrollPosition:UITableViewScrollPositionTop];
    
    for (int i=0; i<self.arrayM.count; i++) {
        LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if((int)sender.tag == i){
            if (cell.isOpen) {
                cell.isOpen = FALSE;
            }else {
                cell.isOpen = TRUE;
            }
        }
        else {
            cell.isOpen = FALSE;
        }
    }
    
    [self.tableView reloadData];

}

-(void)doApplyEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        [self showUseMACSEFFDialog];
    }else {
        [self showUseSingleSEFFDialog];
    }
    //NSLog(@"doApplyEffect");
}

-(void)doShareEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;

    //数据库中或模型中获取文件路径
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *fileName = effData.file_name;
    
    NSString *filePath;
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        filePath = [QIZFileTool fileFullPath:fileName withType:SEFFM_TYPE];
    }else {
        filePath = [QIZFileTool fileFullPath:fileName withType:SEFFS_TYPE];
    }
    
    
    //NSLog(@"%@",filePath);
    _doc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _doc.UTI = @"public.plain-text";
    _doc.delegate = self;
    
    //    [doc presentPreviewAnimated:YES];  //弹出预览对话框
    
    CGRect navRect = self.navigationController.navigationBar.frame;
//    navRect.size =CGSizeMake(self.view.width,40.0f);
    [_doc presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
    //NSLog(@"doShareEffect");
}

-(void)doCollectionEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *collectionFlag = effData.file_favorite;
    
    //更新数据库，更新模型数据
    if ([collectionFlag isEqualToString:@"0"]) {
        effData.file_favorite = @"1";
        [QIZDatabaseTool updateFavoriteFieldValue:@"1" where:effData.data_group_name];
    }else {
        effData.file_favorite = @"0";
        [QIZDatabaseTool updateFavoriteFieldValue:@"0" where:effData.data_group_name];
    }
    
    [self.tableView reloadData];
    
    //NSLog(@"doCollectionEffect");
}

-(void)doLikeEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *likeFlag = effData.file_love;
    
    //更新数据库，更新模型数据
    if ([likeFlag isEqualToString:@"0"]) {
        effData.file_love = @"1";
        [QIZDatabaseTool updateLoveFieldValue:@"1" where:effData.data_group_name];
    }else {
        effData.file_love = @"0";
        [QIZDatabaseTool updateLoveFieldValue:@"0" where:effData.data_group_name];
    }
    
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.arrayM];
    for (SEFFFile *effData in copyArray) {
        if ([effData.file_love isEqualToString:@"0"]) {
            [self.arrayM removeObject:effData];
        }
    }
    
    [self.tableView reloadData];
    //NSLog(@"doLikeEffect");
}

-(void)doDeleteEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    
    NSString *nID = [NSString stringWithFormat:@"%d",effData.autoID];
    
    NSString *fFileName = effData.file_name;
    NSString *aFileName;
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        aFileName = [fFileName stringByAppendingString:SEFFM_TYPE];
    }else {
        aFileName = [fFileName stringByAppendingString:SEFFS_TYPE];
    }
    
    //1.删除数据库
    BOOL isDBDelete = [QIZDatabaseTool deleteSingleRecord:nID];
    //NSLog(@"isDBDelete=%d",isDBDelete);
    //2.删除沙盒文件
    [QIZFileTool deleteFileToBox:aFileName];
    
    //3.删除数组中的对象
    [self.arrayM removeObjectAtIndex:self.selectIndex];
    
    //4.收起弹出菜单
    for (int i=0; i<self.arrayM.count; i++) {
        LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.isOpen = FALSE;
    }
    
    //5.刷新表格
    [self.tableView reloadData];
    
    
    //NSLog(@"doDeleteEffect");
}

-(void)doDetailEffect:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *detailStr = effData.data_eff_briefing;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[LANG DPLocalizedString:@"L_seffitem_details"]  message:detailStr delegate:self cancelButtonTitle:[LANG DPLocalizedString:@"L_System_OKstr"] otherButtonTitles:[LANG DPLocalizedString:@"L_System_Cancel"], nil];
    [alertView show];
    
    //NSLog(@"doDetailEffect");
}

#pragma mark ------cell中收藏、喜欢监听事件-------
-(void)doCollectionEffectCell:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *collectionFlag = effData.file_favorite;
    
    //更新数据库，更新模型数据
    if ([collectionFlag isEqualToString:@"1"]) {
        effData.file_favorite = @"0";
        [QIZDatabaseTool updateFavoriteFieldValue:@"0" where:effData.data_group_name];
    }
    
    [self.tableView reloadData];

    //NSLog(@"doCollectionEffectCell");
}

-(void)doLikeEffectCell:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    NSString *likeFlag = effData.file_love;
    
    //更新数据库，更新模型数据
    if ([likeFlag isEqualToString:@"1"]) {
        effData.file_love = @"0";
        [QIZDatabaseTool updateLoveFieldValue:@"0" where:effData.data_group_name];
    }
    
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.arrayM];
    for (SEFFFile *effData in copyArray) {
        if ([effData.file_love isEqualToString:@"0"]) {
            [self.arrayM removeObject:effData];
        }
    }
    
    [self.tableView reloadData];
    
    //NSLog(@"doLikeEffectCell");
}

//多选
-(void)doMultiCheckBtn:(UIButton *)sender
{
    self.selectIndex = (int)sender.tag;
    LocalEffectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
    cell.isCheck = !cell.isCheck;
    //NSLog(@"FFF doMultiCheckBtn:%d",self.selectIndex);
    //更新模型 数据库
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    effData.list_sel = [NSString stringWithFormat:@"%d",self.isAllSelect];

    if (cell.isCheck) {
        self.selectRowTotal++;
        
        effData.list_sel = @"1";
        [QIZDatabaseTool updateRowCheckFieldValue:@"1" where:effData.data_group_name];
       // [cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_press"] forState:UIControlStateNormal];
    }else {
        self.selectRowTotal--;
        
        effData.list_sel = @"0";
        [QIZDatabaseTool updateRowCheckFieldValue:@"0" where:effData.data_group_name];
        //[cell.multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
    }
    
    NSString *selectedStr = [NSString stringWithFormat:@"%@:%d",[LANG DPLocalizedString:@"L_seffitem_multiselect"],self.selectRowTotal];
    self.multiSelectLabel.text = selectedStr;
    
    [self.tableView reloadData];
    
    
}


#pragma mark ------选中行代理方法-------
- (void)selectedRowClick:(NSInteger)tag
{
//    self.selectIndex = (int)sender.tag;
    //NSLog(@"selectedRowClick:%d",(int)tag);
}

#pragma mark ----UIDocumentInteractionController代理方法----
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
    
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view.frame;
    
    
}

#pragma mark -----UIAlertView代理方法-------
- (void)dealWithSEFF{
    //1.读取文件转赋值给模型
    SEFFFile *effData = (SEFFFile *)self.arrayM[self.selectIndex];
    
    if ([effData.file_type isEqualToString:@"complete"]) {
        
        //整机文件
        
        bool res = [self.mDataTransmitOpt jsonDataToDataArray:effData.file_name withFileType:effData.file_type];
        if(res){
            //3.写入当前调用时间到数据库
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            effData.apply_time = strDate;
            [QIZDatabaseTool updateApplyTimeFieldValue:strDate where:effData.file_name];
            
            //4.如果连接则下发到设备
            if (gConnectState) {
                [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_Save];
            }else{
                [self ShowConnectDialog];
            }
            
            
        }else{
            [self ShowFileErrorDialog];
        }
    } else {
        //单组文件
        
        bool res = [self.mDataTransmitOpt jsonDataToDataArray:effData.file_name withFileType:effData.file_type];
        if(res){
            //3.写入当前调用时间到数据库
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            effData.apply_time = strDate;
            [QIZDatabaseTool updateApplyTimeFieldValue:strDate where:effData.data_group_name];
            
            
            //4.如果连接则下发到设备
            if (gConnectState) {//显示进度条
                [self showSEFFLoadOrSaveProgress:[LANG DPLocalizedString:@"L_Data_Sync"] WithMode:SEFF_OPT_Save];                
            }else{
                [self ShowConnectDialog];
            }
        }else{
            [self ShowFileErrorDialog];
        }
    }
}
#pragma mark 进度提示框
-(void)initSaveLoadSEFFProgress{
    
    self.HUD_SEFF = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD_SEFF];    //常用的设置
    //小矩形的背景色
    //self.HUD_SEFF.color = [UIColor blueColor];//这儿表示无背景clearColor
    //显示的文字
    self.HUD_SEFF.labelText = @"";
    //细节文字
    self.HUD_SEFF.detailsLabelText = @"";
    //是否有庶罩
    self.HUD_SEFF.dimBackground = YES;
    //[self.HUD_SEFF hide:YES afterDelay:2];
    
    self.HUD_SEFF.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD_SEFF.delegate = self;
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    //NSLog(@"hudWasHidden");
    [hud removeFromSuperview];
    //[hud release];
    hud = nil;
}


-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode{
    [self initSaveLoadSEFFProgress];
    self.HUD_SEFF.detailsLabelText = Detail;
    [self.HUD_SEFF showWhileExecuting:@selector(HUD_SEFFProgressTask) onTarget:self withObject:nil animated:YES];
    
}
-(void) HUD_SEFFProgressTask{
    
    int cnt = [_mDataTransmitOpt GetSendbufferListCount];
    //NSLog(@"GetSendbufferListCount cnt=%d",cnt);
    
    SEFF_SendListTotal = cnt;
    int progress = 100;
    while (cnt > 0) {
        cnt = [_mDataTransmitOpt GetSendbufferListCount];
        progress = (int)((float)cnt/(float)SEFF_SendListTotal * 100);
        self.HUD_SEFF.labelText = [NSString stringWithFormat:@"%d%%",100-progress];
        self.HUD_SEFF.progress = 1-progress/100.0;
        usleep(10000);
    }
}

#pragma mark 提示框
//连接提示框
- (void)ShowConnectDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_System_CMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//文件解释错误提示框
- (void)ShowFileErrorDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_System_Title"]message:[LANG DPLocalizedString:@"L_FileError"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//使用整机文件提示框
- (void)showUseMACSEFFDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_AlertPreset"]message:[LANG DPLocalizedString:@"L_USE_MACSEFFMSG"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        [self dealWithSEFF];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {

    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//使用单组文件提示框
- (void)showUseSingleSEFFDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_AlertPreset"]message:[LANG DPLocalizedString:@"L_USE_SEFFMSG"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Confirm"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        [self dealWithSEFF];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {

    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end

//
//  QIZSearchEffectTableViewController.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/29.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZSearchEffectTableViewController.h"
#import "LocalEffectTableViewCell.h"
#import "SEFFFile.h"
#import "Masonry.h"
#import "QIZDatabaseTool.h"
#import "QIZFileTool.h"
//#import "UIView+Extension.h"
#import "QIZDatabaseTool.h"
#import "MBProgressHUD+MJ.h"

@interface QIZSearchEffectTableViewController ()<UISearchBarDelegate,UIDocumentInteractionControllerDelegate,LocalEffectTableViewCellDelegate,UIAlertViewDelegate>
{
    float _nActiveRowHeight;
}
@end

@implementation QIZSearchEffectTableViewController

-(NSMutableArray *)arrayM
{
    if (!_arrayM) {
        _arrayM = [NSMutableArray array];
    }
    return _arrayM;
}

-(NSMutableArray *)searchData
{
    if (_searchData == nil) {
        _searchData = [[NSMutableArray alloc] init];
    }
    return _searchData;
}

-(NSMutableArray *)searchDataModal
{
    if (_searchDataModal == nil) {
        _searchDataModal = [[NSMutableArray alloc] init];
    }
    return _searchDataModal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.tableFooterView=[UIView new];
    if (@available(iOS 11.0, *)) {
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _nActiveRowHeight = 50.0;
    
    // 默认没有开始搜索
    _isSearch = NO;
    
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setTintColor:[UIColor whiteColor]];
    _searchBar.tintColor=[UIColor whiteColor];
    
    
    // 设置没有输入时的提示占位符
    [_searchBar setPlaceholder:[LANG DPLocalizedString:@"L_TableSearch"]];
    self.navigationItem.titleView = _searchBar;
    
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
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
    cell.multiCheckBtn.hidden = YES;
    [cell.multiCheckBtn addTarget:self action:@selector(doMultiCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    [self.tableView reloadData];
    
    //NSLog(@"doLikeEffectCell");
}

//多选
-(void)doMultiCheckBtn:(UIButton *)sender
{
    /*
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
    */
    
}


#pragma mark ------选中行代理方法-------
- (void)selectedRowClick:(NSInteger)tag
{
    //    self.selectIndex = (int)sender.tag;
    //NSLog(@"selectedRowClick:%d",(int)tag);
}


#pragma mark - UISearchBarDelegate

// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    _isSearch = NO;
    [self.tableView reloadData];
}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    //NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchText];
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchBar.text];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

- (void) filterBySubstring:(NSString*) subStr
{
    //NSLog(@"----filterBySubstring------");
    // 设置为搜索状态
    _isSearch = YES;
    
    //1.模型重新赋值 查询数据库
    self.arrayM = [QIZDatabaseTool queryLikeName:subStr];
    
    //2.重新加载
    [self.tableView reloadData];
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

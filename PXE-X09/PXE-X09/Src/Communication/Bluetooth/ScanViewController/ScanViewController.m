//
//  ScanViewController.m
//  DSP-Play
//
//  Created by chs on 2017/12/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ScanViewController.h"
#import "MacDefine.h"

#import "Masonry.h"
#import "ScanTableViewCell.h"
#define  zerocount 5
#define AutoConnectFlg  @"AutoConnectFlg"
@interface ScanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *timeStr;
    BOOL isCancelAuto;//yes 取消自动连接 no 自动连接
}
@property (nonatomic,strong)UIButton *autoConnectBtn;
@end

@implementation ScanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isShow=YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[BLEManager shareBLEManager].baby cancelScan];
    self.isShow=NO;
    [self.activityIndicator stopAnimating];
    [self.timer invalidate];
    self.timer=nil;
}
//停止计时
-(void)StopTimeConnect{
    [self.timer invalidate];
    self.timer=nil;
    self.iscurTime=NO;
    [self.tableView reloadData];
}
-(void)StartTimeConnect{
    if (!self.timer) {
        __block int timeCount=0;
        timeStr=[NSString stringWithFormat:@"(%d)",[@(zerocount) intValue]];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            for (int i=0; i<[BLEManager shareBLEManager].peripherals.count; i++) {
                CBPeripheral *peripheral=[BLEManager shareBLEManager].peripherals[i];
                if (peripheral==self.LastSelectP) {
                    NSIndexPath *path=[NSIndexPath indexPathForRow:i inSection:0];
                    ScanTableViewCell *cell=[self.tableView cellForRowAtIndexPath:path];
                    timeStr=[NSString stringWithFormat:@"(%d)",zerocount-timeCount];
                    cell.timeCout.text=timeStr;
                    if (timeCount==zerocount) {
                        [[BLEManager shareBLEManager] connectBLEDevice:i];
                        cell.timeLabel.hidden=YES;
                        cell.timeCout.hidden=YES;
                        timeStr=[NSString stringWithFormat:@"(%d)",[@(zerocount) intValue]];
                        cell.timeCout.text=timeStr;
                        
                    }
                }
            }
            if (timeCount==zerocount) {
                [self StopTimeConnect];
                
            }
             timeCount ++;
        }];
    }
}
-(void)reloadMytableView{
    if ([[BLEManager shareBLEManager].peripherals containsObject:self.LastSelectP]) {
        self.iscurTime=YES;
        [self.tableView reloadData];
        if (!isCancelAuto) {
            
            [self StartTimeConnect];
        }
        
    }else{
        [self StopTimeConnect];
        [self.tableView reloadData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAutoFlg];
    self.view.backgroundColor=[UIColor clearColor];
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    backgroundView.backgroundColor=RGBA(0, 0, 0, 0.4);
    [self.view addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [backgroundView addGestureRecognizer:tap];
    
//    self.view.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:363], [Dimens GDimens:415])];
    whiteView.center=self.view.center;
     [self.view addSubview:whiteView];
    whiteView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    whiteView.layer.cornerRadius=11;
    whiteView.layer.masksToBounds=YES;
   
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, [Dimens GDimens:54])];
    titleLab.text=[LANG DPLocalizedString:@"spp_le_select_device"];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [whiteView addSubview:titleLab];
    [titleLab setTextColor:[UIColor blackColor]];
    
    self.autoConnectBtn=[[UIButton alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(titleLab.frame), whiteView.frame.size.width-28, [Dimens GDimens:35])];
    self.autoConnectBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.autoConnectBtn addTarget:self action:@selector(changeAutoConnect:) forControlEvents:UIControlEventTouchUpInside];
    [self.autoConnectBtn setTitle:[LANG DPLocalizedString:@"L_AutoConnect_device"] forState:UIControlStateNormal];
    [self.autoConnectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (isCancelAuto) {
         [self.autoConnectBtn setImage:[UIImage imageNamed:@"chs_autoconnect_normal"] forState:UIControlStateNormal];
    }else{
         [self.autoConnectBtn setImage:[UIImage imageNamed:@"chs_autoconnect_press"] forState:UIControlStateNormal];
    }
    self.autoConnectBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.autoConnectBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [whiteView addSubview:self.autoConnectBtn];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.autoConnectBtn.frame), whiteView.frame.size.width-28, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [whiteView addSubview:lineView];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.autoConnectBtn.frame)+0.5, whiteView.frame.size.width, whiteView.frame.size.height-[Dimens GDimens:69]-[Dimens GDimens:54]-self.autoConnectBtn.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
    [whiteView addSubview:self.tableView];

    UIButton *scanBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), whiteView.frame.size.width, [Dimens GDimens:69])];
    [scanBtn setTitle:[LANG DPLocalizedString:@"Rescan"] forState:UIControlStateNormal];
    [scanBtn setTitleColor:RGB(29, 136, 194) forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    scanBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [scanBtn addTarget:self action:@selector(toScan) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:scanBtn];

    self.activityIndicator.frame=CGRectMake(CGRectGetMaxX(scanBtn.frame)-[Dimens GDimens:100], scanBtn.frame.origin.y+([Dimens GDimens:69-20]/2+2), [Dimens GDimens:20], [Dimens GDimens:20]);
    [whiteView addSubview:self.activityIndicator];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScanTableViewCell"];
    
    
    // Do any additional setup after loading the view.
}
-(void)changeAutoConnect:(UIButton *)sender{
    if (isCancelAuto) {
        isCancelAuto=NO;
        [sender setImage:[UIImage imageNamed:@"chs_autoconnect_press"] forState:UIControlStateNormal];
        [self reloadMytableView];
    }else{
        isCancelAuto=YES;
        [sender setImage:[UIImage imageNamed:@"chs_autoconnect_normal"] forState:UIControlStateNormal];
        [self StopTimeConnect];
    }
    [self saveAutoFlg:isCancelAuto];
}
-(UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        self.activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped=YES;
    }
    return _activityIndicator;
}
-(void)toScan{
    [self.activityIndicator startAnimating];
    [[BLEManager shareBLEManager]doScanBluetoothPeriphals];
}
-(void)back{
    [self StopTimeConnect];
    [[BLEManager shareBLEManager].baby cancelScan];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray=[[NSMutableArray alloc]init];
//    }
//    return _dataArray;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --查看沙河自动连接的设置
-(void)getAutoFlg{
    isCancelAuto=[[NSUserDefaults standardUserDefaults]boolForKey:AutoConnectFlg];
}
-(void)saveAutoFlg:(BOOL)flg{
    [[NSUserDefaults standardUserDefaults]setBool:flg forKey:AutoConnectFlg];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return [BLEManager shareBLEManager].peripherals.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ([Dimens GDimens:367]-[Dimens GDimens:69]-[Dimens GDimens:54])/3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"ScanTableViewCell";
    ScanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.backgroundColor=[UIColor clearColor];
    NSLog(@"%ld",[BLEManager shareBLEManager].peripherals.count);
    CBPeripheral *peripheral=[BLEManager shareBLEManager].peripherals[indexPath.row];
    NSString *strID=[[NSString alloc]init];
    if (peripheral.identifier.UUIDString.length>12) {
        strID=[peripheral.identifier.UUIDString substringWithRange:NSMakeRange(peripheral.identifier.UUIDString.length-12, 12)];
    }else{
        strID=peripheral.identifier.UUIDString;
    }
    
    cell.blueIdLab.text=strID;
    if ((peripheral==self.LastSelectP)&&self.iscurTime&&(!isCancelAuto)) {
        cell.timeLabel.hidden=NO;
        cell.timeCout.hidden=NO;
        cell.timeCout.text=timeStr;
    }else{
        cell.timeCout.hidden=YES;
        cell.timeLabel.hidden=YES;
    }
    if (peripheral.name.length>0) {
          cell.bluetoothName.text=peripheral.name;
        
    }else{
        cell.bluetoothName.text=[NSString stringWithFormat:@"未知蓝牙"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self StopTimeConnect];
    [[BLEManager shareBLEManager]connectBLEDevice:(int)indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
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

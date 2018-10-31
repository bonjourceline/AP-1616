//
//  ScanViewController.h
//  DSP-Play
//
//  Created by chs on 2017/12/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEManager.h"
@interface ScanViewController : UIViewController
//@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong)CBPeripheral *LastSelectP;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL iscurTime;
-(void)StopTimeConnect;
-(void)reloadMytableView;
@end

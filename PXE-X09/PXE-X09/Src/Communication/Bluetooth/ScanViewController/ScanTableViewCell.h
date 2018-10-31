//
//  ScanTableViewCell.h
//  DSP-Play
//
//  Created by chs on 2017/12/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bluetoothName;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCout;
@property (weak, nonatomic) IBOutlet UILabel *blueIdLab;

@end

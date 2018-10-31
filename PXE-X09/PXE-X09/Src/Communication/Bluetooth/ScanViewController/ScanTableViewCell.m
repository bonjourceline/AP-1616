//
//  ScanTableViewCell.m
//  DSP-Play
//
//  Created by chs on 2017/12/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "ScanTableViewCell.h"

@implementation ScanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.text=[LANG DPLocalizedString:@"L_AutoConnect_device"];
    self.separatorInset=UIEdgeInsetsMake(0, 600, 0, 0);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

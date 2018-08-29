//
//  DelayTableViewCell.h
//  HH-RDDSP
//
//  Created by chs on 2018/3/20.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CHName;
@property (weak, nonatomic) IBOutlet UILabel *volLab;
@property (weak, nonatomic) IBOutlet UISlider *volSlider;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,assign)NSInteger channelIndex;
//主音量计数定时器 减
@property (nonatomic,strong) NSTimer *pVolMinusTimer;
@property (nonatomic,strong)NSTimer *pVolAddTimer;
@property (nonatomic,strong)void (^subBlock)(UISlider *slider,UILabel *valueLab);
@property (nonatomic,strong)void (^addBlock)(UISlider *slider,UILabel *valueLab);
@property (nonatomic,strong)void (^valueChangeBlock)(UISlider *slider,UILabel *valueLab);
@end

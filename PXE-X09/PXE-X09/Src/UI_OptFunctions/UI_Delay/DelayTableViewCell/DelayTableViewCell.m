//
//  DelayTableViewCell.m
//  HH-RDDSP
//
//  Created by chs on 2018/3/20.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "DelayTableViewCell.h"
#import "MacDefine.h"
#import "Define_Color.h"
@implementation DelayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor clearColor];
    self.volSlider.minimumValue=0;
    self.volSlider.maximumValue=DELAY_SETTINGS_MAX;
    self.volSlider.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
    self.volSlider.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
    [self.volSlider setThumbImage:[UIImage imageNamed:@"chs_mvs_thumb_normal"] forState:UIControlStateNormal];
    // Initialization code
    UILongPressGestureRecognizer *longPressVolMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeSUB_LongPress:)];
    longPressVolMinus.minimumPressDuration = 0.5; //定义按的时间
    [self.subBtn addGestureRecognizer:longPressVolMinus];
    [self.volSlider addTarget:self action:@selector(sliderDidChange) forControlEvents:UIControlEventValueChanged];
    UILongPressGestureRecognizer *longPressVolAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_VolumeAdd_LongPress:)];
    longPressVolAdd.minimumPressDuration = 0.5; //定义按的时间
    [self.addBtn addGestureRecognizer:longPressVolAdd];
    
}
//长按操作
-(void)Btn_VolumeSUB_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolMinusTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(subClick:) userInfo:nil repeats:YES];
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolMinusTimer.isValid){
            [_pVolMinusTimer invalidate];
            _pVolMinusTimer = nil;
            NSLog(@"主音量减长按结束");
        }
    }
    
}
-(void)sliderDidChange{
    self.valueChangeBlock(self.volSlider, self.volLab);
}
-(void)Btn_VolumeAdd_LongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        _pVolAddTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addClick:) userInfo:nil repeats:YES];
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        if(_pVolAddTimer.isValid){
            [_pVolAddTimer invalidate];
            _pVolAddTimer = nil;
            NSLog(@"主音量加长按结束");
        }
    }
}
- (IBAction)subClick:(UIButton *)sender {
    self.subBlock(self.volSlider,self.volLab);
}
- (IBAction)addClick:(UIButton *)sender {
    self.addBlock(self.volSlider,self.volLab);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MixerTableViewCell.m
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/13.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MixerTableViewCell.h"

@implementation MixerTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}
-(void)initView{

    self.separatorInset=UIEdgeInsetsMake(0, 600, 0, 0);
    self.userInteractionEnabled=YES;
    self.backgroundColor=[UIColor clearColor];
    self.item=[[MixerItem alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [Dimens GDimens:MixerItemHeight]-0.5)];
    self.item.userInteractionEnabled=YES;
    self.item.SB_Volume.userInteractionEnabled=YES;
    [self.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_IN"]]];
    [self.item setDataMax:Mixer_Volume_MAX];
    [self.item addTarget:self action:@selector(MixerItemEvent) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.item];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:MixerItemHeight]-0.5, KScreenWidth, 0.5)];
    view.backgroundColor=SetColor(0xFF2d2e31);
    [self.contentView addSubview:view];
    
    
//    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-100, 50, 20, 20 )];
//    button.backgroundColor=[UIColor yellowColor];
//    [button addTarget:self action:@selector(ddddd) forControlEvents:UIControlEventTouchUpInside];
//    [self.item addSubview:button];
}
-(void)ddddd{
    NSLog(@"1111");
}
-(void)MixerItemEvent{
    
    self.MixerBlock(self.item);
    
}
//-(void)setSelected:(BOOL)selected{
//    if (selected) {
//
//    }else{
//
//
//    }
//
//}
//- (void)MixerItemEvent:(MixerItem*)sender{
//    if(self.mMixerItem != nil){
//        [self.mMixerItem setMixerItemNormal];
//    }
//
//    input_channel_sel = (int) ((int)sender.tag - TagStart_MixerItem_self);
//    _CurMixerItem = (MixerItem *)[self.view viewWithTag:input_channel_sel+TagStart_MixerItem_self];
//    [_CurMixerItem setMixerItemPress];
//    _mMixerItem = _CurMixerItem;
//
//    //    if(input_channel_sel == 8){
//    //        input_channel_sel = 10;
//    //    }
//
//    int val = [_CurMixerItem getDataVal];
//    [self setIN_VolByIndex:input_channel_sel withVal:val];
//}
//- (int)getIN_VolByIndex:(int)index{
//    switch (index) {
//        case 0: return RecStructData.OUT_CH[output_channel_sel].IN1_Vol;
//        case 1: return RecStructData.OUT_CH[output_channel_sel].IN2_Vol;
//        case 2: return RecStructData.OUT_CH[output_channel_sel].IN3_Vol;
//        case 3: return RecStructData.OUT_CH[output_channel_sel].IN4_Vol;
//        case 4: return RecStructData.OUT_CH[output_channel_sel].IN5_Vol;
//        case 5: return RecStructData.OUT_CH[output_channel_sel].IN6_Vol;
//        case 6: return RecStructData.OUT_CH[output_channel_sel].IN7_Vol;
//        case 7: return RecStructData.OUT_CH[output_channel_sel].IN8_Vol;
//        case 8: return RecStructData.OUT_CH[output_channel_sel].IN9_Vol;
//        case 9: return RecStructData.OUT_CH[output_channel_sel].IN10_Vol;
//        case 10: return RecStructData.OUT_CH[output_channel_sel].IN11_Vol;
//        case 11: return RecStructData.OUT_CH[output_channel_sel].IN12_Vol;
//        case 12: return RecStructData.OUT_CH[output_channel_sel].IN13_Vol;
//        case 13: return RecStructData.OUT_CH[output_channel_sel].IN14_Vol;
//        case 14: return RecStructData.OUT_CH[output_channel_sel].IN15_Vol;
//        case 15: return RecStructData.OUT_CH[output_channel_sel].IN16_Vol;
//        default:
//            return 100;
//            break;
//    }
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//-(void)setSelected:(BOOL)selected{
//    if (selected) {
//        [self.item setMixerItemPress];
//    }else{
//        [self.item setMixerItemNormal];
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.item setMixerItemPress];
    }else{
        [self.item setMixerItemNormal];
    }
    // Configure the view for the selected state
}

@end

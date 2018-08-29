//
//  MixCollectionViewCell.m
//  OY-DCP680-RW-DSP680
//
//  Created by chs on 2018/4/3.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "MixCollectionViewCell.h"
#import "Masonry.h"
#import "MacDefine.h"
@implementation MixCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
//@property (nonatomic,strong)UILabel *typeLab;
//@property (nonatomic,strong)UILabel *volValue;
//@property (nonatomic,strong)UISlider *mixSlider;
-(void)initUI{
    self.item=[[MixerItem alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.item];
    self.item.userInteractionEnabled=YES;
    self.item.SB_Volume.userInteractionEnabled=YES;
    [self.item setLab_MixerInput:[LANG DPLocalizedString:[NSString stringWithFormat:@"L_Mixer_IN"]]];
    [self.item setDataMax:Mixer_Volume_MAX];
    [self.item addTarget:self action:@selector(MixerItemEvent) forControlEvents:UIControlEventValueChanged];
    [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
//    self.typeLab=[[UILabel alloc]init];
//    self.typeLab.textColor=[UIColor whiteColor];
//    self.typeLab.textAlignment=NSTextAlignmentCenter;
//    self.typeLab.font=[UIFont systemFontOfSize:13];
//    self.typeLab.adjustsFontSizeToFitWidth=YES;
//    [self.contentView addSubview:self.typeLab];
//    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_centerY).offset([Dimens GDimens:-10]);
//        make.centerX.equalTo(self.contentView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(50, 30));
//    }];
//
//    self.volValue=[[UILabel alloc]init];
//    self.volValue.textColor=[UIColor whiteColor];
//    self.volValue.textAlignment=NSTextAlignmentCenter;
//    self.volValue.font=[UIFont systemFontOfSize:13];
//    self.volValue.adjustsFontSizeToFitWidth=YES;
//    [self.contentView addSubview:self.volValue];
//    [self.volValue mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//
//    self.mixSlider=[[UISlider alloc]init];
//    [self.contentView addSubview:self.mixSlider];
//    self.mixSlider.minimumValue=0;
//    self.mixSlider.maximumValue=Mixer_Volume_MAX;
//    self.mixSlider.minimumTrackTintColor = SetColor(UI_Master_SB_Volume_Press); //滑轮左边颜色如果设置了左边的图片就不会显示
//    self.mixSlider.maximumTrackTintColor = SetColor(UI_Master_SB_Volume_Normal); //滑轮右边颜色如果设置了右边的图片就不会显
//    [self.mixSlider setThumbImage:[UIImage imageNamed:@"chs_mvs_thumb_normal"] forState:UIControlStateNormal];
//    [self.mixSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
//    [self.mixSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.right.equalTo(self.contentView.mas_right).offset([Dimens GDimens:0]);
//        make.right.equalTo(self.contentView.mas_right).offset([Dimens GDimens:-20]);
//    }];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
        if (selected) {
            [self.item setMixerItemPress];
        }else{
            [self.item setMixerItemNormal];
        }
}

-(void)MixerItemEvent{
    
    self.MixerBlock(self.item);
    
}
@end

//
//  channelCollectionViewCell.m
//  JH-DBP4106-PPP42DSP
//
//  Created by chs on 2017/10/16.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "channelCollectionViewCell.h"

@implementation channelCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, [Dimens GDimens:0], self.contentView.frame.size.width, self.contentView.frame.size.height-[Dimens GDimens:0])];
    self.titleLabel.layer.cornerRadius=4;
    self.titleLabel.layer.masksToBounds=YES;
    
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font=[UIFont systemFontOfSize:15];
    self.titleLabel.adjustsFontSizeToFitWidth=YES;
//    self.titleLabel.layer.cornerRadius=self.titleLabel.frame.size.height/2;
//    [self.titleLabel setTextColor:SetColor(UI_Channel_BtnListText_Normal)];
    self.titleLabel.textColor=SetColor(UI_Channel_BtnListText_Normal);
//    self.titleLabel.layer.masksToBounds=YES;
//    self.titleLabel.layer.borderColor=SetColor(UI_Channel_BtnListText_Normal).CGColor;
    [self.contentView addSubview:self.titleLabel];
    
    //选中遮盖层
    self.diselectView=[[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-[Dimens GDimens:3], self.contentView.frame.size.width, [Dimens GDimens:3])];;
    self.diselectView.backgroundColor=SetColor(Color_EQItemPress);
    [self.contentView addSubview:self.diselectView];
    self.diselectView.hidden=YES;
}
-(void)setSelected:(BOOL)selected{
    if(selected){
        self.diselectView.hidden=NO;
//        self.titleLabel.backgroundColor=SetColor(UI_Channel_Btn_Press);
        self.titleLabel.textColor=SetColor(UI_Channel_BtnListText_Press);
    }else{
        self.diselectView.hidden=YES;
//        self.titleLabel.backgroundColor=SetColor(UI_Channel_Btn_Normal);
        self.titleLabel.textColor=SetColor(UI_Channel_BtnListText_Normal);
    }

}
@end

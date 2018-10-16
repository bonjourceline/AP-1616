//
//  DoubleChItem.m
//  PXE-X09
//
//  Created by celine on 2018/10/12.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "DoubleChItem.h"
#define borderNormal (0xFF313c45)
#define bgNormal (0xFF27323d)
@implementation DoubleChItem
{
    int firstCh;
    int secCh;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(void)setChannelIndex:(int)index{
    firstCh=index;
    secCh=index+1;
}
-(void)setup{
    self.item1=[[SingleChItem alloc]init];
    [self.item1 setChannelIndex:firstCh];
    [self addSubview:self.item1];
    [self.item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_centerY);
    }];
    self.hl_setBtn=[[NormalButton alloc]init];
    [self.hl_setBtn
                    initViewBroder:[Dimens GDimens:11]
                   withBorderWidth:1
                   withNormalColor:bgNormal
                    withPressColor:bgNormal
             withBorderNormalColor:borderNormal
              withBorderPressColor:borderNormal
               withTextNormalColor:(0xFFffffff)
                withTextPressColor:(0xFFffffff)
                          withType:4];
    [self.hl_setBtn setTitle:[LANG DPLocalizedString:@"HI"] forState:UIControlStateNormal];
    self.hl_setBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    self.hl_setBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:self.hl_setBtn];
    [self.hl_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.item1.chName.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:22]));
    }];
    
    self.item2=[[SingleChItem alloc]init];
    [self.item2 setChannelIndex:secCh];
    [self addSubview:self.item2];
    [self.item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
-(void)setLinkView:(BOOL)boolean{
    
}
-(void)flashView{
    [self.item1 setChannelIndex:firstCh];
    [self.item2 setChannelIndex:secCh];
    [self.item1 flashView];
    self.item1.chName.text=[NSString stringWithFormat:@"输入%d",firstCh-2];
    [self.item2 flashView];
    self.item2.chName.text=[NSString stringWithFormat:@"输入%d",secCh-2];
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

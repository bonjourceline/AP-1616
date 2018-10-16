//
//  DoubleOutItem.m
//  PXE-X09
//
//  Created by celine on 2018/10/16.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "DoubleOutItem.h"

@implementation DoubleOutItem
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
    self.item1=[[SingleOutChItem alloc]init];
    [self.item1 setChannelIndex:firstCh];
    [self addSubview:self.item1];
    [self.item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    
    self.item2=[[SingleOutChItem alloc]init];
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
    self.item1.chName.text=[NSString stringWithFormat:@"输入%d",firstCh+1];
    [self.item2 flashView];
    self.item2.chName.text=[NSString stringWithFormat:@"输入%d",secCh+1];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

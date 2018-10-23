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
    self.linkModeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:80], [Dimens GDimens:150])];
    self.linkModeView.userInteractionEnabled=NO;
    [self addSubview:self.linkModeView];
    [self.linkModeView setImage:[UIImage imageNamed:@"link_bg"]];
    [self.linkModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.item2.spkBtn.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:80], [Dimens GDimens:150]));
    }];
    
    self.linkBtn=[[UIButton alloc]init];
    [self addSubview:self.linkBtn];
    [self.linkBtn setImage:[UIImage imageNamed:@"input_link_normal"] forState:UIControlStateNormal];
    [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.linkModeView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:25], [Dimens GDimens:25]));
    }];
}
-(void)showLinkView:(BOOL)boolean{
    if(boolean){
        self.linkBtn.hidden=NO;
        self.linkModeView.hidden=NO;
    }else{
        self.linkBtn.hidden=YES;
        self.linkModeView.hidden=YES;
    }
}
-(void)flashView{
    [self.item1 setChannelIndex:firstCh];
    [self.item2 setChannelIndex:secCh];
    [self.item1 flashView];
    self.item1.chName.text=[NSString stringWithFormat:@"输入%d",firstCh+1];
    [self.item2 flashView];
    self.item2.chName.text=[NSString stringWithFormat:@"输入%d",secCh+1];
    if (RecStructData.System.out_mode!=0) {
        int spkType=RecStructData.System.out_spk_type[firstCh];
        if (spkType==0||spkType==21||spkType==24||spkType==19||spkType==20) {
            [self showLinkView:NO];
        }else{
            [self showLinkView:YES];
        }
        self.item1.spkBtn.userInteractionEnabled=NO;
        self.item2.spkBtn.userInteractionEnabled=NO;
    }else{
        self.item1.spkBtn.userInteractionEnabled=YES;
        self.item2.spkBtn.userInteractionEnabled=YES;
        
        [self showLinkView:NO];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

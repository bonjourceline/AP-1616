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
    
    
    self.item2=[[SingleChItem alloc]init];
    [self.item2 setChannelIndex:secCh];
    [self addSubview:self.item2];
    [self.item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
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
    [self.hl_setBtn addTarget:self action:@selector(changeHl_setBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.hl_setBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:self.hl_setBtn];
    [self.hl_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.item1.chName.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:45], [Dimens GDimens:22]));
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
    
//    self.linkModeView.backgroundColor=RGBA(255, 255, 255, 0.7);
}
-(void)showLinkView:(BOOL)boolean{
    if (boolean) {
        
        self.linkModeView.hidden=NO;
        self.linkBtn.hidden=NO;
    }else{
        
        self.linkModeView.hidden=YES;
        self.linkBtn.hidden=YES;
    }
}
-(void)changeHl_setBtn:(UIButton *)sender{
    int index=(secCh-2)/2-1;
    if (RecStructData.System.high_Low_Set[index]==0) {
        RecStructData.System.high_Low_Set[index]=1;
        [self.item1.sourceImage setImage:[UIImage imageNamed:@"Source_High"]];
        [self.item2.sourceImage setImage:[UIImage imageNamed:@"Source_High"]];
        [self.hl_setBtn setTitle:@"HI" forState:UIControlStateNormal];
    }else{
        RecStructData.System.high_Low_Set[index]=0;
        [self.item1.sourceImage setImage:[UIImage imageNamed:@"Source_Aux"]];
        [self.item2.sourceImage setImage:[UIImage imageNamed:@"Source_Aux"]];
        [self.hl_setBtn setTitle:@"AUX" forState:UIControlStateNormal];
    }
}
-(void)flashView{
    //设置真实下发通道位置
    [self.item1 setChannelIndex:firstCh];
    [self.item2 setChannelIndex:secCh];
    [self.item1 flashView];
    self.item1.chName.text=[NSString stringWithFormat:@"输入%d",firstCh-2];
    [self.item2 flashView];
    self.item2.chName.text=[NSString stringWithFormat:@"输入%d",secCh-2];
    
    if (RecStructData.System.aux_mode==0&&RecStructData.System.high_mode==0) {
        self.hl_setBtn.userInteractionEnabled=YES;
    }else{
        self.hl_setBtn.userInteractionEnabled=NO;
    }
    //判断是高电平还是低电平
    int index=(secCh-2)/2-1;
    if (RecStructData.System.high_Low_Set[index]==0) {
        [self.item1.sourceImage setImage:[UIImage imageNamed:@"Source_Aux"]];
        [self.item2.sourceImage setImage:[UIImage imageNamed:@"Source_Aux"]];
        [self.hl_setBtn setTitle:@"AUX" forState:UIControlStateNormal];
        if (RecStructData.System.aux_mode==0) {
            self.item1.spkBtn.userInteractionEnabled=YES;
            self.item2.spkBtn.userInteractionEnabled=YES;
            [self showLinkView:NO];
        }else{
            self.item1.spkBtn.userInteractionEnabled=NO;
            self.item2.spkBtn.userInteractionEnabled=NO;
            
            int spkType=RecStructData.System.in_spk_type[firstCh-3];
            if (spkType==0||spkType==21||spkType==24||spkType==19||spkType==20) {
                [self showLinkView:NO];
            }else{
                [self showLinkView:YES];
            }
        }
    }else{
        [self.item1.sourceImage setImage:[UIImage imageNamed:@"Source_High"]];
        [self.item2.sourceImage setImage:[UIImage imageNamed:@"Source_High"]];
        [self.hl_setBtn setTitle:@"HI" forState:UIControlStateNormal];
        if (RecStructData.System.high_mode==0) {
            self.item1.spkBtn.userInteractionEnabled=YES;
            self.item2.spkBtn.userInteractionEnabled=YES;
            [self showLinkView:NO];
        }else{
            self.item1.spkBtn.userInteractionEnabled=NO;
            self.item2.spkBtn.userInteractionEnabled=NO;
            int spkType=RecStructData.System.in_spk_type[firstCh-3];
            if (spkType==0||spkType==21||spkType==24||spkType==19||spkType==20) {
                [self showLinkView:NO];
            }else{
                [self showLinkView:YES];
            }
        }
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

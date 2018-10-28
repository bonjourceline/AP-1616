//
//  LinkViewController.m
//  PXE-X09
//
//  Created by celine on 2018/10/26.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "LinkViewController.h"
#import "NormalButton.h"
#define linkbtnTag 666
@interface LinkViewController ()
@property(nonatomic,strong)UILabel *chTopLabel;
@property(nonatomic,strong)NSMutableArray *linkArray;
@property(nonatomic,strong)NSMutableArray *linkNums;
@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(0, 0, 0, 0.5);
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self initData];
    [self creatView];
    // Do any additional setup after loading the view.
}
-(void)initData{
    self.linkArray=[[NSMutableArray alloc]init];
    self.linkNums=[[NSMutableArray alloc]init];
    if(self.isInputType){
        
        if (RecStructData.System.InSwitch[3]!=0&&RecStructData.System.high_mode==0) {
            //有高电平
            for (int i=0; i<RecStructData.System.HiInputChNum; i++) {
                [self.linkArray addObject:@(i+3)];//加入实际通道位置
            }
        }
        if(RecStructData.System.InSwitch[4]!=0&&RecStructData.System.aux_mode==0){
            //得到低电平开始的位置
            int auxIndex=3;
            if (RecStructData.System.InSwitch[3]!=0) {
                auxIndex=3+RecStructData.System.HiInputChNum;
            }
            for (int i=0; i<RecStructData.System.AuxInputChNum; i++) {
                
                [self.linkArray addObject:@(auxIndex+i)];
            }
            
        }
        for (int i=0; i<self.linkArray.count; i++) {
            int index=[self.linkArray[i] intValue];
            if (RecStructData.IN_CH[index].LinkFlag!=0) {
                [self.linkNums addObject:@(1)];
            }else{
                [self.linkNums addObject:@(0)];
            }
        }
    }else{
        if (RecStructData.System.out_mode==0) {
            for (int i=0; i<RecStructData.System.OutputChNum; i++) {
                [self.linkArray addObject:@(i)];
            }
        }
        for (int i=0; i<self.linkArray.count; i++) {
            int index=[self.linkArray[i] intValue];
            if (RecStructData.OUT_CH[index].LinkFlag!=0) {
                [self.linkNums addObject:@(1)];
            }else{
                [self.linkNums addObject:@(0)];
            }
        }
        
    }
    
    
}
-(void)creatView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380])];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380]));
    }];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:40], [Dimens GDimens:380])];
    [bgImageView setImage:[UIImage imageNamed:@"delay_bg"]];
    [bgView addSubview:bgImageView];
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:30], [Dimens GDimens:30]));
    }];
    self.chTopLabel=[[UILabel alloc]init];
    self.chTopLabel.textColor=[UIColor whiteColor];
    [bgView addSubview:self.chTopLabel];
    self.chTopLabel.font=[UIFont systemFontOfSize:13];
    [self.chTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:5]);
        make.height.mas_equalTo([Dimens GDimens:30]);
    }];
    
    int weith=(KScreenWidth-[Dimens GDimens:40]-[Dimens GDimens:15]*4)/4;
    int heith=[Dimens GDimens:25];
    int margin=[Dimens GDimens:16/2];
    for (int i=0; i<self.linkArray.count; i++) {
        NormalButton *btn=[[NormalButton alloc]init];
        [bgView addSubview:btn];
        btn.frame=CGRectMake(margin-1+(weith+[Dimens GDimens:16])*(i%4), [Dimens GDimens:70]+(2.5*heith)*(i/4), weith, heith);
        [btn initViewBroder:0
            withBorderWidth:1
            withNormalColor:(0xFF27323d)
             withPressColor:(0xFF1d262e)
      withBorderNormalColor:(0xFF3b4853)
       withBorderPressColor:(0xFF2ea1ff)
        withTextNormalColor:(0xFF999faa)
         withTextPressColor:(0xFFffffff)
                   withType:4];
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        btn.tag=i+linkbtnTag;
        [btn setNormal];
        [btn setImage:[UIImage imageNamed:@"linkvc_normal"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isInputType) {
            int valueIndex=[self.linkArray[i] intValue];
            [btn setTitle:[NSString stringWithFormat:@"输入%d",valueIndex-2] forState:UIControlStateNormal];
            if (RecStructData.IN_CH[valueIndex].LinkFlag!=0) {
                [btn setPress];
                [btn setImage:[UIImage imageNamed:@"linkvc_press"] forState:UIControlStateNormal];
            }
            self.chTopLabel.text=[NSString stringWithFormat:@"输入联调"];
        }else{
            int valueIndex=[self.linkArray[i] intValue];
            [btn setTitle:[NSString stringWithFormat:@"输出%d",valueIndex+1] forState:UIControlStateNormal];
            if (RecStructData.OUT_CH[valueIndex].LinkFlag!=0) {
                [btn setPress];
                [btn setImage:[UIImage imageNamed:@"linkvc_press"] forState:UIControlStateNormal];
            }
            self.chTopLabel.text=[NSString stringWithFormat:@"输出联调"];
        }
        
        
    }
    
    UIView *line=[[UIView alloc]init];
    [bgView addSubview:line];
    line.backgroundColor=SetColor(0xFF262d35);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset([Dimens GDimens:10]);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-10]);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-68]);
    }];
    
    UIButton *okBtn=[[UIButton alloc]init];
    okBtn.backgroundColor=SetColor(0xFF2ea1ff);
    [bgView addSubview:okBtn];
    [okBtn setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(checkSpkTypeTis) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset([Dimens GDimens:-20]);
        make.right.equalTo(bgView.mas_right).offset([Dimens GDimens:-25]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:85], [Dimens GDimens:28]));
    }];
    
    UIButton *cancelBtn=[[UIButton alloc]init];
    cancelBtn.backgroundColor=SetColor(0xFF27323d);
    [bgView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:[LANG DPLocalizedString:@"L_System_Cancel"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(okBtn.mas_centerY);
        make.right.equalTo(okBtn.mas_left).offset([Dimens GDimens:-20]);
        make.size.mas_equalTo(okBtn);
    }];
    
    
}
-(void)clickBtn:(NormalButton *)sender{
    
        int value=[self.linkNums[sender.tag-linkbtnTag] intValue];
        if (value!=0) {
            self.linkNums[sender.tag-linkbtnTag]=@(0);
            [sender setNormal];
            [sender setImage:[UIImage imageNamed:@"linkvc_normal"] forState:UIControlStateNormal];
        }else{
            self.linkNums[sender.tag-linkbtnTag]=@(1);
            [sender setPress];
            [sender setImage:[UIImage imageNamed:@"linkvc_press"] forState:UIControlStateNormal];
        }
    
}
-(void)checkSpkTypeTis{
    NSMutableArray *counts=[[NSMutableArray alloc]init];
    for (int i=0; i<self.linkNums.count; i++) {
        int index=[self.linkArray[i] intValue];
        int value=[self.linkNums[i] intValue];
        if (value==1) {
            [counts addObject:@(index)];
        }
    }
    if (counts.count>2) {
        [self showTis];
    }else{
        if (counts.count==2) {
            int spkindex1=[counts[0] intValue];
            int spkindex2=[counts[1] intValue];
            int spk1=0;
            int spk2=0;
            if (self.isInputType) {
                spk1=RecStructData.System.in_spk_type[spkindex1-3];
                spk2=RecStructData.System.in_spk_type[spkindex2-3];
            }else{
                spk1=RecStructData.System.out_spk_type[spkindex1];
                spk2=RecStructData.System.out_spk_type[spkindex2];
            }
            if ([self isSameSpkType:spk1 andType2:spk2]) {
                [self okClick];
            }else{
                [self showTis];
            }
        }else{
            [self okClick];
        }
        
    }
}
//判断是否属于对应通道类型
-(BOOL)isSameSpkType:(int)channelNameNum andType2:(int)channelNameNumEls{
    BOOL isSame=NO;
    int res=0;
    if((channelNameNum>=1)&&(channelNameNum<=6)&&
       (channelNameNumEls>=7)&&(channelNameNumEls<=12)){
        res=channelNameNumEls-channelNameNum;
        if(res==6){
            isSame=YES;
            //NSLog(@"#1 inc=%d",inc);
        }
    }else if((channelNameNum>=7)&&(channelNameNum<=12)&&
             (channelNameNumEls>=1)&&(channelNameNumEls<=6)){
        res=channelNameNum-channelNameNumEls;
        if(res==6){
            isSame=YES;
            //NSLog(@"#2 inc=%d",inc);
        }
    }else if((channelNameNum>=13)&&(channelNameNum<=15)&&
             (channelNameNumEls>=16)&&(channelNameNumEls<=18)){
        res=channelNameNumEls-channelNameNum;
        if(res==3){
            isSame=YES;
            //NSLog(@"#3 inc=%d",inc);
        }
    }else if((channelNameNum>=16)&&(channelNameNum<=18)&&
             (channelNameNumEls>=13)&&(channelNameNumEls<=15)){
        res=channelNameNum-channelNameNumEls;
        if(res==3){
            isSame=YES;
            //NSLog(@"#4 inc=%d",inc);
        }
    }else if((channelNameNum==22)&&(channelNameNumEls==23)){
        isSame=YES;
        //NSLog(@"#5 inc=%d",inc);
    }else if((channelNameNum==23)&&(channelNameNumEls==22)){
        isSame=YES;
        //NSLog(@"#6 inc=%d",inc);
    }else if((channelNameNum==25)&&(channelNameNumEls==26)){
        isSame=YES;
    }else if ((channelNameNum==26)&&(channelNameNumEls==25)){
        isSame=YES;
    }else if ((channelNameNum==27)&&(channelNameNumEls==28)){
        isSame=YES;
    }else if ((channelNameNum==28)&&(channelNameNumEls==27)){
        isSame=YES;
    }
    return isSame;
}
-(void)showTis{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"通道类型不一致，是否联调" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self okClick];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)okClick{
    
   
    
//    BOOL islink=NO;
    for (int i=0; i<self.linkArray.count; i++) {
        int index=[self.linkArray[i] intValue];
        int value=[self.linkNums[i] intValue];
//        if (value!=0) {
//            islink=YES;
//        }
        if (self.isInputType) {
            RecStructData.IN_CH[index].LinkFlag=value;
            
        }else{
            RecStructData.OUT_CH[index].LinkFlag=value;
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//
//    }];
}
-(void)cancleClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

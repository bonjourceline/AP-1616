//
//  HiAuxViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/27.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "HiAuxViewController.h"
#import "HiAuxItem.h"
#import "OutModeViewController.h"
#import "SetChNumViewController.h"
#define itemMargin 5
#define itemWidth (KScreenWidth-[Dimens GDimens:itemMargin]*4)/3
#define itemHeigh itemWidth*1.8
#define hiItemTag 111
#define auxItemTag 211

#define hmodeMax 17
#define amodeMax 5
@interface HiAuxViewController ()
{
    NSMutableArray *hiTypeNames;
    NSMutableArray *auxTypeNames;
    
}
@end

@implementation HiAuxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextBtn setTitle:[LANG DPLocalizedString:@"进入调音"] forState:UIControlStateNormal];
    hiTypeNames=[[NSMutableArray alloc]init];
    auxTypeNames=[[NSMutableArray alloc]init];
    for (int i=1; i<hmodeMax; i++) {
        [hiTypeNames addObject:[SourceModeUtils getOutModeName:i] ];
    }
    [hiTypeNames addObject:[SourceModeUtils getOutModeName:0]];
    for (int i=1; i<amodeMax; i++) {
        [auxTypeNames addObject:[SourceModeUtils getAuxModeName:i]];
    }
    [auxTypeNames addObject:[SourceModeUtils getAuxModeName:0]];
//    hiTypeNames=@[@"主动三分频",@"主动二分频",@"自定义"];
//    auxTypeNames=@[@"5.1ch",@"4.2ch",@"2.0ch",@"自定义"];
    if (RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.InSwitch_temp[4]==1){
        //高低电平
        self.tiltleLab.text=[LANG DPLocalizedString:@"高+低电平输入选择"];
        [self creatHiTypeView];
        [self creatAuxTypeView];
    }else if(RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.InSwitch_temp[4]==0){
        self.tiltleLab.text=[LANG DPLocalizedString:@"高电平输入选择"];
        [self creatHiTypeView];
        //单独高
    }else if(RecStructData.System.InSwitch_temp[3]==0&&RecStructData.System.InSwitch_temp[4]==1){
        //单独低
         self.tiltleLab.text=[LANG DPLocalizedString:@"低电平输入选择"];
         [self creatAuxTypeView];
    }
    
   
    [self flashAuxItem];
    [self flashHiItem];
    // Do any additional setup after loading the view.
}
-(void)creatHiTypeView{
    
    
    UIView *line1=[[UIView alloc]init];
    line1.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line1];
    UIView *line2=[[UIView alloc]init];
    line2.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line2];
    
    UILabel *hilab=[[UILabel alloc]init];
    hilab.text=[LANG DPLocalizedString:@"高电平输入"];
    hilab.textColor=SetColor(0xFF959a9c);
    hilab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:hilab];
    [hilab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:10]);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(hilab.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:10]);
        make.right.equalTo(hilab.mas_left).offset([Dimens GDimens:-10]);
        make.height.mas_equalTo(1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(hilab.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-10]);
        make.left.equalTo(hilab.mas_right).offset([Dimens GDimens:10]);
        make.height.mas_equalTo(1);
    }];
    
    
    UIScrollView *hiScrollView=[[UIScrollView alloc]init];
    [self.view addSubview:hiScrollView];
    [hiScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.InSwitch_temp[4]==0){
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:60]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh*2+[Dimens GDimens:20]));
        }else{
             make.top.equalTo(hilab.mas_bottom).offset([Dimens GDimens:10]);
             make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh));
        }
       
        make.centerX.equalTo(self.view.mas_centerX);
       
    }];
    if(RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.InSwitch_temp[4]==0){
        hilab.hidden=YES;
        line1.hidden=YES;
        line2.hidden=YES;
       int Sizewidth=(hiTypeNames.count%6)>0?(int)(hiTypeNames.count/6)+1:(int)(hiTypeNames.count/6);
        hiScrollView.contentSize=CGSizeMake(KScreenWidth*Sizewidth, 0);
        hiScrollView.pagingEnabled=YES;
    }else{
         hiScrollView.contentSize=CGSizeMake((itemWidth+itemMargin)*hiTypeNames.count+itemMargin, 0);
    }

    for (int i=0; i<hiTypeNames.count; i++) {
        HiAuxItem *item=[[HiAuxItem alloc]init];
        if(RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.InSwitch_temp[4]==0){
            
            item.frame=CGRectMake((itemMargin+itemWidth)*(i%3)+itemMargin+(i/6)*KScreenWidth, i%6/3*(itemHeigh+[Dimens GDimens:20]), itemWidth, itemHeigh);
        }else{
            item.frame=CGRectMake((itemMargin+itemWidth)*i+itemMargin, 0, itemWidth, itemHeigh);
        }
        item.typeName.text=[LANG DPLocalizedString:hiTypeNames[i]];
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"hmode%d",i+1]];
        if ((hiTypeNames.count-1)==i) {
            image=[UIImage imageNamed:@"hmode0"];
        }
        [item.typeImageView setImage:image];
        [item setTag:i+hiItemTag];
        [item addTarget:self action:@selector(clickHiItem:) forControlEvents:UIControlEventTouchDown];
        [hiScrollView addSubview:item];
    }
}
-(void)creatAuxTypeView{
    
    UIView *line1=[[UIView alloc]init];
    line1.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line1];
    UIView *line2=[[UIView alloc]init];
    line2.backgroundColor=SetColor(UI_SystemBtnColorNormal);
    [self.view addSubview:line2];
    
    UILabel *auxlab=[[UILabel alloc]init];
    auxlab.text=[LANG DPLocalizedString:@"低电平输入"];
    auxlab.textColor=SetColor(0xFF959a9c);
    auxlab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:auxlab];
    [auxlab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenHeight>=812) {
             make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:390]);
        }else{
             make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:370]);
        }
       
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(auxlab.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:10]);
        make.right.equalTo(auxlab.mas_left).offset([Dimens GDimens:-10]);
        make.height.mas_equalTo(1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(auxlab.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-10]);
        make.left.equalTo(auxlab.mas_right).offset([Dimens GDimens:10]);
        make.height.mas_equalTo(1);
    }];
    
    UIScrollView *auxScrollView=[[UIScrollView alloc]init];
    [self.view addSubview:auxScrollView];
    [auxScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(RecStructData.System.InSwitch_temp[3]==0&&RecStructData.System.InSwitch_temp[4]==1){
             make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:60]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh*2+[Dimens GDimens:20]));
        }else{
             make.top.equalTo(auxlab.mas_bottom).offset([Dimens GDimens:10]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh));
        }
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    if(RecStructData.System.InSwitch_temp[3]==0&&RecStructData.System.InSwitch_temp[4]==1){
        auxlab.hidden=YES;
        line1.hidden=YES;
        line2.hidden=YES;
        
        int Sizewidth=(auxTypeNames.count%6)>0?(int)(auxTypeNames.count/6)+1:(int)(auxTypeNames.count/6);
        auxScrollView.contentSize=CGSizeMake(KScreenWidth*Sizewidth, 0);
        auxScrollView.pagingEnabled=YES;
    }else{
         auxScrollView.contentSize=CGSizeMake((itemWidth+itemMargin)*auxTypeNames.count+itemMargin, 0);
    }
   
    
    for (int i=0; i<auxTypeNames.count; i++) {
        HiAuxItem *item=[[HiAuxItem alloc]init];
        if(RecStructData.System.InSwitch_temp[3]==0&&RecStructData.System.InSwitch_temp[4]==1){
            
            item.frame=CGRectMake((itemMargin+itemWidth)*(i%3)+itemMargin+(i/6)*KScreenWidth, i%6/3*(itemHeigh+[Dimens GDimens:20]), itemWidth, itemHeigh);
        }else{
            item.frame=CGRectMake((itemMargin+itemWidth)*i+itemMargin, 0, itemWidth, itemHeigh);
        }
        UIImage *image=[[UIImage alloc]init];
        
        image=[UIImage imageNamed:[NSString stringWithFormat:@"amode%d",i+1]];
        if (i==auxTypeNames.count-1) {
            image=[UIImage imageNamed:@"hmode0"];
        }
        
        [item.typeImageView setImage:image];
//        HiAuxItem *item=[[HiAuxItem alloc]initWithFrame:CGRectMake((itemMargin+itemWidth)*i+itemMargin, 0, itemWidth, itemHeigh)];
        item.typeName.text=[LANG DPLocalizedString:auxTypeNames[i]];
        [item setTag:i+auxItemTag];
        [item addTarget:self action:@selector(clickAuxItem:) forControlEvents:UIControlEventTouchDown];
        [auxScrollView addSubview:item];
    }
}
#pragma mark-----------------点击事件
//高电平
-(void)clickHiItem:(HiAuxItem *)selectItem{
    int tag=(int)selectItem.tag-hiItemTag;
    if (RecStructData.System.InSwitch_temp[4]!=0) {
        //高低数量不能超过16
        int hiCount=[SourceModeUtils getHiModeTypeChNum:tag+1];
        int auxCount=[SourceModeUtils getAuxModeTypeChNum:RecStructData.System.aux_mode_temp];
        if (hiCount+auxCount>16) {
            return;
        }else{
            if(tag==hiTypeNames.count-1){
                RecStructData.System.high_mode_temp=0;
            }else{
                RecStructData.System.high_mode_temp=tag+1;
            }
            [SourceModeUtils setHiModeTypeSetting];
        }
        
    }else{
        if(tag==hiTypeNames.count-1){
            RecStructData.System.high_mode_temp=0;
        }else{
            RecStructData.System.high_mode_temp=tag+1;
        }
        [SourceModeUtils setHiModeTypeSetting];
    }
    
    [self flashHiItem];
}
//低电平
-(void)clickAuxItem:(HiAuxItem *)selectItem{
    int tag=(int)selectItem.tag-auxItemTag;
    if (RecStructData.System.InSwitch_temp[3]!=0) {
        //高低数量不能超过16
        int hiCount=[SourceModeUtils getHiModeTypeChNum:RecStructData.System.high_mode_temp];
        int auxCount=[SourceModeUtils getAuxModeTypeChNum:tag+1];
        if (hiCount+auxCount>16) {
            return;
        }else{
            if(tag==auxTypeNames.count-1){
                RecStructData.System.aux_mode_temp=0;
            }else{
                RecStructData.System.aux_mode_temp=tag+1;
            }
        }
    }else{
        if(tag==auxTypeNames.count-1){
            RecStructData.System.aux_mode_temp=0;
        }else{
            RecStructData.System.aux_mode_temp=tag+1;
        }
    }
    
    [self flashAuxItem];
}

#pragma mark-------------页面跳转
-(void)toPassView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toNextView{
    if ((RecStructData.System.InSwitch_temp[3]==1&&RecStructData.System.high_mode_temp==0)||(RecStructData.System.InSwitch_temp[4]==1&&RecStructData.System.aux_mode_temp==0)) {
        SetChNumViewController *vc=[[SetChNumViewController alloc]init];
        vc.type=CHNUMTYPE_input;
        vc.blackHome = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self ClickEventOfBack];
            
        };
        vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [SourceModeUtils syncSource];
        [self ClickEventOfBack];
    }
    
}
#pragma mark------------刷新
-(void)flashHiItem{
    for (int i=0; i<hiTypeNames.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+hiItemTag];
        if ((i+1)==RecStructData.System.high_mode_temp) {
            [item setPress];
        }else if ((i==hiTypeNames.count-1)&&RecStructData.System.high_mode_temp==0){
            [item setPress];
        }else{
            [item setNormal];
        }
    }
}
-(void)flashAuxItem{
    for (int i=0; i<auxTypeNames.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+auxItemTag];
        if ((i+1)==RecStructData.System.aux_mode_temp) {
            [item setPress];
        }else if ((i==auxTypeNames.count-1)&&RecStructData.System.aux_mode_temp==0){
            [item setPress];
        }else{
            [item setNormal];
        }
    }
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

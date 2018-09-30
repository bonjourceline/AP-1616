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
#define itemMargin 8
#define itemWidth (KScreenWidth-[Dimens GDimens:itemMargin]*4)/3
#define itemHeigh itemWidth*1.3
#define hiItemTag 111
#define auxItemTag 211
@interface HiAuxViewController ()
{
    NSArray *hiTypeNames;
    NSArray *auxTypeNames;
    
}
@end

@implementation HiAuxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiTypeNames=@[@"主动三分频",@"主动二分频",@"自定义"];
    auxTypeNames=@[@"5.1ch",@"4.2ch",@"2.0ch",@"自定义"];
    if (RecStructData.System.InSwitch[3]==1&&RecStructData.System.InSwitch[4]==1){
        //高低电平
        self.tiltleLab.text=[LANG DPLocalizedString:@"高+低电平输入选择"];
        [self creatHiTypeView];
        [self creatAuxTypeView];
    }else if(RecStructData.System.InSwitch[3]==1&&RecStructData.System.InSwitch[4]==0){
        self.tiltleLab.text=[LANG DPLocalizedString:@"高电平输入选择"];
        [self creatHiTypeView];
        //单独高
    }else if(RecStructData.System.InSwitch[3]==0&&RecStructData.System.InSwitch[4]==1){
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
        if(RecStructData.System.InSwitch[3]==1&&RecStructData.System.InSwitch[4]==0){
            make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:60]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh*2+[Dimens GDimens:20]));
        }else{
             make.top.equalTo(hilab.mas_bottom).offset([Dimens GDimens:20]);
             make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh));
        }
       
        make.centerX.equalTo(self.view.mas_centerX);
       
    }];
    if(RecStructData.System.InSwitch[3]==1&&RecStructData.System.InSwitch[4]==0){
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
        if(RecStructData.System.InSwitch[3]==1&&RecStructData.System.InSwitch[4]==0){
            
            item.frame=CGRectMake((itemMargin+itemWidth)*(i%3)+itemMargin+(i/6)*KScreenWidth, i%6/3*(itemHeigh+[Dimens GDimens:20]), itemWidth, itemHeigh);
        }else{
            item.frame=CGRectMake((itemMargin+itemWidth)*i+itemMargin, 0, itemWidth, itemHeigh);
        }
        item.typeName.text=[LANG DPLocalizedString:hiTypeNames[i]];
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
        make.top.equalTo(self.view.mas_centerY).offset([Dimens GDimens:-100]);
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
        if(RecStructData.System.InSwitch[3]==0&&RecStructData.System.InSwitch[4]==1){
             make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:60]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh*2+[Dimens GDimens:20]));
        }else{
             make.top.equalTo(auxlab.mas_bottom).offset([Dimens GDimens:20]);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh));
        }
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    if(RecStructData.System.InSwitch[3]==0&&RecStructData.System.InSwitch[4]==1){
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
        if(RecStructData.System.InSwitch[3]==0&&RecStructData.System.InSwitch[4]==1){
            
            item.frame=CGRectMake((itemMargin+itemWidth)*(i%3)+itemMargin+(i/6)*KScreenWidth, i%6/3*(itemHeigh+[Dimens GDimens:20]), itemWidth, itemHeigh);
        }else{
            item.frame=CGRectMake((itemMargin+itemWidth)*i+itemMargin, 0, itemWidth, itemHeigh);
        }
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
    if(tag==hiTypeNames.count-1){
        RecStructData.System.high_mode=0;
    }else{
        RecStructData.System.high_mode=tag+1;
    }
    [self flashHiItem];
}
//低电平
-(void)clickAuxItem:(HiAuxItem *)selectItem{
    int tag=(int)selectItem.tag-auxItemTag;
    if(tag==auxTypeNames.count-1){
        RecStructData.System.aux_mode=0;
    }else{
        RecStructData.System.aux_mode=tag+1;
    }
    [self flashAuxItem];
}
#pragma mark-------------页面跳转
-(void)toPassView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toNextView{
    OutModeViewController *vc=[[OutModeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark------------刷新
-(void)flashHiItem{
    for (int i=0; i<hiTypeNames.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+hiItemTag];
        if ((i+1)==RecStructData.System.high_mode) {
            [item setPress];
        }else if ((i==hiTypeNames.count-1)&&RecStructData.System.high_mode==0){
            [item setPress];
        }else{
            [item setNormal];
        }
    }
}
-(void)flashAuxItem{
    for (int i=0; i<auxTypeNames.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+auxItemTag];
        if ((i+1)==RecStructData.System.aux_mode) {
            [item setPress];
        }else if ((i==auxTypeNames.count-1)&&RecStructData.System.aux_mode==0){
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

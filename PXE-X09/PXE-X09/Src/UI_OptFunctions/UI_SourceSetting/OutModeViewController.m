//
//  OutModeViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/28.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "OutModeViewController.h"
#import "SetChNumViewController.h"
#import "HiAuxItem.h"
#define itemMargin 5
#define itemWidth (KScreenWidth-[Dimens GDimens:itemMargin]*4)/3
#define itemHeigh itemWidth*1.8
#define outItemTag 111
#define outModeMax 17

@interface OutModeViewController ()
{
    NSMutableArray *outModes;
}
@end

@implementation OutModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SourceModeUtils syncSourceTemp];
    self.tiltleLab.text=[LANG DPLocalizedString:@"输出方式选择"];
    outModes=[[NSMutableArray alloc]init];
    for (int i=1; i<outModeMax; i++) {
        [outModes addObject:[SourceModeUtils getOutModeName:i] ];
    }
    [outModes addObject:[SourceModeUtils getOutModeName:0]];
//    outModes=@[@"主动2分频",@"主动3分频",@"主动4分频",@"主动3分频+超低",@"主动2分频+超低",@"自定义"];
    self.passBtn.hidden=YES;
    [self.nextBtn setTitle:[LANG DPLocalizedString:@"进入调音"] forState:UIControlStateNormal];
    [self creatOutModeView];
    [self flashOutItem];
    // Do any additional setup after loading the view.
}
-(void)creatOutModeView{
    UIScrollView *outScrollView=[[UIScrollView alloc]init];
    [self.view addSubview:outScrollView];
    [outScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.navBar.mas_bottom).offset([Dimens GDimens:60]);
     make.size.mas_equalTo(CGSizeMake(KScreenWidth, itemHeigh*2+[Dimens GDimens:20]));
     make.centerX.equalTo(self.view.mas_centerX);
        
    }];
 
        int Sizewidth=(outModes.count%6)>0?(int)(outModes.count/6)+1:(int)(outModes.count/6);
        outScrollView.contentSize=CGSizeMake(KScreenWidth*Sizewidth, 0);
        outScrollView.pagingEnabled=YES;
  
    for (int i=0; i<outModes.count; i++) {
        HiAuxItem *item=[[HiAuxItem alloc]init];
            
        item.frame=CGRectMake((itemMargin+itemWidth)*(i%3)+itemMargin+(i/6)*KScreenWidth, i%6/3*(itemHeigh+[Dimens GDimens:20]), itemWidth, itemHeigh);
        
        item.typeName.text=[LANG DPLocalizedString:outModes[i]];
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"hmode%d",i+1]];
        if ((outModes.count-1)==i) {
            image=[UIImage imageNamed:@"hmode0"];
        }
        [item.typeImageView setImage:image];
        [item setTag:i+outItemTag];
        [item addTarget:self action:@selector(clickOutItem:) forControlEvents:UIControlEventTouchDown];
        [outScrollView addSubview:item];
    }
}
#pragma mark-----------------点击事件
//高电平
-(void)clickOutItem:(HiAuxItem *)selectItem{
    int tag=(int)selectItem.tag-outItemTag;
    if(tag==outModes.count-1){
        RecStructData.System.out_mode_temp=0;
    }else{
        RecStructData.System.out_mode_temp=tag+1;
    }
    [self flashOutItem];
}
#pragma mark-------------页面跳转
-(void)toPassView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toNextView{
    if (RecStructData.System.out_mode_temp==0) {
        SetChNumViewController *vc=[[SetChNumViewController alloc]init];
        vc.type=CHNUMTYPE_output;
        vc.blackHome = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self ClickEventOfBack];
            
        };
        vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        
        [SourceModeUtils setOUTModeTypeSetting];
        [SourceModeUtils syncOutSource];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark------------刷新
-(void)flashOutItem{
    for (int i=0; i<outModes.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+outItemTag];
        if ((i+1)==RecStructData.System.out_mode_temp) {
            [item setPress];
        }else if ((i==outModes.count-1)&&RecStructData.System.out_mode_temp==0){
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

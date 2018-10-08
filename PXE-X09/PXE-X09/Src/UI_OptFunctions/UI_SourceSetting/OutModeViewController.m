//
//  OutModeViewController.m
//  PXE-X09
//
//  Created by chs on 2018/9/28.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "OutModeViewController.h"
#import "HiAuxItem.h"
#define itemMargin 8
#define itemWidth (KScreenWidth-[Dimens GDimens:itemMargin]*4)/3
#define itemHeigh itemWidth*1.3
#define outItemTag 111

@interface OutModeViewController ()
{
    NSArray *outModes;
}
@end

@implementation OutModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tiltleLab.text=[LANG DPLocalizedString:@"输出方式选择"];
    outModes=@[@"主动2分频",@"主动3分频",@"主动4分频",@"主动3分频+超低",@"主动2分频+超低",@"自定义"];
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
        [item setTag:i+outItemTag];
        [item addTarget:self action:@selector(clickHiItem:) forControlEvents:UIControlEventTouchDown];
        [outScrollView addSubview:item];
    }
}
#pragma mark-----------------点击事件
//高电平
-(void)clickHiItem:(HiAuxItem *)selectItem{
    int tag=(int)selectItem.tag-outItemTag;
    if(tag==outModes.count-1){
        RecStructData.System.out_mode=0;
    }else{
        RecStructData.System.out_mode=tag+1;
    }
    [self flashOutItem];
}
#pragma mark-------------页面跳转
-(void)toPassView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toNextView{
    
}
#pragma mark------------刷新
-(void)flashOutItem{
    for (int i=0; i<outModes.count; i++) {
        HiAuxItem *item=(HiAuxItem *)[self.view viewWithTag:i+outItemTag];
        if ((i+1)==RecStructData.System.out_mode) {
            [item setPress];
        }else if ((i==outModes.count-1)&&RecStructData.System.out_mode==0){
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
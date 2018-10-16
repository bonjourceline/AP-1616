//
//  SourceSettingController.m
//  PXE-X09
//
//  Created by chs on 2018/9/17.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "SourceSettingController.h"
#import "MacDefine.h"
#import "Masonry.h"
#import "SourceItem.h"
#import "DeviceUtils.h"
#import "HiAuxViewController.h"
#define SourceItemTag 123
@interface SourceSettingController ()
@property(nonatomic,strong)NSArray *NameArray;
@property(nonatomic,strong)NSArray *ImageArray;

@end

@implementation SourceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passBtn setTitle:[LANG DPLocalizedString:@"跳过"] forState:UIControlStateNormal];
    [self creatView];
    // Do any additional setup after loading the view.
}

-(void)creatView{
    
    for (int i=0; i<5; i++) {
        SourceItem *item=[[SourceItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame)+[Dimens GDimens:100*i], KScreenWidth, [Dimens GDimens:100])];
        item.SoucreTitle.text=[LANG DPLocalizedString:self.NameArray[i]];
        [item.logoImage setImage:[UIImage imageNamed:self.ImageArray[i]]];
        [item setTag:i+SourceItemTag];
        item.selectBlock = ^(BOOL isSelected, NSInteger itemTag) {
             RecStructData.System.InSwitch[itemTag-SourceItemTag]=isSelected;
//            if (isSelected&&(itemTag<(2+SourceItemTag))) {
//                if (itemTag==0+SourceItemTag) {
//                    RecStructData.System.InSwitch[1]=0;
//                }else if (itemTag==1+SourceItemTag){
//                    RecStructData.System.InSwitch[0]=0;
//                }
                [self flashSourceItem];
//            }
           
        };
        [self.view addSubview:item];
        
    }
    [self flashSourceItem];
 
}
-(void)toNextView{
    if (RecStructData.System.InSwitch[3]==0&&RecStructData.System.InSwitch[4]==0) {
       
    }else{
        HiAuxViewController *vc=[[HiAuxViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)toPassView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)flashSourceItem{
    for (int i=0; i<5; i++) {
        SourceItem *item=(SourceItem *)[self.view viewWithTag:i+SourceItemTag];
        [item flashSelect:RecStructData.System.InSwitch[i]];
    }
}
-(NSArray *)NameArray{
    if (!_NameArray) {
        _NameArray=@[@"L_InputSource_Optical",@"L_InputSource_Coaxial",@"L_InputSource_Bluetooth",@"L_InputSource_High",@"L_InputSource_AUX"];
    }
    return _NameArray;
}
-(NSArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray=@[@"Source_Optical",@"Source_Coaxial",@"Source_Blue",@"Source_High",@"Source_Aux"];
    }
    return _ImageArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

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
#define SourceItemTag 123
@interface SourceSettingController ()
@property(nonatomic,strong)NSArray *NameArray;
@property(nonatomic,strong)NSArray *ImageArray;
@end

@implementation SourceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBgTypeView];
    [self creatView];
    // Do any additional setup after loading the view.
}
-(void)creatBgTypeView{
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [bgImage setImage:[UIImage imageNamed:@"rootbg"]];
    [self.view addSubview:bgImage];
    [self.view insertSubview:bgImage atIndex:0];
}
-(void)creatView{
    
    for (int i=0; i<5; i++) {
        SourceItem *item=[[SourceItem alloc]init];
        item.SoucreTitle.text=self.NameArray[i];
        [item.logoImage setImage:self.ImageArray[i]];
        [self.view addSubview:item];
        
    }
}
-(NSArray *)NameArray{
    if (!_NameArray) {
        _NameArray=@[@"",@"",@"",@"",@""];
    }
    return _NameArray;
}
-(NSArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray=@[@"",@"",@"",@"",@""];
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

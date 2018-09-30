//
//  OptFunPageTabBarC.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OptFunPage_TBC.h"
#import "InputSetViewController.h"
#import "OutSetViewController.h"
@interface OptFunPage_TBC (){
    
}


- (void)initView;
@end



@implementation OptFunPage_TBC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToHome) name:kN_TopbarBackButton object:nil];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
-(void)dealloc{
    NSLog(@"OptFunPage_TBC释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kN_TopbarBackButton object:nil];
    
}
-(void)backToHome{
    [self dismissViewControllerAnimated:YES completion:nil];
    CurPage = UI_Page_Home;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)initView{
//    self.tabBar.backgroundImage=[UIImage imageNamed:@"tab_bar_bg"];
//    self.tabBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bar_bg"]];

        self.mHome       = [[HomePageViewController alloc]init];
       self.mHome.tabBarItem.title    = [LANG DPLocalizedString:@"L_Master_Master"];
        self.mHome.tabBarItem.image = [UIImage imageNamed:@"tab_home_normal"] ;
        self.mHome.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_home_press"];

    InputSetViewController *inputVC=[[InputSetViewController alloc]init];
    inputVC.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_Input"];
    inputVC.tabBarItem.image = [UIImage imageNamed:@"tab_input_normal"] ;
    inputVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_input_press"];
    
    OutSetViewController *outputVC=[[OutSetViewController alloc]init];
    outputVC.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_OutputPage"];
    outputVC.tabBarItem.image = [UIImage imageNamed:@"tab_output_normal"] ;
    outputVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_output_press"];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:inputVC];
    [items addObject:self.mHome];
    [items addObject:outputVC];

    //状态栏颜色
    [[UITabBar appearance] setBarTintColor:SetColor(UI_TabbarBgColor)];
    [UITabBar appearance].translucent = NO;
    
    [self setViewControllers:items];
    self.selectedIndex=1;
    if (KScreenWidth==414) {
        for (UIBarItem *item in self.tabBar.items) {
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(UI_TabbarTextColorNormal),NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(UI_TabbarTextColorPress)} forState:UIControlStateSelected];
        }
    }else{
        for (UIBarItem *item in self.tabBar.items) {
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(UI_TabbarTextColorNormal),NSFontAttributeName:[UIFont systemFontOfSize:11.0]} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(UI_TabbarTextColorPress)} forState:UIControlStateSelected];
        }
    
    }
    
    
}


@end


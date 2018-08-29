//
//  OptFunPageTabBarC.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "OptFunPage_TBC.h"


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
    //    self.mCDelayPage  = [[CDelayViewController alloc]init];
    //    self.mDelayPage_FRS  = [[DelayViewController_FRS alloc]init];
    self.mDelayPage  = [[DelayViewController alloc]init];
    //    self.mXOverPage  = [[XOverViewController alloc]init];
    //    self.mOutputPage = [[OutputViewController alloc]init];
    //    self.mOutputPage_FRS = [[OutputViewController_FRS alloc]init];
    self.mEQPage     = [[EQViewController alloc]init];
    self.mXOverOutput= [[XOverOutputViewController alloc]init];
    self.mMixer      = [[MixerViewController alloc]init];
    //    self.mCFMixer    = [[MixViewController alloc]init];
//        self.mHome       = [[HomePageViewController alloc]init];
    //    self.mInputPage    = [[InputViewController alloc]init];
    //    self.mOutputFunsPage       = [[OutputPageViewController alloc]init];
    //    self.mXOverOutputFRS = [[XOverOutputFRSViewController alloc]init];
    
    //    self.mCDelayPage.tabBarItem.title = [LANG DPLocalizedString:@"L_TabBar_Delay"];
    //    self.mDelayPage_FRS.tabBarItem.title = [LANG DPLocalizedString:@"L_TabBar_Delay"];
    self.mDelayPage.tabBarItem.title = [LANG DPLocalizedString:@"L_TabBar_Delay"];
    //    self.mXOverPage.tabBarItem.title = [LANG DPLocalizedString:@"L_XOver_XOver"];
    //    self.mOutputPage.tabBarItem.title= [LANG DPLocalizedString:@"L_TabBar_Output"];
    //    self.mOutputPage_FRS.tabBarItem.title= [LANG DPLocalizedString:@"L_TabBar_Output"];
    self.mEQPage.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_EQ"];
    self.mXOverOutput.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_Output"];
    self.mMixer.tabBarItem.title    = [LANG DPLocalizedString:@"L_Mixer_Mixer"];
    //    self.mCFMixer.tabBarItem.title    = [LANG DPLocalizedString:@"L_Mixer_Mixer"];
//    self.mHome.tabBarItem.title    = [LANG DPLocalizedString:@"L_Master_Master"];
    //    self.mInputPage.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_Input"];
    //    self.mOutputFunsPage.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_Output"];
    //    self.mXOverOutputFRS.tabBarItem.title    = [LANG DPLocalizedString:@"L_TabBar_Output"];
    
    //    self.mCDelayPage.tabBarItem.image = [[UIImage imageNamed:@"tab_setdelay_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mCDelayPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_setdelay_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mDelayPage_FRS.tabBarItem.image = [[UIImage imageNamed:@"tab_setdelay_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mDelayPage_FRS.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_setdelay_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.mDelayPage.tabBarItem.image = [[UIImage imageNamed:@"tab_setdelay_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mDelayPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_setdelay_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mXOverPage.tabBarItem.image = [[UIImage imageNamed:@"tab_xover_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mXOverPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_xover_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mOutputPage.tabBarItem.image = [[UIImage imageNamed:@"tab_output_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mOutputPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_output_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mOutputPage_FRS.tabBarItem.image = [[UIImage imageNamed:@"tab_output_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mOutputPage_FRS.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_output_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.mEQPage.tabBarItem.image = [[UIImage imageNamed:@"tab_eq_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mEQPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_eq_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.mXOverOutput.tabBarItem.image = [[UIImage imageNamed:@"tab_output_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mXOverOutput.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_output_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mXOverOutputFRS.tabBarItem.image = [[UIImage imageNamed:@"tab_output_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mXOverOutputFRS.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_output_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.mMixer.tabBarItem.image = [[UIImage imageNamed:@"tab_mixer_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mMixer.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_mixer_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mCFMixer.tabBarItem.image = [[UIImage imageNamed:@"tab_mixer_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mCFMixer.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_mixer_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
        self.mHome.tabBarItem.image = [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.mHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //    self.mInputPage.tabBarItem.image = [[UIImage imageNamed:@"tab_input_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mInputPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_input_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    self.mOutputFunsPage.tabBarItem.image = [[UIImage imageNamed:@"tab_outputpage_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.mOutputFunsPage.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_outputpage_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
 
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    

    [items addObject:self.mDelayPage];
    
    [items addObject:self.mXOverOutput];
    
    [items addObject:self.mEQPage];
    
    [items addObject:self.mMixer];
    //状态栏颜色
    [[UITabBar appearance] setBarTintColor:SetColor(UI_TabbarBgColor)];
    [UITabBar appearance].translucent = NO;
    
    [self setViewControllers:items];
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


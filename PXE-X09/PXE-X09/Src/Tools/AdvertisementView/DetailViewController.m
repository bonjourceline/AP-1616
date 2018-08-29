//
//  DetailViewController.m
//  UAIbum3
//
//  Created by aocheng on 2016/11/29.
//  Copyright © 2016年 aocheng. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>

@interface DetailViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(retain,nonatomic)WKWebView *webView;
@property(retain,nonatomic)UIProgressView *progressView;
@property(retain,nonatomic)WKWebViewConfiguration *configuration;
@property (retain,nonatomic)UILabel *titleLab;

@end

@implementation DetailViewController
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (self.changebtn) {
//        [self changeBackButton];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(self.changebtn){
//        [self changeBackButton];
//    }
    [self addnav];
    _configuration=[[WKWebViewConfiguration alloc]init];
    _webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) configuration:_configuration];
    _webView.UIDelegate=self;
    _webView.navigationDelegate=self;
    NSURL *url=[NSURL URLWithString:_urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _webView.allowsBackForwardNavigationGestures=YES;
    [self.view addSubview:_webView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _progressView.center = self.view.center;
    [self.view addSubview:_progressView];
    
    // Do any additional setup after loading the view.
}
-(void)addnav{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navView.backgroundColor=SetColor(UI_ToolbarBackgroundColor);
    [self.view addSubview:navView];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, navView.frame.size.height-44, 44, 44)];
    backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//    [backBtn setTitle:[NSString stringWithFormat:@" %@",[LANG DPLocalizedString:@"L_TopBar_Back"]] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"topbar_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toHome) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(44, navView.frame.size.height-44, self.view.frame.size.width-88, 44)];
    [self.titleLab setTextColor:[UIColor whiteColor]];
    self.titleLab.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:self.titleLab];
    
}
-(void)toHome{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progressView.progress=[[change objectForKey:@"new"]floatValue];
        if (_progressView.progress==1) {
            [_progressView removeFromSuperview];
        }
    }

}
-(void)changeBackButton{
//    [self.NavBackButton removeTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavBackButton addTarget:self action:@selector(dismiss1) forControlEvents:UIControlEventTouchUpInside];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.titleLab.text=self.webView.title;
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

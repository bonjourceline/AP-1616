//
//  SplanViewController.m
//

#import "SplanViewController.h"
#import "ADView.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Define_Dimens.h"




#define kDeclareShowKey @"kDeclareShowKey"


@interface SplanViewController ()

@end

@implementation SplanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor clearColor];
    if ([self isFisrtStarApp] == YES) {
        //[self showGuide];
        //[self gotoMainPage];
        [self goFoward];
    }else{
        [self goFoward];
        //[self gotoMainPage];
    }
    
}



-(void)showGuide{
    NSArray *imageArray =@[
                           @"newGuide1@2x.png",
                           @"newGuide2@2x.png",
                           @"newGuide3@2x.png",
                           @"newGuide4@2x.png",
                           @"newGuide5@2x.png"
                           ];
    
    ADView *adView = [[ADView alloc]initWithArray:imageArray andFrame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight) andBlock:^{
        //[self goFoward];
        [self gotoMainPage];
    }];
    [self.view addSubview:adView];
    
    
}

-(void)goFoward{
    
    //获得单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //读取免责申明标记
    NSString *number = [userDefaults objectForKey:kDeclareShowKey];
    //判断是否有值
    if (number!=nil) {
        BOOL starNumer = [number boolValue];
        gDeclareFlag = starNumer;
    }else{
        
        [userDefaults setObject:@TRUE forKey:kDeclareShowKey];
        [userDefaults synchronize];
        gDeclareFlag = TRUE;
    }
    
    
    if (gDeclareFlag) {
        //免责申明
        _declareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _declareView.center = self.view.center;
        //背景设置
        [_declareView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbg"]]];
        [self.view addSubview:_declareView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:90], [Dimens GDimens:50])];
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:0xe5/255.0 green:0x79/255.0 blue:0x0a/255.0 alpha:1.0];//e5790a
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [LANG DPLocalizedString:@"L_Statement"];
        [_titleLabel sizeToFit];
        _titleLabel.center = self.view.center;
        CGRect tempRect = _titleLabel.frame;
        tempRect.origin.y = [Dimens GDimens:50];
        _titleLabel.frame = tempRect;
        [_declareView addSubview:_titleLabel];
        
        
        
        _textShow = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-[Dimens GDimens:50], KScreenHeight-[Dimens GDimens:250])];
        _textShow.font = [UIFont systemFontOfSize:20];
        _textShow.backgroundColor = [UIColor blackColor];
        _textShow.textColor = [UIColor whiteColor];
        _textShow.userInteractionEnabled = NO;
        _textShow.text = [LANG DPLocalizedString:@"L_StatementCON"];
        //        _textShow.numberOfLines = 0;
        //        _textShow.adjustsFontSizeToFitWidth = YES;
        //        [_textShow sizeToFit];
        _textShow.center = self.view.center;
        tempRect = _textShow.frame;
        tempRect.origin.y = CGRectGetMaxY(_titleLabel.frame)+[Dimens GDimens:10];
        _textShow.frame = tempRect;
        
        /*
         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_textShow.text];
         NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
         paragraphStyle.alignment = NSTextAlignmentLeft;
         paragraphStyle.maximumLineHeight = 60;  //最大的行高
         paragraphStyle.lineSpacing = 5;  //行自定义行高度
         [paragraphStyle setFirstLineHeadIndent:_textShow.frame.size.width + 5];//首行缩进 根据用户昵称宽度在加5个像素
         [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_textShow.text length])];
         _textShow.attributedText = attributedString;
         //        [_textShow sizeToFit];
         */
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0x80/255.0, 0x80/255.0, 0x80/255.0, 1 });
        
        [_textShow.layer setCornerRadius:5.0];
        [_textShow.layer setBorderWidth:2.0];
        [_textShow.layer setBorderColor:colorref];
        
        
        [_declareView addSubview:_textShow];
        
        
        _alwaysShowBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alwaysShowBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _alwaysShowBtn1.frame = CGRectMake(_textShow.frame.origin.x,CGRectGetMaxY(_textShow.frame)+[Dimens GDimens:30],[Dimens GDimens:20],[Dimens GDimens:20]);
        //    [_alwaysShowBtn1 setTitle:@"OK" forState:UIControlStateNormal];
        [_alwaysShowBtn1 setBackgroundImage:[UIImage imageNamed:@"always_check"] forState:UIControlStateNormal];
        [_alwaysShowBtn1 addTarget:self action:@selector(alwaysShow) forControlEvents:UIControlEventTouchUpInside];
        [_declareView addSubview:_alwaysShowBtn1];
        
        _alwaysShowBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alwaysShowBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _alwaysShowBtn2.backgroundColor = [UIColor clearColor];
        _alwaysShowBtn2.frame = CGRectMake(_textShow.frame.origin.x+[Dimens GDimens:30],CGRectGetMaxY(_textShow.frame)+[Dimens GDimens:30],[Dimens GDimens:180],[Dimens GDimens:20]);
        [_alwaysShowBtn2 setTitle:[LANG DPLocalizedString:@"L_StatementShow"] forState:UIControlStateNormal];
        _alwaysShowBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
        _alwaysShowBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _alwaysShowBtn2.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [_alwaysShowBtn2 addTarget:self action:@selector(alwaysShow) forControlEvents:UIControlEventTouchUpInside];
        [_declareView addSubview:_alwaysShowBtn2];
        
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptBtn.backgroundColor = [UIColor colorWithRed:0x42/255.0 green:0x97/255.0 blue:0xff/255.0 alpha:1.0];
        [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _acceptBtn.frame = CGRectMake(0,self.view.frame.size.height-[Dimens GDimens:90],KScreenWidth-[Dimens GDimens:50],[Dimens GDimens:50]);
        
        _acceptBtn.center = self.view.center;
        tempRect = _acceptBtn.frame;
        tempRect.origin.y = CGRectGetMaxY(_alwaysShowBtn2.frame)+[Dimens GDimens:20];
        _acceptBtn.frame = tempRect;
        
        [_acceptBtn.layer setCornerRadius:5.0];
        [_acceptBtn.layer setBorderWidth:1.0];
        
        [_acceptBtn setTitle:[LANG DPLocalizedString:@"L_StatementAccept"] forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_acceptBtn addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
        [_declareView addSubview:_acceptBtn];
    }
    else{
        [self accept];
    }
    
}

-(void)alwaysShow {
    gDeclareFlag = !gDeclareFlag;
    if (gDeclareFlag) {
        [_alwaysShowBtn1 setBackgroundImage:[UIImage imageNamed:@"always_check"] forState:UIControlStateNormal];
    }
    else{
        [_alwaysShowBtn1 setBackgroundImage:[UIImage imageNamed:@"always_uncheck"] forState:UIControlStateNormal];
    }
    
    
}

-(void)accept{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [NSNumber numberWithBool:gDeclareFlag];
    [userDefaults setObject:number forKey:kDeclareShowKey];
    [userDefaults synchronize];
    
    [_declareView removeFromSuperview];
    
    [self gotoMainPage];
}

- (void)gotoMainPage{
    MainViewController *vc = [[MainViewController alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = vc;
    
}

-(BOOL)isFisrtStarApp{
    //获得单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //读取次数（用户上一次启动app的次数）
    NSString *number = [userDefaults objectForKey:kAppFirstLoadKey];
    //判断是否有值
    if (number!=nil) {
        //能够取到值，则不是第一次启动
        NSInteger starNumer = [number integerValue];
        //用上一次的次数+1次
        NSString *str = [NSString stringWithFormat:@"%lu",(long)++starNumer];
        //存的是用户这一次启动的次数
        [userDefaults setObject:str forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return NO;
    }else{
        //不能取到值，则是第一次启动
        NSLog(@"用户是第一次启动");
        [userDefaults setObject:@"1" forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return YES;
    }
}


@end

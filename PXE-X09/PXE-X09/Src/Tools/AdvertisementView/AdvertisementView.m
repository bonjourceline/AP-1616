//
//  AdvertisementView.m
//  DSP-Play
//
//  Created by chs on 2017/12/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "AdvertisementView.h"
#import "AppDelegate.h"
#import "KGModal.h"
#import <AFNetworking.h>
@implementation AdvertisementView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self initView];
    }
    return self;
}

-(void)initView{
    //    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:394], [Dimens GDimens:570])];
    //    backgroundView.backgroundColor=[UIColor clearColor];
     AppDelegate *mainDelegte=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.adImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:330], [Dimens GDimens:490])];
    self.adImageView.backgroundColor=[UIColor whiteColor];
    self.adImageView.layer.cornerRadius=20;
    self.adImageView.layer.masksToBounds=YES;
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:mainDelegte.Ad_model.Ad_Image_Path]];
    [self addSubview:self.adImageView];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:330], [Dimens GDimens:490]));
    }];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openURL)];
    [self.adImageView addGestureRecognizer:tap];
    self.adImageView.userInteractionEnabled=YES;
    
    self.closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Dimens GDimens:34], [Dimens GDimens:34])];
    [self.closeBtn setImage:[UIImage imageNamed:@"chs_musicMain_cha"] forState:UIControlStateNormal];
//    [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:34], [Dimens GDimens:34]));
    }];
}
-(void)openURL{
     AppDelegate *mainDelegte=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (mainDelegte.Ad_model.Ad_URL.length>0&&mainDelegte.Ad_model.Ad_URL) {
//        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//        NSString *url=mainDelegte.Ad_model.Ad_Close_URL;
//        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            QIZLog(@"成功上传");
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            QIZLog(@"上传失败%@",url);
//        }];
        self.openUrlBlock(mainDelegte.Ad_model.Ad_URL);
    }
}
-(void)closeView{
     AppDelegate *mainDelegte=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[KGModal sharedInstance]hideWithCompletionBlock:^{
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSString *url=mainDelegte.Ad_model.Ad_Close_URL;
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            QIZLog(@"成功上传");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QIZLog(@"上传失败%@",url);
        }];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

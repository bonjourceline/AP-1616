//
//  DelayViewController_Ch.h
//  HH-RDDSP
//
//  Created by chs on 2018/3/20.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalButton.h"
#import "rootViewController.h"
@interface DelayViewController_Ch :rootViewController
@property (strong, nonatomic) NormalButton *BtnCM;
@property (strong, nonatomic) NormalButton *BtnMS;
@property (strong, nonatomic) NormalButton *BtnINCH;
-(void)FlashPageUI;
@end

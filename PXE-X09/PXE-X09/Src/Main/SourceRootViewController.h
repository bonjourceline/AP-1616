//
//  SourceRootViewController.h
//  PXE-X09
//
//  Created by chs on 2018/9/27.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacDefine.h"
#import "Masonry.h"
#import "DeviceUtils.h"
@interface SourceRootViewController : UIViewController
@property(nonatomic,strong)UIButton *passBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIView *navBar;
@property (nonatomic,strong)UILabel *tiltleLab;
-(void)toNextView;
-(void)toPassView;
@end


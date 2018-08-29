//
//  OptFunPageTabBarC.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixerViewController.h"
#import "OutputPageViewController.h"
#import "EQViewController.h"
#import "XOverViewController.h"
#import "DelayViewController.h"
#import "OutputViewController.h"
#import "XOverOutputViewController.h"
#import "MixerViewController.h"
#import "MixViewController.h"
#import "HomePageViewController.h"
#import "InputViewController.h"
#import "OutputPageViewController.h"
#import "DelayViewController_FRS.h"
#import "OutputViewController_FRS.h"
#import "DelayViewController_Ch.h"
#import "XOverOutputFRSViewController.h"

#import "Define_Color.h"
@interface OptFunPage_TBC : UITabBarController

{


}
//@property (nonatomic,strong) CDelayViewController *mCDelayPage;
@property (nonatomic,strong) DelayViewController_FRS *mDelayPage_FRS;
@property (nonatomic,strong) DelayViewController *mDelayPage;
@property (nonatomic,strong) XOverViewController *mXOverPage;
@property (nonatomic,strong) XOverOutputFRSViewController *mXOverOutputFRS;
@property (nonatomic,strong) OutputViewController *mOutputPage;
@property (nonatomic,strong) OutputViewController_FRS *mOutputPage_FRS;
@property (nonatomic,strong) EQViewController *mEQPage;
@property (nonatomic,strong) HomePageViewController *mHome;
@property (nonatomic,strong) XOverOutputViewController *mXOverOutput;
@property (nonatomic,strong) MixerViewController *mMixer;
@property (nonatomic,strong) MixViewController *mCFMixer;
@property (nonatomic,strong) InputViewController *mInputPage;
@property (nonatomic,strong) OutputPageViewController *mOutputFunsPage;


@end

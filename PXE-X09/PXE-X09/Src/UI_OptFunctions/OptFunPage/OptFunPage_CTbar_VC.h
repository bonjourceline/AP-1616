//
//  OptFunsPageCVViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptFunPage_TBC.h"

#import "TopBarView.h"

//音效文件
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#import "QIZLocalEffectViewController.h"
#import "SEFFFile.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "BottomBar.h"


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
//#import "CDelayViewController.h"

@interface OptFunPage_CTbar_VC : UIViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
TopBarViewDelegate,
UITabBarControllerDelegate,
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>

{
    @private
    int SEFF_SendListTotal;
    int pageNum;
}
@property (nonatomic,strong) BottomBar *mBottomBar;
@property (nonatomic,strong) TopBarView *mToolbar;
//音效文件
@property (nonatomic,strong) UIDocumentInteractionController *doc;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;

//@property (nonatomic,strong) CDelayViewController *mCDelayPage;
@property (nonatomic,strong) DelayViewController_FRS *mDelayPage_FRS;
@property (nonatomic,strong) DelayViewController *mDelayPage;
@property (nonatomic,strong) XOverViewController *mXOverPage;
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

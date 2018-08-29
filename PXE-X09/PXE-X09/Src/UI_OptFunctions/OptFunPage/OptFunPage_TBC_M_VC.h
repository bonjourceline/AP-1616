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


@interface OptFunPage_TBC_M_VC : UIViewController
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
    
}

@property (nonatomic,strong) OptFunPage_TBC *mTabBarC;
@property (nonatomic,strong) TopBarView *mToolbar;
//音效文件
@property (nonatomic,strong) UIDocumentInteractionController *doc;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;




@end

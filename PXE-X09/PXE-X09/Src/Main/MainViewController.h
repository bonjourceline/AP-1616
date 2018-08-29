//
//  MainViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/24.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"


@interface MainViewController : UIViewController
<MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
   int SEFF_SendListTotal; 
}
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;

@end

//
//  OutputViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopBarView.h"
#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"


#import "OutputItem.h"
#import "OutNameSet.h"
#import "DataCommunication.h"


@interface OutputViewController : UIViewController
<MBProgressHUDDelegate>
{
    @private
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;

    OutputItem   *LinkOutputItem;
    
    int LinkChannel;
    int OldLinkChannel;
    int OldChannelSel;
}


- (void)FlashPageUI;



@property (strong, nonatomic) OutputItem   *CurOutputItem;

@property (strong, nonatomic) NormalButton *Btn_Link;
@property (strong, nonatomic) NormalButton *Btn_Lock;
@property (strong, nonatomic) NormalButton *Btn_Reset;
@property (strong, nonatomic) OutNameSet   *setOutNameDialog;
@end

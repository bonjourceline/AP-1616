//
//  MixViewController.h
//  CHSDCP812
//
//  Created by chsdsp on 16/7/13.
//  Copyright © 2016年 hmaudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacDefine.h"

#import "TopBarView.h"


#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"
#import "EQView.h"
#import "EQItem.h"
#import "EQIndex.h"
#import "ChannelBtn.h"
#import "ASValueTrackingSlider.h"


@interface MixViewController : UIViewController
    <UIScrollViewDelegate,
    MBProgressHUDDelegate>
{
    @private
    NSString *setEnNum;
    int SEFF_SendListTotal;

}
- (void)FlashPageUI;
    
//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

@property (nonatomic,strong) ChannelBtn * channelBtn;
    
@property (weak, nonatomic) IBOutlet UILabel *labelMix1;
@property (weak, nonatomic) IBOutlet UILabel *labelMix2;
@property (weak, nonatomic) IBOutlet UILabel *labelMix3;
@property (weak, nonatomic) IBOutlet UILabel *labelMix4;

@property (weak, nonatomic) IBOutlet UIView *viewMix1;
@property (weak, nonatomic) IBOutlet UIView *viewMix2;
@property (weak, nonatomic) IBOutlet UIView *viewMix3;
@property (weak, nonatomic) IBOutlet UIView *viewMix4;


@property (weak, nonatomic) IBOutlet UISlider *sliderMixVol1;
@property (weak, nonatomic) IBOutlet UISlider *sliderMixVol2;
@property (weak, nonatomic) IBOutlet UISlider *sliderMixVol3;
@property (weak, nonatomic) IBOutlet UISlider *sliderMixVol4;

@property (weak, nonatomic) IBOutlet UILabel *btnMixVol1;
@property (weak, nonatomic) IBOutlet UILabel *btnMixVol2;
@property (weak, nonatomic) IBOutlet UILabel *btnMixVol3;
@property (weak, nonatomic) IBOutlet UILabel *btnMixVol4;

@property (weak, nonatomic) IBOutlet UIButton *btnPol1;
@property (weak, nonatomic) IBOutlet UIButton *btnPol2;
@property (weak, nonatomic) IBOutlet UIButton *btnPol3;
@property (weak, nonatomic) IBOutlet UIButton *btnPol4;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitchVol1;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchVol2;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchVol3;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchVol4;


@end

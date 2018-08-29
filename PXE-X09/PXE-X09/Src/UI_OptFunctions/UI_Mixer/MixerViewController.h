//
//  MixerViewController.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
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
#import "ChannelBar.h"
#import "ASValueTrackingSlider.h"
#import "SeekBarChannel.h"
#import "MixerItem.h"
#import "IZValueSelectorView.h"
#import "rootViewController.h"

@interface MixerViewController : rootViewController
<UIScrollViewDelegate,
IZValueSelectorViewDataSource,
IZValueSelectorViewDelegate,
MBProgressHUDDelegate>

{
    
    @private
    //主音量计数定时器 减
    NSTimer *_pVolMinusTimer;
    NSTimer *_pVolAddTimer;
    
    NSString *setEnNum;
    int SEFF_SendListTotal;
    
    
}
- (void)FlashPageUI;


@property (nonatomic,strong) MixerItem *mMixerItem;
@property (nonatomic,strong) MixerItem *CurMixerItem;
@property (nonatomic, strong) UIScrollView *SVMixer;
@property (nonatomic,strong)UITableView *SVMixer1;
//加密用
@property (strong, nonatomic) UIButton *Encrypt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;

//@property (nonatomic,strong) ChannelBtn * channelBtn;
//@property (nonatomic,strong) SeekBarChannel * mChannel;
//@property (nonatomic,strong) UIButton *BtnChannelSel;
//@property (nonatomic,strong) UIButton *BtnChannelIndex;
@property (nonatomic,strong) ChannelBar * channelBar;
//@property (nonatomic,strong) UIImageView *bg;






@end

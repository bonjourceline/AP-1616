//
//  DataProgressHUD.h
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/8.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "DataCommunication.h"
@interface DataProgressHUD : NSObject<MBProgressHUDDelegate>
{
    int SEFF_SendListTotal; 
}
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,assign)BOOL showVolView;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong)MasterVolView *volView;
+ (instancetype)shareManager;
-(void)addNotification;
-(void)showFailConnectionHub;
-(void)initSaveLoadSEFFProgress;
@end

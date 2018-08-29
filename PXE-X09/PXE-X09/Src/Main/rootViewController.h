//
//  rootViewController.h
//  JH-DBP4106-PPP42DSP
//
//  Created by chs on 2017/10/16.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView.h"
@interface rootViewController : UIViewController<TopBarViewDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)TopBarView *mToolbar;
@property (nonatomic,strong) UIDocumentInteractionController *doc1;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt1;
-(void)addTopbarStyle;
-(void)FlashPageUI;
@end

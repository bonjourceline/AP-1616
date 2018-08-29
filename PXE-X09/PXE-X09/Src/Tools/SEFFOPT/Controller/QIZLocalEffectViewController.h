//
//  QIZLocalEffectViewController.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/30.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "WMPageController.h"
#import "MacDefine.h"
#import "Define_Dimens.h"
#import "Define_Color.h"
#import "Masonry.h"
#import "LANG.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"
#import "Define_NSNotification.h"
#import "Dimens.h"
#import "QIZAllEffectTableViewController.h"
#import "QIZCollectionTableViewController.h"
#import "QIZLikeTableViewController.h"
#import "QIZLatelyTableViewController.h"
#import "QIZSearchEffectTableViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@interface QIZLocalEffectViewController : WMPageController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
UIDocumentInteractionControllerDelegate,
//QIZAllEffectTableViewControllerDelegate,
//QIZCollectionTableViewControllerDelegate,
//QIZLatelyTableViewControllerDelegate,
//QIZLikeTableViewControllerDelegate,
//QIZSearchEffectTableViewControllerDelegate,
UITextFieldDelegate>
{
    
@private
    int SEFF_SendListTotal;
}
/**
 * 返回主页
 */
@property (nonatomic,strong) UIButton *backHomeBtn;

/**
 * 查找文件
 */
@property (nonatomic,strong) UIButton *searchBtn;

/**
 * 显示所有效果列表控制器
 */
@property (nonatomic,strong) QIZAllEffectTableViewController *allEffectVC;

/**
 * 显示收藏效果列表控制器
 */
@property (nonatomic,strong) QIZCollectionTableViewController *collectionVC;

/**
 * 显示喜欢效果列表控制器
 */
@property (nonatomic,strong) QIZLikeTableViewController *likeVC;

/**
 * 显示最近效果列表控制器
 */
@property (nonatomic,strong) QIZLatelyTableViewController *latelyVC;

@property (nonatomic,strong) QIZSearchEffectTableViewController *SearchVC;

/**
 *  数据通信类
 */

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
-(void)showSEFFLoadOrSaveProgress:(NSString*)Detail WithMode:(int)Mode;
@end

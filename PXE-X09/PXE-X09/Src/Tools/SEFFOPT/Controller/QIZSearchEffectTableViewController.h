//
//  QIZSearchEffectTableViewController.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/29.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
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
#import "DataCommunication.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

//代理协议
@protocol QIZSearchEffectTableViewControllerDelegate <NSObject>
@optional
-(void)loadDialogSearchEffect:(int)type;
@end


@interface QIZSearchEffectTableViewController : UITableViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>
{
    
    @private
    int SEFF_SendListTotal;

}
@property (nonatomic, weak) id<QIZSearchEffectTableViewControllerDelegate> delegate;


@property (nonatomic,strong) NSMutableArray *arrayM;

@property (nonatomic,assign) int selectIndex;

// 保存搜索结果数据的NSArray对象。
@property (nonatomic,strong) NSMutableArray *searchData;

@property (nonatomic,strong) NSMutableArray *tableDataModal;
@property (nonatomic,strong) NSMutableArray *searchDataModal;

// 是否搜索变量
@property (nonatomic, assign) bool isSearch;

@property (nonatomic,strong) UISearchBar *searchBar;

/**
 * 发送文档
 */
@property (nonatomic,strong) UIDocumentInteractionController *doc;

/**
 *  数据通信类
 */

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;

@end

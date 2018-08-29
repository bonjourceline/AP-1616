//
//  QIZLatelyTableViewController.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/30.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconButton.h"
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
@protocol QIZLatelyTableViewControllerDelegate <NSObject>
@optional
-(void)loadDialogLately:(int)type;
@end


@interface QIZLatelyTableViewController : UIViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>
{
    
    @private
    int SEFF_SendListTotal;

}
@property (nonatomic, weak) id<QIZLatelyTableViewControllerDelegate> delegate;


@property (nonatomic,strong) NSMutableArray *arrayM;

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiSelect;

@property (nonatomic, assign) BOOL isAllSelect;

/**
 * 发送文档
 */
@property (nonatomic,strong) UIDocumentInteractionController *doc;

/**
 * 默认升序
 */
@property (nonatomic, assign) BOOL isASC;

/**
 * 统计选中的行数
 */
@property (nonatomic, assign) int selectRowTotal;

/**
 * 展开多选功能表格高度
 */
@property (nonatomic, assign) int openMultiH;

/**
 * 关闭多选功能表格高度
 */
@property (nonatomic, assign) int closeMultiH;

/**
 * 顶部多选操作
 */
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *orderBtn;
@property (nonatomic,strong) UIButton *allSelectBtn;
@property (nonatomic,strong) UILabel *multiSelectLabel;
@property (nonatomic,strong) UIButton *multiSelectOpenBtn;

/**
 * 底部多选操作
 */
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) IconButton *multiCollectionBtn;
@property (nonatomic,strong) IconButton *multiLikeBtn;
@property (nonatomic,strong) IconButton *multiDeteleBtn;

/**
 *  数据通信类
 */

@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;

@end

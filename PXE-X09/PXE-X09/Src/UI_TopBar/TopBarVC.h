//
//  TopBarVC.h
//  HS-DAP812-DSP-8012
//
//  Created by chsdsp on 2017/8/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"



#import "BLEManager.h"
//音效文件
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#import "QIZLocalEffectViewController.h"
#import "SEFFFile.h"

@interface TopBarVC : UIViewController
<MBProgressHUDDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
//TopBarViewDelegate,
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>
{
    int SEFF_SendListTotal;
}
@property (nonatomic,strong) MBProgressHUD *HUD_SEFF;
@property (nonatomic,strong) UIDocumentInteractionController *doc;
@property (nonatomic,strong) DataCommunication *mDataTransmitOpt;
//控件，调用方法等
@property (strong, nonatomic) UIImageView  *im_Logo;
@property (strong, nonatomic) UIButton *Btn_Back;
@property (strong, nonatomic) UILabel  *lab_Title;
@property (strong, nonatomic) UILabel  *lab_Logo;
@property (strong, nonatomic) UIButton *Btn_Connect;
@property (strong, nonatomic) UIButton *Btn_Menu;

@property (strong, nonatomic) UIView  *IVLine;



@property (nonatomic,weak) UITextField *fileNameTextField;
@property (nonatomic,weak) UITextField *detailTextField;
@property (nonatomic,weak) UIButton *singleChoiceBtn;
@property (nonatomic,weak) UIButton *allChoiceBtn;
@property (nonatomic,weak) UILabel *allChoiceLabel;
@property (nonatomic,assign) BOOL isShareAllFile;
/** 保存到本地文件名称 */
@property (nonatomic, copy) NSString *saveLocalName;
@property (nonatomic, copy) NSString *saveLocalNameDetail;
//@property (nonatomic,strong) UIDocumentInteractionController *doc;
/**
 *蓝牙通信变量
 */

@property (nonatomic,strong) BLEManager *bleManager;
@property (nonatomic,strong) BabyBluetooth *baby;
@property (nonatomic,strong) NSMutableArray *peripherals;
@property (nonatomic,strong) NSMutableArray *peripheralsAD;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBCharacteristic *writecharacteristic;
@property (nonatomic,strong) CBCharacteristic *readcharacteristic;
@property (nonatomic,strong) CBPeripheral *savePeripheral;




- (void)setLogoShow:(BOOL)Show;
- (void)setTitle:(NSString*)Name;
- (void)setConnectState:(BOOL)Bool_Connect;
- (void)setMenuShow:(BOOL)Show;

@end


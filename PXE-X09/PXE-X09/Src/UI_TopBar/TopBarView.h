//
//  TopBarView.h
//  MT-IOS
//
//  Created by chsdsp on 2017/2/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView.h"

#import "Define_Color.h"
#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"



#import "BLEManager.h"
#import "QIZFileTool.h"
#import "QIZDatabaseTool.h"
#import "QIZDataStructTool.h"
#define kN_TopbarBackButton @"kN_TopbarBackButton"

//代理协议
@protocol TopBarViewDelegate <NSObject>
@optional
-(void)TopbarClickBack:(BOOL)Bool_Click;
-(void)SEFFFileOpt:(int)Opt;//音效文件操作
@end


//
@interface TopBarView : UIView{
    //变量参数等
    
}
@property (nonatomic, weak) id<TopBarViewDelegate> delegate;

//控件，调用方法等
@property (strong, nonatomic) UIImageView  *im_Logo;
@property (strong, nonatomic) UIButton *Btn_Back;
@property (strong, nonatomic) UILabel  *lab_Title;
@property (strong, nonatomic) UILabel  *lab_Logo;
@property (strong, nonatomic) UIButton *Btn_Connect;
@property (strong, nonatomic) UILabel  *lab_Connect;
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

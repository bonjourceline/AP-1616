//
//  SimpleTopBar.h
//  YB-DAP460-X2
//
//  Created by chsdsp on 2017/7/5.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Define_Color.h"
#import "Masonry.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"

#import "PIMG.h"

#import "BLEManager.h"
@interface SimpleTopBar : UIView

{
    
}


@property (strong, nonatomic) UIButton *Btn_Back;
@property (strong, nonatomic) UILabel  *lab_Title;
@property (strong, nonatomic) UIButton *Btn_Settings;
@end

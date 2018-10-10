//
//  XoveritemView.h
//  PXE-X09
//
//  Created by celine on 2018/10/9.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XoverType) {
    H_Type=1,
    L_Type,
    
};
@interface XoveritemView : UIView
@property (nonatomic,strong)NormalButton *filterBtn;
@property(nonatomic,strong)NormalButton *levelBtn;
@property(nonatomic,strong)NormalButton *freqBtn;
-(void)setXoverType:(XoverType)xoverType;
-(void)flashXover;
@end

NS_ASSUME_NONNULL_END

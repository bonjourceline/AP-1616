//
//  DoubleOutItem.h
//  PXE-X09
//
//  Created by celine on 2018/10/16.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleOutChItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoubleOutItem : UIControl
@property(nonatomic,strong)SingleOutChItem *item1;
@property(nonatomic,strong)SingleOutChItem *item2;
@property(nonatomic,strong)UIImageView *linkModeView;
@property(nonatomic,strong)UIButton *linkBtn;

-(void)setChannelIndex:(int)index;
-(void)showLinkView:(BOOL)boolean;
-(void)flashView;
@end

NS_ASSUME_NONNULL_END

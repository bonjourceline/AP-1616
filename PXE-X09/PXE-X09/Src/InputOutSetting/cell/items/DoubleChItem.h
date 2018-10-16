//
//  DoubleChItem.h
//  PXE-X09
//
//  Created by celine on 2018/10/12.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleChItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoubleChItem : UIControl
@property(nonatomic,strong)SingleChItem *item1;
@property(nonatomic,strong)SingleChItem *item2;
@property (nonatomic,strong)NormalButton *hl_setBtn;


-(void)setChannelIndex:(int)index;
-(void)setLinkView:(BOOL)boolean;
-(void)flashView;
@end

NS_ASSUME_NONNULL_END

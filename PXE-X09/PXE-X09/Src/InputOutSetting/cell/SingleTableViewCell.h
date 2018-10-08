//
//  SingleTableViewCell.h
//  PXE-X09
//
//  Created by celine on 2018/10/6.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleChItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface SingleTableViewCell : UITableViewCell
@property(nonatomic,strong)SingleChItem *item;

@end

NS_ASSUME_NONNULL_END

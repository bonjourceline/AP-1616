//
//  MixCollectionViewCell.h
//  OY-DCP680-RW-DSP680
//
//  Created by chs on 2018/4/3.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixerItem.h"
@interface MixCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)MixerItem *item;
@property (nonatomic,copy)void (^MixerBlock)(MixerItem *curitem);
@end

//
//  MixerTableViewCell.h
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/13.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixerItem.h"
@interface MixerTableViewCell : UITableViewCell
@property (nonatomic,strong)MixerItem *item;
@property (nonatomic,copy)void (^MixerBlock)(MixerItem *curitem);
@end

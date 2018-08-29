//
//  AdvertisementView.h
//  DSP-Play
//
//  Created by chs on 2017/12/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface AdvertisementView : UIView
@property (nonatomic,strong)UIImageView *adImageView;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)void (^openUrlBlock)(NSString *url);
@end

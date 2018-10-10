//
//  OutDelayViewController.h
//  PXE-X09
//
//  Created by celine on 2018/10/10.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutDelayViewController : UIViewController
@property(nonatomic,strong)UILabel *chTopLabel;
@property(nonatomic,strong)UILabel *chLabel;
@property(nonatomic,strong)void (^dismissBlock)(void);
@property (nonatomic,strong)
@end

NS_ASSUME_NONNULL_END

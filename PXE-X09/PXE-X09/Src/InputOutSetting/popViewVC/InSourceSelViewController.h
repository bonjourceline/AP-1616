//
//  InSourceSelViewController.h
//  PXE-X09
//
//  Created by celine on 2018/10/17.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InSourceSelViewController : UIViewController
@property (nonatomic,strong) void(^mixerBlock)(void);
@end

NS_ASSUME_NONNULL_END
